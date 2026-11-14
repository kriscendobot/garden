---
handler-timeout: 7200
---

Dependabotany active-row snapshot (v2):

- Journal HEAD: `f1ac88062a93eae447423eb8a89a0377086767ca`
- Project: `endo-but-for-bots`
- Repository: `endojs/endo-but-for-bots`
- Rows: 1

This normalized snapshot is authoritative only when your synced journal HEAD
is exactly the commit above. If it matches, consume these rows directly and do
not reconstruct the unindexed prose ledger. If the snapshot is unavailable,
malformed, or HEAD has changed, fail open to the role's case-insensitive full scan.

```tsv
disposition	pr	source
MERGE-NOW	1658	entries/2026/11/08/224140Z-message-botanist-82093c.md
```

---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear roles/botanist/AGENT.md and re-evaluate every open PR in the endo-but-for-bots dependabotany ledger whose maturity date has arrived or whose recorded blocker has cleared. Recover the ledger with: grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'. Execute the now-due verdict for each PR: MERGE-NOW through ci-wait-merge.sh --dependabot-auto-merge, REJECT closes, EMBARGO re-defers. Current row: #1629 (setup-python 7.1.0) is held on endojs/endo-but-for-bots#1613 and #1646.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=599 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-14T03:23:08Z -->
