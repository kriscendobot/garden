---
ts: 2026-06-12T05:25:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--89bfcd
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687595219
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687710148
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/052101Z-result-fixer-d74faf.md
---

# dispatch: fixer — bump @endo/* + ses to latest npm versions on PR #5 per kriskowal directive

Maintainer directive on PR #5 (kriskowal at 2026-06-12T04:55:08Z,
issue comment `4687595219`):

> I've just completed a fresh release of Endo packages to sort
> out the ses-ava range constraints. Please reconstruct this PR
> with the latest versions published of Endo packages, including
> `@endo/*` and `ses`.

The prior fixer `d74faf` applied Option B (restoring ava ^7.0.0
via interactive rebase edit). Head is now `bd397628bc` with 68
SUCCESS / 1 acknowledge-fail. This dispatch is the
**version-bump-to-latest-npm** follow-on the maintainer
requested.

## Current npm versions (verified at dispatch time)

| Package | PR ships | npm latest |
| - | - | - |
| @endo/pass-style | 1.7.0 | **1.8.1** |
| @endo/bundle-source | 4.2.0 | **4.3.2** |
| @endo/compartment-mapper | 2.0.0 | **2.3.0** |
| @endo/marshal | 1.9.0 | **1.10.0** |
| @endo/ses-ava | 1.4.0 | **1.4.2** ← key release per maintainer |
| ses | 2.1.0 | **2.2.0** |

The maintainer specifically released a fresh `@endo/ses-ava@1.4.2`
to widen the ava range constraint. Combined with the rest of
the bump, the workspace ava conflict (which Option B currently
papers over) should be resolved via natural package versioning.

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh` at
  `bd397628bc` (post-Option-B). CI 68 SUCCESS, 1 FAILURE
  (`test-dapp (node-new)` env-acknowledge).
- The Option B edit restored ava ^7.0.0 in 29 workspaces.
  The bump-to-latest-Endo should make this papering-over
  unnecessary — the new `@endo/ses-ava` widens to ava ^7.

## Task — Endo + ses bump per MAINTAINERS § Syncing Endo
dependency versions

In your `project/` worktree on
`mirror/12527-endo-sync-refresh` at `bd397628bc`:

### Phase 1 — Pre-check

1. **Read** `agoric-sdk/MAINTAINERS.md` § Syncing Endo
   dependency versions for the canonical procedure.
2. **Verify current npm versions** at fixer time
   (`npm view <pkg> version` for each Endo package + ses).
   The table above lists the versions current at dispatch
   time; confirm none have changed.

### Phase 2 — The yarn-up walk

1. `corepack yarn up ses '@endo/*' -R` — the canonical
   bump-all-Endo-versions walk.
2. `corepack yarn dedupe` — reconcile any duplicate
   transitive deps.
3. Verify `corepack yarn install --immutable` passes
   afterward.

If the catalog "dev" gate or other blockers reappear from
the prior fixer c39b42's diagnosis, address them per that
fixer's notes
(`journal/entries/2026/06/10/041600Z-result-fixer-c39b42.md`).
The maintainer's fresh ses-ava release may have addressed
those too — verify rather than assume.

### Phase 3 — Patch refresh

The PR carries patches for the Endo packages. With the bump:
- **`@endo/pass-style@1.8.1`**: per prior fixer c39b42, the
  patch substance is absorbed at 1.8.0 — patch should be
  DELETED.
- **`@endo/bundle-source@4.3.2`**: per prior fixer c39b42,
  4.3.1 had a rewritten cache.js + dropped esbuild dep.
  4.3.2 may or may not need the patch — inspect.
- **`@endo/compartment-mapper@2.3.0`**: per prior fixer
  c39b42, 2.2.0 still emits `__createdBy` so the patch
  applied; 2.3.0 may need a rebase.
- **Other patches** in `patches/` — inspect each per the
  new version.

### Phase 4 — Consider rolling back Option B

The prior fixer's Option B edit restored ava ^7.0.0 in 29
workspaces inside the cherry-picked commit `218350dda7`.
With the bump-to-latest ses-ava handling the range:

**Option α**: keep the Option B edit AND do the bump. The
ava ^7.0.0 restore is now redundant-but-harmless.

**Option β**: undo the Option B edit (restore the cherry-pick's
original ava ^6.4.1 downgrades) so the resulting commit
ladder is faithful to upstream PR #12527. The bump-to-new-
ses-ava handles the range, so the workspace ava conflict is
resolved without the per-package edit.

The maintainer's "reconstruct" framing leans toward Option β
(faithful to upstream). The fixer makes the call based on
test results — if Option β passes CI, prefer it.

### Phase 5 — Verify

- `corepack yarn install --immutable`
- `corepack yarn build`
- Representative package smoke (e.g., `yarn workspace
  @endo/marshal test`, `yarn workspace ses test`).
- Whatever local CI-equivalent the prior fixers ran.

### Phase 6 — Commit + push

Commit ladder per MAINTAINERS discipline:
- One commit per logical step (per the agoric § Syncing
  Endo dep versions guidance) OR as the fixer prefers if
  bundling makes sense.
- Separate `chore: Update yarn.lock` commit at the end per
  the project discipline.

Force-with-lease push with lease anchor
`bd397628bc...` (full 40-char SHA via `gh pr view 5 --json
headRefOid`).

### Phase 7 — Reply

1. **Reply on the directive comment** (`4687595219`)
   at-mentioning `@kriskowal`:
   - Confirm bump to latest npm versions (with the table).
   - Note which patches were dropped / rebased / preserved.
   - Note whether Option B was kept (α) or rolled back (β),
     with rationale.
   - First-look CI state.
2. **Post a top-level summary comment** on PR #5 (if the
   directive reply isn't sufficient).

## Authorizations (per-action, forwarded by liaison)

- **Force-with-lease push** to
  `mirror/12527-endo-sync-refresh`. Use the full 40-char SHA
  for the lease anchor.
- **Multiple push cycles** if iteration is needed.
- **Edit the PR body** via `gh pr edit` to update the version
  table.
- **Top-level summary comment + directive reply** on PR #5.
- **Re-request review** from kriskowal if CI converges green
  (PR is DRAFT but the maintainer is actively reviewing, so
  a re-request signals the bump is ready).
- Do NOT mark ready.
- Do NOT amend pre-Option-B commits without preserving
  authorship.

## Out of scope

- Do NOT ferry to upstream (separate boatman from
  credentialed host).
- Do NOT rebase the base (lock to `master-57c6564`).
- Do NOT add unrelated substance.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- Pre/post head SHAs.
- Per-commit substance summary.
- The Option α vs β decision + rationale.
- Per-package patch decision (delete / rebase / preserve).
- Test results.
- CI state post-push.
- The directive-reply comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: shepherd` if CI needs
  watching; `next: none` if green and review-ready; `next:
  liaison` only at impasse.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
