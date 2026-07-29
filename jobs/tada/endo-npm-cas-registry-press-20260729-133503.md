## Completion report — endo-npm-cas-registry-press-20260729-133503

**Headline: the finish line is demonstrably MET.** I produced fresh real-execution evidence on `llm` HEAD `bfc91f55802c` that `endor run <entry.js>` resolves, fetches, and executes npm dependencies with no `npm` CLI, no `node_modules`, and no lockfile.

**Assessment (step 1–2).** PR endojs/endo-but-for-bots#276 (Phase 2 HTTP fetch) is **MERGED**; the design doc records all five phases implemented on `llm`. Every known-gap has a live PR: #857 (peer/optional deps), #873 (workspace protocol), #860 (npmrc auth — **approved**, CI green, shepherded), #875 (imports field), #876/#877/#878/#859 (execution refinements) — all eight CLEAN/MERGEABLE with fully green CI. Follow-up pushes landed on #875/#877 today by live peers (several older press-tick workers are still alive on those branches), so per the defer rule I pushed nothing to any shared branch. The registry-capability edge (#671 merged, #403/#563 open) needed no npm-side action.

**Evidence run (step 4 — the press action this tick).** Built `endor` at `llm` HEAD in my isolated worktree (needed `git submodule update --init c/moddable` plus the thixotrope stub bundler for the three generated XS bundles — a documented pre-existing gap; stubs suffice because the standalone runner never evaluates them). Then, from a completely empty `ENDO_STATE_PATH`:

- `endor run entry.js` (app depending on `semver: 7.5.4`, `"type": "module"`): fetched the transitive graph **semver@7.5.4 → lru-cache@6.0.0 → yallist@4.0.0** from registry.npmjs.org, CAS-ingested each as a tree, recorded them in the SQLite registry table, assembled a `cas:sha256:` compartment map, and executed the ESM entry importing the CJS package in XS — correct output (`sorted: 1.2.0,1.10.1,2.0.0`).
- `endor run --offline` reran a cached app with **zero network** — the registry-table-as-lockfile behavior, proven not assumed.
- `endor registry verify`: 4 packages verified, 0 incomplete. `find … -name node_modules` → 0.

**What changed.** No project-branch or garden `main2` commits (nothing to land; all PRs green and peer-owned). Sent the maintainer a milestone message (delivered `20260729T161421Z-f17bc4`) with the evidence and a suggestion that the 6h press cadence could be retired or slowed in favor of shepherding the open PRs. Recorded the arc state and the endor build gotcha in memory.

**Follow-ups.**
- DX rough edge found: an `import` statement in a CJS-flavored entry (no `"type": "module"`) dies with a bare `SyntaxError: invalid import` from `__loadCjs`; Node's equivalent error hints at the fix. Suggested as a small follow-up on the endojs/endo-but-for-bots#877 nearest-package.json work (peer-owned, so not pushed by me).
- Arc is now review-bound: #860 awaits its merge word; the rest await review. Next ticks should mostly shepherd, not build.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-npm-cas-registry-press-20260729-133503.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (3813671 cached reads)
- Output: 26403 tokens
- Cost: $6.762870000000001
- Wall-clock: 602s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
