All three pass (tier-vocabulary exits 0 with all PASS). The work is complete and pushed to `main2`.

## Completion report

Implemented **Option B** of `designs/opus55-tier.md` (resolved 2026-09-23): registered Opus 5.5 at the `mentor` tier as the anthropic mentor default and raised the anthropic automatic ceiling to it, removing the mentor→minion downshift. Committed as `f82432ffa27` and pushed to `main2` (rebased once onto a concurrent commit).

**Changes made, per the design's "Exact changes" section:**

1. **`scripts/jobs/model-tier-inventory.tsv`** — added `anthropic  claude-opus-5-5  mentor` ordered *before* `claude-opus-5`, so first-match makes it the anthropic mentor default. Opus 5 row kept.
2. **`scripts/jobs/model-routing-defaults.tsv`** + **`scripts/jobs/common.sh`** inline fallback — classified `claude-opus-5-5` as anthropic; added the `opus55` short alias in `resolve_model_tier` for hand pins.
3. **Option B** — removed the anthropic mentor cost-ceiling downshift (`serve_tier=minion` block) from `scripts/jobs/handlers/monk-claude.sh` and its matching ceiling-suppression case from `scripts/jobs/reaper.sh` (the per-role floor reroute now applies uniformly). No effort flag added — automatic effort `medium` is Opus 5.5's default.
4. **Tests** — updated `gardener-claude-tier-serving-test.sh` (now asserts mentor→claude-opus-5-5, no downshift), added Opus 5.5 assertions to `tier-vocabulary-routing-test.sh`, and rewrote the reroute test's B2 case for Option B (anthropic-served mentor now demotes to floor like any provider). All pass.
5. **Docs** — retired the "anthropic automatic-work cost ceiling / downshift" language in `skills/model-selection/SKILL.md` and `designs/provider-model-catalog.md`; new ceiling is `claude-opus-5-5` ($4/$20, cache read $0.20), with Opus 5.5 added to the model table and alias list.

**Verification:** the three target tests plus `model-routing-test.sh`, `subscription-budget-model-test.sh`, and `panel-seat-tiering-test.sh` all pass; `bash -n` clean on all edited scripts. No rate-card change needed — the anthropic arm is a flat `* / *` subscription row, not per-model.

**Notes / follow-ups:**
- `kimi-credit-exhaustion-routing-test.sh` (1/4) and `worker-spine-kinds-test.sh` (258/32) fail, but I confirmed identical failure counts on baseline HEAD (`origin/main2`) — pre-existing/environmental, not a regression from this change.
- Left `designs/claude-ollama-cloud-worker-kind.md` untouched (out of the design's doc-update scope); it now describes the retired downshift as historical design context. A future cleanup could add a note there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-opus55-tier.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (5687636 cached reads)
- Output: 30652 tokens
- Cost: $4.916847999999999
- Wall-clock: 692s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
