---
created: 2026-05-19
updated: 2026-05-19
author: gardener
---

# Skill: node-lts-window-watch

A sensor + planner + driver for keeping a project's Node.js version pins (both the runtime the project ships and the CI matrices the project tests against) aligned with the upstream Node.js LTS supported-versions window. The skill runs on a cadence, detects motion in the window, plans the minimal set of edits across every known pin surface, opens a draft upgrade PR via a builder, and shepherds the PR through CI or surfaces the compatibility impasse early.

The skill exists because PR #231 (familiar-release design) surfaced two pin surfaces that drift independently and silently: `packages/familiar/scripts/download-node.mjs` ships a literal `v20.18.1` to every end-user binary, and `.github/workflows/ci.yml` carries three separate Node version matrices plus four single-version pins, all of which encode different opinions about which majors the project supports. Manual maintenance of these surfaces is reactive (the maintainer notices Node 20 has EOL'd, files an issue, dispatches a builder); this skill makes the maintenance scheduled and idempotent.

## When to use

- **Scheduled cadence (default).** Once per week the steward (or a `/loop` invocation) dispatches a builder that loads this skill. The probe stage either reports `no-motion` and exits, or produces a plan that the builder turns into a draft PR.
- **Maintainer-triggered.** A maintainer asks for "the Node LTS check" or "advance the Node pin"; the liaison dispatches a builder against this skill scoped to one project.
- **Reactive.** A Node.js security advisory lands or a Node major reaches end-of-life inside the embargo window the skill enforces; the steward dispatches out-of-band.

The skill is **not** a replacement for the [botanist](../../roles/botanist/AGENT.md) (which gates each upgrade at merge time) or the [major-general](../../roles/major-general/AGENT.md) (which scouts major-version bumps of project dependencies). It is the **Node-runtime specialization** of the same shape, with one sensor surface (Node.js release schedule and `dist/index.json`) the major-general's `npm registry latest` query does not cover.

## Inputs

`node-lts-window-watch.sh [--probe-only] [--plan-only] [--apply] [<project-root>]`

- `<project-root>`: defaults to the current working directory. The script auto-detects the project shape from `package.json` and the `.github/workflows/` directory.
- `--probe-only`: emit the current state of upstream LTS window + every pin surface; exit 0 with the inventory; do not plan or write.
- `--plan-only` (the default for a scheduled run): probe + compute the minimal-edit plan; print the plan; exit 0 if there is no motion, exit 1 if there is a plan to apply.
- `--apply`: probe + plan + write the edits to the working tree (no git mutation; the calling builder commits).

## State

The skill is stateless across invocations. The two upstream sources of truth are fetched fresh on every run:

- `https://nodejs.org/dist/index.json` — every published Node version with its `lts` field (boolean or LTS codename) and `date`.
- `https://raw.githubusercontent.com/nodejs/Release/main/schedule.json` — the per-major schedule (start, lts, maintenance, end) used to know which majors are *currently* in the active or maintenance LTS window on a given date.

The local source of truth is the project's working tree: pin surfaces are read from files, never cached.

Embargo metadata (when a new LTS major has been published but is younger than the embargo window) is recomputed each run from the upstream schedule; the skill does not persist its own ledger. The botanist's per-project dependabotany ledger is the right place for any cross-cycle decision the skill defers to.

## The LTS-window posture

The skill encodes one **support window posture** the project commits to, expressed as a tuple per pin surface:

- **App bundle (the runtime shipped to end users)**: pin to the **current active LTS** (the most recent major whose Node.js schedule status is `active`). When a new major enters active LTS, the bundle pin advances at the start of the new active window, not before. When the current major drops to maintenance, the bundle pin advances immediately.
- **CI matrix (the versions the project tests against)**: include every major currently in the LTS window (`active` + `maintenance`) plus the current major (the in-development major) at the project's discretion. When a major's schedule end date passes, drop it from the matrix. When a new major enters maintenance, add it.
- **CI single-version pins (lint, depcheck, docs, release-build jobs)**: track the bundle pin (one indirection: lint runs on the same major the bundle ships).

