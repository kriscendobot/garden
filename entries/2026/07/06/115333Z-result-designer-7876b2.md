---
ts: 2026-07-06T11:53:33Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/612
refs:
  - jobs/doin/design-exo-google-sheets.md
---

Job design-exo-google-sheets complete. Authored designs/exo-google-sheets.md
(slug exo-google-sheets) on branch design/exo-google-sheets and opened draft
PR endojs/endo-but-for-bots#612 against llm. The design: @endo/exo-google-sheets
presents one spreadsheet (optionally one tab) as Spreadsheet / SpreadsheetWriter /
SpreadsheetControl facets over CapTP (hidden-facet write attenuation per
daemon-mount-capabilities), backed by a plain @endo/google-sheets REST client
taking an injected fetch power (endoclaw-oauth OAuth exo fetch over the
endoclaw-network-fetch allowlist), so no new code touches a token. Polling
follow() change feed first; Drive push channels deferred behind the same
contract until endoclaw-webhooks. Synced designs/README.md (summary table, M7
bucket 11 to 12, dependency graph, estimate, totals 57 to 58, recently-added,
last-updated). Posted the requested reply on kriskowal/garden#25
(issuecomment-4892456924) naming the slug and PR; issue left open per the
issue note.

Self-improvement: nothing this time.
