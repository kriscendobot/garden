---
ts: 2026-05-20T02:49:07Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/025135Z-result-liaison-569900.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Follow-up fast-forward ferry of `endojs/endo-but-for-bots#109` over `endojs/endo#3256`. **Sixth ferry of #109 in the running** (third on this kmkmbp2021 session). The source has advanced by **six new bot-side commits** since the prior fast-forward append at `b65072faf`; the upstream was force-pushed by the user (or a fixer) since to `b1cf4affd`, but the 6 new bot commits stack cleanly on top of that — fast-forward append remains the right shape.

The upstream history was rebased between sessions (my prior `b65072faf` is no longer the tip; the new tip `b1cf4aff` is `ahead 4 / behind 3` against master). Verified: the source's new 6 commits are stacked on top of `b1cf4aff` (the source's bottom carries `bff8b847`, `f80ea14e`, `b1cf4aff` exactly — same SHAs as the upstream branch). Fast-forward append from `b1cf4aff` is clean.

## Six new source commits (in order)

All authored by `endolinbot <main.barn5084@fastmail.com>`. All carry a `(#109)` bot-internal suffix that needs stripping during the attribution-rewrite amend.

1. `27439a6b test(syrup-frame): note makePipe refactor opportunity for makeArrayWriter (#109)` (May 19 05:41)
2. `dcc1a2f4 test(syrup-frame): drop ASCII section banner (#109)` (May 19 05:42)
3. `8c58e74f chore(syrup-frame): drop the unreleased placeholder CHANGELOG.md (#109)` (May 19 05:42)
4. `bd12c59f fix(ocapn): invert tcp-test-only default to syrup framing (#109)` (May 20 02:40) — substantive behavioral change
5. `e55ae018 docs(syrup-frame): cite 2025-12-09 OCapN plenary on TCP-for-testing framing (#109)` (May 20 02:41)
6. `8f9d7b43 refactor(ocapn): drop async indirection in syrup-framing socket writer (#109)` (May 20 02:41)

Strip the `(#109)` suffix from each commit's subject during the amend. Bodies untouched.

## Source

- Repo: `endojs/endo-but-for-bots`, PR #109 (OPEN, MERGEABLE).
- Branch: `feat/syrups-package`
- Head: `8f9d7b4382ff8ec94a98da3161e45cc73163d5d0`

## Upstream

- Repo: `endojs/endo`, PR #3256.
- Branch: `feat/syrups-package`
- Current head: `b1cf4affd5d3bc545c4843e9ce6be723ccfc4990` (force-pushed by user/fixer between sessions; prior boatman-pushed tip `b65072faf` is no longer reachable).
- State: OPEN, **APPROVED** by kumavis (from the original ferry's review, anchored on an old commit OID that persisted across the user's force-push).
- Branch is not protected.

## Human

`Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true**.

## Dispatch root

`/Users/kris/garden/dispatches/boatman--ferry-syrup-frame-109-six-more--20260520-024857--39160e/`. Project worktree on `endojs/endo:feat/syrups-package` (detached at `b1cf4aff`).

## Boatman direction

- Detach at upstream tip `b1cf4aff` (not master). Fast-forward append per the boatman wisdom branch.
- Cherry-pick the six new commits (`27439a6b`, `dcc1a2f4`, `8c58e74f`, `bd12c59f`, `e55ae018`, `8f9d7b43`) onto `b1cf4aff`.
- Use the `cherry-pick + git commit --amend --reset-author --no-edit` pattern with `user.name='Kris Kowal'` / `user.email='kris@cixar.com'` set first.
- **Strip the `(#109)` suffix** from each commit's subject during the amend. New subjects:
  1. `test(syrup-frame): note makePipe refactor opportunity for makeArrayWriter`
  2. `test(syrup-frame): drop ASCII section banner`
  3. `chore(syrup-frame): drop the unreleased placeholder CHANGELOG.md`
  4. `fix(ocapn): invert tcp-test-only default to syrup framing`
  5. `docs(syrup-frame): cite 2025-12-09 OCapN plenary on TCP-for-testing framing`
  6. `refactor(ocapn): drop async indirection in syrup-framing socket writer`
- **Trailer-strip discipline**: `git interpret-trailers --parse` per commit. Apply unconditionally — the #73 ferry's lesson stands.
- Verify with `git log b1cf4aff..HEAD --pretty=fuller`: six commits, all `Kris Kowal <kris@cixar.com>`.
- **Fast-forward push** (no `--force`, no `--force-with-lease`). `git push origin HEAD:feat/syrups-package`. Pre-flight ancestor check: `git merge-base --is-ancestor origin/feat/syrups-package HEAD` must succeed.
- **Title and body untouched**. User did not ask for title/description changes.
- Source-side cross-link comment on `endo-but-for-bots#109`: post under kriskowal (only authenticated identity). Name the new head SHA, the six new commits, and the fast-forward append.
- **Identity discipline on `endojs/endo#3256`**: NO direct comments.

## Out of scope

- Title/body updates on #3256.
- Comments on the upstream PR.
- Master-merge conflict resolution (the upstream PR is `ahead 4 / behind 3` against master; the conflict is a weaver's job, not the boatman's).

## Expected report

≤300 words:
- Upstream head SHA after push, six new commit SHAs in order, attribution verified.
- Push mode confirmed as fast-forward.
- Source-side cross-link URL.
- kumavis-approval persistence check.
- One-line `Self-improvement: ...`.

If blocked, `message`-to-liaison and stop.
