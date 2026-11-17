---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-17T04:01:29Z
job: dependabotany-recheck-endo-but-for-bots-20261117-030511
claim: a24f55c77063b748
---
# Dependabotany - endojs/endo-but-for-bots recheck 2026-11-17: #1663, #1664, and #1665 merged; #1655, #1657, and #1658 remain held on #1646

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- **#1663:** MERGE-NOW executed. Rebased head `f922a0ff28a1a21367cc0427dfe5be45e6c55399`; `ci-wait-merge.sh` observed 33 terminal checks with 0 failures and state `MERGED` at 2026-11-17T03:39:49Z.
- **#1664:** MERGE-NOW executed. Rebased head `a859a31c2ab910b28ceda4b2898cc0f37d4312ed`; `ci-wait-merge.sh` observed 33 terminal checks with 0 failures and state `MERGED` at 2026-11-17T03:49:40Z.
- **#1665:** MERGE-NOW executed. Rebased head `1863cd222b48e43e696480b9863113c7916ea5fb`; the conductor observed the terminal green rollup and state `MERGED` at 2026-11-17T03:58:38Z.
- **#1655:** MERGE-NOW remains non-terminal. It was rebased to `688a278fb9c19c1272db2c9bfb7a185c0077287e`, but fresh CI failed `test-xs`; #1646 remains OPEN with the same base-wide oracle failures.
- **#1657 and #1658:** MERGE-NOW remains non-terminal. Their recorded `test-xs` failures remain held on open #1646, so they were not needlessly rebased into another known-red CI cycle.
- **#1629:** still held on open #1613 and #1646; its recorded `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` failures remain.

dependabotany-active-pr: 1655
dependabotany-active-pr: 1657
dependabotany-active-pr: 1658
dependabotany-terminal-pr: 1663
dependabotany-terminal-pr: 1664
dependabotany-terminal-pr: 1665

Foreign-content classification: none; no upstream prose was read.

Self-improvement: nothing this time.
