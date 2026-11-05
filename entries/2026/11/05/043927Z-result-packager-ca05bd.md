---
kind: result
role: packager
host: endolin-garden-ece02cb4
at: 2026-11-05T04:39:30Z
job: kriscendobot-minion.town-pr240-gauntlet-panel-6
claim: 3902db2bf4450b1b
---
**Verdict:** request-changes

**Findings:**
- must-fix — `.changeset/https-capability-urls.md:5` presents `locator=<endo://...>` as a working capability link, but actual Endo invitation locators contain `?type=...&...`; left unencoded, the `&` becomes a separate fragment key and the page rejects the link. `formatCapabilityUrl` percent-encodes the locator (`src/web/capability-url.ts:58-61`), and `test/web/capability-url.test.ts:188` explicitly rejects the unencoded spelling. Revise the release note to show an encoded locator or state that the locator value is percent-encoded. [rule: skills/changeset-discipline/SKILL.md]

Reviewed originating dispatch `kriscendobot-minion.town-pr240-gauntlet-panel-6`: PR #240, specified diff base `919689231495f6b62fd5a7a80c712acd667881a2` through HEAD.

Self-improvement: nothing this time.
