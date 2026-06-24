---
ts: 2026-06-09T03:00:23Z
kind: result
role: researcher
host: endolinbot
project: agoric-sdk
repo: Agoric/agoric-sdk
dispatch_root: /home/kris/dispatches/researcher--fcab29
short_id: fcab29
to: liaison
refs:
  - entries/2026/05/12/193700Z-message-liaison-5f675d.md
  - entries/2026/05/13/213320Z-dispatch-liaison-9c1ae8.md
  - entries/2026/05/13/214419Z-dispatch-liaison-3fdcd2.md
  - entries/2026/05/13/214930Z-result-builder-a2f187.md
  - entries/2026/05/13/023600Z-message-monitor-926d77.md
  - entries/2026/05/13/023818Z-result-gardener-b86896.md
  - projects/agoric-sdk/README.md
  - projects/endo/README.md
prs:
  - repo: Agoric/agoric-sdk
    pr: 12527
    role: source
---

# result: researcher refinement for the Agoric/agoric-sdk#12527 mirror-and-refresh builder dispatch (fcab29)

The proposed builder will mirror Copilot-authored upstream PR
`Agoric/agoric-sdk#12527` (`Sync Endo dependencies and refresh patch
set`, base `master`, head `copilot/update-endo-dependency-versions`,
+4637/-4731 across 92 files; APPROVED by turadg but DIRTY /
CONFLICTING with master) onto `kriscendobot/agoric-sdk`, rebase on
current master, and move to the latest npm-published Endo versions
(which probably means refreshing the patch set again because the
versions named in the upstream PR (`@endo/pass-style@1.7.0`,
`@endo/bundle-source@4.2.0`, `@endo/compartment-mapper@2.0.0`) are
already older than current npm: `1.8.0`, `4.3.1`, `2.2.0` per
`npm view` 2026-06-09). The most direct precedent is the prior
agoric-sdk Endo-sync mirror (`Agoric/agoric-sdk#11540` → branch
`parallel-upgrade-tests` on `kriscendobot/agoric-sdk`, May 2026); the
maintainer's framing then was "don't run more cycles without new
direction" because the rebase was too contentious (~58 commits with
type-suppression conflicts). Today's dispatch is shaped differently:
the maintainer is explicitly asking for the rebase and version-bump,
and the build is the deliverable. The substance the refinement
grounds: the canonical Endo-sync procedure from upstream
`MAINTAINERS.md` (the helper that walks every `yarn.lock`, runs
`yarn up ses '@endo/*' -R; yarn dedupe`, then resolves patch renames
or deletes; followed by `yarn` at the root, a separate `chore: Update
yarn.lock`, the `xsnap` METER_TYPE bump in `packages/xsnap/api.js`,
and SwingSet `xsnap-store` snapshot updates); the agoric-sdk project
README's "passive standing watch" posture (no active monitor
dispatches; this is the project's first active PR cycle); identity
shape (`kriscendobot` for the fork-side work, `kriskowal` reserved
for upstream landings); frozen-base discipline for any fork-side PR;
and the post-rebase patch-set hygiene (every `.yarn/patches/@endo-*`
file is keyed on the exact npm version; bumping versions requires
renaming or deleting each one and re-resolving against the new
upstream). Several substantive library gaps surface: no library
coverage of the agoric-sdk `MAINTAINERS.md` § Syncing Endo versions
procedure, no concept page for `.yarn/patches/@endo-*-<version>-<hash>.patch`
naming, no coverage of `xsnap` METER_TYPE bumping. These are queued
for the scholar / librarian, not fabricated as citations.

