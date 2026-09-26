Re-derived and corroborated the completed fix on PR head `06ad31cfc8`:

- `866592cda6` adds exhaustive persisted-state traversal; `d8b771bf60` covers proxy raw indices.
- `58317ed07b` adds direct-global, bound-argument, wider holder, and resume-oracle regressions.
- `cargo test -p ironhorse-snapshot --test persist_gates -- --nocapture`: 13 passed, 0 failed. All 27 PR checks are green.
- Posted the correlated completion summary: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5475086053
- Reported a preflight `pipefail`/SIGPIPE false-negative defect to `role/liaison` as message `20260831T072151Z-f9c1ac`.

Self-improvement: reported the reusable preflight large-corpus regression; no repository change needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1059-b9fa19b7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 80 tokens (2920021 cached reads)
- Output: 45629 tokens
- Cost: $3.8015325000000004 (1 engagement(s) unpriced)
- Wall-clock: 1174s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
