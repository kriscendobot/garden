---
created: 2026-06-02
updated: 2026-06-04
author: builder, gardener
---

# scripts/systemd

Systemd user unit files for the garden's driver pool, the per-feed activity
watchers, and the design-queue poller.

| File                                | Instance arg (`%i`) | Invokes                                       |
| ----------------------------------- | ------------------- | --------------------------------------------- |
| `garden-driver@.service`            | lane number         | `~/scripts/driver/driver.sh <lane>`           |
| `garden-watcher@.service`           | feed slug           | `~/scripts/watcher/<feed>/watcher.sh`         |
| `garden-design-poller.service`      | (single-instance)   | `~/scripts/daemons/design-poller.sh endo-but-for-bots` |

The design-poller (added 2026-06-04 per the contractor retirement; see `skills/design-poller/SKILL.md` for the contract and `designs/driver.md` § Update — 2026-06-03 contractor retirement) is single-instance because today only one project's roadmap branch is configured (`endojs/endo-but-for-bots:llm`). A templated `garden-design-poller@.service` with the project slug as `%i` lands when a second project comes online.

See [`designs/driver.md`](../../designs/driver.md) § systemd-managed
daemons for the full rationale.

## Drop-in locations

Systemd's user manager reads units from a small set of paths. The
recommended location for these templated units is:

```
~/.config/systemd/user/
```

(This path is the user-local equivalent of `/etc/systemd/system/` and
is honored without root.)

A minimal install:

```sh
mkdir -p ~/.config/systemd/user
ln -sf "$PWD/scripts/systemd/garden-driver@.service"       ~/.config/systemd/user/
ln -sf "$PWD/scripts/systemd/garden-watcher@.service"      ~/.config/systemd/user/
ln -sf "$PWD/scripts/systemd/garden-design-poller.service" ~/.config/systemd/user/
systemctl --user daemon-reload
```

Symlinks are preferred over copies so a `git pull` that updates the
unit body is picked up by the next `daemon-reload` without
re-installation. Direct file copies work too if the maintainer
wants the unit divorced from the repo.

## Reload cadence

After any edit to either unit file:

```sh
systemctl --user daemon-reload
```

`scripts/daemons/start.sh` runs `daemon-reload` automatically before
enabling units, so the routine startup path already covers the
common case.

## Enable / start lifecycle

```sh
# Enable a single lane (so it comes up on host boot).
systemctl --user enable garden-driver@1.service

# Start it now.
systemctl --user start garden-driver@1.service

# Enable a feed watcher.
systemctl --user enable garden-watcher@endo-but-for-bots.service
systemctl --user start  garden-watcher@endo-but-for-bots.service

# Or batch via the daemons-script wrapper (reads scripts/daemons/config.sh):
scripts/daemons/start.sh
```

The maintainer's host-local `scripts/daemons/config.sh` decides
which lanes and which feeds are part of the configured set.

## Log review

Both units route stdout and stderr to the systemd journal. Tail
them via:

```sh
# All driver lanes:
journalctl --user --user-unit 'garden-driver@*.service' --follow

# A single lane:
journalctl --user --user-unit garden-driver@1.service --follow

# All watchers:
journalctl --user --user-unit 'garden-watcher@*.service' --follow

# Or use the convenience wrapper:
scripts/daemons/logs.sh
scripts/daemons/logs.sh --lane 1
scripts/daemons/logs.sh --feed endo-but-for-bots
```

## Restart-on-failure semantics

Both units have `Restart=on-failure` with `RestartSec=30s`. Combined
with the driver's gardener-inbox escalation, this gives a two-layer
self-healing strategy:

- **Transient crashes** (a network blip, a momentary file-system
  contention): systemd restarts the unit after the 30-second
  backoff. The maintainer sees nothing.
- **Persistent failures**: each crash appends a section to
  `journal/inboxes/<host>/gardener.md` with the captured transcript
  SHA. A loop crashes every 30 seconds, the gardener inbox
  accumulates sections, and the maintainer's next pass sees a
  clear pattern. Per
  [`designs/driver.md`](../../designs/driver.md) § Self-healing.

## What is *not* in this directory

- System-level (`/etc/systemd/system/`) unit files. The garden's
  daemons run as the bot user, not as a system service.
- Timer units. The drivers and watchers run as continuous
  services; nothing is on a timer.
- Socket-activated units. The daemons poll on their own schedules.
