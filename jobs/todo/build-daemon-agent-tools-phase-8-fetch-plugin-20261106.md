---
posted_at: 2026-11-06T02:15:48Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
tier: mentor
arc: daemon-agent-tools
---
Repo: endojs/endo-but-for-bots @ llm. Build Phase 8 of the daemon agent tools design (find it under designs/ via `grep -ril 'agent tools' designs/`). Maintainer decision on Open Question 4 (kriskowal, liaison muster 2026-11-06): the HTTP client is provided by the `@endo/fetch` plugin, NOT a new daemon `provideHttpClient` formula. Record the resolution in the design's open-questions section and tick the Phase 2c checkbox only if endojs/endo-but-for-bots#1497 has merged (it was open on 2026-11-06; check first). Open a DRAFT PR on an in-repo endojs branch per the usual builder flow.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-06T02:53:10Z -->
