---
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---
# Land, deploy, and verify guest self-formula identifier

Continue the completed implementation from job `minion-town-guest-self-formula-id`: supervise the standard gauntlet for draft kriscendobot/minion.town#61 (head `feat/guest-self-formula-id`, current head `200dccac306`), address review/CI, use the delegated proxy-reviewer authority recorded in the parent job to approve/merge when green, deploy minion.town, and verify the full public chain. A signed-in OAuth guest must retrieve only its own formula identifier from `GET /account/guest-formula-id` and see/copy it on the home page. Then from a peer use the public OCapN-CBOR-Noise location and the revealed identifier with `enlivenSturdyRef(location, <guestFormulaId>)`, invoke a harmless guest method to prove the guest was fetched, and report exact evidence on kriscendobot/garden#58. Coordinate with the worker handling issue comment 5447329184; the liaison received current status in inbox message `20260828T021115Z-cf29a8`.

Verification already completed on head `200dccac306`: `npm run typecheck`; `npm test` (278 passed, five skip-gated daemon integration tests); pre-push gates; local-verify; regression mutation proving the route self-scope test fails on a substituted subject; headless Chromium rendered the read-only 64-character identifier field and exercised the copy fallback to `Copied.` with the full value. A separate real-daemon attempt against a stale Endo checkout failed before assertions because `@endo/cancel` was absent; do not count it as feature evidence.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5447180549
submitter: kriskowal
----- END ISSUE NOTE -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-28T02:12:04Z
