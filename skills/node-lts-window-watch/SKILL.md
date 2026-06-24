---
created: 2026-05-19
updated: 2026-06-24
author: gardener
---

# Skill: node-lts-window-watch

A sensor + planner for keeping a project's Node.js version pins (both the runtime the project ships and the CI matrices it tests against) aligned with the upstream Node.js LTS supported-versions window. The sensor runs on a cadence, detects motion in the window, and plans the minimal set of edits across every known pin surface. When there is motion, a job is posted to the board; a gardener claims it, applies the plan, opens a draft upgrade PR, and runs it through the gauntlet (CI then the panel) or surfaces the compatibility impasse early.

The skill exists because PR #231 (familiar-release design) surfaced two pin surfaces that drift independently and silently: `packages/familiar/scripts/download-node.mjs` ships a literal `v20.18.1` to every end-user binary, and `.github/workflows/ci.yml` carries three Node version matrices plus four single-version pins, all encoding different opinions about which majors the project supports. Manual maintenance is reactive; this skill makes it scheduled and idempotent.

## v2 shape: sensor-as-producer, applier-as-gardener-job

The skill splits cleanly along the v2 producer/consumer line:

- **The sensor + planner is a producer.** A poller (a [triager](../job-board/SKILL.md)-style per-project unit, or the [watchman](../job-board/SKILL.md) running on a cadence) runs `node-lts-window-watch.sh --plan-only` against the project worktree. On `no-motion` it does nothing (quiet). On a non-empty plan it **posts a job** to the board (`post-job.sh`, per [job-board](../job-board/SKILL.md)), with the structured report from §5 as the job body.
- **The applier is a gardener job.** A gardener claims the job, runs `node-lts-window-watch.sh --apply` against its project worktree to write the edits, forms the commits (`chore: advance Node pin to v22.11.0`, `chore: drop Node 20 from CI matrix`), opens the draft PR per [pr-formation](../pr-formation/SKILL.md), and lets the gardening state machine drive the PR through the gauntlet (CI then the panel via `scripts/jobs/gardening/garden-pr.sh`).

The sensor holds no standing state of its own (both upstream sources are fetched fresh each run; see *State*), so the producer needs only its cadence and the journal clone for posting. Any cross-cycle marker the poller wants (e.g. "I already posted a job for this window transition; don't double-post") lives under `GARDEN_STATE`, never `/tmp` — consistent with all v2 standing markers.

This is the Node-runtime specialization of the dependency-cadence shape; it is not a replacement for a merge-time upgrade gate (which embargoes each upgrade) or a general major-version scout (which scouts npm-registry bumps). It has one sensor surface — the Node.js release schedule and `dist/index.json` — that an `npm registry latest` query does not cover.

## Inputs

`node-lts-window-watch.sh [--probe-only] [--plan-only] [--apply] [<project-root>]`

