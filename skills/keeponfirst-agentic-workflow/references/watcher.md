# Jules Watcher Reference

The watcher script monitors Jules sessions in the background and auto-notifies when complete.

## Usage

```bash
./scripts/agent.sh watch <session_id> [max_retries]
```

## Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| session_id | Yes | - | Jules session ID to monitor |
| max_retries | No | 3 | Max retry attempts for failed tasks |

## How It Works

1. **Polling**: Checks session status every 30 seconds
2. **Completion Detection**: Uses `jules remote list --session` to check status
3. **Auto Pull**: When complete, runs `jules remote pull --session <id> --apply`
4. **Validation**: Checks that output files have content (not empty)
5. **Retry Logic**: If output is empty, retries up to max_retries times
6. **Notification**: Sends system notification and opens review file in Antigravity

## Output Files

- **Log**: `jules/watcher.log`
- **Review**: `jules/completed/<session_id>_completed.md`

## Monitoring

```bash
# View live logs
tail -f jules/watcher.log

# Stop watcher
kill <pid>  # PID shown when watcher starts
```

## Retry Mechanism

If Jules produces empty files:
1. Watcher detects empty output
2. Reverts changes: `git checkout HEAD~1 -- .`
3. Re-submits latest task from `jules/tasks/`
4. Updates session ID and continues monitoring

## System Notifications

Works on:
- **macOS**: Uses `osascript` with Glass sound
- **Linux**: Uses `notify-send`

## Getting Session ID

```bash
jules remote list --session
```
