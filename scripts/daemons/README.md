---
created: 2026-06-02
updated: 2026-06-02
author: builder
---

# scripts/daemons

Human-invocable wrappers around `systemctl --user` for the garden's
driver and per-feed-watcher daemons. The maintainer who prefers a
script over remembering unit names runs these; the systemd unit
files themselves live at [`scripts/systemd/`](../systemd/).

See [`designs/driver.md`](../../designs/driver.md) §
Start, stop, status, and log review for the full design context.

## Files

| File                  | Purpose                                                        |
| --------------------- | -------------------------------------------------------------- |
| `start.sh`            | `daemon-reload`, then enable + start the configured units      |
| `stop.sh`             | stop (and optionally disable) the configured units             |
| `status.sh`           | report `Active` state for every configured unit                |
| `logs.sh`             | tail the systemd journal for the units; `--lane` / `--feed` filter |
| `config.sh.example`   | template for the host-local config (which lanes, which feeds)  |
| `config.sh` (gitignored) | the actual host-local config the four scripts read         |

The `config.sh.example` is checked in; the actual `config.sh` is
host-local and gitignored. Copy the example to start:

```sh
cp scripts/daemons/config.sh.example scripts/daemons/config.sh
$EDITOR scripts/daemons/config.sh
```

## First-time setup

After the unit files are installed under `~/.config/systemd/user/`
(see [`scripts/systemd/README.md`](../systemd/README.md) for the
drop-in step):

```sh
# Edit the host-local config to declare which lanes and feeds you want.
cp scripts/daemons/config.sh.example scripts/daemons/config.sh
$EDITOR scripts/daemons/config.sh

# Bring the configured set up.
scripts/daemons/start.sh

# Check that everything is active.
scripts/daemons/status.sh

# Watch the logs in another terminal.
scripts/daemons/logs.sh
```

`start.sh` runs `systemctl --user daemon-reload`, then
`systemctl --user enable ...` for each configured unit, then
`systemctl --user start ...`. The `--enable-only` and `--start-only`
flags split the two steps when you need them separately.

## Routine operations

```sh
# A single lane is misbehaving; restart it.
systemctl --user restart garden-driver@1.service

# Look at recent failures on one feed.
scripts/daemons/logs.sh --feed endo-but-for-bots --no-follow -- --since '1 hour ago'

# Stop everything cleanly before a host reboot or a config change.
scripts/daemons/stop.sh

# Reload after a config.sh edit.
scripts/daemons/stop.sh && scripts/daemons/start.sh

# Disable a lane permanently.
scripts/daemons/stop.sh --disable-too
# ... then remove the lane number from config.sh and re-run start.sh.
```

## Troubleshooting

- **`systemctl: command not found`.** The host is not running
  systemd or the user manager is unavailable. The daemons scripts
  no-op with a message in that case; the driver and watcher
  scripts still work when invoked by hand (`scripts/driver/driver.sh
  <lane>`).
- **`config.sh: file not found`.** Copy `config.sh.example`.
  Without `config.sh`, `start.sh` and `stop.sh` exit cleanly with
  a message.
- **Unit failed: see `systemctl --user status garden-driver@1`.**
  The driver's `EXIT` trap appended a section to
  `journal/inboxes/<host>/gardener.md` with a transcript SHA. Read
  the transcript via `git -C journal cat-file blob <sha>`. See
  [`skills/gardener-inbox-error-reporting/SKILL.md`](../../skills/gardener-inbox-error-reporting/SKILL.md).
- **No logs show up.** The unit's `StandardOutput=journal` and
  `StandardError=journal` route into `journalctl --user`. If
  nothing is there, the unit may have failed before `ExecStart`
  ran; check `systemctl --user status <unit>`.

## What these scripts are *not*

- A supervisor. systemd is the supervisor. These wrappers are
  convenience over `systemctl --user`.
- A health-check loop. The driver itself escalates to the
  gardener inbox on unexpected exit; the daemons scripts only
  report on systemd's view of unit state.
- A way to launch a driver outside of systemd. For ad-hoc
  invocation use `scripts/driver/driver.sh <lane>` directly.
