---
title: §Multi-Round-Trip Requests (SEP-2322) — input-required result with requestState echo
source-slug: mcp-blog--2026-07-28-release-candidate
source-url: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
authors: [David Soria Parra (Lead Maintainer), Den Delimarsky (Lead Maintainer)]
publication-date: 2026-05-21
spec-versions: [2025-11-25, 2026-07-28]
ingest-cycle: 251
ingest-date: 2026-06-09
lane: papers
parent: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum
---

§Multi-Round-Trip-Requests-IS-the-new-server-to-client-request-mechanism. §Instead-of-holding-an-SSE-stream-open, §the-server-returns-an-InputRequiredResult:

```json
{
  "resultType": "inputRequired",
  "inputRequests": {
    "confirm": {
      "type": "elicitation",
      "message": "Delete 3 files?",
      "schema": { "type": "boolean" }
    }
  },
  "requestState": "eyJzdGVwIjoxLCJmaWxlcyI6WyJhIiwiYiIsImMiXX0="
}
```

§The-client-gathers-the-answers-and-re-issues-the-original-call-with-inputResponses-and-the-echoed-requestState. §Any-server-instance-can-pick-that-retry-up-because-everything-it-needs-is-in-the-payload.

§The-requestState-IS-the-server-side-state-encoded-in-the-payload + §the-client-doesn't-need-to-understand-it + §the-client-just-echoes-it-back-on-retry. §When-an-async-protocol-must-become-sync-or-stateless, §encode-the-server's-resumption-state-as-an-opaque-payload-the-client-echoes-back.

§First-explicit-observation in library of §opaque-server-state-echoed-by-client-as-resumption-mechanism. §Sibling-pattern-to-cycle-249's-out-of-band-communications-as-named-sync-over-async-mechanism — §two-different-shapes-of-async-to-sync-bridge: §cycle-249 out-of-band-channel + §cycle-251 opaque-state-echoed-by-client-in-retry.

§Sibling-pattern-to-cycle-241's-postponed-handler-pattern — §three-cycles-with-deferred-response-mechanisms (241 postponed-handler + 249 out-of-band-sync + 251 echo-state-on-retry).
