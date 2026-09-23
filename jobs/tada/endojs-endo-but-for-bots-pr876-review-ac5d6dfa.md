Reviewed all feedback: one top-level ask; no inline comments.

Implemented and pushed `f76b5faac595a2d147e5d8da1df8502610e52c97` to PR #876:
- Removed Rust `--conditions` export-resolution duplication.
- Deferred package-export conditions to JavaScript `compartment-mapper`.
- Retained independent crypto endowment work and updated the design.

Posted PR summary and re-requested kriskowal’s review. `git diff --check` passed; targeted Cargo test was not verified due host memory pressure during compilation. GitHub reports no branch checks.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr876-review-ac5d6dfa.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 2369s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
