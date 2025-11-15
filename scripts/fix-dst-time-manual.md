# Fix DST Time Issue - Manual Steps

The task shows "3:00 AM" in properties but runs at "2:00 AM" due to a Windows DST bug.

## Quick Fix (Recommended):

1. Open Task Scheduler (`Win + R` → `taskschd.msc`)
2. Find **"Homelab Automated Updates"** task
3. Right-click → **Properties**
4. Go to **Triggers** tab
5. Select the "Daily" trigger → Click **Edit...**
6. Change the time to **3:01 AM** (temporarily)
7. Click **OK**
8. Edit the trigger again
9. Change it back to **3:00 AM**
10. Click **OK** → **OK**

This forces Windows to recalculate the time correctly.

## Alternative: Delete and Recreate

If the above doesn't work, delete and recreate the task:

1. Right-click **"Homelab Automated Updates"** → **Delete**
2. Run: `scripts\fix-update-schedule.bat` as Administrator

The task will be recreated with the correct 3:00 AM time.

