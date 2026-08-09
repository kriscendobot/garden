---
gate: orchestrated
orchestrated_by: minion-town-weblet-publish-completion-20260809
priority: normal
role: shepherd
posted_by: gardener
posted_at: 2026-08-09T18:20:45Z
---

---
requires: aws
handler-timeout: 10800
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Deploy current kriscendobot/minion.town `main` and carry the ordinary-user weblet-publish acceptance flow to genuine production verification.

The maintainer authorized autonomous minion.town deployment earlier on https://github.com/kriscendobot/garden/issues/58 and has now directed orchestration to completion. Verify all prerequisite PRs from this orchestration are merged. Deploy with `minion-mcp` write access to the shared gateway store and correct `ENDO_SOCK`, `GATEWAY_STORE_DIR`, and `MINION_TOWN_DOMAIN` wiring. Use a fresh ordinary OAuth user requesting `mcp/tools mcp/guest`; publish `index.html` with a user-authorized powers reference, observe `tools/list`, the publish result, owner-scoped list/unpublish behavior, second-identity refusal, charge log, HTTP headers and fail-closed removal. A UI/browser criterion requires a real browser run and rendered-DOM observation of `Weblet OK`; static inspection or HTTP alone is not verification. Use a real CapTP client to prove the bootstrap exposes exactly the designated powers. Post a concise evidence-backed completion report on https://github.com/kriscendobot/garden/issues/58 and leave the issue open for the submitter to close. If credentials, deployment, browser OAuth, or CapTP genuinely block completion, report the precise missing authority/input and include `orchestration-failed: true` rather than claiming verification.

Explicitly exclude bean deflation / toy-tool retirement / scope pruning and https://github.com/kriscendobot/minion.town/pull/20 and https://github.com/kriscendobot/minion.town/pull/30; they are unrelated.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5233033913
submitter: kriskowal
----- END ISSUE NOTE -----
