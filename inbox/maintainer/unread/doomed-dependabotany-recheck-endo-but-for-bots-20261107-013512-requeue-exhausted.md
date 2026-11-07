from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T02:43:48Z
doom_base: dependabotany-recheck-endo-but-for-bots-20261107-013512
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T02:43:48Z
last_seen: 2026-11-07T02:43:48Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/dependabotany-recheck-endo-but-for-bots-20261107-013512; it stays HELD until a human promotes it
(promote-plan.sh dependabotany-recheck-endo-but-for-bots-20261107-013512) or removes it, so nothing is lost.
Original job base: dependabotany-recheck-endo-but-for-bots-20261107-013512

--- original job body ---
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