This is the **default policy**; a project's own opinion lives in `<project-root>/.node-lts-window.json` (see *Per-project configuration* below). If no policy file exists, the default applies.

## Pin-surface inventory (what the probe scans)

The probe walks a fixed set of patterns per project shape. Each match is one entry in the inventory with `{surface, file, line, current_pin}`:

| Surface kind          | Path pattern                                  | Pattern                                                   | Replacement strategy                      |
| --------------------- | --------------------------------------------- | --------------------------------------------------------- | ----------------------------------------- |
| App bundle pin        | `packages/*/scripts/download-node.mjs`        | `process.argv[2] \|\| 'v<MAJOR>.<MINOR>.<PATCH>'`         | Literal swap of the full vX.Y.Z string.   |
| App bundle pin        | `**/.nvmrc`                                   | `<MAJOR>` or `<MAJOR>.<MINOR>` or `v<MAJOR>.<MINOR>.<PATCH>` | Match the file's existing precision.    |
| App bundle pin        | `package.json` `engines.node`                 | A semver range                                            | Advance the floor when the floor major leaves the window; keep the range expression. |
| CI single pin         | `.github/workflows/*.yml` step `node-version` | `<MAJOR>.x` (string) at a top-level `with:`               | Bump to new active-LTS `<MAJOR>.x`.       |
| CI matrix             | `.github/workflows/*.yml` `matrix.node-version` | YAML sequence of `<MAJOR>.x` strings                    | Add or drop majors to match the window.   |
| CI matrix (annotated) | `.github/workflows/*.yml` `matrix.node-version` with adjacent comments | Same as above, but comments are preserved | Special handling per *Annotated matrices* below. |

The pattern list lives in `probes/inventory.sh`; new surfaces are added by extending that script and adding a row here.

### Annotated matrices

Some matrices intentionally include non-LTS versions for the project's own reasons (the `test-async-hooks` job in `endojs/endo-but-for-bots` lists `'20'` with a paragraph of comments explaining why; that matrix is **policy-frozen** and the skill does not touch it). The probe treats any `matrix.node-version` block whose adjacent comments contain the substrings `# pinned` or `# policy-frozen` as out-of-scope and reports it as an inventory entry of kind `frozen` (so the maintainer sees it on every probe run but no plan is generated against it).

## Procedure

### 1. Probe upstream

```sh
curl -fsSL https://nodejs.org/dist/index.json           > /tmp/node-dist.json
curl -fsSL https://raw.githubusercontent.com/nodejs/Release/main/schedule.json > /tmp/node-schedule.json
```

Compute:

