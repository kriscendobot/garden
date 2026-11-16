---
handler-timeout: 7200
---

Dependabotany active-row snapshot (v2):

- Journal HEAD: `93e7aeb9afb538c45095a957a1b2a78fe6bbd82b`
- Project: `endo-but-for-bots`
- Repository: `endojs/endo-but-for-bots`
- Rows: 2

This normalized snapshot is authoritative only when your synced journal HEAD
is exactly the commit above. If it matches, consume these rows directly and do
not reconstruct the unindexed prose ledger. If the snapshot is unavailable,
malformed, or HEAD has changed, fail open to the role's case-insensitive full scan.

```tsv
disposition	pr	source
EMBARGO-2026-11-16	1662	entries/2026/11/15/202539Z-message-botanist-48713a.md
MERGE-NOW	1658	entries/2026/11/08/224140Z-message-botanist-82093c.md
```

---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear roles/botanist/AGENT.md and re-evaluate every open PR in the endo-but-for-bots dependabotany ledger whose maturity date has arrived or whose recorded blocker has cleared. Recover the ledger with: grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'. Execute the now-due verdict for each PR: MERGE-NOW through ci-wait-merge.sh --dependabot-auto-merge, REJECT closes, EMBARGO re-defers. Current row: #1629 (setup-python 7.1.0) is held on endojs/endo-but-for-bots#1613 and #1646.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-16T03:07:13Z
