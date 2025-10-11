# Troubleshooting History

This document tracks all the issues encountered during development and their solutions to avoid repeating mistakes.

## PowerShell Syntax Issues

### Issue 1: Variable Reference Errors in Regex Patterns
**Date:** Current session
**Error:** `Variable reference is not valid. ':' was not followed by a valid variable name character. Consider using ${} to delimit the name.`

**Root Cause:** PowerShell was interpreting `$ServiceName:` in regex patterns as an invalid variable reference.

**Files Affected:**
- `automated-updates.ps1` (lines 106, 89, 119)

**Solution:**
```powershell
# BEFORE (caused errors):
$pattern = "($ServiceName:[\s\S]*?image:\s*)([^\s]+)"
Write-Log "Failed to check updates for $Owner/$Repo: $($_.Exception.Message)" "ERROR"
Write-Log "Failed to update docker-compose.yml for $ServiceName: $($_.Exception.Message)" "ERROR"

# AFTER (fixed):
$pattern = "(${ServiceName}:[\s\S]*?image:\s*)([^\s]+)"
Write-Log "Failed to check updates for ${Owner}/${Repo}: $($_.Exception.Message)" "ERROR"
Write-Log "Failed to update docker-compose.yml for ${ServiceName}: $($_.Exception.Message)" "ERROR"
```

### Issue 2: Here-String Variable Expansion Problems
**Date:** Current session
**Error:** Multiple syntax errors including "Missing statement after '=' in named argument", "Missing closing ')' in expression", "Unexpected token '$Action' in expression or statement"

**Root Cause:** Using double-quoted here-strings (`@"`) which attempt variable expansion, causing issues with complex scripts containing variables and special characters.

**Files Affected:**
- `setup-automation.ps1` (multiple here-strings)

**Solution:**
```powershell
# BEFORE (caused errors):
$managementScript = @"
# Script content with variables like $Action
"@

# AFTER (fixed):
$managementScript = @'
# Script content with variables like $Action
'@
```

### Issue 3: Nested Try-Catch Blocks in Here-Strings
**Date:** Current session
**Error:** "Missing closing '}' in statement block or type definition", "The Try statement is missing its Catch or Finally block"

**Root Cause:** Nested try-catch blocks inside here-strings were causing PowerShell parser confusion.

**Files Affected:**
- `setup-automation.ps1` (startup script and dashboard script)

**Solution:**
```powershell
# BEFORE (caused errors):
$startupScript = @'
try {
    Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
    Write-Host "Docker Desktop startup initiated" -ForegroundColor Green
} catch {
    Write-Host "Failed to start Docker Desktop: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
'@

# AFTER (fixed):
$startupScript = @'
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
Write-Host "Docker Desktop startup initiated" -ForegroundColor Green
'@
```

### Issue 4: String Termination Errors
**Date:** Current session
**Error:** "The string is missing the terminator: ."

**Root Cause:** Backslashes in Write-Host messages were being interpreted as escape characters.

**Files Affected:**
- `setup-automation.ps1` (Write-Host message)

**Solution:**
```powershell
# BEFORE (caused errors):
Write-Host "Review logs in the logs\ directory" -ForegroundColor White

# AFTER (fixed):
Write-Host "Review logs in the logs/ directory" -ForegroundColor White
```

## File Organization Issues

### Issue 5: Duplicate Files and Poor Organization
**Date:** Current session
**Problem:** Multiple versions of setup scripts created during debugging, cluttering the repository.

**Files Created During Debugging:**
- `setup-automation-clean.ps1` (deleted)
- `setup-automation-simple.ps1` (deleted)
- `test-syntax.ps1` (deleted)
- `setup-automation-original.ps1` (deleted)

**Solution:**
- Consolidated all working functionality into single `setup-automation.ps1`
- Moved `PROJECT-SUMMARY.md` to `docs/11-PROJECT-SUMMARY.md`
- Organized scripts into `scripts/` directory
- Removed duplicate files

## Best Practices Learned

### PowerShell Here-Strings
1. **Use single-quoted here-strings (`@'`) for literal text** - prevents variable expansion issues
2. **Use double-quoted here-strings (`@"`) only when you need variable expansion**
3. **Avoid nested try-catch blocks inside here-strings** - move error handling outside

### Variable References in Strings
1. **Use `${VariableName}` syntax when variable names are followed by special characters**
2. **Be especially careful with regex patterns and file paths**

### File Organization
1. **Create one working version and delete test files immediately**
2. **Use version control to track changes instead of multiple files**
3. **Document debugging attempts to avoid repetition**

### Error Prevention
1. **Test PowerShell syntax with minimal scripts first**
2. **Use `read_lints` tool to check for syntax errors**
3. **Keep here-strings simple and avoid complex nested structures**

## Debugging Workflow

1. **Identify the specific error message and line number**
2. **Check for common issues:**
   - Variable reference problems with special characters
   - Here-string syntax issues
   - Missing closing braces
   - String termination problems
3. **Create minimal test cases to isolate the issue**
4. **Apply the fix and test**
5. **Document the solution for future reference**

## Tools Used for Debugging

- `grep` - Search for patterns in files
- `read_file` - Examine specific sections of files
- `read_lints` - Check for syntax errors
- Terminal output - Parse error messages for line numbers and specific issues

## Prevention Strategies

1. **Always use `${VariableName}` syntax when variables are followed by special characters**
2. **Prefer single-quoted here-strings for literal text**
3. **Keep here-strings simple and avoid complex nested structures**
4. **Test scripts incrementally rather than creating multiple versions**
5. **Use proper PowerShell syntax checking tools**
6. **Document all debugging attempts and solutions**