- **Active LTS major** (`active_lts`): the largest major in `schedule.json` whose `start <= today < lts` is false and `lts <= today < maintenance`. (The "active LTS" window per Node's own terminology.)
- **Maintenance LTS majors** (`maintenance_lts`): majors whose `maintenance <= today < end`.
- **In-window set** (`window = {active_lts} ∪ maintenance_lts`).
- **Current major** (`current`): the largest major in `schedule.json` with `start <= today` (this may be larger than `active_lts` when an odd-numbered major is current-but-not-LTS-yet).
- **Latest patch per in-window major**: max `version` in `dist/index.json` whose `version.startsWith('v<MAJOR>.')`.

### 2. Probe local inventory

Walk the patterns in the table above against `<project-root>`. Produce a JSON inventory:

```json
{
  "surfaces": [
    {"kind":"app-bundle","file":"packages/familiar/scripts/download-node.mjs","line":22,"current":"v20.18.1"},
    {"kind":"ci-single","file":".github/workflows/ci.yml","line":62,"current":"22.x"},
    {"kind":"ci-matrix","file":".github/workflows/ci.yml","line":131,"current":["20.x","22.x","24.x"]},
    {"kind":"frozen","file":".github/workflows/ci.yml","line":239,"current":["20"], "reason":"# pinned per test-async-hooks comments"}
  ]
}
```

### 3. Plan edits

For each non-`frozen` inventory entry, compute the desired pin from the LTS window + the project's policy file:

- **App bundle**: desired = `v<active_lts>.<latest patch>`.
- **CI single**: desired = `<active_lts>.x`.
- **CI matrix**: desired = sorted list of `<MAJOR>.x` for every major in `window`, optionally extended with `<current>.x` if the project opts in (default: yes for matrices that already include a non-LTS current-major version).

A plan entry is `{surface, file, line, current, desired, reason}`. If `current == desired`, no plan entry is emitted.

The plan emits one **summary line per pin surface** plus a **rollup**:

```
  app-bundle: packages/familiar/scripts/download-node.mjs:22  v20.18.1 -> v24.15.0  (app-bundle policy active-lts; advance to active LTS major 24 latest patch)
  ci-single:  .github/workflows/ci.yml:62                     22.x -> 24.x  (ci-single tracks bundle; bump to active LTS 24.x)
  ci-matrix:  .github/workflows/ci.yml:131  ["20.x","22.x","24.x"] -> ["22.x","24.x","26.x"]  (ci-matrix policy window-plus-current; align to window)

rollup: 21 surface(s) affected.
```

### 4. Apply

If `--apply` is set and the plan is non-empty, the script rewrites the inventory's lines in place. The script does not stage, commit, or push; the calling builder runs its standard commit-formation flow.

Per pin-surface kind:

- **App bundle (literal swap)**: regex-anchored replacement of the exact `v<X>.<Y>.<Z>` string at the noted line.
- **CI single**: regex-anchored replacement of the `<MAJOR>.x` value.
- **CI matrix**: YAML re-emit of the sequence preserving inline comments adjacent to non-frozen lines. The probe's matrix parser is intentionally narrow (sequence of bare `<MAJOR>.x` strings); anything else is treated as `frozen` and not edited.
- **`engines.node` range**: deferred (out of scope for v1; see *Future probes*).

### 5. Report

The skill emits a structured report the builder turns into the PR body:

```
# Node.js LTS window report

Generated: 2026-05-19  (window state: active=22, maintenance=24, current=25)

## Plan

[the per-surface plan from §3]

## Upstream sources

- https://nodejs.org/dist/index.json   (fetched 2026-05-19T14:23:45Z)
- https://raw.githubusercontent.com/nodejs/Release/main/schedule.json (fetched 2026-05-19T14:23:45Z)

## Cadence

This run is part of the weekly node-lts-window-watch cadence. Next run: 2026-05-26.

## Out-of-scope inventory

[any `frozen` entries with their reason]
```

## Composition with other skills

- **[`skills/pre-push-gates/SKILL.md`](../pre-push-gates/SKILL.md)**: the gate runs on the builder's push of the upgrade PR, exactly as it runs on any other PR. The gate's probes do not need to know about this skill; the upgrade PR's diff (a literal Node version swap + matrix edits) is small enough that the gate's existing probes (`no-ascii-banners`, `no-pull-citations`, `filename-no-stutter`, etc.) all pass trivially. Typecheck stays the gate's terminal failure mode; a Node version that breaks the project's `tsc` baseline is exactly the compatibility-impasse signal this skill exists to surface.
- **[`skills/verify-upstream-state-before-pinning/SKILL.md`](../verify-upstream-state-before-pinning/SKILL.md)**: the upstream-state-verification posture this skill encodes. The plan stage's curl of `dist/index.json` and `schedule.json` is the verification; the plan cites the URLs in the PR body so a reviewer can re-verify without re-running the script.
- **[`roles/botanist/AGENT.md`](../../roles/botanist/AGENT.md)**: the botanist gates each dependency upgrade at merge time. The botanist's posture (read the lockfile diff, disable preinstall scripts, embargo by default) applies to the upgrade PR this skill produces; the dispatch chain is `node-lts-window-watch` (this skill, run by a builder) → draft PR → CI → judge panel → botanist (when the PR is a fresh-week upgrade) → conductor. The botanist's embargo discipline (≥7 days from upstream publish) is the *upgrade-PR-merge* gate; this skill's own embargo discipline (don't propose a Node major younger than 30 days of active LTS) is the *upgrade-PR-open* gate.
- **[`roles/major-general/AGENT.md`](../../roles/major-general/AGENT.md)**: the major-general scouts npm-registry major bumps; this skill scouts Node.js LTS-window motion. They share the cadence shape (default weekly) and the "PR-not-merge" deliverable; they do not share the sensor surface. A future refactor could extract a common `external-version-cadence` skill they both compose; for now they live as siblings.
- **[`roles/shepherd/AGENT.md`](../../roles/shepherd/AGENT.md)**: the shepherd drives CI to green on any PR. The upgrade PR routes to the shepherd like any other PR; the shepherd's posture (read CI failures, fix the smallest failing surface, iterate) is exactly what surfaces the compatibility impasse this skill is asked to surface early. The impasse becomes legible as a *failing test* on the new Node major rather than as a *missed maintenance signal*.
- **[`roles/builder/AGENT.md`](../../roles/builder/AGENT.md)**: the builder is the role that loads this skill, runs `--apply`, forms the commits (`chore: advance Node pin to v22.11.0`, `chore: drop Node 20 from CI matrix`), and opens the draft PR per [`skills/pr-formation/SKILL.md`](../pr-formation/SKILL.md).
- **[`roles/boatman/AGENT.md`](../../roles/boatman/AGENT.md)**: the boatman ferries the merged garden-side PR upstream when the project has an upstream fork relationship. The upgrade PR this skill produces is ordinary code from the boatman's perspective.

