# List of desired models (edit this list as needed)
$models = @(
    "deepseek-r1:14b",
    "llama3.2-vision:11b",
    "llama3.1:8b",
    "nomic-embed-text:latest"
)

# Helper: Check if Docker is running
Write-Host "Checking if Docker is running..."
try {
    docker info | Out-Null
} catch {
    Write-Error "Docker does not appear to be running. Please start Docker Desktop and try again."
    exit 1
}

# Helper: Check if ollama container is running
$ollamaContainer = docker ps --filter "name=^ollama$" --format "{{.Names}}"
if (-not $ollamaContainer) {
    Write-Error "Ollama container is not running. Please start it with 'docker compose up -d ollama' and try again."
    exit 1
}

# Get list of currently downloaded models in the container
Write-Host "Getting list of currently downloaded models..."
$existingModelsRaw = docker exec ollama ollama list --json | Out-String
$existingModels = @()
if ($existingModelsRaw) {
    $existingModels = ($existingModelsRaw | ConvertFrom-Json) | ForEach-Object { "{0}:{1}" -f $_.name, $_.tag }
}

# Pull desired models if missing
foreach ($model in $models) {
    $modelParts = $model.Split(":")
    $modelName = $modelParts[0]
    $modelTag = if ($modelParts.Count -gt 1) { $modelParts[1] } else { "latest" }
    $fullModel = "$modelName`:$modelTag"
    if ($existingModels -contains $fullModel) {
        Write-Host "Model $fullModel already present. Skipping."
    } else {
        Write-Host "Pulling model $fullModel..."
        docker exec ollama ollama pull $fullModel
    }
}

# Clean up models not in the desired list
Write-Host "Cleaning up models not in the desired list..."
foreach ($existing in $existingModels) {
    if ($models -notcontains $existing) {
        Write-Host "Removing model $($existing)..."
        $removeParts = $existing.Split(":")
        $removeName = $removeParts[0]
        $removeTag = if ($removeParts.Count -gt 1) { $removeParts[1] } else { "latest" }
        docker exec ollama ollama rm "$removeName`:$removeTag"
    }
}

Write-Host "Ollama model sync complete!" 