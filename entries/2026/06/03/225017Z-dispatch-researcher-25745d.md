---
ts: 2026-06-03T22:50:17Z
kind: dispatch
role: researcher
host: endolinbot
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/researcher--25745d
short_id: 25745d
refs:
  - entries/2026/06/03/223900Z-result-builder-a5da82.md
---

# dispatch: researcher — refine proposed daemon-side UserDaemon.fetchContentTree builder prompt

Researcher precedes the daemon-side builder. Subject: implement
the `UserDaemon.fetchContentTree` exo method (and any
supporting wiring) on the daemon so that the gateway's
`serveWeblet` power (PR #420 Phase 11b) can resolve a weblet
formula's contentRoot, walk the readable-tree for a path
suffix, and stream blob bytes from the CAS.

Branch choice (master vs llm vs gateway-stack head) is one of
the researcher's open questions — daemon-side state may differ
across branches and the right base depends on what's where.
