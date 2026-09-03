The change is on `origin/main2`. Line 1099 is the existing whole-review stamp; line 1163 is the new attention stamp.

## Completion report

**Job:** Stamp non-mechanical attention directives with `handler-budget-role: review` in `scripts/jobs/comment-watcher.sh`.

**What I found:** The `attention` (triage) verb — minted for ambiguous/@-mention comments and trusted plain-language directives — flows through the generic `write_job_body` path. There, `verb_role attention` returns empty, so the job body was emitted **headerless**, inheriting the default 2400s handler budget. Because these directives re-fetch and assess substantive feedback exactly like a whole-review job, PR #1059's attention routing deterministically hit that 2400s wall and cycled timeout → reap → re-claim → timeout.

**What changed:** In the generic frontmatter block of `write_job_body`, the `attention` verb now emits a `handler-budget-role: review` frontmatter block, earning it the same 7200s review budget (via `handler_budget_role` → `GARDEN_REVIEW_HANDLER_TIMEOUT` in `common.sh`) as whole-review feedback jobs. Fixed branch-op verbs (rebase/retcon/pinbase/conduct/merge/finalize) keep their existing `role:` stamp unchanged, and non-actionable/mechanical paths are untouched.

**Verification:**
- `bash -n` passes.
- Isolated functional test confirmed: `attention` body now starts with `--- / handler-budget-role: review / ---`; `rebase` still emits `role: weaver`.
- There is a single `write_job_body` call site, so all attention jobs are covered.

**Landed:** commit `fdd82fdfda` on `origin/main2`.

**Follow-ups:** None. The change takes effect on the deployed watcher after the next deliberate deploy of the garden root (comment-watcher runs from the deployed checkout).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-attention-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 36 tokens (962324 cached reads)
- Output: 7781 tokens
- Cost: $1.1874569999999998
- Wall-clock: 157s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
