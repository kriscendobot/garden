---
handler-timeout: 7200
---

Dependabotany active-row snapshot (v1):

- Journal HEAD: `0578ad57be8ad58901bdedb6cbb260e518fc9f30`
- Project: `endo-but-for-bots`
- Repository: `endojs/endo-but-for-bots`
- Rows: 2

This normalized snapshot is authoritative only when your synced journal HEAD
is exactly the commit above. If it matches, consume these rows directly and do
not reconstruct the unindexed prose ledger. If the snapshot is unavailable,
malformed, or HEAD has changed, fail open to the role's case-insensitive full scan.

```tsv
maturity_date	pr	source
2026-10-28	1553	entries/2026/10/27/113143Z-message-botanist-0ca2c6.md
2026-10-28	1555	entries/2026/10/27/002223Z-message-botanist-bac676.md
```

---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear `roles/botanist/AGENT.md` and re-evaluate every due Dependabot embargo row for project `endo-but-for-bots` / repo `endojs/endo-but-for-bots`, executing each now-due verdict on this bot-owned repository. Recover the cumulative ledger with `grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'`; re-fetch live PR/base state and do not rely on stale rows.
