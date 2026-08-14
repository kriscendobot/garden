---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# promote local `qwen3.6` from myrmidon to minion in the tier inventory

Maintainer directive (2026-08-14): promote qwen3.6 to the next higher tier so the
fleet can measure whether it is able to do real work. The hermit pool on
`endolin-garden2-5bcdff64` has been raised to 1 to carry the experiment.

## The change

`scripts/jobs/model-tier-inventory.tsv` currently classifies:

    local<TAB>qwen3.6<TAB>myrmidon

Change the tier to `minion` (the ladder is mentat > mentor > minion > myrmidon;
minion is the next tier up and the automatic fallback tier).

## Two things to handle while you are in this file

1. **The row has only 3 fields — no `pull_bytes`.** The file's own header says
   column 4 is REQUIRED on the `local` routing default before the sysop
   `local-model` provisioning op will pull it, and that a blank/missing size
   "fails that op closed before any network or disk activity". So qwen3.6 cannot
   currently be provisioned onto another host through the supported op. The model
   is already pulled on `endolin-garden2-5bcdff64`; its measured on-disk size is
   **23938333577 bytes** (23 GB, `qwen3.6:latest`, digest `07d3521259`, 36.0B
   params, Q4_K_M, context 262144, capabilities vision/completion/tools/thinking).
   Add that as the reviewed `pull_bytes` value so the op works.

2. **Confirm the tier ladder placement is coherent** with
   `skills/model-selection/SKILL.md`, which currently lists "served local Qwen"
   under **myrmidon** ("Expedient tier; not an automatic escalation path") and
   describes minion as "the automatic fallback tier". Moving the inventory row
   without updating the skill leaves the two disagreeing. Update the skill's
   table so local Qwen is described at its new tier.

## Deploy dependency (state this in your report)

`_model_tier_inventory_file()` in `common.sh` reads ONLY
`$GARDEN_ROOT/scripts/jobs/model-tier-inventory.tsv` (or a test env override).
Unlike model ROUTING — which has a per-instance journal override
(`config/model-routing`, `set-model-routing.sh`, no deploy needed) — the tier
inventory has **no journal override**. So this change reaches the fleet only
through a deliberate deploy. Note that plainly in your completion report.

## Risk worth recording (do not act on it, just record it)

This host has **no GPU**: ollama reports `inference compute: cpu`,
`total_vram="0 B"`, 125.1 GiB system RAM. A 36B model at Q4_K_M on CPU is slow.
The fleet's dominant failure mode right now is handler-budget overrun (as of
2026-08-14, 12 of 16 halted chains failed at a panel stage, and 15 of 41 halt
notices read "stalled"). Promoting a slow local model into the automatic
fallback tier could manufacture more of exactly that. Recommend in your report
whether minion-tier hermit jobs need a raised `handler-timeout:` default, and
what evidence would settle it.

## Definition of done
- Inventory row reads `local<TAB>qwen3.6<TAB>minion<TAB>23938333577`.
- `skills/model-selection/SKILL.md` agrees with the new tier.
- Any test asserting qwen3.6's tier is updated (check `model-routing-test.sh`,
  `tier-vocabulary-routing-test.sh`, `worker-spine-kinds-test.sh`).
- Report states the deploy dependency and the CPU-only risk assessment.
