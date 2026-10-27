---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-10-27T11:31:45Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1553 — EMBARGO-2026-10-28 (CI infrastructure recheck)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 1553
head: ba26b7472ada68b693c3698a2d64c881995763da
verdict: EMBARGO-2026-10-28
active: true

The live head is unchanged, there is no sibling bump, and `llm` still resolves `eslint-plugin-jsdoc` 64.5.4. The maturity floor (2026-10-25T15:17:50Z from `eslint-plugin-jsdoc@65.3.12`) has passed. Live OSV and GitHub Advisory Database checks on 2026-10-27 returned no advisories for either side of all eight moved packages, so the prior clean diligence remains valid.

CI still cannot clear because the shared Ubuntu 26.04 fixes remain unmerged: #1542 (sandbox/bwrap) and #1546 (`tred`) are open, and #1556 (Playwright runner) is open and draft. The unrelated macOS `@endo/floot` fix #1567 is also open. This is an escalation embargo, not a maturity embargo. The daily `dependabotany-recheck-endo-but-for-bots` backstop remains installed; rebase, rerun CI, and conduct with `--dependabot-auto-merge` after the infrastructure fixes land.

Verdict comment carries marker `garden-dependabotany-recheck:endojs/endo-but-for-bots#1553:2026-10-27`.
