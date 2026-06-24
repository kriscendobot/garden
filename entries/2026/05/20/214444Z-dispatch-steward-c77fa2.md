---
ts: 2026-05-20T21:44:44Z
kind: dispatch
role: steward
to: shepherd
dispatch_id: c77fa2
dispatch_root: /home/kris/dispatches/shepherd--c77fa2
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Dispatch shepherd c77fa2 — drive #75 CI to green (user directive)

User directive at 2026-05-20T21:43Z: "Please shepherd #75 again." PR #75 (kriskowal-random-chacha12) has `lint` job FAILURE; all other 27 checks pass.

Prior fixer b2141e (~03:54Z) cleared two jsdoc warnings. New lint failure likely surfaced by upstream changes since then (master sync brought import-x migration; could be new warnings).

Drive CI to green. Stay through CI completion.
