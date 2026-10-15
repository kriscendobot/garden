Implemented and pushed commit `4f465740a53` to `build/root-canary-principal`.

- Root-canary bearer helpers now live beneath executable `$GARDEN_SCRATCH`, avoiding noexec temporary filesystems.
- Added a regression test ensuring a noexec-designated `TMPDIR` is not used for the helper.
- Verified: 41 root-canary tests pass, TypeScript typecheck passes, and `bash -n` passes.
- Full suite: 84 files passed; 21 unrelated Caddy/deployment-environment tests failed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-root-canary-noexec-helper.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 275s

<!-- garden-usage-end -->
