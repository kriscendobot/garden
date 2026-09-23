Done. Added per-worker memory confinement to the gardener template unit.

## What I did

Edited `scripts/systemd/garden-gardener@.service`, adding three keys to `[Service]` (right after the `KillMode=mixed`/`TimeoutStopSec=2700` graceful-drain block):

- `MemoryAccounting=yes` — enables per-cgroup accounting for the worker.
- `MemoryHigh=6G` — soft throttle; systemd applies reclaim/swap pressure to *this* worker's cgroup before any kill, so a transient spike degrades into swap (host has 8G swap / 128G RAM) rather than a hard kill.
- `MemoryMax=8G` — hard cap; confines the eventual OOM to the offending worker's cgroup so the killer targets it deterministically and it self-restarts, never sniping an innocent process.

Each key carries a comment: the rationale block ties the change to the observed `oom-kill` outage class (arbitrary victim → leader singleton or a mid-job peer whose SIGKILLed `claude -p` requeues and burns a poison cycle), and the `MemoryMax` comment flags the `xs2rust`/rust-build family as the memory-heaviest handlers and directs anyone hitting a legitimate OOM to raise the cap here rather than adding a `background.slice` aggregate cap (which would starve idle peers' headroom).

## What changed

- One unit file, one commit, pushed to `main2` (rebase-CAS loop, landed first try). No aggregate slice cap added, per the job constraint.

## Follow-ups

- The change reaches instances on the next deploy that re-renders/reinstalls the templated unit (`@GARDEN_ROOT@` is substituted at render time); running `garden-gardener@N` units pick it up on `daemon-reload` + restart, which the drained deploy path handles.
- If a real rust-build is ever OOM'd at 8G, bump `MemoryMax`/`MemoryHigh` in step — the comment documents this as the intended tuning knob.
