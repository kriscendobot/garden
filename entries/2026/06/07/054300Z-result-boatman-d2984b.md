---
ts: 2026-06-07T05:43:00Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/07/053930Z-dispatch-liaison-d2984b.md
---

First-time ferry (Shape 1) of `endojs/endo-but-for-bots#71` to a new upstream PR, **endojs/endo#3299**, closing the OPEN issue endojs/endo#2879 (test that `@endo/env-options` `ENDO_RANK_STRINGS` is per-compartment scoped).

- **Upstream PR**: https://github.com/endojs/endo/pull/3299 (number 3299), ready-for-review (not draft).
- **Branch**: `kriskowal-2879-env-options-per-compartment`, head `884e2a8cfd5e999d2886464605e2658f82ec3025`.
- **Base**: upstream natural `master` at `4a04d078b` (verified via `git ls-remote origin refs/heads/master`; source's older base `6804b7dc8` was behind, the package.json auto-merged cleanly during cherry-pick with no conflict).
- **Squash**: the two source test commits (`980053849` test + `2b890a617` bot-side review fixup) folded into one commit `5ccc2fce`, subject `test(env-options,marshal): per-compartment options are scoped`, `(#2879)` suffix dropped, `Closes #2879` in body. One voice upstream.
- **yarn.lock**: did NOT cherry-pick the bot's `8cf0cb632`; regenerated via `corepack yarn install`. The install changed the lockfile (the new marshal devDep `@endo/compartment-mapper: workspace:^` added one line to the marshal workspace entry), so a separate `chore: Update yarn.lock` commit (`884e2a8c`) was needed.
- **Attribution**: both commits author AND committer `Kris Kowal <kriskowal@kriskowal.com>`. Identity-pin overridden per-commit via `git -c user.name=... -c user.email=...`.
- **Trailer gate**: `interpret-trailers --parse` EMPTY on both commits. The two source test commits each carried a `Co-Authored-By: Claude Opus 4.7 (1M context)` trailer; both stripped in the squash.
- **Net diff**: `origin/master..HEAD` touches only `packages/marshal/package.json`, `packages/marshal/test/env-options-in-compartment.test.js`, `packages/marshal/test/_fixtures-env-options-in-compartment/{main.js,package.json}`, and `yarn.lock` (5 files, +187).
- **Mergeable**: MERGEABLE.
- **CI**: all 16 checks pending at report time (browser-tests, build, cover, lint, test matrix 22.x/24.x, test262, test-xs, test-hermes, zizmor, etc.); not waited.
- **Host/identity**: `gh auth status` showed kriskowal active; `gh api repos/endojs/endo --jq .permissions` showed `push: true, admin: true`. Push under kriskowal.
- **Cross-link**: searched bots#71 comments with `--paginate` for `^Mirror of `; none found; created `endojs/endo-but-for-bots#71` comment id **4641564314** (`Mirror of https://github.com/endojs/endo/pull/3299 (head 884e2a8c).`). No upstream-side mirror comment (retired). No comment on endojs/endo under kriskowal.

Self-improvement: nothing this time. Shape 1 ran cleanly against the existing pr-handoff playbook; the squash-via-`cherry-pick --no-commit`-then-`--amend` mechanism, the workspace-devDep yarn.lock one-line regeneration, and the trailer-strip all behaved as the skill documents.
