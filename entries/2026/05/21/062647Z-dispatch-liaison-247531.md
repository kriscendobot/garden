---
ts: 2026-05-21T06:26:47Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/062400Z-dispatch-liaison-92d137.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 79
    role: source
  - repo: endojs/endo
    pr: 3231
    role: target
---

Re-ferry `endojs/endo-but-for-bots#79` over `endojs/endo#3231`. **Recompute-from-master force-push-with-lease**. Source has 3 commits with a slightly reshaped subject ("pin" instead of upstream's existing "Verify"); squash to 1 on the upstream. Dispatched in parallel with #67 (returned, opened #3274), #68 (in flight), and #75 (in flight).

## Source

- Repo: `endojs/endo-but-for-bots`, PR #79.
- Branch: `ses-namespace-mutation-test`
- Head: `10800c7bc01586626233acf898eae718ebd36601`
- Base: `llm` at `7effc95a`
- State: OPEN, non-draft, MERGEABLE, no reviews.
- 3 commits, all `Kris Kowal <kriskowal@kriskowal.com>` (no attribution rewrite needed):
  1. `d70b91ea test(ses): pin namespace mutation parity with Node.js` (2026-05-01)
  2. `cb3fb042 style(ses): apply prettier formatting to namespace mutation test` (prettier follow-up)
  3. `10800c7b fix(ses): satisfy lint+tsc on namespace mutation test` (lint follow-up)

## Upstream

- Repo: `endojs/endo`, PR #3231.
- Branch: `kriskowal-namespace-mutation`
- Current head: `bace5d83637be66583dc55b8ee50dd0644c62bca`. Single commit `bace5d83 test(ses): Verify namespace mutation parity with Node.js` by `Kris Kowal <kriskowal@kriskowal.com>`.
- State: OPEN, non-draft, REVIEW_REQUIRED, mergeable: UNKNOWN.
- Title (leave untouched): `test(ses): Verify namespace mutation parity with Node.js`. Note the subject wording is "Verify" upstream and "pin" on source — the user did not ask to align; leave the title as-is.

## Human

`Kris Kowal <kriskowal@kriskowal.com>` (matches source). **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-namespace-mutation-79--20260521-062647--247531/`. Project worktree on `endojs/endo:kriskowal-namespace-mutation` (detached at `bace5d83`).

## Boatman direction

- **Squash 3 → 1** (commits 2 and 3 are bot-internal prettier/lint cleanups; the final shape is what upstream reviewers see).
- Detach at `origin/master` (`bf951df346cfcf605a6709e6a5479f2fdd526113`).
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- `git cherry-pick --no-commit d70b91ea cb3fb042 10800c7b` to stage combined diff.
- `git commit -m '<subject>' -m '<body>'` with the composed message.
- **Composed subject**: use the source's commit 1 subject verbatim: `test(ses): pin namespace mutation parity with Node.js`. The user's source uses "pin" framing; upstream PR title uses "Verify". The commit subject and PR title need not match (the PR title is metadata; the commit subject is the substance). Going with source's "pin" for the commit.
- **Composed body**: take substantive content. Drop test-plan checklists, drop any bot trailers (commits look clean but verify), drop the "address review" or "satisfy lint+tsc" framing from commits 2/3 (subsumed by the squash).
- **Tree-identity check**: `git diff 10800c7b HEAD -- .` should be empty after the squash. Verify before pushing.
- **Trailer-strip discipline**: `git interpret-trailers --parse`. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows one commit, `Kris Kowal <kriskowal@kriskowal.com>`.
- **Pre-flight ancestor/lease check**: refetch `origin/kriskowal-namespace-mutation`; confirm still at `bace5d83`.
- **Force-push with lease**: `git push origin HEAD:kriskowal-namespace-mutation --force-with-lease=kriskowal-namespace-mutation:bace5d83637be66583dc55b8ee50dd0644c62bca`.
- **Title and body untouched** on the PR (user did not ask).
- Source-side cross-link comment on `endojs/endo-but-for-bots#79`: post under kriskowal. Name the new upstream head SHA, the 3→1 squash. Note that the commit subject uses "pin" framing (matching source) while the PR title remains "Verify" framing (matching upstream's original).
- **Identity discipline on `endojs/endo#3231`**: NO direct comments.

## Out of scope

- Title/body edits on #3231.
- Comments on the upstream PR.
- Any source-side changes.

## Expected report

≤300 words:
- Upstream head SHA after force-push + new commit SHA.
- Squash + tree-identity verification.
- Attribution verified.
- Pre-flight ancestor/lease check result.
- Push mode (force-with-lease).
- Source-side cross-link URL.
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
