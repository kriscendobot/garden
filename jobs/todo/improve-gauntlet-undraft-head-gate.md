---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
Defect: `scripts/jobs/gauntlet.sh:853` delegates the required panel-head equality check before undrafting to an agent; the 2026-10-06T05:25:53Z progress entry reports #163 was undrafted on a stale head before later must-fix findings. Before accepting `undraft=done` and calling `finish_done`, deterministically fetch the PR’s draft state and `headRefOid`, require it to equal the recorded `panel_head`, and halt or restage review on mismatch. This prevents an agent from undrafting a head that no passing panel reviewed.
