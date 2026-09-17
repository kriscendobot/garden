Done. CI is established, proven green, and the submitter has been notified.

## Completion report

**Job:** Establish CI for `kriscendobot/oros-ckm-data-readiness` (issue kriscendobot/garden#99, from dckc).

**What I found:** The repo (a Vite + React + TypeScript POC with a vitest gate-test suite and Node scoring scripts) had no `.github/workflows`. No prior attempt had left committed work or an existing PR (verified via `ensure-pr.sh --find-only`).

**What I did:**
- Validated the project's own scripts pass green locally on this tree: `npm run typecheck` (clean), `npm run test:run` (79/79 tests), `npm run build` (succeeds).
- Authored `.github/workflows/ci.yml`: a `build & test` job on `ubuntu-latest` across a Node **20 / 22** matrix running `npm ci` → `typecheck` → `test:run` → `build`. Best-practice touches: `pull_request` + push-to-`ckm-poc-build` + `workflow_dispatch` triggers, a `concurrency` group cancelling superseded runs, least-privilege `permissions: contents: read`, `setup-node` npm caching, and actions pinned to `@v5` (runs cleanly on the Node 24 runner — the initial `@v4` produced a benign deprecation annotation I then cleared).
- Opened **PR kriscendobot/oros-ckm-data-readiness#1** via `ensure-pr.sh` (carrying the `garden-job: issue-kriscendobot-garden-99` marker). ensure-pr required a frozen base, so I snapshotted the tip; since there was zero divergence I then retargeted the PR to the live `ckm-poc-build`, deleted the throwaway snapshot branch, and marked it ready for review — so a merge actually lands CI on the default branch.
- **CI is green on both Node 20 and 22** on the PR (run 35231524436).
- Posted a reply comment on issue #99 summarizing the work and linking the PR/run; **did not close** the issue (submitter closes it).

**Notes / possible follow-ups:** the `scripts/` DB-loader subpackage (needs Postgres) and the Playwright dev dependency (needs a browser + running server) are intentionally not exercised — they'd require service containers. Flagged in the PR/issue for a later pass if e2e coverage is wanted.

**Handoff:** none — deliverable complete; the PR is mergeable and awaits dckc's review/merge.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-99.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 70 tokens (1940835 cached reads)
- Output: 17584 tokens
- Cost: $1.9900394999999995 (1 engagement(s) unpriced)
- Wall-clock: 379s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
