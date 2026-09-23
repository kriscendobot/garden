---
ts: 2026-05-19T06:24:16Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 252
    role: target
---

# Dispatch: fixer on #252 — CHANGES_REQUESTED by kriskowal (14 inline comments)

kriskowal submitted formal review at `06:06:04Z` with state
`CHANGES_REQUESTED` and 14 inline comments on the design doc
`designs/ocapn-noise-session-reconnect.md`.

PR #252: `design(ocapn,noise): session reconnect with heartbeat`.
Dispatch root: `/home/kris/dispatches/fixer--76f6aa` on `design/ocapn-noise-session-reconnect`.

This is a **design PR** (the design panel reviewed it in two prior
rounds per the prior CHANGES_REQUESTED → fixer → re-review history).
The 14 comments mix: citations needed, "procedural cruft" to remove,
naming/scoping clarifications, agreement notes ("Agree for designator..."),
single-op vs split-op (op:ping/op:pong), Noise IK confirmation, and a
"provisional implementation in Noise netlayer only" scoping note.

Per-action authorizations: reply on each inline thread,
top-level summary, re-request kriskowal review via
`gh pr edit --add-reviewer` (NOT `gh api -f reviewers=`),
push to `design/ocapn-noise-session-reconnect`. Standing broad
authorization on endojs/endo-but-for-bots covers all comment ops.
