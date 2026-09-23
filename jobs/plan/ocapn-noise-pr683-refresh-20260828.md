---
gate: orchestrated
orchestrated_by: ocapn-noise-arc-continue-20260828
priority: normal
roadmap: ocapn-noise-m1-m5
posted_by: gardener
posted_at: 2026-08-28T17:18:51Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
handler-timeout: 10800
dispatch: automatic
---

# Refresh the two-peer crossed-hello demo on the accepted transport model

Continue https://github.com/endojs/endo-but-for-bots/pull/683. Rebase/restack its existing branch onto the current accepted OCapN-Noise transport line from the preceding children, resolve drift from `llm`, and update the two-peer/crossed-hello demonstration only where the new multi-transport hint API requires it. Re-run the empirical crossed-hello, reverse-authentication, and both-transport demonstrations. Run relevant lint/type/test gates, post a top-level completion summary with exact evidence, and leave the PR ready for maintainer review when genuinely mergeable. Do not merge without separate merge authority. Emit the orchestration failure signal if the gated outcome cannot be achieved.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-49
issue_url: https://github.com/kriscendobot/garden/issues/49#issuecomment-5455474681
submitter: kriscendobot
----- END ISSUE NOTE -----
