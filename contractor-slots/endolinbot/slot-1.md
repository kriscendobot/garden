---
slot: 1
status: in-flight
design_path: designs/ocapn-noise-session-reconnect.md
pr_number: 252
current_stage: fixer
in_flight_dispatch: c26ee2
last_update: 2026-05-15T03:44:00Z
started_at: 2026-05-15T03:10:00Z
host: endolinbot
---

Weaver `924a59` returned at 03:23Z with a successful rebase onto
`llm@ddbc8ad7e` (new head `d58a075be`). PR MERGEABLE.

Advancing to fixer for the 1 must-fix cluster + 9 should-fix items from
the design panel verdict (judge `30e396` at 03:16Z).

Must-fix cluster (§4 Resumption handshake):
- AEAD-inconsistent "cleartext but MAC'd" phrasing.
- Procedural-text vs Mermaid-diagram mismatch on `RESUME-ACK`.
- Duplicated nonce-advance formula.

Stale-prep applies: worktree at `5cadc3b42`, current head `d58a075be`.
Fixer fetches FETCH_HEAD first.

Dispatch root: `dispatches/fixer--c26ee2`.
