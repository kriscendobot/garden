---
ts: 2026-05-14T01:12:15Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/004700Z-dispatch-liaison-c5d710.md
  - entries/2026/05/14/010000Z-message-boatman-176fd1.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: pre-existing-upstream
---

#75 ferry: **blocked, no upstream push performed.** The boatman correctly stopped at the discovery step and wrote a substantive `message`-to-liaison (`entries/2026/05/14/010000Z-message-boatman-176fd1.md`) before any commit rewrite or push.

The blocker: there is already an open kriskowal-authored upstream PR `endojs/endo#3232` (`feat(chacha12): Consolidate PRNG for fuzzing`) on branch `kriskowal-random-chacha20` at head `b61c928e` that covers the same scope. That SHA appears as a non-tip commit inside our source branch `kriskowal-random-chacha12` (which is `b61c928e` plus 10 newer commits with the breaking surface refactor and various review responses). Active recent maintainer review: gibson042 substantive comment 2026-05-11 anchored to the `b61c928e` SHA; kriskowal's own self-review 2026-05-12; kriskowal's "will finish revising Monday" reply 2026-05-11.

The boatman laid out three options for the user to choose between:

a. **Update PR #3232 by force-pushing rewritten history to `kriskowal-random-chacha20`.** Risk: invalidates the in-flight pure-rand-v8 review thread's commit-OID anchor; overwrites kriskowal's pending revisions.
b. **Open a new sibling PR on `kriskowal-random-chacha12`.** Risk: two open kriskowal PRs upstream covering the same scope, requires the maintainer to reconcile.
c. **Hold the dispatch and re-route to the human (kriskowal) directly**, since the human's 2026-05-11 comment said they would finish revising on Monday (2026-05-13, today) and may already have a local plan that conflicts with the bot's current state.

**Worktree status**: `boatman--ferry-random-chacha12-75--20260514-005221--13bf86` left **active**, project worktree at source HEAD `836928335` with commits unmodified, identity already set to `Kris Kowal <kris@cixar.com>` so a follow-up dispatch can proceed quickly once the user picks a direction. **Do NOT teardown** until the user decides.

**Action item for the user**: pick a, b, or c (or instruct otherwise). I'll either re-dispatch the boatman with explicit direction (a/b) or teardown the worktree and message kriskowal directly via journal (c).

Self-improvement: nothing this time. The boatman role's "if anything blocks, message-to-liaison and stop" rule fired correctly the first time it met an overlapping-upstream-PR situation. One occurrence is below the threshold for adding a new norm; if a second handoff hits the same shape, the lesson "verify no overlapping upstream PR before starting work" should land in the role.
