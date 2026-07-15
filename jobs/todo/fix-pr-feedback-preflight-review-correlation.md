---
role: builder
model: gpt-5.6-terra
priority: urgent
---
Fix the false-positive resolution detection in scripts/jobs/gardening/pr-feedback-preflight.sh on kriskowal/garden main2. The job for endojs/endo-but-for-bots#722 review 4699091386 returned EXIT=2 even though the reviewed head was unchanged, CHANGES_REQUESTED remained, and no reply specific to that review existed. Similar false positives are documented in the tada reports for PR #682 and PR #678.

Make resolution evidence correlation-specific and time-aware: an older or unrelated generic Addressed @kriskowal acknowledgment must not satisfy a newer review/comment. Add deterministic regression fixtures covering review-body feedback, older acknowledgments, unrelated comment acknowledgments, reviewed-head timestamps/SHAs, and genuine peer resolution. Preserve the push-CAS backstop and fail-safe behavior. Run the focused test suite and land directly on main2 per garden repository policy; no garden PR.
