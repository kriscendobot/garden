The job is complete. Final report:

---

## Completion report — `kriscendobot-oros-ckm-data-readiness-pr1-receipt`

**Deliverable (the receipt):** emitted successfully for kriscendobot/oros-ckm-data-readiness PR #1 (merged).
- **Archive:** `/home/kris/garden/.garden-state/receipts/journal/receipts/kriscendobot-oros-ckm-data-readiness/2026/09/pr1.md` (committed + pushed to `origin/journal2` as `14dd0ce74`).
- **Comment:** https://github.com/kriscendobot/oros-ckm-data-readiness/pull/1#issuecomment-5894768382

**Incident found and remediated (root cause of the initial failures):** the first two `pr-receipt.sh` runs failed on a repo-lock timeout. Investigation revealed a live **fork bomb** — 502+ `scripts/jobs/bin/gh auth token --user kriscendobot` processes holding the receipts-journal repo lock. Cause: the fleet `gh` wrapper resolves the real `gh` by skipping only its own path, but running a garden script *from a worktree* puts **two** wrapper copies on PATH (the worktree's `scripts/jobs/bin` prepended by its `common.sh`, ahead of the deployed root's already inherited from the gardener env). Each copy picked the *other* as "real gh" and exec'd it endlessly, with `env -u GH_TOKEN` forcing infinite re-resolution.

**Actions:**
1. Killed the runaway (`pkill -9`, verified 0 remaining; stale advisory holder metadata auto-cleared on next lock acquire).
2. Fixed the wrapper (`scripts/jobs/bin/gh`) to skip **all** wrapper copies — by canonical `.../scripts/jobs/bin/gh` path (deploy-safe against the older marker-less root copy) **and** by a `GARDEN_GH_WRAPPER_MARKER` content sentinel. Sandbox-tested both the same-version and mixed old/new-across-deploy cases: no recursion, real gh reached. Pushed to `main2` (`a74d90f9789`, `c82c1885512`).
3. Re-ran `pr-receipt.sh` from the (now-fixed) worktree with a fork-bomb guard: clean, exit 0, max 1 gh proc.

**Follow-ups:**
- The **deployed root** wrapper stays the old, buggy version until `main2` redeploys past `c82c1885512`; until then any job that lands two OLD wrapper copies on PATH can still fork-bomb. The rolling deploy will resolve this; no manual action needed beyond letting it land.
- Recorded a diagnostic memory (`gh-wrapper-dual-path-fork-bomb`) for the failure signature and recovery.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-oros-ckm-data-readiness-pr1-receipt.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (2 unmetered)
- Input: 88 tokens (3331331 cached reads)
- Output: 35186 tokens
- Cost: $3.4965355 (2 engagement(s) unpriced)
- Wall-clock: 1516s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
