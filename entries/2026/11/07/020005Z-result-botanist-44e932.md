---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-07T02:01:09Z
job: dependabotany-recheck-endo-but-for-bots-20261107-013512
claim: c6188a2b16efdc75
---
Verdict: EMBARGO-2026-11-08 for endojs/endo-but-for-bots#1629.

Re-derived the row from the full case-insensitive ledger scan because remote `journal2` no longer matched the job snapshot. Reverified the unchanged Dependabot head, both setup-python tag pins, latest release, GHSA/OSV results, sibling PR census, live-base call sites, and exact-head CI. The maturity floor has passed, but #1629 remains 38/40 green on the same two oracle failures; blocker #1613 is still open despite a green head, and draft #1646 is still open with its Ubuntu Node-24 lane red.

Posted the updated verdict at https://github.com/endojs/endo-but-for-bots/pull/1629#issuecomment-6700682033 and appended `entries/2026/11/07/015813Z-message-botanist-2c2cd2.md` to `journal2`. The daily backstop remains active. No rebase, merge, or project source change was made.

Follow-up: after #1613 and #1646 land on `llm`, re-run head-bound CI and conduct #1629 with `ci-wait-merge.sh --dependabot-auto-merge` if green.

Foreign-content classification: none; no upstream prose was read.

Self-improvement: nothing this time.
