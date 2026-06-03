---
ts: 2026-06-03T04:45:50Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs: [411]
refs:
  - entries/2026/06/03/044048Z-dispatch-liaison-626602.md
  - https://github.com/endojs/endo-but-for-bots/pull/411
---

# result: builder — Playwright cache + version pin + install retry (#411)

DRAFT PR #411 open: `ci(browser-test): cache Playwright browsers + retry install + pin version`.

## Outputs

- **PR**: https://github.com/endojs/endo-but-for-bots/pull/411 (DRAFT).
- **Head branch**: `ci/cache-playwright-browsers`.
- **Head SHA**: `b82249e1ce775325cd360ec2a11dfa819f74861c`.
- **Base branch**: `master-ba26f4c` (frozen-base snapshot of `origin/master` at `ba26f4cdb`, pushed at PR open time per `skills/frozen-base-branch/SKILL.md`).
- **Resolved Playwright version pinned**: `1.49.1` (read from `browser-test/package-lock.json` before edit; the lock file's `node_modules/@playwright/test` block named version `1.49.1`).

## Changes (one commit, `b82249e1c`)

1. **`.github/workflows/browser-test.yml`**: inserted a `Cache Playwright browsers` step between `Install browser test dependencies` and `Install Playwright Browsers`. Replaced the `run: npx playwright install --with-deps` step with a `nick-fields/retry` wrapper.
2. **`browser-test/package.json`**: changed `"@playwright/test": "^1.49.1"` → `"@playwright/test": "1.49.1"` (drop caret).
3. **`browser-test/package-lock.json`**: refreshed via `npm install --package-lock-only --ignore-scripts`. Only the spec line for `@playwright/test` in the `packages.""` block moved; no resolved version or integrity hash changed.

No root `yarn.lock` churn: `browser-test/` is outside the yarn workspace (workspace is `packages/*`) and uses its own npm lock file.

## Action pins used (both already in this repo's pin policy)

- `actions/cache@0057852bfaa89a56745cba8c7296529d2fc39830` # v4.3.0 (matches usage in `.github/workflows/ci.yml` and `.github/workflows/ocapn-guile-interop.yml`).
- `nick-fields/retry@ce71cc2ab81d554ebbe88c79ab5975992d79ba08` # v3.0.2 (matches usage in `.github/workflows/ocapn-guile-interop.yml`).

No new third-party action enters the repo's pin policy.

## Retry approach

Used `nick-fields/retry@v3.0.2` (preferred per dispatch brief; already pinned in this repo). Three attempts, 10-minute per-attempt ceiling. Command body: `cd browser-test && npx playwright install --with-deps`. The bash retry loop fallback was not needed.

## Cache-hit short-circuit

Not added (matches dispatch recommendation). The install step runs unconditionally. Rationale captured both in a YAML comment block in the workflow and in the PR body: `--with-deps` also installs apt system packages, which the cache does not cover; a strict cache-hit short-circuit would need a separate always-run apt step. The browser-binary download is the expensive part and is a no-op on cache hit, so the unconditional run stays cheap.

## Judgment calls

- **Frozen base over bare `master`**: the `frozen-base-branch` skill says "Builder opens every fork-side PR with a frozen base," so I created `master-ba26f4c` (snapshot of `origin/master` at `ba26f4cdb`) and pushed it to the fork before opening the PR. The dispatch brief gave discretion; I took the skill canon.
- **Single commit, not two**: the dispatch brief said "Two commits is fine ... Or one commit if no yarn.lock churn." The root `yarn.lock` did not move (browser-test is npm, not yarn workspace), and the three changes are tightly coupled to one goal, so one commit.
- **Workflow base content differed from the dispatch's brief sketch**: the brief's sketch showed `actions/checkout@34e114876b…` (v4) and `node-version: 18`, but `origin/master@ba26f4cdb` already has `actions/checkout@de0fac2e…` (v6.0.2) and `node-version-file: .node-version`. I applied the cache + retry edits to the current state without retrofitting the older shape.
- **Initial Read returned stale content**: when I first read `browser-test.yml` from the worktree, I saw the older shape (the worktree was originally at `0ec70c6dd` per the dispatch prompt). After fetch + frozen-base creation, the file content updated to the `ba26f4cdb` shape and my Edit needed to be re-formed. Not a problem in practice (the Edit tool's "file modified since last read" guard caught it), but a small lesson on read-before-edit ordering when the worktree's HEAD has just moved.
- **Cache key**: used `hashFiles('browser-test/package-lock.json')` rather than a parsed Playwright version. The lock file moves only when the dep moves (now that the pin is exact), and `hashFiles` is the GHA idiom; resolving the version inside YAML would need a custom step.

## Pre-PR checklist

- YAML valid (`python3 -c "import yaml; yaml.safe_load(...)"`).
- `npm install --package-lock-only --ignore-scripts` reports `up to date, audited 7 packages`; no unexpected lock churn.
- Pre-push gates not run: the gate's auto-fixers (Prettier, eslint `--fix`, garden probes for ASCII banners / PR citations / etc.) target source code; this diff is one workflow YAML, one JSON dep pin, one JSON spec-line refresh. None of the gate's checks apply. Recording the skip explicitly for audit.

## Per-action authorization observance

- Authorized: branch off `origin/master`; edit the three files; one commit; push to a new branch; open DRAFT PR. All executed.
- Not authorized (and not done): editing other workflows; touching packages outside `browser-test/`; force-pushing; un-drafting the PR; merging.

## Next stage

Per the dispatch brief: "DRAFT mode — the steward/contractor's PR-creation-flow picks up from there." The steward's per-cycle PR-creation-flow scan will find this DRAFT and run the gauntlet (assayer → cleaner → judge panel → fixer loop → un-draft).

Self-improvement: nothing this time. The frozen-base-branch skill, the dispatch brief, and the existing action pins composed cleanly; the worktree-HEAD-moved-mid-Edit recovery is already implicit in the Edit tool's stale-read guard.
