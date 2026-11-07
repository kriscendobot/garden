---
gate: go-ahead
priority: normal
tier: mentor
handler-timeout: 7200
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-07T02:43:15Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T02:43:15Z
---

---
handler-timeout: 7200
---

Dependabotany active-row snapshot (v1):

- Journal HEAD: `82d9fde9072bb03ff8b25e26834135cf01d69a22`
- Project: `endo-but-for-bots`
- Repository: `endojs/endo-but-for-bots`
- Rows: 1

This normalized snapshot is authoritative only when your synced journal HEAD
is exactly the commit above. If it matches, consume these rows directly and do
not reconstruct the unindexed prose ledger. If the snapshot is unavailable,
malformed, or HEAD has changed, fail open to the role's case-insensitive full scan.

```tsv
maturity_date	pr	source
2026-11-06	1629	entries/2026/11/05/081237Z-message-gardener-6ade4e.md
```

---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Wear roles/botanist/AGENT.md and re-evaluate every open PR in the endo-but-for-bots dependabotany ledger whose maturity date has arrived or whose recorded blocker has cleared. Recover the ledger with: grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'. Execute the now-due verdict for each PR: MERGE-NOW through ci-wait-merge.sh --dependabot-auto-merge, REJECT closes, EMBARGO re-defers. Current row: #1629 (setup-python 7.1.0) is held on endojs/endo-but-for-bots#1613 and #1646.
