Rebased PR #1039 onto `llm` at `97d8de25d` using frozen base `llm-97d8de2`; force-pushed head `e59c50573` with lease.

Addressed all review findings: nested-dispatch resume handling, native Promise/callback catch boundaries, preserved rejection values, catchable descriptor errors, and direct coverage for captured TDZ and iterator-result errors. Added seven regression tests.

Verification:
- `cargo test --manifest-path rust/engine/Cargo.toml -p ironhorse-vm` passed.
- Snapshot sidetable tests passed: 5/5.
- `git diff --check origin/llm..HEAD` passed.
- PR is mergeable; GitHub CI was running at completion.

Posted the review response and completion summary: https://github.com/endojs/endo-but-for-bots/pull/1039#issuecomment-5502099066

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1039-rebase.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 542s

<!-- garden-usage-end -->
