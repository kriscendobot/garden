---
order: serial
children: openrouter-zdr-data-policy openrouter-stealth-lane openrouter-reputation-unmask-migration
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-08-22T08:15:51Z
---

Splits the doomed monolithic `openrouter-zdr-policy-and-stealth-lane` job
(deadline-overrun, 40 min handler budget, three bundled decisions) into three
ordered children, each riding the builder role's 7200s budget instead of the
default 2400s. Serial because all three touch overlapping shared files
(common.sh, claim-job.sh, model-tier-inventory.tsv, the openrouter design/ops
docs) and each genuinely depends on its predecessor landing first:
data-policy enforcement -> stealth lane (inherits it) -> reputation-unmask
migration (needs the stealth lane's real arm shape). Halt on failure rather
than continue, since a later child assumes an earlier one's mechanism exists.
