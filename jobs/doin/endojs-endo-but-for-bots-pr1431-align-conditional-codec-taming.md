---
posted_at: 2026-10-27T18:12:39Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1431 (draft design `designs/hardened-text-codecs-shim.md`, encapsulation revision): PR #1349 now replaces host text codecs ONLY when the constructor has an own `arguments` property (naugtur's review r4229750056 on #1349, followed in #1349 head b43f86c0d3; see https://github.com/endojs/endo-but-for-bots/pull/1349#discussion_r4392435669). Revise the design so conditional replacement is the chosen approach, not a rejected alternative. Record the trade-offs it accepts: constructor identity depends on the engine, and tests must plant the affected shape. Note what this implies for the planned URL/URLSearchParams follow-up and the shared `encapsulateHostConstructor`. Keep the design consistent with #1349's changeset and guides.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T18:12:49Z
