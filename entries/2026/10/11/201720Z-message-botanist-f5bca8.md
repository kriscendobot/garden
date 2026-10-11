---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-11T20:17:21Z
---
# Dependabotany: endojs/endo-but-for-bots PR #1441 — REJECT (incompatible)

project: endo-but-for-bots

- PR: https://github.com/endojs/endo-but-for-bots/pull/1441 (closed 2026-10-11)
- Bump: `@earendil-works/pi-tui` 0.87.1 -> 1.0.2 (`packages/agentry`)
- Verdict: REJECT (engine incompatibility, found by preflight). The root engines field is `^20.17.0 || >=22.9.0` (floor 20.17.0), and pi-tui 1.0.2 declares `>=22.19.0`.
- Note: the outgoing pi-tui 0.87.1 also declares `>=22.19.0`, so this mismatch already exists on the base. The fix is a Node-floor decision for `packages/agentry` or the root. Until that is decided, every pi-tui bump will hit the same REJECT.