```markdown
## Library and project references

### Project context (agoric-sdk)

- [`journal/projects/agoric-sdk/README.md`](../../projects/agoric-sdk/README.md)
  § *Rules of engagement*. The project is on **passive standing
  watch** with monitor reactions consolidated to journal-only ticks
  per [`garden/skills/monitor-agoric-sdk/SKILL.md`](../../../garden/skills/monitor-agoric-sdk/SKILL.md).
  The README's framing: *"Until this garden opens its first PR
  against `agoric/agoric-sdk` (or one of its forks), every observed
  event class resolves to journal one tick entry per NEW batch and
  stop."* Today's mirror dispatch is plausibly the trigger for
  upgrading the rule set; the dispatch should note in the result
  entry that the project has moved out of passive standing watch so
  the gardener can land per-class rules in a follow-up.
- [`journal/projects/agoric-sdk/README.md`](../../projects/agoric-sdk/README.md)
  § *Identity and credentials*. Same shape as endo. Routine work
  uses the `kriscendobot` identity; `kriskowal` reserved for upstream
  landings. The mirror PR is fork-side (`kriscendobot/agoric-sdk`);
  the dispatch does **not** open an upstream PR on
  `Agoric/agoric-sdk` and does **not** carry
  `identity_switch_authorized: true`.
- [`journal/projects/endo/README.md`](../../projects/endo/README.md)
  § *Authority structure*. Agoric-sdk consumes Endo. Endo's senior
  contributor (erights) is authoritative on `pass-style`, `marshal`,
  `eventual-send`, `patterns`, `captp`. Patch-refresh decisions that
  touch the substance of any of those packages (for example, a patch
  that reverts an erights-authored change) merit erights-grade scrutiny
  even though the PR lives on the agoric-sdk side. The dispatch
  should surface any such patch-substance change for the orchestrator
  rather than silently keeping or dropping.

### Prior agoric-sdk Endo-sync precedent

- [`journal/entries/2026/05/13/214419Z-dispatch-liaison-3fdcd2.md`](../../entries/2026/05/13/214419Z-dispatch-liaison-3fdcd2.md)
  and [`journal/entries/2026/05/13/214930Z-result-builder-a2f187.md`](../../entries/2026/05/13/214930Z-result-builder-a2f187.md):
  the May 2026 mirror of `Agoric/agoric-sdk#11540` (`kris-sync-endo-2025-06-27-00-30-49`,
  the prior Endo-sync PR) onto `kriscendobot/agoric-sdk:parallel-upgrade-tests`.
  Critical context: the May dispatch was **mirror-and-comment only,
  no rebase**. The reason: *"the rebase is too contentious to
  autonomously do (~58 commits to apply, type-suppression conflicts
  dominant)"*. Today's dispatch is the inverse: the rebase **is** the
  deliverable. The conflict surface on `#11540` clustered around
  `z:acceptance loadgen` (a3p-integration), `test-boot shard-2`
  perf regressions, `deployment-test` (infra), and `test-docker-build`.
  `#12527` will touch substantially the same a3p-integration
  `yarn.lock` set (`f:ymax0-restart`, `g:ymax1`, `h:hook-msg-send`,
  `k:param-change`, `l:wallet-upgrade`, `m:before-next-upgrade`,
  `n:upgrade-next`, `z:acceptance`); expect the same CI shape.
  The May mirror branch `parallel-upgrade-tests` **still exists** on
  `kriscendobot/agoric-sdk` (verified 2026-06-09); the dispatch
  should pick a distinct head-branch name to avoid colliding with
  it.
- [`journal/entries/2026/05/13/023600Z-message-monitor-926d77.md`](../../entries/2026/05/13/023600Z-message-monitor-926d77.md)
  and [`journal/entries/2026/05/13/023818Z-result-gardener-b86896.md`](../../entries/2026/05/13/023818Z-result-gardener-b86896.md):
  the monitor's "passive standing watch" rule-set proposal and the
  gardener's landing on [`garden/skills/monitor-agoric-sdk/SKILL.md`](../../../garden/skills/monitor-agoric-sdk/SKILL.md).
  The rule set is uniform across event classes (every class →
  journal a tick and stop). With today's dispatch, agoric-sdk has an
  active engagement; the steward's next cycle should consider
  whether to widen the rule set per the project README's "upgrade to
  per-class rules at the point an active engagement begins" clause.

### Upstream procedure (the canonical recipe)

The agoric-sdk upstream `MAINTAINERS.md` § *Syncing Endo dependency
versions* (read at `master` 2026-06-09 via `gh api repos/Agoric/agoric-sdk/contents/MAINTAINERS.md`)
is the canonical procedure. The substance (not citable as a library
path; see *Open questions* for the library gap):

