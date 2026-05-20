---
ts: 2026-05-19T06:42:47Z
kind: result
role: gardener
project: endo-but-for-bots
refs:
  - PR#231 L227 (kriskowal): https://github.com/endojs/endo-but-for-bots/pull/231#discussion_r... (familiar-release.md G5)
---

# Result: skills/node-lts-window-watch landed on main

Per PR #231 L227 (kriskowal's CHANGES_REQUESTED review on the
familiar-release design): design and propose a mechanism for sensing
motion on the Node.js LTS supported-versions window and automatically
updating the version pin (app bundle + CI matrices), shepherding the
upgrade PR through CI or surfacing compatibility impasses early.

## What landed

Commit `eea9725` on `main`:

- `skills/node-lts-window-watch/SKILL.md` (new). Contract: sensor +
  planner + applier. Cadence default weekly. Composes with
  `pre-push-gates`, `verify-upstream-state-before-pinning`,
  `botanist`, `major-general`, `shepherd`.
- `skills/node-lts-window-watch/node-lts-window-watch.sh` (driver).
- `skills/node-lts-window-watch/probes/upstream-window.sh` (fetches
  `nodejs.org/dist/index.json` and `nodejs/Release schedule.json`;
  emits window state).
- `skills/node-lts-window-watch/probes/inventory.sh` (walks project
  for pin surfaces: app-bundle literals, .nvmrc, CI single pins,
  CI matrix inline + block form; marks annotated matrices as
  `frozen`; reports `engines.node` ranges read-only).
- `skills/node-lts-window-watch/probes/plan.sh` (minimal-edit plan
  per the project's `.node-lts-window.json` policy file or the
  default).
- `skills/node-lts-window-watch/probes/report.sh` (per-run report,
  copy into PR body).
- `skills/node-lts-window-watch/probes/apply.sh` (rewrites pin
  surfaces in place; no git mutation).
- `CLAUDE.md` § Current inventory updated.
- `roles/builder/AGENT.md` and `roles/major-general/AGENT.md`
  cross-reference the skill.

## Sensing cadence and trigger conditions

- **Weekly cadence (Monday 14:00 UTC default).** Steward dispatches
  a builder that runs `--plan-only`; if non-empty, the same
  dispatch runs `--apply` and opens a draft PR.
- **Maintainer request.** Liaison dispatches builder ad-hoc.
- **Node major schedule transition** (active→maintenance,
  maintenance→end): caught within 7 days by the weekly cadence.
- **Node security release inside the window.** Steward dispatches
  out-of-band the next morning after the advisory.
- **Fresh active LTS** (a major just entered active LTS): held by
  the skill's own 30-day embargo before the bundle pin advances
  (configurable via `.node-lts-window.json`
  `embargo-days-for-new-lts`).

## Smoke-test result (against endojs/endo-but-for-bots@llm)

Probe identified 27 surfaces. Today's window state (computed live):
active=24, maintenance=[22], current=26, latest_patch={20:v20.18.1,
22:v22.22.3, 24:v24.15.0, 25:v25.9.0, 26:v26.1.0}.

Plan against that repo correctly proposes:
- `packages/familiar/scripts/download-node.mjs:22 v20.18.1 -> v24.15.0`
- Fifteen CI single pins (`22.x` or `20.x`) -> `24.x`
- Five CI matrices `[20.x, 22.x, 24.x]` or `[20.x, 24.x]` ->
  `[22.x, 24.x, 26.x]`
- Block-form annotated matrix `test-async-hooks` correctly marked
  `frozen`.
- Five `engines.node` semver ranges reported (no plan; v1 does not
  rewrite ranges).

Apply correctly rewrote the bundle pin, the CI single pins, and the
inline matrices on a scratch copy.

## Compatibility-impasse surfacing

Two surfaces:
1. **Failing CI on the upgrade PR.** The shepherd's normal CI-fix
   attempt becomes a cost report: how many surfaces broke, in which
   packages, with what error class. If the shepherd cannot close
   the gap in one pass, the PR's CI rollup is the impasse evidence.
2. **The plan's `out-of-scope` rollup.** Frozen matrices and
   non-rewritable `engines.node` ranges produce a recurring line in
   the weekly plan; persistent presence is itself the signal that
   the project has accreted a Node-version dependency without a
   story.

The upgrade PR stays draft until the shepherd reports green; the
judge's normal un-draft chain (`skills/pr-creation-flow/SKILL.md`)
gates the merge.

## Composition

- **`pre-push-gates`**: runs as usual on the upgrade PR push. The
  bundle/matrix edits are small literals that pass the existing
  probes trivially; `yarn typecheck` is the gate's terminal failure
  mode and exactly the compatibility-impasse signal the skill exists
  to surface.
- **`verify-upstream-state-before-pinning`**: the verification
  posture this skill encodes. Both upstream URLs are cited in the
  PR body each run.
- **`botanist`**: gates the upgrade PR at merge time (lockfile
  reading, scripts-disabled install, embargo). The botanist's
  7-day embargo applies in addition to this skill's 30-day
  new-LTS embargo.
- **`major-general`**: sibling skill for npm-registry major
  bumps. Same cadence shape, distinct sensor surface. A future
  refactor could extract a common `external-version-cadence`
  skill they both compose.
- **`shepherd`**: drives CI to green on the upgrade PR, which is
  the impasse-surfacing path.
- **`builder`**: loaded by the cadence-driven dispatch (not the
  default `build #N` path).

## Followups noted

- **A `node-lts` vocabulary verb.** The maintainer might want a
  shorthand like `bump node` or `check node lts` for the
  ad-hoc maintainer-triggered case. Not landed in this dispatch;
  defer until the cadence has run a few weeks and the verb's shape
  is obvious.
- **Block-form CI matrix apply.** v1 inventory recognises block
  form (and flags it correctly as `ci-matrix` or `frozen`), but
  apply only handles the inline form. The block-form apply is a
  future probe stage; until then a builder rewrites by hand from
  the plan.
- **`engines.node` floor-advancement policy.** v1 reports the
  range read-only. A future skill addition could advance the
  floor when the floor major leaves the LTS window, but the
  semver range carries authored intent that needs project policy
  before automation is safe.
- **Docker base image pins** (`FROM node:<MAJOR>`). No project
  in the active set ships a Dockerfile yet; the surface gets a
  probe when one does.
- **Sibling-skill extraction.** `node-lts-window-watch` and
  `major-general` share a *cadence + scout + propose-PR* shape;
  pulling out a common `external-version-cadence` skill is
  worth considering once the maintenance burden is visible.
- **Steward cadence row.** The skill notes the weekly cadence in
  its trigger table, but does not (yet) land a row in
  `roles/steward/AGENT.md` § Scheduled engagements / Standing
  duties. A follow-up gardener dispatch (after the maintainer
  confirms the cadence in practice) lands that row.
- **Per-project `.node-lts-window.json` for endo-but-for-bots.**
  The repo currently has none; the default policy applies and
  produces a sensible plan against the live tree. If the
  maintainer wants the `test-async-hooks` block to remain
  policy-frozen (it already is, by adjacent-comment heuristic),
  no config is needed; if the maintainer wants a stricter
  matrix policy than `window-plus-current`, a config file
  records the opinion.

Self-improvement: nothing this time. The skill exercises the
existing dispatch contract cleanly (a builder loads a skill that
produces a PR-ready plan) without surfacing a new pattern that
would warrant a role or skill change.
