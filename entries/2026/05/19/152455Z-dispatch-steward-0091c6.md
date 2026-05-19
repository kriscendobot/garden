---
ts: 2026-05-19T15:24:55Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
---

# Dispatch: fixer on #75 — split multiplier-test into per-source tests

kriskowal at `2026-05-19T15:23:46Z` on
`packages/random/test/random.test.js:64` ([r3267488858](https://github.com/endojs/endo-but-for-bots/pull/75#discussion_r3267488858)):
*"This will be more legible as a separate test for each mock source."*

Dispatch root: `/home/kris/dispatches/fixer--5045ed` on `kriskowal-random-chacha12`,
head `afa6631ae`.

The current single test `random() multiplies randomUint53 by exactly
2 ** -53` carries four sources (`allSetSource`, `allClearSource`,
`lo52SetSource`, `all53SetSource`) with four `t.is` assertions.
Split into four separate `test(...)` blocks (one per source), each
naming the source's bit pattern and its expected float.

Per-action authorizations: reply on the inline thread, push to
`kriskowal-random-chacha12`, `gh pr edit --add-reviewer kriskowal`
(NOT `gh api -f reviewers=`). Standing broad authorization covers
comment ops.

This is a quick mechanical change; should be a single commit.