1. Branch from `master`, optionally `git merge origin/integration-endo-master`
   first to pick up parallel work.
2. Walk every `yarn.lock` in the tree (`git ls-tree -r HEAD | cut -f2 | grep '.yarn.lock$'`),
   `cd` to each directory, run `yarn up ses '@endo/*' -R; yarn dedupe`.
   This is the only correct way to bump Endo versions across the
   monorepo + the seven `a3p-integration/proposals/*/yarn.lock` +
   the `multichain-testing/yarn.lock`. **Critical**: PR #12527's
   diff shows the helper landed across 19 `yarn.lock` files; today's
   refresh hits the same set plus root.
3. Commit: `chore: Sync Endo versions`.
4. **Patch hygiene**: every `.yarn/patches/@endo-<pkg>-npm-<version>-<hash>.patch`
   file is **version-keyed**. Bumping the version means either:
   (a) deleting the patch if the fix landed upstream;
   (b) renaming with a new hash if the fix did **not** land upstream
       (in which case you re-resolve the patch against the new npm
       tarball with `yarn patch @endo/<pkg>`);
   (c) deleting the patch if the substance no longer applies (the
       upstream API changed and the patch is moot).
   Per change: `chore: Updated patch version for @endo/<pkg> X.Y.Z` or
   `chore: Remove patch version for @endo/<pkg> X.Y.Z`. PR #12527's
   diff shows the pattern: `@endo-eventual-send-npm-1.3.4-12411c5a98.patch`
   DELETED (substance landed upstream); `@endo-pass-style-npm-1.6.3-139d4e4c47.patch`
   DELETED and replaced with `@endo-pass-style-npm-1.7.0-7dc50195b4.patch`
   (substance carried forward to a new version); and so on. Today's
   re-resolution against `@endo/pass-style@1.8.0` (current npm)
   requires a third refresh pass.
5. `yarn` at the root, separate `chore: Update yarn.lock`.
6. **Bump xsnap METER_TYPE**: edit `packages/xsnap/api.js` →
   `export const METER_TYPE = 'xs-meter-<N+1>';`. *"It is safe to
   assume that any change to Endo will invalidate assumptions about
   guest application meters."*
7. **Regenerate SwingSet xsnap-store snapshots**: `cd packages/SwingSet
   && yarn test test/xsnap-store.test.js --update-snapshots` (and
   `test/xs-perf.test.js`). PR #12527 already touches these
   (`xsnap-store.test.js.md`, `xsnap-store.test.js.snap`,
   `dynamic-vat-metered.test.js`); today's refresh likely needs
   another snapshot pass.
8. **Companion `agoric/documentation` PR**: MAINTAINERS notes the
   `test-dapp (node-new)` job currently fails until a sibling
   change lands on `agoric/documentation`. The May `#11540` mirror's
   verbatim CI failure list included `test-dapp` for this reason.
   The dispatch should treat `test-dapp` failure as **expected**, not
   a blocker.

### Latest npm-published Endo versions (2026-06-09)

| Package | `#12527` ships | Current npm |
|---|---|---|
| `@endo/pass-style` | 1.7.0 | **1.8.0** |
| `@endo/marshal` | (bumped) | 1.10.0 |
| `@endo/eventual-send` | (bumped) | 1.5.0 |
| `@endo/patterns` | (bumped) | 1.9.0 |
| `@endo/bundle-source` | 4.2.0 | **4.3.1** |
| `@endo/compartment-mapper` | 2.0.0 | **2.2.0** |
| `@endo/ses-ava` | (bumped) | 1.4.1 |
| `@endo/promise-kit` | (bumped) | 1.2.1 |
| `@endo/errors` | (bumped) | 1.3.1 |
| `@endo/init` | (bumped) | 1.1.13 |
| `@endo/exo` | (bumped) | 1.7.0 |
| `@endo/far` | (bumped) | 1.1.14 |
| `@endo/captp` | (bumped) | 4.5.1 |
| `@endo/lockdown` | (bumped) | 1.0.19 |
| `@endo/evasive-transform` | (bumped) | 2.2.0 |
| `ses` | (bumped) | 2.1.0 |

