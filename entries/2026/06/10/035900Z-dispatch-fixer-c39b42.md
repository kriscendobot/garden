---
ts: 2026-06-10T03:59:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--c39b42
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4662462430
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4666316507
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/035700Z-result-shepherd-528eb6.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/09/033100Z-result-builder-1f1de6.md
---

# dispatch: fixer — deferred yarn-up Endo version-bump walk on PR #5 (shepherd `next: fixer` escalation)

Auto-chain dispatch after shepherd `528eb6` diagnosed all 4 CI
failures (`build (node-new)`, `build (node-old)`, `test-dapp
(node-new)`, `flake-check`) as a single root cause: `YN0028: The
lockfile would have been modified by this install, which is
explicitly forbidden`. The yarn-immutable-install gate hits
*before* any test/build logic runs.

The fix is the `yarn up ses '@endo/*' -R; yarn dedupe` walk that
builder `1f1de6` explicitly deferred when opening the PR (per
its result entry § "Version bump to current npm not landed").

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`
  ("chore(deps): mirror Agoric/agoric-sdk#12527 (Endo sync) on
  current master"), DRAFT, base `master-daf7a86`, head
  `mirror/12527-endo-sync-refresh` at `962b1b5b9`.
- **Maintainer directive** (kriskowal at 2026-06-09T17:48:45Z,
  issue comment `4662462430`): "Pray shepherd." — shepherd has
  run, escalated to fixer per dispatch policy.
- **CI**: 4 red, all `YN0028` (immutable lockfile gate before
  test/build logic).
- **Builder's two named blockers** the deferral cited:
  1. **a3p `prepare-test.sh` requirement** — a3p subworkspace
     has a `prepare-test.sh` script that interacts with the
     lockfile walk in a way the builder couldn't immediately
     navigate.
  2. **Root catalog "dev" gate** — `eslint-plugin-import@catalog:dev:
     catalog "dev" not found or empty` blocks the root
     `yarn up` immediately.

## Task

In your `project/` worktree on `mirror/12527-endo-sync-refresh`
at `962b1b5b9`:

1. **Read** `agoric-sdk/MAINTAINERS.md` § "Syncing Endo
   dependency versions" for the canonical procedure (the
   builder's brief named it as the recipe to follow).
2. **Read** the builder's result entry
   (`journal/entries/2026/06/09/033100Z-result-builder-1f1de6.md`)
   for the deferred-bump details: PR ships
   `pass-style@1.7.0 / bundle-source@4.2.0 /
   compartment-mapper@2.0.0`; current npm at builder time:
   `1.8.0 / 4.3.1 / 2.2.0`. Verify current npm at fixer time
   via `npm view <pkg> version` for each.
3. **Investigate the catalog "dev" gate**. The error
   `eslint-plugin-import@catalog:dev: catalog "dev" not found
   or empty` says some transitive devDep references a missing
   `dev` catalog entry. Look at:
   - The root `package.json` for any `"catalogs"` block.
   - The `yarn.lock` for the `eslint-plugin-import@catalog:dev`
     entry to see who imports it.
   - The newly-published Endo packages' devDeps for the
     `catalog:dev` reference.
   The fix may be adding a `dev` catalog entry to the root
   `package.json` with the eslint-plugin-import pin (per the
   resolved version from a manual probe), OR a workaround like
   forcing the dependency through a `resolutions` block.
4. **Investigate the a3p `prepare-test.sh` requirement**. Look
   at `a3p-integration/proposals/*/prepare-test.sh` for what it
   does; the builder said it interacted poorly with the lockfile
   walk. The fix may be running it as part of the lockfile-walk
   sequence, or skipping it for the version-bump-only PR.
5. **Run the version-bump walk per MAINTAINERS.md** (recommended
   order; deviate only if necessary):
   - `corepack yarn up ses '@endo/*' -R`
   - `corepack yarn dedupe`
   - If a3p subworkspace needs separate treatment per its
     `prepare-test.sh`, follow the MAINTAINERS guidance.
   - Verify by `corepack yarn install --immutable` succeeds
     locally (mimics the CI gate).
6. **Handle the Endo-version-driven patch refresh**. The
   builder's commit ladder included patch-set edits because the
   newer Endo versions absorb some prior patches. With newer
   versions still:
   - `@endo/pass-style@1.8.0`: the builder noted this version
     **incorporates the patch substance** (verified by tarball
     diff); the patch should be **deleted**, not just renamed.
   - `@endo/bundle-source@4.3.1`: the builder noted the patch
     **does not incorporate** the esbuild substance and needs
     rebase against the rewritten cache.js. Inspect; rebase
     surgically.
   - `@endo/compartment-mapper@2.2.0`: substance-still-applies
     status was unverified by the builder; verify now.
7. **Run cross-package smoke** via the test command shapes the
   MAINTAINERS doc references; at minimum, verify
   `corepack yarn build` and a representative package's test
   suite pass locally before push.
8. **Commit per the MAINTAINERS § Syncing Endo dependency
   versions** discipline. Typically: one commit for the version
   bump + lockfile updates (`chore(deps): yarn up ses
   '@endo/*' -R per MAINTAINERS § Syncing Endo dependency
   versions`); separate commit for patch-set adjustments
   (`chore(patches): refresh per Endo bump 1.7.0->1.8.0 etc.`).
9. **Push** to `mirror/12527-endo-sync-refresh` via `git push
   bot HEAD:mirror/12527-endo-sync-refresh` (append push only;
   do NOT amend builder or shepherd commits; do NOT force-push).
10. **Post a top-level summary** on PR #5 listing the addressed
    blockers + the per-commit substance + first-look CI state.
11. **Reply on kriskowal's directive comment**
    (`4662462430`) confirming the version-bump-walk is now in
    place. Short.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `mirror/12527-endo-sync-refresh`
  (append push only).
- **Top-level summary comment** on PR #5. Same authority as the
  shepherd had via this liaison's dispatch.
- **Reply on the directive comment**. Same.
- **Add a `dev` catalog entry** to root `package.json` if the
  investigation shows that's the right fix. The catalog/
  resolutions surface is in scope for this dispatch.
- Do NOT re-request review (PR is DRAFT; the maintainer is
  watching directly).
- Do NOT mark the PR ready.

## Out of scope

- Do NOT amend builder or shepherd commits.
- Do NOT force-push.
- Do NOT rebase onto a moving target; the base
  `master-daf7a86` is frozen. If the PR has drifted from current
  Agoric master, that's a separate weaver dispatch.
- Do NOT touch the patches the builder already curated unless
  the version bump invalidates them (the three Endo packages
  named above are the only candidates).
- Do NOT post the convergence summary on PR #5 yet; CI from this
  push converges later, and the shepherd is the right role to
  drive that convergence if it goes red again. Your summary
  comment is about "what landed", not "CI is green".

## Deliverable

A `result` entry under `journal/entries/2026/06/10/` naming:

- Pre/post branch tip SHAs.
- Per-commit substance summary.
- The catalog "dev" gate diagnosis + fix (or workaround).
- The a3p `prepare-test.sh` interaction outcome.
- Per-package patch-set decision: `pass-style` (delete?),
  `bundle-source` (rebase scope), `compartment-mapper`
  (decision).
- Local `yarn install --immutable` + `yarn build` + smoke-test
  results.
- The PR comment URLs (top-level summary + directive reply).
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: shepherd` if CI needs a
  second convergence pass after the version-bump push; `next:
  none` if the post-push CI is already green and the PR is in
  shape for maintainer review.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
