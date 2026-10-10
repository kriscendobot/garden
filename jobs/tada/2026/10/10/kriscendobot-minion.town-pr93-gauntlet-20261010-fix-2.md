Fix round 2 for kriscendobot/minion.town PR #93 is done: the panel's only must-fix item is applied, pushed, and CI is green.

**The must-fix:** the pruner seat asked for two cuts in the "Clip content-store garbage collection" section of `DEPLOYMENT.md`. Both are done in one commit, `578cba7`, which advanced the PR head from `2df7849` to `578cba7` via `safe-push-pr-head.sh --mode advance`:
- **Hedging sentence removed.** The "deploy-time step… opening and testing the implementation PR does not deploy it…" disclaimer is gone. Only the instruction remains: record the per-deploy status as a comment on the deploy PR that merged this change, not in the runbook.
- **Rationale paragraph dropped.** The paragraph on the one-hour grace, blob mtime and backups is gone. The design doc already states that invariant in § B.4 (`designs/clip-formula-id-origin-and-content-gc.md`), so nothing was moved. I kept one instruction an operator needs: mask `endo-gateway-gc.timer` before any maintenance or restore that would change `blobs/**` or its mtimes, with a pointer to § B.4.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0. All three checks passed: test, Claude harness (amd64) and Claude harness (arm64). My first wait attempt hit a 590-second shell timeout. I re-ran it in the background with a 3000-second deadline instead of the specified 3600 and polled it until it finished green.

**Follow-ups:** The panel also listed should-fix items, which this stage left alone because only the must-fix was in scope. Panel round 3 will decide whether any of them get raised:
- A timing gap in the sweep between the mtime check and the delete, with a test needed for that interleaving.
- A guest-controlled `front` pointer that can wedge GC or be trusted without checking.
- No minimum on the grace period (`--grace-ms 1` is accepted).
- No lock between a timer run and a manual `--delete` run.
- Delete permission, since the gateway and the GC run as different users.
- Scope: the guest pet-name cleanup should be justified or split into its own PR, and the `--drop-unresolved` removal step should be split out of `runGc`.
- Unrelated typography changes in `2bef1cb`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (887264 cached reads)
- Output: 4016 tokens
- Cost: $0.7171887999999998
- Wall-clock: 771s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
