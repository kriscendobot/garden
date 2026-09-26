Completed option (2): fixed the garden-owned environment bug; direct-node invocation is not the expected fallback.

Live reproduction on an endo-but-for-bots WARM-CACHE hit showed:

- 130 `node_modules` trees populated; reconciliation succeeded.
- `yarn workspace @endo/9p-server test --help` failed with `permission denied: ava`.
- Package files retained mode 755. Yarn 4 was creating executable wrappers under noexec `/tmp`.
- With the worker’s executable `TMPDIR`, the same command exited 0.

Changed `worker-common.sh` to export `exec_tmpdir` before launching any provider, documented the process-scope distinction in `ensure-project-worktree.sh`, and recorded the diagnosis in local-verify field notes. Added regression coverage for worker inheritance and warm-cache mode preservation.

Verification passed:

- `worker-exec-tmpdir-test.sh`: 1/1
- `project-worktree-isolation-test.sh`: 53/53
- `worker-local-bin-path-test.sh`: 4/4
- `gardener-worktree-test.sh`: 44/44
- `worker-ensure-worktree-test.sh`: 6/6

Pushed commit `eb3f1e9dc145791c7037a3eb375d85e1cfb4eaa7` to `main2`.

Self-improvement: updated `skills/local-verify/field-notes.md`; clarified that Yarn’s noexec temporary-wrapper failure affects ordinary agent commands, not just local-verify.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-warm-cache-yarn-bin-shim-permissions-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 542s

<!-- garden-usage-end -->
