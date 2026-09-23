---
created: 2026-09-23
updated: 2026-09-23
author: gardener
---

# Design: Opus 5.5 tier placement

| Field | Value |
| --- | --- |
| Status | **Resolved (2026-09-23).** The open questions were answered empirically by a mentat canary (`mentat-opus55-tier-open-questions-20260923`); see "Resolved decisions" below. The design landed on `main2`; the PR #108 answer-surface has served its purpose and can be closed. Implementation is the follow-up build `build-opus55-tier`. |
| Directive | kriskowal, 2026-09-23: where does Anthropic's Opus 5.5 sit in the tier vocabulary, and does its lower price change the automatic-work cost ceiling? kriskowal, on PR #108: "get data to inform this choice." |
| Decision | Opus 5.5 slots at the existing `mentor` tier (no new tier). Register it as the anthropic `mentor` default, before Opus 5. **Adopt Option B** — remove the anthropic mentor downshift so automatic mentor work uses Opus 5.5 at `medium` effort — on the strength of a bounded quota-burn canary (below). Keep Opus 5 selectable. |
| Related design | [TypeSafe Jev for classification work](typesafe-jev-classification.md) |

## Evidence

Anthropic first-party API pricing, transcribed from the bundled `claude-api` skill's model catalog:

| Model | Id | Input $/MTok | Output $/MTok | Cache read | Fleet tier today |
| --- | --- | --- | --- | --- | --- |
| Claude Opus 5.5 | `claude-opus-5-5` | **$4.00** | **$20.00** | $0.20 | unclassified |
| Claude Opus 5 | `claude-opus-5` | $5.00 | $25.00 | - | `mentor` |
| Claude Opus 4.8 | `claude-opus-4-8` | $5.00 | $25.00 | - | `minion`, the automatic ceiling |
| Claude Fable 5 | `claude-fable-5` | $10.00 | $50.00 | - | `mentat`, manual-only |

Opus 5.5 is the successor to Opus 5 in the Opus line, with the same 1M context, 128K output, tokenizer, and feature set at a lower price. Its default reasoning effort is `medium`; thinking is always on and effort controls its depth. Fast mode is $8/$40. It is newer and cheaper than the incumbent Opus 5 and cheaper than the Opus 4.8 automatic ceiling.

**Pricing rechecked 2026-09-23** against the bundled `claude-api` model catalog (the authoritative first-party source): the three figures above are unchanged and current — Opus 5.5 $4.00/$20.00 (cache read $0.20), Opus 5 $5.00/$25.00, Opus 4.8 $5.00/$25.00. The follow-up build lands against these figures.

## Existing tier, not a new tier

The four tiers (`mentat`, `mentor`, `minion`, and `myrmidon`) are ordinal thoughtfulness bands, not price bands. [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md) keeps cost in the rate card. A new tier for a cheaper Opus would mix the cost axis into the capability axis and require every tier consumer to learn a band that expresses no new thoughtfulness level.

Opus 5.5 succeeds Opus 5, which already sits at `mentor`. Register Opus 5.5 at `mentor`, before Opus 5 in the first-match inventory so it becomes the anthropic mentor default. Keep Opus 5 selectable unless the maintainer chooses to retire it.

## Automatic-work cost ceiling

The anthropic automatic-work cost ceiling in `scripts/jobs/handlers/monk-claude.sh` downshifts an automatic `mentor` job to `serve_tier=minion`, which resolves to `claude-opus-4-8`. Manual mentor jobs stay at `mentor`. `scripts/jobs/reaper.sh` mirrors that distinction when deciding whether to reroute after a failure.

Opus 5.5 changes the inputs to that policy. It costs less per token than Opus 4.8, but its always-on thinking may consume more quota than Opus 4.8 with adaptive thinking off. The fleet runs on flat subscriptions, so weekly quota rather than sticker price is the binding constraint.

Options:

- **A: register only.** Register Opus 5.5 at `mentor`; leave automatic mentor work downshifted to Opus 4.8.
- **B: raise the ceiling (CHOSEN).** Remove the anthropic downshift so automatic mentor work uses Opus 5.5. Retire the matching reaper exception.
- **C: retarget the ceiling.** Resolve the ceiling directly to `claude-opus-5-5`. This adds special-case code without an advantage over B.

**Decision: Option B, at `medium` automatic effort.** The canary below shows the design's central worry — that Opus 5.5's always-on thinking would burn *more* quota than Opus 4.8's adaptive thinking — does not materialize at `medium`. Opus 5.5 at `medium` consumed equal-or-less quota per completed job while producing terser output and less reasoning, so there is no quota reason to keep the Opus 4.8 downshift. C stays rejected: the data does not contradict the design's reasoning, and B is simpler than C. Because Opus 5.5's *default* effort is already `medium`, "automatic effort = `medium`" is satisfied by adding no effort flag to the handler — the build need not plumb effort.

### Canary: quota per completed job, Opus 5.5 @ `medium` vs Opus 4.8

Method (bounded, 2026-09-23, run by job `mentat-opus55-tier-open-questions-20260923`): a controlled single-turn A/B via `claude -p --output-format json`, three representative fleet-style tasks (a bash race/quoting fix, a short design-risk analysis, a five-item PR-title classification) run on each model with identical inputs — Opus 5.5 at `--effort medium` (its default; the handler sets no effort, so this is what the fleet would run), Opus 4.8 at its default. Per-run figures came from each run's own `modelUsage` block. This isolates model behavior on identical inputs rather than a full multi-turn agentic session, so the transferable signal is the *relative* comparison (reasoning depth, verbosity, per-token price), not the absolute per-task size. All six runs completed successfully (`is_error=false`) with comparable answer quality. Total canary spend: **$0.57** (6 runs).

