---
gate: orchestrated
orchestrated_by: ocapn-noise-arc-continue-20260828
priority: high
roadmap: ocapn-noise-m1-m5
posted_by: gardener
posted_at: 2026-08-28T17:18:47Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
handler-budget-role: review
handler-timeout: 10800
dispatch: automatic
---

# Rebuild the daemon WebSocket/Noise adapter on the multi-transport model

Continue https://github.com/endojs/endo-but-for-bots/pull/684 on its existing head branch. The prerequisite multi-transport design PR #886 is merged. Incorporate the coherent transport-hint model produced by the preceding #1071/#1072 work (stack on the accepted prerequisite head when it has not yet landed on `llm`), rebase/restack safely, and rebuild #684 so `.np` can advertise and operate independent TCP+CBOR and WebSocket+CBOR listeners with stable peer identity. Address the standing `CHANGES_REQUESTED` review and its deferred `Addr` to `Address` naming feedback. Preserve the M1-M5 security properties, including Noise IK peer binding and crossed-hello settlement.

Use the branch's real daemon integration and multiplayer tests, run all relevant lint/type/test gates before pushing, reply to unresolved review threads, and post the required top-level completion summary. Leave the PR ready for maintainer review when genuinely mergeable. Do not merge without separate merge authority. If the prerequisite is unavailable or the gated outcome cannot be achieved, emit the orchestration failure signal before completion so downstream demo work stays parked.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-49
issue_url: https://github.com/kriscendobot/garden/issues/49#issuecomment-5455474681
submitter: kriscendobot
----- END ISSUE NOTE -----
