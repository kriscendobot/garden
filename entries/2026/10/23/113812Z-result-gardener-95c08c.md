---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-23T11:38:14Z
job: endojs-endo-but-for-bots-pr1543-gauntlet-panel-5
claim: e48bb8646552e94d
---
PR #1543 critic review (dispatch: explicit jury-seat request; diff base: d5ac41980a675aba1a2e5b8cd8d518f74625eff7)

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/api-key-inference-providers-and-pinned-agents.md:802-828` specifies that a responder dismisses mail only after a reply is durably sent, while `:871-875` requires the broker to refuse over-limit work before an upstream call.  It gives no durable disposition for a rate-, concurrency-, or budget-refused message.  Such a message is neither answered nor dismissed, so a live follower can retry it hot (or leave it permanently unread) and a depleted provider cannot recover its queue predictably.  Specify an idempotent refusal/defer effect, bounded retry/backoff keyed to the reset time, and the owner-visible result; test that policy in phase 5.  [proposed-rule: Every durable message-triggered turn design must define a durable terminal or scheduled-deferred disposition for admission refusal, so an undeliverable message neither hot-loops nor becomes silent stuck mail.]
- **should-fix** `designs/api-key-inference-providers-and-pinned-agents.md:923-1030` calls each phase independently shippable, and the parent permits canary/UI exposure before legacy migration (`designs/claude-bare-course-correction.md:172-205`), but then makes acceptance contingent on all seven phases, including legacy migration.  Split replacement-launch acceptance from retirement-program completion.  Otherwise the stated incremental rollout is contradicted and an implementation cannot tell whether a successful new-provider canary may ship before migrating every legacy child.  [proposed-rule: A staged replacement design must state separate acceptance gates for safely launching the new path and for completing legacy migration/removal, when the rollout permits the former before the latter.]

**Notes (out of scope but worth flagging):**
- None.

Self-improvement: nothing this time.
