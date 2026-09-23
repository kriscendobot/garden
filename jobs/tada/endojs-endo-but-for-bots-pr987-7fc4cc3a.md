Re-fetched the untrusted directive and ran the required preflight. Existing gix PR #872 and libgit2 fork PR #4 were prior art, but did not satisfy the new request for coordinated, comparable builder attempts.

Posted and confirmed on `origin/journal2`:

- Gix probe: `endojs-endo-but-for-bots-pr987-gix-probe-5456716519`
- Libgit2 probe: `endojs-endo-but-for-bots-pr987-libgit2-probe-5456716519`
- Parallel orchestration: `endojs-endo-but-for-bots-pr987-backend-comparison-5456716519`

Both builders must produce independent draft probe PRs using the same functional and Linux/macOS/Windows artifact comparison matrix. Posted completion comment: https://github.com/endojs/endo-but-for-bots/pull/987#issuecomment-5456780508

No source or garden `main2` changes were needed. Follow-up is owned by the orchestration watcher and its two builder jobs.

Self-improvement: used paired gap-revealing probes to preserve an apples-to-apples backend comparison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr987-7fc4cc3a.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 243s

<!-- garden-usage-end -->
