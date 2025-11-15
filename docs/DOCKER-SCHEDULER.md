# Docker-Based Scheduler

This replaces Windows Task Scheduler with a Docker-based cron scheduler that:
- ✅ **No DST bugs** - Uses UTC/timezone-aware scheduling
- ✅ **Cross-platform** - Works on Windows, Linux, and macOS
- ✅ **Reliable** - Runs in a container, isolated from host issues
- ✅ **Easy to manage** - Standard Docker commands

## Setup

### Windows
```cmd
scripts\setup-docker-scheduler.bat
```

### Linux
```bash
chmod +x scripts/setup-docker-scheduler.sh
./scripts/setup-docker-scheduler.sh
```

## Configuration

Edit `docker-compose-scheduler.yml` to change:
- **Schedule**: Edit the cron line `'0 3 * * *'` (currently 3 AM daily)
- **Timezone**: Change `TZ=America/New_York` to your timezone

### Cron Format
```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

Examples:
- `0 3 * * *` - 3 AM daily
- `0 */6 * * *` - Every 6 hours
- `0 3 * * 1` - 3 AM every Monday

## Management

### View Logs
```bash
docker logs homelab-scheduler
docker logs -f homelab-scheduler  # Follow logs
```

### Stop Scheduler
```bash
docker-compose -f docker-compose-scheduler.yml down
```

### Restart Scheduler
```bash
docker-compose -f docker-compose-scheduler.yml restart
```

### Check Status
```bash
docker ps | grep homelab-scheduler
```

## Disable Windows Task Scheduler

After setting up the Docker scheduler, you can disable/delete the Windows tasks:
1. Open Task Scheduler
2. Disable or delete:
   - "Homelab Automated Updates"
   - "Homelab Update"

## Alternative: Use n8n Scheduler

Since you already have n8n running, you can also use its built-in scheduler:

1. Open n8n at `http://localhost:5678`
2. Create a new workflow
3. Add a "Schedule Trigger" node
4. Set it to run daily at 3 AM
5. Add an "Execute Command" node that runs:
   ```bash
   scripts\ansible-runner.bat update
   ```

This gives you a web UI to manage schedules and see execution history.

