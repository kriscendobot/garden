---
created: 2026-06-02
updated: 2026-06-29
author: builder, gardener
---

# scripts/systemd

Systemd user unit files for the garden's per-feed activity watchers (and the
other long-running `garden-*` services rendered by `install-units.sh`).

| File                                | Instance arg (`%i`) | Invokes                                       |
| ----------------------------------- | ------------------- | --------------------------------------------- |
| `garden-watcher@.service`           | feed slug           | `~/scripts/watcher/<feed>/watcher.sh`         |

The `garden-design-poller.service` proposed during the 2026-06-03 contractor retirement was never ported to v2: its unit crash-looped on a missing `scripts/daemons/design-poller.sh` and was retired 2026-06-26. The design-queue-walk seam it was meant to fill is served in the v2 job system by the triager/poller producer + gardener pool (see `designs/v1-migration-manifest.md`, where the `design-poller` skill is marked superseded).

The June-2026 **driver** pool (its `@`-instance service template and worker
scripts) was the reconstructed general-contractor's PR-pipeline automation; it was
superseded by the v2 gardener fleet and removed 2026-06-29 (see
`designs/v1-migration-manifest.md`).

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
ln -sf "$PWD/scripts/systemd/garden-watcher@.service"      ~/.config/systemd/user/
systemctl --user daemon-reload
```

Symlinks are preferred over copies so a `git pull` that updates the
unit body is picked up by the next `daemon-reload` without
re-installation. Direct file copies work too if the maintainer
wants the unit divorced from the repo.

## Reload cadence

After any edit to a unit file:

```sh
systemctl --user daemon-reload
```

`scripts/daemons/start.sh` runs `daemon-reload` automatically before
enabling units, so the routine startup path already covers the
common case.

## Enable / start lifecycle

```sh
# Enable a feed watcher (so it comes up on host boot).
systemctl --user enable garden-watcher@endo-but-for-bots.service
systemctl --user start  garden-watcher@endo-but-for-bots.service

# Or batch via the daemons-script wrapper (reads scripts/daemons/config.sh):
scripts/daemons/start.sh
```

The maintainer's host-local `scripts/daemons/config.sh` decides
which feeds are part of the configured set.

## Log review

The unit routes stdout and stderr to the systemd journal. Tail it via:

```sh
# All watchers:
journalctl --user --user-unit 'garden-watcher@*.service' --follow

# Or use the convenience wrapper:
scripts/daemons/logs.sh
scripts/daemons/logs.sh --feed endo-but-for-bots
```

## Restart-on-failure semantics

The watcher unit has `Restart=on-failure` with `RestartSec=30s`. Combined
with the gardener-inbox escalation, this gives a two-layer
self-healing strategy:

- **Transient crashes** (a network blip, a momentary file-system
  contention): systemd restarts the unit after the 30-second
  backoff. The maintainer sees nothing.
- **Persistent failures**: each crash appends a section to
  `journal/inboxes/<host>/gardener.md` with the captured transcript
  SHA. A loop crashes every 30 seconds, the gardener inbox
  accumulates sections, and the maintainer's next pass sees a
  clear pattern. Per `designs/self-healing-audit.md` and
  `skills/self-healing-wrapper/SKILL.md`.

## What is *not* in this directory

- System-level (`/etc/systemd/system/`) unit files. The garden's
  daemons run as the bot user, not as a system service.
- Socket-activated units. The daemons poll on their own schedules.
