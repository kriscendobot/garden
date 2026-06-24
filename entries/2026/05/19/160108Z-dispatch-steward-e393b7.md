---
ts: 2026-05-19T16:01:08Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Dispatch: fixer on #75 — 2 more kriskowal inline directives

Two COMMENTED reviews from kriskowal (`15:59:31Z` and `16:00:11Z`):

1. `packages/random/seeds.js:16` — "The number in this name doesn't
   track with bits or bytes. Please fix."
2. `packages/random/CHANGELOG.md:1` — "This needs to be cleared out
   and the title fixed."

Dispatch root: `/home/kris/dispatches/fixer--f58ece` on `kriskowal-random-chacha12`.

Both are quick fixes. The CHANGELOG one matches the established
"no hand-rolled CHANGELOG.md on new packages" pattern (4th
occurrence — #288 round 1 + #109 + #288 round 2 retcon + now #75).

Per-action authorizations: reply on each inline thread; push;
`gh pr edit --add-reviewer kriskowal`; local prettier check
before push.