The columns that diverge between `#12527 ships` and `Current npm` are
the ones that **require a fresh `yarn up` pass** and a fresh
patch-rename for any surviving patch file. `@endo/pass-style@1.7.0 → 1.8.0`
is the load-bearing one because `pass-style` is the most heavily
patched package on agoric-sdk per the upstream PR's resolutions
table (it has nested patches: `@endo/pass-style@patch:@endo/pass-style@patch:...`).
The current PR resolutions section pins
`@endo/pass-style@patch:@endo/pass-style@patch:@endo/pass-style@npm:1.6.3#...`
(pre-bump); after the refresh the resolution may need to land at
`1.8.0` directly with one patch, not three nested patches, **if and
only if** the substance of the two outer patches has been absorbed
into 1.7.0/1.8.0 upstream. Check `endojs/endo` commit log between
`1.6.3` and `1.8.0` on `packages/pass-style/` before deciding.

### Fork-side PR conventions

- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md):
  every fork-side PR uses a frozen base `<base>-<7-char-short-sha>`.
  For this dispatch the convention is `master-<short-sha>`
  snapshotting `Agoric/agoric-sdk@master` (via `git rev-parse --short=7
  upstream/master`). The mirror PR opens against `kriscendobot/agoric-sdk:master-<sha>`
  with head `kriscendobot/agoric-sdk:mirror/12527-endo-sync` (or
  similar; see *Naming convention* below). The May `#11540` precedent
  used the plain branch name `parallel-upgrade-tests` because frozen-
  base discipline post-dates it (2026-05-22); today's dispatch is
  bound by the current convention.
- [`garden/skills/pr-formation/SKILL.md`](../../../garden/skills/pr-formation/SKILL.md):
  fetch agoric-sdk's PR template on the `master` branch; behavior-
  over-diff body; no checklists; no internal-agent references. The
  PR body should cite `Agoric/agoric-sdk#12527` as the upstream source
  and explain the post-rebase patch-refresh.
- [`garden/skills/pre-pr-checklist/SKILL.md`](../../../garden/skills/pre-pr-checklist/SKILL.md)
  and [`garden/skills/pre-push-gates/SKILL.md`](../../../garden/skills/pre-push-gates/SKILL.md):
  the deterministic gate runs before the first push. **Auto-fix
  behaviors** (Prettier, eslint) will run silently in the builder's
  commit; non-auto-fixable findings get addressed before pushing.
  Note: agoric-sdk's lint regime differs from endo-but-for-bots
  (different lockfile shape, different lint plugin versions); the
  pre-push gate may surface findings the builder has not seen
  before. Surface unfamiliar ones in the result rather than chasing.
- [`garden/skills/yarn-lock-separate-commit/SKILL.md`](../../../garden/skills/yarn-lock-separate-commit/SKILL.md):
  `chore: Update yarn.lock` ships in its own commit. The MAINTAINERS
  procedure already prescribes this shape; the skill reinforces it.
  **Important nuance**: the Endo-sync flow produces **two** distinct
  lockfile commits (`chore: Sync Endo versions`, the per-`yarn.lock`
  `yarn up`+dedupe walk that produces the bulk of the diff) and
  `chore: Update yarn.lock` (the root-level `yarn` after patch
  refresh). Both are lockfile churn; keep them separate per
  MAINTAINERS.
- [`garden/skills/pr-creation-flow/SKILL.md`](../../../garden/skills/pr-creation-flow/SKILL.md):
  the PR opens DRAFT. The cleaner / judge / fixer / un-draft chain
  applies (this is a normal `build #N` deliverable, not a `probe`).
- [`garden/skills/changeset-discipline/SKILL.md`](../../../garden/skills/changeset-discipline/SKILL.md):
  agoric-sdk uses lerna-lite for versioning; no changesets per se.
  The upstream `#12527` does not add a changeset file (verified in
  the diff); today's mirror should follow the same shape.
- [`garden/skills/verify-upstream-state-before-pinning/SKILL.md`](../../../garden/skills/verify-upstream-state-before-pinning/SKILL.md):
  verify the Endo npm versions in real time (per the `npm view`
  table above) rather than copying from `#12527`'s diff verbatim;
  npm publishes drift between the upstream PR's open date (2026-03)
  and now (2026-06).

