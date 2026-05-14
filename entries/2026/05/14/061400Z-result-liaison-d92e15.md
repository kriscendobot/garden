---
ts: 2026-05-14T06:14:00Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/055605Z-dispatch-liaison-3a4b1c.md
  - entries/2026/05/14/055620Z-dispatch-liaison-9d2c47.md
  - entries/2026/05/14/055635Z-dispatch-liaison-cf8e02.md
  - entries/2026/05/14/061330Z-message-liaison-7e2b50.md
  - entries/2026/05/14/061345Z-result-boatman-bf7290.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
  - repo: endojs/endo
    pr: 3257
    role: target
  - repo: endojs/endo
    pr: 3256
    role: target
---

Three concurrent re-ferries closed out: all three source PRs successfully ferried to their upstream PRs.

**#75 → #3232**: head now `f87bf8425`. The boatman cherry-picked the 3 new source commits (`refactor(ocapn) revert`, `chore(changeset) consolidate`, `test(random) pin equivalence`) onto the user's prior `04664e52e` tip rather than recomputing from upstream/master. Preserves all prior history including the b61c928e gibson042 review thread. Boatman's Agent stream closed unexpectedly post-push but pre-journal; the liaison reconstructed the boatman's `result` (`061345Z`) and the steward-bound message (`061330Z`) from filesystem evidence.

**#223 → #3257**: head now `71c102f0`. Force-pushed; single squashed commit on top of fresh master. The 3 new source commits (Copilot review responses) folded into the squash. Boatman returned cleanly. Steward-bound message for the upstream comment at `entries/2026/05/14/060250Z-message-boatman-e95131.md`.

**#109 → #3256**: head now `acddddba`. Force-pushed; single squashed commit on top of fresh master. The 3 new source commits (`@endo/syrups → @endo/syrup-frame` rename, yarn.lock, thousands-separator chore) folded into the squash. Boatman returned cleanly. **The user updated the upstream PR's title and description directly per their explicit ask** (kriskowal as the author of the PR is appropriate; the identity-discipline rule is for routine comments, not for the maintainer/author updating their own PR's metadata). New title: `feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`. New body in line with the boatman's proposed text at `entries/2026/05/14/060538Z-message-boatman-355658.md`.

**Open question for #109/#3256**: branch is `feat/syrups-package` upstream; renaming to `feat/syrup-frame-package` would close the PR (GitHub does not retarget head branches on rename). Boatman recommended leaving the branch name as-is to preserve PR continuity; flagged for liaison/user judgment, no action taken.

**Open question for #75 carried forward**: the `packages/random/test/random.test.js` 33-line drift between source and the upstream PR's prior tip was not investigated by the boatman (the cherry-pick approach side-stepped it). If it represents a lost-on-upstream test that source has, a separate investigation dispatch would resolve it. Held for liaison/user follow-up.

**Recovery pattern, second occurrence**: the #75 boatman's stream-idle-or-closed timeout has now happened twice in two ferry attempts. The recovery procedure (verify upstream state via `gh pr view`; verify project worktree state via reflog; reconstruct missing journal entries from filesystem evidence; complete soft-touch follow-ups directly under kriskowal where allowed and via steward-bound message where not) worked cleanly both times. Worth a Note from the field on the eventual `skills/pr-handoff/SKILL.md` write-up: long-running boatman dispatches are stream-fragile; the substantive work tends to land before the stream dies, and the orchestrator's recovery from filesystem/upstream state is reliable.

**Identity discipline observation**: the procedure landed at main `8580728` worked exactly as intended on this round. The two completed boatmen (#223, #109) wrote steward-bound messages for the upstream explanatory comments without prompting; the #75 reconstruction continued the pattern. Source-side cross-links posted directly under kriskowal. PR title/body update on #3256 was a user-directed maintainer action (allowed). Three teardowns next; will mark the worktrees collected and push.

Self-improvement: held for the eventual `skills/pr-handoff/SKILL.md` extraction. Two procedural patterns worth landing there:
1. Cherry-pick-on-prior-tip vs recompute-from-master decision tree.
2. Recovery-from-stream-close pattern (verify, reconstruct, complete missing follow-ups).
