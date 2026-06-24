---
ts: 2026-06-09T03:16:00Z
kind: dispatch
role: steward
host: endolinbot
repo: Agoric/agoric-sdk
project: agoric-sdk
to: builder
dispatch_root: /home/kris/dispatches/builder--1f1de6
prs:
  - repo: Agoric/agoric-sdk
    pr: 12527
    role: source
refs:
  - entries/2026/06/09/025700Z-dispatch-researcher-fcab29.md
  - entries/2026/06/09/030023Z-result-researcher-fcab29.md
  - entries/2026/05/13/214419Z-dispatch-liaison-3fdcd2.md
  - entries/2026/05/13/214930Z-result-builder-a2f187.md
  - https://github.com/Agoric/agoric-sdk/pull/12527
---

# dispatch: builder — mirror+rebase+refresh agoric-sdk#12527 to latest npm Endo

User directive (2026-06-09T02:50Z):

> Please dispatch a builder to create a mirror of
> https://github.com/Agoric/agoric-sdk/pull/12527 and rebase
> on current master. There has been an even more recent
> release of Endo packages, so please also instruct the
> builder to move to the latest versions published to npm.
> This may require some reconstruction of some commits or
> further adjustments to patches. Use the kriscendobot fork
> of agoric-sdk.

## State at dispatch time

