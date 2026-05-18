---
ts: 2026-05-18T00:44:00Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: builder drops Node.js 20 from CI

Dispatch root: `dispatches/builder--1ecc43/`. Project worktree on `endojs/endo-but-for-bots@master` (current head `c2fc02eb8`).

Maintainer directive (2026-05-18): *"Please dispatch a builder to drop CI for Node.js 20."*

Context: Node.js 20's LTS phase has been winding down. Today (2026-05-15 elsewhere in this session) we filed issue [endojs/endo-but-for-bots#260](https://github.com/endojs/endo-but-for-bots/issues/260) for a `test-xs (macos-15)` flake observed on Node 20. Dropping Node 20 from the matrix removes the flake's surface area and aligns with the supported-LTS roadmap.

## Task

Read `garden/roles/COMMON.md` and `garden/roles/builder/AGENT.md` first.

1. **Inventory Node-20 references** across the repo:
   - `.github/workflows/*.yml` — primary CI matrix entries (`node-version: [20.x, …]`, individual jobs that pin 20, `setup-node` actions)
   - Workflow names referencing Node 20 (e.g., `test-node-20-macos`)
   - `package.json` `engines.node` (if it explicitly lists 20)
   - `README.md` / contributor docs that mention Node 20 as a supported version
   - Any per-package `engines.node` in `packages/*/package.json`

2. **Remove Node-20 entries from CI matrices** (the load-bearing change). Each matrix job loses its `20` / `20.x` / `node-20` row; standalone Node-20 jobs (e.g., `test-xs (macos-15)` on Node 20) are dropped.

3. **Update minimum-Node-version declarations** if the project advances its floor as part of dropping 20. The builder reads the README or CONTRIBUTING.md to find the project's stated minimum; if it currently says "Node 18 or newer" or similar, advance to "Node 22 or newer" (i.e., the next LTS above 20). If it's silent, leave the declared floor alone — CI matrix is the load-bearing artifact.

4. **Update docs/README** if Node 20 is named as a supported runtime.

5. **Add a changeset** per project convention if the change is downstream-observable (an `engines.node` bump is observable; CI-matrix-only is not). Per `skills/changeset-discipline/SKILL.md`.

6. **Per today's recurring self-improvement**: commit + push BEFORE extended local validation.

7. **Conventional commit**: e.g., `chore(ci): drop Node.js 20 from the test matrix`. If `engines.node` advances, that's a `chore(*): require Node.js 22+` or similar — separate commit if scope warrants.

8. **Open as DRAFT PR** against `master`. Branch: `chore/drop-node-20-ci`. Title: `chore(ci): drop Node.js 20 from the test matrix`. Body cites the maintainer's directive + issue #260 (the macOS flake) + the LTS lifecycle context.

9. **Per `skills/yarn-lock-separate-commit/SKILL.md`**: no yarn.lock churn expected here (CI config + maybe `engines.node`), but if any commit touches it, separate commit.

## Per-action authorization

Standing on endo-but-for-bots: push to `chore/drop-node-20-ci`, open draft PR. READ-ONLY on endojs/endo.

## Out of scope

- No removal of Node 18 (if present); the directive is specifically about 20.
- No un-draft. Cleaner + judge run via the orchestrator's separate dispatch.
- No upstream ferry. Boatman handles when maintainer authorizes.
- No code changes outside CI / config / docs.

## Report

≤ 400 words: PR URL + head SHA, files touched (one-line each), whether `engines.node` was advanced (yes/no), whether a changeset was added (yes/no), local-validation status if any ran, one-line `Self-improvement: ...`. The liaison adds a bulletin row.
