@echo off
REM Start Stable Diffusion WebUI automatically

cd C:\stable-diffusion-webui
start "" "C:\stable-diffusion-webui\venv\Scripts\python.exe" launch.py --api --medvram --opt-sdp-attention --no-half-vae --listen --port 7860
