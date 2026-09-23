---
ts: 2026-06-12T04:14:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriscendobot/agoric-sdk
project: agoric-sdk
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d74faf
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: target
refs:
  - https://github.com/kriscendobot/agoric-sdk/pull/5
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687224493
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687234318
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687196485
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/035100Z-result-shepherd-076ec8.md
---

# dispatch: fixer — apply Option B (surgical drop of ava edits) + investigate override path on PR #5

Two maintainer messages on PR #5 (kriskowal, 2026-06-12):

1. **Issue comment `4687224493`** (03:53:31Z):
   > Option B sgtm. I'll ask for a rebase and retcon regardless,
   > then shepherd again.
   
   Approves Option B from the shepherd's corroboration report:
   surgical drop of just the ava version edits inside the
   offending cherry-picked commit `218350dda7` (not the whole
   commit), preserving its other substance.

2. **Issue comment `4687234318`** (03:54:54Z):
   > Looking back to
   > https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4677822843,
   > can we override the non-overlapping ava version issue to get
   > CI passing on the actual agoric-sdk?
   
   Asks: can we add a YARN `resolutions` block (or similar
   workspace-level override) that forces a single ava version
   across workspaces, sidestepping the published `@endo/ses-ava@1.4.0`'s
   narrow `"ava": "^5.3.0 || ^6.1.2"` constraint? The eventual
   goal is to make this work on upstream `Agoric/agoric-sdk` too.

The 👀 reactjis are on both
(`reactions/369064053`, `reactions/369064054`).

## State at dispatch time

- **PR** `kriscendobot/agoric-sdk#5`, DRAFT, base
  `master-57c6564`, head `mirror/12527-endo-sync-refresh` at
  `c81b03e62216edcbfc12809aefb91d029f7a20a5` (`c81b03e62`).
  Post-ava-restore-drop (per weaver `0207d5`). CI: 28 SUCCESS,
  14 FAILURE.

## Shepherd's corroboration recap (per
`journal/entries/2026/06/12/035100Z-result-shepherd-076ec8.md`)

- Cherry-pick commit `218350dda7` from upstream
  `Agoric/agoric-sdk#12527` edited pinned ava versions in 28
  workspace `package.json` files, downgrading `^7.0.0` → `^6.4.1`.
- Workspaces mixed: root and 22 stay at `^7.0.0`; the
  cherry-pick downgraded 28 to `^6.4.1`. Result: two physical
  ava installs in `node_modules`, causing the `runnerChain`
  cascade.
- Published `@endo/ses-ava@1.4.0` declares
  `"ava": "^5.3.0 || ^6.1.2"` as a **regular dependency** (not
  peerDependency). It does NOT include ava 7. The maintainer's
  "wide range" premise rests on unpublished `master` widening.

## Task — two phases

### Phase 1 — Option B (surgical drop of ava edits)

Surgically edit commit `218350dda7` to remove ONLY the ava
version downgrades, preserving every other change in that
commit.

1. **Identify the offending commit** in the PR's commit ladder.
   The cherry-picked commit `218350dda7` should be in the
   history; locate via
   `git log master-57c6564..HEAD --oneline | grep -i ava` OR
   inspect `git show 218350dda7 --stat`.
2. **Use interactive rebase to edit the commit**:
   `git rebase --interactive master-57c6564`. In the editor,
   change the offending commit's line from `pick` to `edit`.
3. **When stopped at the commit**: undo just the ava edits
   in the 28 package.json files. The clean approach:
   - `git checkout HEAD~ -- <list-of-affected-package-jsons>`
     (restore each package.json to its pre-commit state),
     BUT ONLY for the ava version lines (use targeted edits
     instead of full-file restore if other changes in the
     same file are wanted from `218350dda7`).
   - Or: read the commit's full diff, identify which lines
     touch ava version specifically, and revert just those.
4. **Stage + amend**: `git add -p` for each package.json (keep
   only the non-ava hunks); `git commit --amend --no-edit`.
   The commit's substance other than ava versions is preserved.
5. **Continue rebase**: `git rebase --continue`. Resolve any
   later conflicts from the now-different file state.

### Phase 2 — Override path investigation

The maintainer asks whether a workspace-level override can
force a single ava version. Options to investigate:

1. **YARN `resolutions`** in root `package.json`:
   `"resolutions": { "ava": "^7.0.0", "@endo/ses-ava": "..." }`.
   This forces the workspace to install only one version. Test
   whether this fixes CI without requiring per-package edits.
2. **YARN workspace protocol**: forcing a workspace-protocol
   reference if `ava` is somehow workspace-resolvable.
   (Probably not applicable; ava is external.)
3. **`@endo/ses-ava` shim**: if the project's ses-ava install
   resolves to a `workspace:`-protocol reference or local
   override, the constraint may not bind.

Apply the most promising option as a follow-on commit on top
of the Option-B-rebased head:
- If `resolutions` works (CI passes locally with
  `yarn install --immutable`), commit it
  (`chore(deps): force single ava version via resolutions per
  kriskowal review`).
- Document the override in the PR body's "How CI passes
  without per-package ava bumps" section, and call out that
  the same override mechanism could be applied upstream.

### Phase 3 — Verify CI

1. Local: `corepack yarn install --immutable` + smoke tests.
2. Force-with-lease push to
   `mirror/12527-endo-sync-refresh` with lease anchor
   `c81b03e62216edcbfc12809aefb91d029f7a20a5`.
3. Watch CI for convergence. If failures persist after the
   push, classify and either fix in-scope OR escalate
   `next: liaison`.

## Authorizations (per-action, forwarded by liaison)

- **Force-with-lease push** to
  `mirror/12527-endo-sync-refresh` (lease anchor
  `c81b03e62216edcbfc12809aefb91d029f7a20a5`).
- **Multiple push cycles** if needed.
- **Edit the PR body** via `gh pr edit` to document the
  override mechanism.
- **Post a top-level summary comment** on PR #5 after the
  push lands, naming:
  - The Option B commit-edit details (which files, which
    lines).
  - The override mechanism (if found).
  - First-look CI state.
  - At-mention `@kriskowal`.
- **Reply on both directive comments** (`4687224493`,
  `4687234318`) noting Option B applied + override outcome.
- Do NOT re-request review (PR is DRAFT).
- Do NOT mark ready.
- Do NOT add unrelated substance.

## Out of scope

- Do NOT re-add the ava-restore commit `cf798d660e`
  (the maintainer dropped it explicitly).
- Do NOT rebase onto a moving base (lock to
  `master-57c6564`).
- Do NOT touch other parts of the cherry-picked
  `218350dda7` beyond the ava version edits.
- Do NOT ferry to upstream (separate boatman engagement
  from credentialed host).

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- Pre/post head SHAs.
- Phase 1: which lines in which package.json files were
  un-edited from `218350dda7`; the amended commit's new SHA;
  any subsequent-rebase conflict notes.
- Phase 2: the override mechanism evaluation; if applied,
  the commit SHA; first-look CI state.
- Phase 3: per-check terminal state at termination.
- The PR comment URLs (summary + directive replies).
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: none` if green and
  review-ready; `next: shepherd` if CI needs continued
  watching after this push; `next: liaison` only at
  genuine impasse with specific question.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
