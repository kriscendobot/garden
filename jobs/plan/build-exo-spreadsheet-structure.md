---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/881
priority: normal
role: builder
posted_by: producer
posted_at: 2026-09-13T14:08:07Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots

Build the `SpreadsheetStructure` follow-on layer from the exo Google Sheets design.

Origin: report `build-exo-google-sheets-facets` flagged `SpreadsheetStructure` and
`SpreadsheetStructure` as the design's thin follow-on layers, still unbuilt, and
"a natural next job once #874 and this land." Maintainer decision 2026-09-13
(muster): park the follow-on builds so they fire when the precondition is met
rather than being forgotten.

Blocked on https://github.com/endojs/endo-but-for-bots/pull/881 (attenuated Google
Sheets facets), which is itself stacked on
https://github.com/endojs/endo-but-for-bots/pull/874 (portable Google Sheets
client). Both were still OPEN as of 2026-09-13.

On promotion: re-read the design and both merged PRs first — a thin layer
described months earlier may have been absorbed or reshaped by what actually
landed. If `SpreadsheetStructure` is no longer the right shape, say so and report rather
than building to a stale spec.

Skills: skills/design-to-pr-pipeline, skills/pr-formation,
skills/fully-qualified-github-urls.
