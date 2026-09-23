---
ts: 2026-05-21T06:24:00Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/061345Z-result-boatman-bf7290.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
---

Re-ferry `endojs/endo-but-for-bots#75` over `endojs/endo#3232`. **Recompute-from-master force-push**. Source has been rebased onto fresh master with 11 cleanly-organized commits; upstream #3232 was CONFLICTING with master at `6fbe4b06a` and needs the new shape.

## Source (rebased & reshaped to 11 commits)

- Repo: `endojs/endo-but-for-bots`, PR #75 (OPEN, non-draft, MERGEABLE, CHANGES_REQUESTED).
- Branch: `kriskowal-random-chacha12`
- Head: `77f4e0526acbbb8e323c17d90c0b7f8c5bc058ff`
- Base: master (current `bf951df3`).
- **11 commits**, all `endolinbot <main.barn5084@fastmail.com>` (need attribution rewrite to `Kris Kowal <kriskowal@kriskowal.com>`), authored 2026-05-21T06:09-06:10Z:
  1. `1a1caf13 feat(random): add @endo/random source-agnostic samplers`
  2. `9cf2c491 feat(chacha12): add @endo/chacha12 pure-JS ChaCha12 keystream`
  3. `b1421890 feat(chacha12-fast-check-test): adopt test-package shape`
  4. `5a86f545 refactor(hex): use @endo/chacha12 keystream + @endo/random/seeds for bench inputs`
  5. `4d954880 refactor(ocapn): use @endo/chacha12 + @endo/random for fuzz drivers`
  6. `5b952ddc fix(ses): tuple-typed args restores Parameters<typeof compartmentOptions> overlap`
  7. `0ce81e15 style(evasive-transform): align customVisitor JSDoc continuation indent`
  8. `662ac97a docs: document the thunk-module policy in AGENTS.md`
  9. `871f4151 chore: register chacha12, chacha12-fast-check-test, random in root tsconfig and typedoc`
  10. `b73abdd6 docs(random,chacha12): changeset for @endo/random + @endo/chacha12`
  11. `77f4e052 chore: Update yarn.lock`

**Note on commit 8 (AGENTS.md)**: this is NOT off-topic for this PR (unlike #68's similar commit). Upstream #3232 already contains an equivalent `e8496452 docs: Document thunk module policy` commit by `Kris Kowal <kris@agoric.com>`. The thunk-module policy belongs with the random/chacha12 work. **Include in this ferry.**

## Upstream

- Repo: `endojs/endo`, PR #3232.
- Branch: `kriskowal-random-chacha20` (historical name, NOT `kriskowal-random-chacha12` despite the source-side branch name change).
- Current head: `6fbe4b06adb2175ecc77be7d4628e810723a64bb` (CONFLICTING with master `bf951df3`; state OPEN, REVIEW_REQUIRED).
- Title (leave untouched): `feat(chacha12): Consolidate PRNG for fuzzing`.

## Human

`Kris Kowal <kriskowal@kriskowal.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-random-chacha12-75-rebase--20260521-062400--92d137/`. Project worktree on `endojs/endo:kriskowal-random-chacha20` (detached at `6fbe4b06a`).

## Boatman direction

- Detach at `origin/master` (`bf951df3`), NOT at the current upstream tip. Recompute-from-master.
- Set local `user.name='Kris Kowal'` / `user.email='kriskowal@kriskowal.com'`.
- Cherry-pick **all 11 commits** in order (1 through 11). **Preserve as 11 commits** — the structure is deliberate (one logical change per commit).
- Use `cherry-pick + git commit --amend --reset-author --no-edit` per commit.
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit. Always.
- **Verify attribution**: `git log origin/master..HEAD --pretty=fuller` shows 11 commits, all author + committer `Kris Kowal <kriskowal@kriskowal.com>`.
- **Pre-flight ancestor/lease check**: refetch `origin/kriskowal-random-chacha20`, confirm still at `6fbe4b06a`.
- **Force-push with lease**: `git push origin HEAD:kriskowal-random-chacha20 --force-with-lease=kriskowal-random-chacha20:6fbe4b06adb2175ecc77be7d4628e810723a64bb`.
- **Title and body untouched** (user did not ask for changes).
- Source-side cross-link comment on `endojs/endo-but-for-bots#75`: post under kriskowal. Name the new upstream head SHA, the 11-commit shape, and confirm the recompute onto fresh master.
- **Identity discipline on `endojs/endo#3232`**: NO direct comments.

## Out of scope

- Title/body edits on #3232.
- Comments on the upstream PR.
- Any source-side changes.

## Expected report

≤350 words:
- Upstream head SHA after force-push + 11 new commit SHAs in order.
- Attribution verified.
- Pre-flight ancestor/lease check result.
- Push mode (force-with-lease).
- Source-side cross-link URL.
- Master-merge mergeability state after the push (current state is CONFLICTING; expected to be MERGEABLE after the recompute onto fresh master).
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