- **Upstream PR `Agoric/agoric-sdk#12527`** ("Sync Endo
  dependencies and refresh patch set"): Copilot-authored,
  base `master`, head `copilot/update-endo-dependency-versions`
  at `a6212a8` (9 commits, +4637/-4731 across 92 files).
  Updated 2026-04-14 (~8 weeks stale). APPROVED by turadg.
  Currently DIRTY / CONFLICTING.
- **Bot fork**: `kriscendobot/agoric-sdk`, default branch
  `master`, last updated 2026-05-12.
- **Upstream master tip**: `ce854477ce8860142c81f731c70527040729ffb9`.
- **PR #12527 touches**:
  - 19 `yarn.lock` files (root + 7 `a3p-integration/proposals/*`
    + `multichain-testing` + 11 `packages/*`).
  - All `@endo/*` `package.json` dep blocks.
  - Patch set in `.yarn/patches/`.
  - `packages/xsnap/api.js` (`METER_TYPE` bump).
  - SwingSet snapshots.

## Library and project references

(Inlined verbatim from researcher `fcab29`'s section. Full
section in `entries/2026/06/09/030023Z-result-researcher-fcab29.md`.)

### Prior-art

- [`entries/2026/05/13/214419Z-dispatch-liaison-3fdcd2.md`](../../05/13/214419Z-dispatch-liaison-3fdcd2.md)
  + [`214930Z-result-builder-a2f187.md`](../../05/13/214930Z-result-builder-a2f187.md):
  `Agoric/agoric-sdk#11540` mirrored to
  `kriscendobot/agoric-sdk:parallel-upgrade-tests` in May
  2026. That dispatch was **mirror-and-comment only**,
  explicitly **NOT rebased** because the maintainer found
  ~58 commits with type-suppression conflicts too contentious.
  **Today's dispatch is the inverse**: rebase IS the
  deliverable. The `parallel-upgrade-tests` branch still
  exists on the fork; pick a distinct head name (suggested
  `mirror/12527-endo-sync-refresh`).

### PR #12527 substance

- Copilot-authored, +4637/-4731 across 92 files. Touches
  every `@endo/*` `package.json` dep block, 19 `yarn.lock`
  files, the patch set in `.yarn/patches/`, `packages/xsnap/
  api.js` (METER_TYPE), and SwingSet snapshots. APPROVED
  by turadg but DIRTY / CONFLICTING against current master.

### Endo version staleness

PR #12527 ships these versions; current npm at 2026-06-09:

| package | PR #12527 ships | npm current |
|---|---|---|
| `@endo/pass-style` | 1.7.0 | 1.8.0 |
| `@endo/bundle-source` | 4.2.0 | 4.3.1 |
| `@endo/compartment-mapper` | 2.0.0 | 2.2.0 |

(The researcher's result entry carries the full version
table; query `npm view @endo/<pkg> version` to confirm and
extend.)

### Canonical procedure

agoric-sdk's upstream `MAINTAINERS.md § Syncing Endo
dependency versions` (read at master via `gh api repos/Agoric/
agoric-sdk/contents/MAINTAINERS.md`; not yet ingested into
the garden's library). Recipe summary:

1. `git ls-tree` walk for every `yarn.lock`.
2. `yarn up ses '@endo/*' -R; yarn dedupe` per workspace.
3. `chore: Sync Endo versions` commit.
4. Patch rename / delete triage (per-patch commits): patches
   in `.yarn/patches/@endo-*-<version>-<hash>.patch` are
   keyed by version; bumping versions invalidates the patches'
   names and may invalidate their contents. Re-resolve each
   conflict; commit per-patch if the resolution carries.
5. Root `yarn` + `chore: Update yarn.lock`.
6. `xsnap` METER_TYPE bump (`xs-meter-N → N+1`).
7. SwingSet snapshot regen (`xsnap-store.test.js`,
   `xs-perf.test.js`).

### Open questions / discipline notes

- `@endo/pass-style` resolution-nest in `package.json` is
  currently three-level nested patch; bumping may simplify
  or eliminate.
- `test-dapp (node-new)` is an expected-fail on Endo-sync PRs
  (companion `agoric/documentation` PR required); do not
  chase.
- **Identity / posture**: `kriscendobot` for fork work; no
  `identity_switch_authorized` (fork-side only, no upstream
  PR). The bot opens the PR from `kriscendobot/agoric-sdk`
  against `Agoric/agoric-sdk:master` (cross-fork; if
  cross-fork is blocked per memory, mirror onto the same
  bot fork instead and surface).
- **Project exits passive standing watch** with this dispatch;
  note for follow-up gardener cycle to widen
  `skills/monitor-agoric-sdk/SKILL.md` if recurring.
- **Library structural gaps**: no coverage of (a)
  `MAINTAINERS.md § Syncing Endo versions`, (b) `.yarn/patches`
  naming/triage, (c) `xsnap` METER_TYPE convention. Queue
  for librarian/scholar.

## Task

In your `project/` worktree (cwd: project worktree on
`Agoric/agoric-sdk` at master `ce854477`):

1. **Add bot fork remote** (idempotent):
   `git remote add kriscendobot https://github.com/kriscendobot/agoric-sdk.git`.
2. **Add upstream PR's branch reference**:
   `git fetch origin pull/12527/head:source-12527` (creates
   local ref to the source).
3. **Create the mirror branch** `mirror/12527-endo-sync-refresh`
   off current upstream master (`ce854477`):
   `git checkout -b mirror/12527-endo-sync-refresh ce854477`.
4. **Cherry-pick or rebase** PR #12527's 9 commits onto the
   mirror branch:
   - Try `git cherry-pick ce854477..source-12527` (range
     form). Resolve conflicts per
     `garden/skills/conflict-resolution/SKILL.md`.
   - The conflicts will primarily be in `yarn.lock` files,
     `package.json` dep blocks, and `.yarn/patches/`
     (because master moved 8 weeks). Per the canonical
     procedure: yarn.lock conflicts → regenerate via `yarn
     install`; patch conflicts → re-resolve per the patch's
     intent.
5. **Refresh to latest npm Endo versions**: after the cherry-
   pick lands, run the canonical procedure step 2-7 to bump
   from PR #12527's `1.7.0` / `4.2.0` / `2.0.0` versions to
   the current npm versions (`1.8.0` / `4.3.1` / `2.2.0`,
   plus all other `@endo/*` packages). Use `yarn up ses
   '@endo/*' -R` per workspace; commit as `chore: Sync Endo
   versions (refresh to current npm)`.
6. **Patch re-resolution**: any patch whose filename version
   no longer matches (e.g.,
   `.yarn/patches/@endo-pass-style-npm-1.7.0-<hash>.patch` →
   needs rename to `1.8.0-<newhash>.patch` OR deletion if the
   upstream fix landed). Per-patch commits per the canonical
   discipline.
7. **xsnap METER_TYPE bump** and SwingSet snapshot regen per
   the canonical procedure (steps 6-7).
8. **Push** the mirror branch:
   `git push kriscendobot mirror/12527-endo-sync-refresh`.
9. **Open the PR DRAFT** on the bot fork OR (if cross-fork
   opening is feasible) against `Agoric/agoric-sdk:master`:
   - Title: `Sync Endo dependencies and refresh patch set
     (mirror of #12527, refreshed to current npm versions)`
   - Body: cite upstream #12527 as source, name the version
     deltas (mid-April → current npm), enumerate any
     non-trivial patch resolutions, note CI will validate
     the deps and METER_TYPE bump.
   - Surface any out-of-scope drift in the PR body.

## Authorizations (per-action, forwarded by steward)

- **Push** the mirror branch to `kriscendobot/agoric-sdk`.
- **Open the DRAFT PR**. If cross-fork open against
  `Agoric/agoric-sdk:master` fails (cross-fork PR-creation
  block per memory rule), mirror onto the same bot fork
  instead and surface.
- **Post the draft-PR body**. Per the External-repo etiquette
  rule (`roles/COMMON.md`): the user's directive authorizes
  the PR open + body; subsequent comments/reviews/cross-refs
  need separate per-action authorization.

## Out of scope

- Do NOT chase `test-dapp (node-new)` failures (expected
  per the researcher's notes).
- Do NOT touch other PRs or other repos.
- Do NOT shepherd CI to green.
- Do NOT open upstream cross-references without per-action
  authorization beyond the PR-open / PR-body shape.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` per the
builder deliverable: mirror branch + tip SHA, opened PR
number/URL, version-bump table (PR-#12527-baseline → current
npm → actual landed), patch-by-patch resolution notes, any
out-of-scope drift surfaced, and `Self-improvement: ...`.

If the scope grows unwieldy (substantial test-fixture
regeneration, deep test failures, or upstream-test infra
beyond the mirror's scope), surface to liaison via a
`message: builder → liaison` and stop at a partial mirror
rather than overrun.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