- `<project-root>`: defaults to the current working directory. The script auto-detects the project shape from `package.json` and `.github/workflows/`.
- `--probe-only`: emit the current state of the upstream LTS window + every pin surface; exit 0 with the inventory; no plan, no write. (The producer's smoke-test mode.)
- `--plan-only` (the default; the producer's cadence mode): probe + compute the minimal-edit plan; print the plan; exit 0 if no motion, exit 1 if there is a plan to apply.
- `--apply` (the gardener's mode): probe + plan + write the edits to the working tree (no git mutation; the gardener commits).

## State

Stateless across invocations. The two upstream sources of truth are fetched fresh on every run:

- `https://nodejs.org/dist/index.json` — every published Node version with its `lts` field and `date`.
- `https://raw.githubusercontent.com/nodejs/Release/main/schedule.json` — the per-major schedule (start, lts, maintenance, end) used to know which majors are *currently* in the active or maintenance LTS window on a given date.

The local source of truth is the project's working tree: pin surfaces are read from files, never cached. Embargo metadata is recomputed each run from the upstream schedule; the skill does not persist its own ledger. Any optional poller-side dedup marker lives under `GARDEN_STATE`.

## The LTS-window posture

The skill encodes one **support window posture** the project commits to, expressed per pin surface:

- **App bundle (the runtime shipped to end users)**: pin to the **current active LTS** (the most recent major whose schedule status is `active`). When a new major enters active LTS, the bundle pin advances at the start of the new active window, not before. When the current major drops to maintenance, the bundle pin advances immediately.
- **CI matrix (the versions tested against)**: include every major currently in the LTS window (`active` + `maintenance`) plus the current major at the project's discretion. Drop a major when its schedule end date passes; add a major when it enters maintenance.
- **CI single-version pins (lint, depcheck, docs, release-build jobs)**: track the bundle pin (lint runs on the same major the bundle ships).

This is the **default policy**; a project's own opinion lives in `<project-root>/.node-lts-window.json` (see *Per-project configuration*). If no policy file exists, the default applies.

## Pin-surface inventory (what the probe scans)

| Surface kind          | Path pattern                                  | Pattern                                                   | Replacement strategy                      |
| --------------------- | --------------------------------------------- | --------------------------------------------------------- | ----------------------------------------- |
| App bundle pin        | `packages/*/scripts/download-node.mjs`        | `process.argv[2] \|\| 'v<MAJOR>.<MINOR>.<PATCH>'`         | Literal swap of the full vX.Y.Z string.   |
| App bundle pin        | `**/.nvmrc`                                   | `<MAJOR>` or `<MAJOR>.<MINOR>` or `v<MAJOR>.<MINOR>.<PATCH>` | Match the file's existing precision.    |
| App bundle pin        | `package.json` `engines.node`                 | A semver range                                            | Advance the floor when the floor major leaves the window; keep the range expression. |
| CI single pin         | `.github/workflows/*.yml` step `node-version` | `<MAJOR>.x` (string) at a top-level `with:`               | Bump to new active-LTS `<MAJOR>.x`.       |
| CI matrix             | `.github/workflows/*.yml` `matrix.node-version` | YAML sequence of `<MAJOR>.x` strings                    | Add or drop majors to match the window.   |
| CI matrix (annotated) | `.github/workflows/*.yml` `matrix.node-version` with adjacent comments | Same as above, comments preserved | Special handling per *Annotated matrices*. |

The pattern list lives in `probes/inventory.sh`; new surfaces extend that script and add a row here.

### Annotated matrices

Some matrices intentionally include non-LTS versions (the `test-async-hooks` job in `endojs/endo-but-for-bots` lists `'20'` with a paragraph of comments; that matrix is **policy-frozen** and the skill does not touch it). The probe treats any `matrix.node-version` block whose adjacent comments contain `# pinned` or `# policy-frozen` as out-of-scope and reports it as an inventory entry of kind `frozen`.

## Procedure

### 1. Probe upstream

```sh
curl -fsSL https://nodejs.org/dist/index.json > "$TMP/dist.json"
curl -fsSL https://raw.githubusercontent.com/nodejs/Release/main/schedule.json > "$TMP/schedule.json"
```

(The sensor uses a `mktemp -d` scratch dir, not `/tmp` markers.) Compute via `probes/upstream-window.sh`:

- **Active LTS major** (`active_lts`): the largest major whose `lts <= today < maintenance`.
- **Maintenance LTS majors** (`maintenance_lts`): majors whose `maintenance <= today < end`.
- **In-window set** (`window = {active_lts} ∪ maintenance_lts`).
- **Current major** (`current`): the largest major with `start <= today`.
- **Latest patch per in-window major**: max `version` in `dist.json` for that major.

### 2. Probe local inventory

`probes/inventory.sh <project-root>` walks the patterns above and emits a JSON inventory of `{kind, file, line, current}` entries (frozen entries carry a `reason`).

### 3. Plan edits

`probes/plan.sh <window.json> <inventory.json> <project-root>` computes, for each non-`frozen` entry, the desired pin from the window + the policy file:

- **App bundle**: `v<active_lts>.<latest patch>`.
- **CI single**: `<active_lts>.x`.
- **CI matrix**: sorted `<MAJOR>.x` for every major in `window`, optionally extended with `<current>.x`.

A plan entry is `{surface, file, line, current, desired, reason}`; if `current == desired`, no entry is emitted. The plan emits one summary line per pin surface plus a rollup.

### 4. Apply

If `--apply` and the plan is non-empty, `probes/apply.sh <plan.json> <project-root>` rewrites the inventory's lines in place (literal swap for app-bundle, regex-anchored for CI single, narrow YAML re-emit for CI matrix preserving non-frozen inline comments; `engines.node` ranges are deferred). The script does not stage, commit, or push; the gardener runs its commit-formation flow.

### 5. Report

`probes/report.sh` emits the structured report the gardener turns into the PR body (and the producer posts as the job body):

```
# Node.js LTS window report

Generated: 2026-05-19  (window state: active=22, maintenance=24, current=25)

## Plan
[the per-surface plan from §3]

## Upstream sources
- https://nodejs.org/dist/index.json   (fetched 2026-05-19T14:23:45Z)
- https://raw.githubusercontent.com/nodejs/Release/main/schedule.json (fetched 2026-05-19T14:23:45Z)

## Out-of-scope inventory
[any `frozen` entries with their reason]
```

## Per-project configuration

A project may override the default posture with `<project-root>/.node-lts-window.json`:

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

Recognised policies: `app-bundle-policy` (`active-lts` default | `active-lts-minus-1` | `<MAJOR>` literal); `ci-matrix-policy` (`window-only` | `window-plus-current` default | `window-plus-next`); `embargo-days-for-new-lts` (integer; default 30); `frozen-matrices` (list; the `anchor` is the job name containing the matrix). Read once at the start of a run; if missing, defaults apply.

## Cadence and trigger conditions

| Trigger                                    | Producer action                          | Consumer action |
| ------------------------------------------ | ---------------------------------------- | --------------- |
| Weekly cadence (every Monday 14:00 UTC)    | The poller runs `--plan-only`; on a non-empty plan, posts a `node-lts` job to the board. | A gardener claims it, runs `--apply`, opens the draft PR, runs the gauntlet. |
| Maintainer request                         | The liaison posts the job directly (or a gardener runs the skill in-session). | Same. |
| Node major schedule transition (active→maintenance, maintenance→end) | The weekly cadence catches it within 7 days; the plan emits the appropriate drop/advance. | Same. |
| Node security release inside the active window | Out-of-band: the poller's next run posts a patch-version-bump job. | Same. |
| Fresh active LTS | The embargo gate holds the proposal for `embargo-days-for-new-lts` (default 30); the first run after expiry plans the advance. | Same. |

Cadence is **weekly** in the default policy because Node's schedule shifts in discrete steps and the upgrade PR's review cost is non-trivial; a daily cadence would post the same `no-motion` every day without changing the outcome.

## Impasse surfacing

The skill's value-add over a hand-written upgrade is that it *fails loudly* when the project cannot move with the LTS window. Impasses surface in two places:

1. **CI on the upgrade PR.** A test that fails only on the new Node major is the project's own statement that it is not yet portable. The gardening state machine's CI-fix attempt becomes a cost report: how many surfaces broke, in which packages, with what error class.
2. **The plan's out-of-scope rollup.** A `frozen` surface or an `engines.node` range the skill cannot safely rewrite produces an explicit line on every cadence run. Persistent presence of the same line for N weeks is itself a signal.

The PR stays **draft** until either CI is green or a maintainer acknowledges the impasse; the panel's normal un-draft trigger ([panel](../panel/SKILL.md)) applies, and un-drafting waits on green CI by construction.

## Composition with other skills

- **[pre-push-gates]:** runs on the gardener's push of the upgrade PR like any other PR; the upgrade diff is small enough that the gates pass trivially. A Node version that breaks the project's `tsc` baseline is exactly the compatibility-impasse signal.
- **[verify-upstream-state-before-pinning]:** the curl of `dist.json` and `schedule.json` is the verification; the plan cites the URLs in the PR body so a reviewer can re-verify.
- **A merge-time upgrade gate:** the embargo discipline (≥7 days from upstream publish) is the *upgrade-PR-merge* gate; this skill's own embargo (don't propose a Node major younger than 30 days of active LTS) is the *upgrade-PR-open* gate.
- **A general major-version scout:** shares the cadence shape and the "PR-not-merge" deliverable; they do not share the sensor surface.

## Adding a pin surface

1. Add a regex-or-parser stage to `probes/inventory.sh` that finds the pin and emits an inventory line.
2. Add the surface to the *Pin-surface inventory* table with the path pattern and replacement strategy.
3. Add a corresponding apply branch to `probes/apply.sh`.

## Pitfalls

- **Do not blindly bump `engines.node`.** The semver range is the project's authored intent, not a single-version pin. v1 reports the range but does not rewrite it; advancing the floor is a project decision.
- **Do not edit a frozen matrix.** A matrix with deliberate non-LTS versions exists for a documented reason; the `frozen` inventory kind is the safety belt.
- **Do not propose a Node major younger than the embargo.** A major's first 30 days as active LTS are high-risk (registry-cache poisoning, fresh CVEs against the new V8).
- **Do not assume one project, one pin.** The app bundle's `download-node.mjs` and the CI matrices must advance together in a *single* PR so reviewers see the policy applied consistently. The plan stage produces one plan per project, not per file.
- **Auto-fix loops with pre-push-gates.** The gate's `yarn format` may rewrite a YAML matrix the skill just edited; the gate runs after the apply in the gardener's flow, so the apply stage emits YAML the gate accepts (conservative whitespace, sorted versions ascending, no inserted inline comments).

## Future probes

The v1 inventory does not cover: Docker base images (`FROM node:<MAJOR>`); `engines.node` semver-range advancement; per-package `engines.node` consistency; Renovate/Dependabot config for `nodejs` itself; hand-rolled binary download caches with a different shape than `process.argv[2] || 'vX.Y.Z'`. Each lands as a new probe with a row in the inventory table and a branch in `apply.sh`.

## Notes from the field

- _2026-06-24_: migrated to v2. The sensor (`node-lts-window-watch.sh` + `probes/`) is a self-contained probe pipeline (curl/jq/file-rewrite, `mktemp -d` scratch, no daemon or driver plumbing) and is reproduced verbatim alongside this skill. The v1 "driver" portion (steward/`/loop` dispatch of a builder) re-homes onto the producer/consumer split: a poller producer runs `--plan-only` on a cadence and posts a job; a gardener claims it, runs `--apply`, and drives the PR through the gauntlet. Any poller dedup marker lives under `GARDEN_STATE`, not `/tmp`.
- _2026-05-19_: initial bootstrap from PR #231 L227 ask. Ships with the two pin surfaces present in `endojs/endo-but-for-bots` (familiar app bundle, ci.yml matrices and single pins) and the default LTS-window posture.