## Per-project configuration

A project may override the default LTS-window posture by placing `<project-root>/.node-lts-window.json` at the repo root:

```json
{
  "app-bundle-policy": "active-lts",
  "ci-matrix-policy": "window-plus-current",
  "embargo-days-for-new-lts": 30,
  "frozen-matrices": [
    {"file": ".github/workflows/ci.yml", "anchor": "test-async-hooks"}
  ]
}
```

Recognised policies:

- `app-bundle-policy`: `active-lts` (default) | `active-lts-minus-1` (lag by one major; pin to the previous active LTS) | `<MAJOR>` (literal pin, escape hatch).
- `ci-matrix-policy`: `window-only` (active LTS + maintenance majors only) | `window-plus-current` (default; add current major) | `window-plus-next` (also include the next-to-be-current; aggressive).
- `embargo-days-for-new-lts`: integer days a new active LTS must have been active before the bundle pin advances (default 30).
- `frozen-matrices`: list of matrices to skip; the `anchor` is the job name immediately containing the matrix.

The skill reads this file once at the start of a run; if missing, defaults apply.

## Cadence and trigger conditions

| Trigger                                    | Driver                                  | Action                                  |
| ------------------------------------------ | --------------------------------------- | --------------------------------------- |
| Weekly cadence (every Monday 14:00 UTC)    | Steward `/loop` or cron-equivalent      | Dispatch builder, run skill `--plan-only`. If plan non-empty, `--apply` and open draft PR. |
| Maintainer request                         | Liaison dispatches builder              | Same, scoped to one project.            |
| Node major schedule transition (active→maintenance, maintenance→end) | The weekly cadence catches it within 7 days | Plan emits the appropriate drop / advance. |
| Node security release inside the active window | Out-of-band cadence: steward dispatches the next morning after the advisory | Plan emits a patch-version bump only. |
| Fresh active LTS (a major has just entered active LTS) | Weekly cadence; the embargo gate holds the proposal for `embargo-days-for-new-lts` (default 30) | The first run after the embargo expires plans the advance. |

Cadence is encoded as **weekly** in the default policy because (a) Node's schedule shifts in discrete steps (a major moves from active to maintenance on a published date), and (b) the upgrade PR's review cost is non-trivial. A daily cadence would produce noise (the same `no-motion` report every day) without changing the outcome.

## Impasse surfacing

The skill's value-add over a hand-written upgrade is that it *fails loudly* when the project cannot move with the LTS window. Impasses surface in two places:

1. **CI on the upgrade PR**. A test that fails only on the new Node major is the project's own statement that the project is not yet portable to that major. The shepherd's CI-fix attempt (default behaviour for any failing PR) becomes a *cost report*: how many surfaces broke, in which packages, with what error class. If the shepherd cannot close the gap in one pass, the PR's CI rollup becomes the impasse evidence.
2. **The plan's `out-of-scope` rollup**. A pin surface marked `frozen` or an `engines.node` range the skill cannot safely rewrite produces an explicit line in the plan that the maintainer reads on every weekly cadence. Persistent presence of the same out-of-scope line for N weeks is itself a signal (the project has accreted a Node-version dependency it does not yet have a story for).