Billable tokens use the fleet meter definition (`input + output + cache_creation`; cache_read excluded — `usage-meter.sh`):

| Task | Model | output | thinking | billable | list $ |
| --- | --- | --- | --- | --- | --- |
| bash-fix | Opus 4.8 | 1868 | 1067 | 11121 | 0.1443 |
| bash-fix | Opus 5.5 | 1321 | 473 | 8471 | 0.0857 |
| design-risk | Opus 4.8 | 937 | 475 | 8588 | 0.1059 |
| design-risk | Opus 5.5 | 818 | 464 | 8470 | 0.0799 |
| classify | Opus 4.8 | 724 | 455 | 6263 | 0.0794 |
| classify | Opus 5.5 | 379 | 142 | 8023 | 0.0711 |
| **total** | **Opus 4.8** | **3529** | **1997** | **25972** | **0.3296** |
| **total** | **Opus 5.5** | **2518** | **1079** | **24964** | **0.2367** |

Findings: aggregate billable quota is ~**3.9% lower** for Opus 5.5 (neutral-to-favorable — and cache_creation, which dominates billable, is run-to-run noise from cache state; the one task where 5.5's billable was higher, `classify`, was driven entirely by incidental cache_creation while its *generation* was far lower). Generation tokens (output + thinking) — the part the model actually controls — were **lower for Opus 5.5 on all three tasks** (3597 vs 5526, −35% aggregate), and reasoning specifically was **46% lower** (1079 vs 1997): at `medium`, Opus 5.5 thinks *less*, not more. Per-job list cost was **28% lower** ($0.079 vs $0.110), from the combined lower price and lower token counts. Conclusion: adopting Opus 5.5 at `medium` as the automatic anthropic model is quota-neutral-to-favorable and strictly cheaper — Option B.

> Note on the automatic route: a separate choke-point policy has kept automatic fleet work off Claude since 2026-07-29 ("Claude off automatic"), so B's *live* effect is latent until automatic work routes to an anthropic worker again; B is nonetheless the correct target state, making Opus 5.5 the anthropic automatic ceiling whenever that path reopens.

## Exact changes

A follow-up build implements the selected option:

1. Add `anthropic\tclaude-opus-5-5\tmentor` to `scripts/jobs/model-tier-inventory.tsv`, ordered before `claude-opus-5`.
2. Add `claude-opus-5-5` to the anthropic patterns in `scripts/jobs/model-routing-defaults.tsv` and the inline fallback in `scripts/jobs/common.sh`. Optionally add an `opus55` short alias for hand pins.
3. If option B is selected, remove the anthropic mentor downshift from `scripts/jobs/handlers/monk-claude.sh` and its matching ceiling-suppression case from `scripts/jobs/reaper.sh`.
4. Extend `scripts/jobs/test/gardener-claude-tier-serving-test.sh` and the inventory tests. Under option B, update `reroute-role-floor-test.sh` too.
5. Update [`designs/provider-model-catalog.md`](provider-model-catalog.md) and [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md).

## Alternative considered

Considered and rejected: a new tier for a cheaper Opus. Reason: tiers express thoughtfulness; the rate card expresses cost.

## Resolved decisions

Answered empirically 2026-09-23 by job `mentat-opus55-tier-open-questions-20260923` (kriskowal on PR #108: "get data to inform this choice").

- **Which automatic ceiling should the garden use, and at what effort?** **Option B, at `medium` effort.** Register Opus 5.5 at `mentor` (before Opus 5) and remove the anthropic mentor downshift so automatic mentor work uses Opus 5.5; retire the matching reaper ceiling-suppression exception. The bounded canary (see "Canary" above) refuted the always-on-thinking quota worry: at `medium`, Opus 5.5 consumed ~3.9% less aggregate billable quota than Opus 4.8, generated 35% fewer output+thinking tokens (thinking specifically 46% fewer), and cost 28% less per completed job — quota-neutral-to-favorable and strictly cheaper. Option C stays rejected (special-case code, no advantage over B). Effort is `medium` because that is Opus 5.5's default and what the canary measured; no handler effort plumbing is required.
- **Should Opus 5 remain registered?** **Yes — keep it selectable, but stop making it the mentor default.** Confirmed. Opus 5.5 becomes the first-match anthropic mentor row; Opus 5 stays in the inventory reachable by an explicit `model: claude-opus-5` pin. Keeping it costs nothing and preserves an explicit-pin fallback and reproducibility of existing pins.
- **Is the pricing still current?** **Yes.** Rechecked 2026-09-23 against the bundled `claude-api` catalog: Opus 5.5 $4.00/$20.00 (cache read $0.20), Opus 5 $5.00/$25.00, Opus 4.8 $5.00/$25.00 — unchanged from the Evidence table. The build lands against these figures.

## Grounding

- Opus 5.5 pricing and behavior: the bundled `claude-api` model catalog.
- Tier vocabulary and model-change checklist: [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md).
- Current implementation: `tier_model_for_provider` and the routing fallback in `scripts/jobs/common.sh`; the automatic-work ceiling in `scripts/jobs/handlers/monk-claude.sh`; its reroute mirror in `scripts/jobs/reaper.sh`.
