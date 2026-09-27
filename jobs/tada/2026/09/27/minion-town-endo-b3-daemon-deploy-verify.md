Completed PR #32 (`feat/b3-deploy-coherence-guard`).

- Corrected daemon deployment, readiness probing, systemd ordering, IAM coverage, config coherence, and deployment documentation.
- Added AVA deployment-coherence tests covering the production closure, CLI path, CapTP probe, units, workflow order, IAM actions, and config shape.
- Verified: typecheck; full suite 357 passed/8 skipped; focused deployment suite 47/47; `bash -n`; `systemd-analyze verify`; clean diff.
- Prior live ARM64 deployment also succeeded. PR is ready for maintainer re-review.
- Self-improvement: nothing this time.
- Goal usage: 105,187/100,000 tokens; 2m56s elapsed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-endo-b3-daemon-deploy-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 18 on 2 host(s) (14 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (14 engagement(s) unpriced)
- Wall-clock: 10462s
- Model(s): claude-opus-4-8 ×3, claude-opus-5-5 ×1

<!-- garden-usage-end -->
