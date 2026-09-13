---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-13T20:15:47Z
---
# Dependabotany: endo-but-for-bots PR #1274

project: endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1274
head: 5411f94cd52cdde1b67eb1026fa9e95711c41a1a
package: electron 43.4.1 -> 44.2.0
verdict: REJECT
disposition: closed
reason: packages/familiar advertises Node ^22.0.0 || ^24.0.0, but electron 44.2.0 requires Node >=22.12.0, excluding the supported 22.0.0 through 22.11.x interval.
comment: https://github.com/endojs/endo-but-for-bots/pull/1274#issuecomment-5655836494

Verification: live head and declarations re-fetched immediately before disposition; 7 Familiar tests passed on Node 22.23.2, ESLint completed with 0 errors and 3 warnings, TypeScript passed, OSV and GitHub Advisory queries returned no Electron advisory, and the PR was observed CLOSED after the comment.

Self-improvement: nothing this time.