### Head-branch naming

The repo has these branches on `kriscendobot/agoric-sdk` today:
`master`, `dev-upgrade-23`, `feat/migrate-eslint-plugin-import-x`,
`fix/node-sqlite-builtin`, `fix/photostructure-sqlite-backend`,
`integrate/xsnap-pub-pr-50`, `parallel-upgrade-tests`. The convention
the May `#11540` mirror used (`parallel-upgrade-tests`) is descriptive
but non-citing. The endo-but-for-bots precedent uses `mirror/<N>-<slug>`
(for example, `mirror/3164-freezable-typedarrays`); applied here that would
be `mirror/12527-endo-sync` or `mirror/12527-endo-sync-refresh`. The
*-refresh* suffix is meaningful because today's PR diverges from
`#12527` (post-rebase and post-version-refresh); reviewers should
not assume the diff equals `#12527`'s.

### Why each reference is relevant

- The agoric-sdk project README sets the engagement rules (passive
  standing watch is about to end; this is the first active PR cycle)
  and the identity protocol (`kriscendobot` for fork work).
- The endo project README's authority structure scopes patch-substance
  decisions: a patch on `@endo/pass-style` or `@endo/marshal` that
  reverts erights's work merits erights-grade scrutiny.
- The May `#11540` mirror dispatch is the prior-art for the
  fork-side branch shape, the CI failure pattern (especially the
  `test-dapp` expected-fail), and the conflict surface the rebase
  will hit. Today's deliverable is the rebase the May dispatch
  declined to attempt; the May commentary is the best available
  briefing for what will go wrong.
- The MAINTAINERS procedure is the canonical recipe. Every step
  matters (the `yarn up` walk, the patch-rename triage, the xsnap
  METER_TYPE bump, the SwingSet snapshot regen).
- The npm version table is the live target; copying `#12527`'s
  versions would leave the dispatch one (or more) Endo release
  behind.
- The frozen-base, pr-formation, pre-push, yarn-lock-separate-commit,
  pr-creation-flow, and changeset skills are non-optional procedural
  scaffolding for fork-side PRs the garden opens.

### Open questions (load-bearing for the dispatch; the orchestrator decides)

- **Patch-set substance triage.** PR #12527 deleted three patches
  outright (`@endo-eventual-send-npm-1.3.4-12411c5a98.patch`,
  `@endo-marshal-npm-1.8.0-c73c5363a1.patch`,
  `@endo-patterns-npm-1.7.0-70bb963d8a.patch`) and the
  `@endo-pass-style-patch-*.patch` nest. The dispatch needs to
  decide for **each surviving patch** whether the post-bump npm
  package still needs it. The mechanical answer (per MAINTAINERS):
  attempt the bump with the patch removed; if a test that the patch
  fixed regresses, re-create the patch against the new version. The
  pragmatic answer: read `endojs/endo`'s commit log between the old
  and new versions on the patched paths to see if the substance
  landed.
- **`@endo/pass-style` resolution nest.** The upstream PR carries
  a three-level nested patch (`patch:@endo/pass-style@patch:@endo/pass-style@patch:@endo/pass-style@npm:1.6.3#...`).
  Bumping to 1.8.0 may simplify this to a single patch or eliminate
  it entirely. Verify before pushing.
- **xsnap METER_TYPE name.** Current value at `packages/xsnap/api.js`
  on `master`: read at dispatch time. The increment is mechanical
  (`xs-meter-N` → `xs-meter-N+1`) but the dispatch needs to read
  the current value to know what `N` is.
- **SwingSet snapshot regen scope.** The MAINTAINERS procedure names
  `xsnap-store.test.js` explicitly; the PR diff also touches
  `dynamic-vat-metered.test.js`. The full snapshot regen scope is
  whatever fails after the bump; run the SwingSet test suite at
  least once and update-snapshots whatever needs updating. **Risk**:
  snapshot regen tells you the hash changed; it does not tell you
  whether the change is benign. Per MAINTAINERS: *"Changing anything
  in Endo usually frustrates the SwingSet kernel hashes, and if Endo
  changes nothing, bumping the meter version certainly will."* This
  is expected; surface in the PR body so reviewers know to look at
  the snapshot diffs.
