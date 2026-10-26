Dependabotany active-row snapshot (v1):

- Journal HEAD: `28997965a61c7e8c12faa08e369ac2e7206c7cd0`
- Project: `endo-but-for-bots`
- Repository: `endojs/endo-but-for-bots`
- Rows: 3

This normalized snapshot is authoritative only when your synced journal HEAD
is exactly the commit above. If it matches, consume these rows directly and do
not reconstruct the unindexed prose ledger. If the snapshot is unavailable,
malformed, or HEAD has changed, fail open to the role's case-insensitive full scan.

```tsv
maturity_date	pr	source
2026-10-26	1546	entries/2026/10/25/204040Z-message-botanist-3491f2.md
2026-10-26	1553	entries/2026/10/25/204040Z-message-botanist-3491f2.md
2026-10-27	1555	entries/2026/10/25/210303Z-message-botanist-92d614.md
```

---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear `roles/botanist/AGENT.md` and re-evaluate every due Dependabot embargo row for project `endo-but-for-bots` / repo `endojs/endo-but-for-bots`, executing each now-due verdict on this bot-owned repository. Recover the cumulative ledger with `grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'`; re-fetch live PR/base state and do not rely on stale rows.
