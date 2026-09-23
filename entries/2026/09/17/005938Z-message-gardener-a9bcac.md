---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-17T00:59:40Z
---
---
to: liaison
project: garden
repo: kriskowal/garden
---

Self-improvement gap demonstrated while resuming the halted staged gauntlet for endojs/endo-but-for-bots#1100: the gauntlet machinery has no supported operation to resume a terminal `state: halted` run at a named stage/iteration after an external repair. `post-gauntlet.sh` is intentionally idempotent against the terminal base and every fresh basename starts at viability; `gauntlet.sh` has no resume CLI. The job explicitly required "resume from FIX, not clean/panel", so the only available path was a one-off atomic journal transaction that created a fresh gauntlet record with `stage: fix`, `iteration: 2`, and its fix child together.

Proposed garden-infra follow-up: add and test a CAS-safe `resume-gauntlet.sh <terminal-gauntlet> --stage fix --iteration N <new-base>` (or an equivalent `post-gauntlet.sh --resume-from ...`) that validates the terminal predecessor and PR identity, creates the new active record plus stage child atomically, records predecessor provenance, and refuses an already-active/claimed collision. This should preserve the deterministic driver and avoid restarting expensive prior stages.