The PR stays **draft** until either the shepherd reports green or a maintainer acknowledges the impasse. The judge's normal un-draft trigger (per [`skills/pr-creation-flow/SKILL.md`](../pr-creation-flow/SKILL.md)) applies; un-drafting waits on green CI by construction.

## Output

The skill's deliverables, per run:

- A `result` journal entry from the dispatched builder summarising the plan, with `kind: result`, `role: builder`, and a `project:` slug.
- When the plan is non-empty: a draft PR titled `chore(ci,bundle): advance Node pins to track LTS window (<date>)` with the structured report from §5 as the body.
- When the plan is empty: a one-line journal entry (no PR) confirming the cadence ran and the window has not moved.

## Adding a pin surface

A new pin surface is one new probe under `probes/`:

1. Add a regex-or-parser stage to `probes/inventory.sh` that finds the pin and emits an inventory line.
2. Add the surface to the *Pin-surface inventory* table above with the path pattern, the pattern, and the replacement strategy.
3. Add a corresponding apply branch to `apply.sh`.

The probe driver walks the project for any pattern in the inventory; the apply driver rewrites any pattern in the plan. New surfaces compose without changing the skill's top-level shape.

## Pitfalls

- **Do not blindly bump `engines.node`.** The semver range is the project's authored intent (the minimum Node the project supports), not a single-version pin. The skill's v1 reports the range in the inventory but does not rewrite it; advancing the floor is a project decision, not a window-motion consequence.
- **Do not edit a frozen matrix.** A matrix exists with deliberate non-LTS versions for a reason the comment documents; rewriting it loses that intent. The `frozen` inventory kind is the safety belt.
- **Do not propose a Node major younger than the embargo.** A major's first 30 days as active LTS is high-risk (registry-cache poisoning, freshly-disclosed CVEs against the new V8). The embargo gate holds the proposal until the upstream signal stabilises; this matches the [botanist](../../roles/botanist/AGENT.md)'s default embargo of seven days for non-vuln-repair upgrades, scaled up because a Node bump's blast radius is larger.
- **Do not assume one project, one pin.** The familiar app's `download-node.mjs` is a pin surface distinct from the CI matrices; both must advance together in a *single* PR so reviewers see the policy applied consistently across the project. The skill's plan stage produces one plan per project, not per file.
- **Auto-fix loops with `pre-push-gates`.** The gate's `yarn format` may rewrite a YAML matrix the skill just edited (whitespace, line ordering). The gate runs after this skill in the builder's flow, so the gate wins; the skill's apply stage should already emit YAML the gate accepts (sentinels for matrix re-emit are conservative whitespace, sorted versions ascending, no inline comments inserted).

## Future probes

The v1 inventory does not cover:

- **Docker base images** (`FROM node:<MAJOR>` in `Dockerfile`). Add when a project the garden touches ships a Dockerfile.
- **`engines.node` semver-range advancement** with floor / ceiling policy.
- **Per-package `package.json` `engines.node`** (workspace-wide consistency check).
- **Renovate or Dependabot config for `nodejs` itself** (most projects do not enable this; when one does, the skill should detect and surface that Renovate is already moving the pin and step down).
- **Hand-rolled binary download caches** (the skill's app-bundle handler today recognises one shape: `process.argv[2] || 'vX.Y.Z'`. A project that downloads Node via a different shape is uncovered.).

Each of these lands as a new probe with a row in the *Pin-surface inventory* table and a branch in `apply.sh`.

## Notes from the field

(Append; terse and dated.)

- _2026-05-19_: initial bootstrap from PR #231 L227 ask. The skill ships with the two pin surfaces present in `endojs/endo-but-for-bots` (familiar app bundle, ci.yml matrices and single pins) and the default LTS-window posture. The first weekly cadence after the bundle pin advance to v22 (G5 in the familiar-release design) will exercise the skill end-to-end on the same repo that motivated it.