- **`test-dapp (node-new)` expected fail.** Per MAINTAINERS and the
  May `#11540` notes, this job fails until a companion change lands
  on `agoric/documentation`. The dispatch should not try to chase
  this failure; surface in the PR body and result.
- **Per-class monitor rule upgrade.** With this dispatch, agoric-sdk
  exits passive standing watch. The dispatch should note in the
  result entry that the project has an active engagement so a
  follow-up gardener cycle can widen `garden/skills/monitor-agoric-sdk/SKILL.md`
  beyond the uniform "journal a tick, do not dispatch" rule.
- **Library structural gaps (queued for librarian / scholar).** No
  library coverage of: the agoric-sdk `MAINTAINERS.md § Syncing Endo
  versions` procedure (the only canonical source for the recipe;
  agoric-sdk-side; should be a source page); the
  `.yarn/patches/@endo-<pkg>-npm-<version>-<hash>.patch` naming
  convention and triage discipline (cross-cutting; should be a
  concept page); the `xsnap` METER_TYPE convention and the Endo-
  invalidates-meters rationale (endo-side; should be a section
  page off `packages/xsnap`). These are signaled here, not
  fabricated as citations.
```

## Library writeback

No writebacks applied during this engagement. Per the
[library-lookup skill](../../../garden/skills/library-lookup/SKILL.md)
§ 4a-c, writebacks require either (a) a flat-grep success that
reached the right concept page (no concept page exists for any of
the Endo-sync, patch-package, xsnap-METER_TYPE, or
agoric-sdk-MAINTAINERS terms; flat-grep returned nothing relevant),
(b) a distraction on a concept page (none surfaced), or (c) enough
context to draft a missing concept page (the engagement read upstream
`MAINTAINERS.md` directly, but a single read is not the right basis
to draft a concept page that should distill multiple sources). The
absences are surfaced as *Open questions / Library structural gaps*
above instead, per the role file's *Do not invent references* norm.
Queueing a scholar / librarian follow-up to consider three pages:

- An agoric-sdk source page for `MAINTAINERS.md § Syncing Endo
  versions` (today the only library coverage of agoric-sdk is
  `library/sources/agoric-sdk--packages-readme.md` and a handful of
  per-package READMEs; no MAINTAINERS coverage).
- A concept page on patch-package / `.yarn/patches/*` discipline:
  version-keyed filenames, the rename-or-delete-on-bump triage, the
  resolution-nest pattern, and the cross-package recurrence (agoric-
  sdk has 30+ patches; endo and endo-but-for-bots have their own).
- A section page off `packages/xsnap` on the METER_TYPE convention
  (Endo-invalidates-meters rationale; bump shape).

## Open questions

See *Open questions* inside the fenced refinement above. The
load-bearing items for the dispatch are: (1) patch-set substance
triage per surviving patch; (2) `@endo/pass-style` resolution-nest
simplification; (3) xsnap METER_TYPE increment; (4) SwingSet
snapshot regen scope; (5) `test-dapp (node-new)` expected-fail
acknowledgment; (6) per-class monitor rule upgrade follow-up; (7)
library structural gaps (three pages queued for scholar / librarian).

Self-improvement: nothing this time. The researcher role's
*budget: 1-3 minutes* was extended to ~7 minutes per the dispatch
prompt's *Five-to-seven minute target (new-repo depth warranted)*
clause; the depth was load-bearing because (a) no prior library
coverage of the Endo-sync procedure required reading upstream
`MAINTAINERS.md` directly via `gh api`, (b) the npm version table
required per-package `npm view` reads to detect the drift between
`#12527`'s ship date and now, and (c) the May `#11540` precedent
needed full reading (not just citation) to surface the conflict-
surface and `test-dapp` expected-fail context. The *don't-invent-
citations* norm held (every cited journal entry, project README, and
skill path was verified at the researcher's `journal/` HEAD or under
`garden/`). The *index-on-the-fly is mandatory* clause was honored by
surfacing the three library gaps for the librarian / scholar rather
than drafting concept pages on a thin single-source basis.
