---
ts: 2026-06-08T05:41:22Z
kind: dispatch
role: researcher
host: endolinbot
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/researcher--e69c67
short_id: e69c67
refs: []
---

# dispatch: researcher — refine proposed designer prompt for daemon-move-transfer-negotiation

Researcher precedes the designer dispatch. Subject: a design
that generalizes the daemon's `move` command into an exo
interface family negotiating the best in-band or out-of-band
transfer mechanism per source/target pair — from POSIX-atomic
rename through mount-scoped move, same-host copy+remove, and
cross-peer copies (CapTP fallback; out-of-band Git push/pull
or similar when data-plane capabilities align).

The protocol's load-bearing primitives the prompt names:
- grant matching equality (do the two endpoints refer to the
  "same" thing?)
- sealer / unsealer (proof of shared substrate)

Full proposed prompt in the Agent invocation.
