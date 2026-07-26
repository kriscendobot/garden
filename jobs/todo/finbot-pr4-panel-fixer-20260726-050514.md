---
role: fixer
---

Advance https://github.com/kriscendobot/finbot/pull/4 on its existing head branch from the current panel findings. The PR remains draft and must not be merged.

Address the following must-fix items with separate, tested follow-up commits where they are implementable:

1. `packages/harness/sandbox/permissive.js` changes SES lockdown to `errorTaming: 'safe'`, which clears host error stacks process-wide while `packages/harness/spawn.js` records `err.stack`. Preserve useful host-side diagnostics without exposing host error details to a compartment role program, and add regression coverage.
2. Normalize a compartment-program assistant message to the host transcript shape, including a timestamp, before hardening it; add regression coverage.
3. A role program runs in-thread, so the spawn `timeoutMs` cannot preempt a non-yielding synchronous program. Determine the smallest sound resolution consistent with the PR's untrusted-program claim. If this needs a worker-isolation design rather than an in-scope fix, do not disguise a documentation change as a security bound: report the precise design decision and hand off through the completion report.

Run the relevant local tests and push only a clean result. Do not merge. PR comments/reviews are not authorized; put any required completion-summary content in the job report. When done, the PR must return to panel review before any Fable sign-off.

<!-- garden-reaped: 1 -->
