Message delivered to the maintainer. My job here is the fail-closed halt the spec prescribes — I've completed the specified behavior (verified preconditions, detected fix #2 missing, halted before any restore/relaunch, messaged the liaison). I'll emit the terminal decline marker as a plain frontmatter-style line so the deployed (old) `tada_failed` grep recognizes it.

---

## Completion report

**Outcome: HALTED at the precondition gate. Nothing restored, nothing relaunched, no spend armed.**

**What I did**
- Verified both required fixes against the **deployed garden root** (`/home/kris/garden`) by reading the files directly — not inferring from `main2`.
- Fingerprinted the deployed `scripts/jobs/{common.sh, complete-job.sh, orchestrate.sh}` (via `git hash-object`) against every candidate commit's blob. All three match commit **`225e364eb0`** exactly.

**Precondition results**
- **Fix #1 — `9a16e2a6ef` (stall heuristic): LIVE.** Deployed `orchestrate.sh` contains no `requeue count rose from` string and uses the corrected test `! has_productive_cycle_hint "$jf" && [ "$n" -gt "$limit" ]`. ✓
- **Fix #2 — `ede7f1f467` (child-failure detect/stamp): NOT LIVE.** ✗
  - Deployed `tada_failed()` in `common.sh` is the OLD 3-line grep (`^orchestration-(status:...|failed:...)`) — it does **not** recognize decorated verdict lines (list bullets, emphasis, backticks, `Outcome:` labels).
  - Deployed `complete-job.sh` has **no** `--orchestration-failed` flag (still the plain 3-positional-arg version dated Aug 5).
  - The three HEAD commits `ede7f1f467`, `b63befa87e`, `b580e3d51a` exist on `main2`/`origin` but have not been deployed to the root.

**Why I stopped (not judgment, the spec's fail-closed gate):** Relaunching a 29-child, ~2,080,000-billable-token real-spend campaign with child-failure detection absent is unsafe — the old `tada_failed` would **miss** a decorated failure line and let the serial run promote *past* a genuinely-failed child instead of halting. This is the exact class of silent progression the maintainer's gate is meant to block.

**What I did NOT do (correctly deferred):** did not recover/re-park any of the 22 swept children, did not record the orchestration, and did not verify the 2.08M budget figure — all of that is downstream of the gate.

**Action needed (relayed to the liaison / maintainer via `message-user.sh`, delivered `20260812T170548Z-21924f`):**
1. Run a deliberate deploy (`scripts/jobs/deploy-garden.sh`) to advance the root to at least `ede7f1f467`.
2. Re-post this restore job (new campaign base `ironhorse-test262-implementation-completion-resume-2`). The 22 swept child bodies remain recoverable from the sweep-commit parent `c95607119^:jobs/plan/<child>.md`.

**Follow-up:** none from me until the deploy lands; the job can then be re-run cleanly.

orchestration-failed: true
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-restore-and-relaunch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 24 tokens (647442 cached reads)
- Output: 12607 tokens
- Cost: $1.133448 (1 engagement(s) unpriced)
- Wall-clock: 259s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
