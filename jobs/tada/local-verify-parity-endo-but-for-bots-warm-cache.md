Pushed as `08bf7864e9`.

## Report

**Divergence 1 — warm-cache hit left yarn believing the project was not installed: CLOSED.**

Reproduced exactly. The missing artifact is not inside `node_modules` at all: yarn 4 keeps its "is this project installed?" state in `.yarn/install-state.gz` at the project root, which is gitignored (so `git worktree add` never carries it) and outside every tree the cache snapshots. A hit therefore populated `node_modules` and left yarn refusing every `yarn run <script>` with the usage error — confirmed on a fresh warm-hit worktree.

Fix in `scripts/jobs/ensure-project-worktree.sh`: a cache HIT now finishes by running the package manager's own install (new `dep_reconcile_cmd`) to reconcile its state against the trees just linked in.

- **It does not defeat the cache.** What the cache spares is the *native build*, and a reconcile against a populated store performs none. Measured on `endojs/endo-but-for-bots`: cold install 6s (on an already-warm yarn store) vs. 1s link + 5s reconcile on a hit, with `better-sqlite3`'s prebuilt `.node` keeping its cached inode and mtime across the reconcile.
- **The delta is logged, not asserted.** The cold install's duration is recorded beside the cache (`install-secs`) and the `WARM-CACHE hit:` line now reads `… in 6s (of which 5s link-state reconcile 'yarn install --immutable' rc=0; cold install was Ns)`, so a reconcile that ever grew into a real rebuild is visible in the journal.
- `npm ci` is substituted for the additive `npm install` **on this path only** — `npm ci` deletes `node_modules` first and, because the trees are hardlinked, is the one installer that could reach back into the cache. Escape hatches: `GARDEN_DEP_RECONCILE_CMD`, `GARDEN_SKIP_DEP_RECONCILE=1`.

**Divergence 2 — `@endo/agentry` conflict-rebase eval: NOT NEW; already closed in `main2`, not deployed.**

It is precisely the `rerere.enabled=true` divergence `b6cffb8d17` already closed. The fixture provisions its repo by resolving the conflict once, so inherited rerere auto-stages `app.txt` on the test's own rebase, leaving `M  app.txt` where the test asserts `UU app.txt` — hence the rethrow. Verified directly on a fresh worktree: the test **passes** under `GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null` and **fails** without them, printing `Staged 'app.txt' using previous resolution`.

The reason the reporting gardener still hit it: the **deployed** root's `local-verify.sh` is behind `main2` — it has no `hermetic_gitconfig`, still lints before building, and lacks the workspace-test aggregation. Nothing to fix in the harness.

**Tests:** `project-worktree-isolation-test.sh` extended (35 passed, 0 failed) — a hit reconciles link state, a cold build does not redundantly reconcile, the native artifact keeps its inode across a reconcile, the hit log line carries both timings, and a stub `npm` proves `npm ci` → `npm install` on the reconcile path with the populated trees surviving. (The stub bin dir needed an exec-capability probe: `/tmp` is noexec here.) `local-verify-test.sh` still 24/24. `bash -n` + `shellcheck` clean apart from the file's pre-existing SC1091/SC2015/SC2164.

**Skill field notes:** two dated `_2026-07-28_` entries added, each with its tell, plus two new Pitfalls — *N steps failing with one identical tail is one environment failure, not N defects* (especially when the tail is a package-runner usage error), and *a divergence already described in these notes is a deploy-lag tell; diff the deployed script against `main2` before diagnosing it as new*.

**Follow-ups:**
1. **A deploy is needed** (`context/operations/deploy.md`) — until the root checkout advances, gardeners keep running the pre-`hermetic_gitconfig` harness and will keep re-reporting divergence 2. This is the liaison-supervised half of "done"; I closed the harness half.
2. `endojs/endo-but-for-bots#883`'s project-side pin (`rerere.enabled=false` in the fixture's own repo-local config) is still not on `llm`, so the harness-side defense is currently the only one in force.
3. **Not finished:** the full end-to-end `local-verify.sh` run on a fresh warm-cache worktree (`project-wt-lvp-e2e-verify-f4d57e5d`) was still executing (in `packages/daemon` tests, ~35 min in) when my handler's 2400s budget ran out, so I cannot report its final verdict. What it does establish is that the gate now *runs*: it is deep in the per-workspace test sweep rather than dying instantly with six identical usage errors, which was the failure mode being fixed. Its output lands in `/home/kris/garden2/scratch/lvp-e2e.{out,err}` if someone wants the verdict; the agentry-specific claim was proven directly and separately.
4. Scratch worktrees `project-wt-lvp-warmhit-probe-*`, `project-wt-lvp-e2e-verify-*` and `project-wt-local-verify-parity-…` are left for the scratch GC.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/local-verify-parity-endo-but-for-bots-warm-cache.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 125 tokens (7175697 cached reads)
- Output: 48301 tokens
- Cost: $6.128903500000002
- Wall-clock: 2092s

<!-- garden-usage-end -->
