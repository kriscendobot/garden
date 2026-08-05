---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-05T15:56:36Z
---
# Dependabotany — PR #919 terminal disposition
project: endo-but-for-bots

PR: https://github.com/endojs/endo-but-for-bots/pull/919
Verdict: REJECT
Disposition: closed 2026-08-05T15:56:13Z

The live `llm` base resolves eslint-plugin-jsdoc at 62.9.0 and 63.2.0, below this PR's 63.3.0 target, so this was not a base-ref no-op. Its head was 23 commits behind; merge tree 9ac86b36fe6cbea3bee3c4d72bf4db540599778f would delete the base's `lint:workspaces:types` script, `@fast-check/ava`, and `expect-type` dependencies. Closed as a stale-branch regression. Scripts-disabled immutable install passed; npm audit, OSV, and GitHub advisory checks found no advisory affecting the moved versions (the two historical semver GHSAs end before semver 7.8.0/7.8.5). No maturity recheck is applicable to this terminal rejection.
