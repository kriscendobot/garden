---
gate: orchestrated
orchestrated_by: endo-npm-cas-arc-landing-2
priority: normal
posted_by: producer
posted_at: 2026-08-01T09:15:03Z
---

---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `llm`)
PR: https://github.com/endojs/endo-but-for-bots/pull/876 (OPEN/DRAFT, CONFLICTING,
`endor run --conditions` flag and webcrypto endowment)

MAINTAINER AUTHORIZATION (kriskowal, via liaison, 2026-08-01): "#876 stands approved and awaits
a conductor." This settles the long-open default-condition-set policy question in the direction
#876 implements — opt-in via an explicit `--conditions` flag plus webcrypto endowment — rather
than browser-by-default or node-shims. Record that policy resolution in your report; it also
governs the remaining web-global gaps (`crypto.subtle`, `TextEncoder`/`TextDecoder` streaming
and `fatal` fidelity, `encodeInto`, `URL`/`URLSearchParams`).

Task (conductor): the PR is currently DRAFT and CONFLICTING. Rebase onto current `llm`, drive CI
green, un-draft, and merge on the #862 pattern — verify on the exact merged tree, merge, then
post a provenance comment.

Ordering note: #875 (shares `EXPORTS_RESOLVER_JS`) lands before this job; #877 (shares
`__archiveEndowments`) rebases after it.
