---
created: 2026-09-23
updated: 2026-09-23
author: gardener
---

# Design: Opus 5.5 tier placement

| Field | Value |
| --- | --- |
| Status | **Draft; carries open questions.** Landed on `main2` and presented as a PR answer-surface per the garden's-own-repo open-questions carve-out ([`roles/designer/AGENT.md`](../roles/designer/AGENT.md) section "Operating norms"). Not a pending merge. |
| Directive | kriskowal, 2026-09-23: where does Anthropic's Opus 5.5 sit in the tier vocabulary, and does its lower price change the automatic-work cost ceiling? |
| Decision | Opus 5.5 slots at the existing `mentor` tier. No new tier is needed. Make it the anthropic `mentor` default. Recommended, but open: adopt it as the automatic-work ceiling model after a bounded quota-burn measurement. |
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

## Existing tier, not a new tier

The four tiers (`mentat`, `mentor`, `minion`, and `myrmidon`) are ordinal thoughtfulness bands, not price bands. [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md) keeps cost in the rate card. A new tier for a cheaper Opus would mix the cost axis into the capability axis and require every tier consumer to learn a band that expresses no new thoughtfulness level.

Opus 5.5 succeeds Opus 5, which already sits at `mentor`. Register Opus 5.5 at `mentor`, before Opus 5 in the first-match inventory so it becomes the anthropic mentor default. Keep Opus 5 selectable unless the maintainer chooses to retire it.

## Automatic-work cost ceiling

The anthropic automatic-work cost ceiling in `scripts/jobs/handlers/monk-claude.sh` downshifts an automatic `mentor` job to `serve_tier=minion`, which resolves to `claude-opus-4-8`. Manual mentor jobs stay at `mentor`. `scripts/jobs/reaper.sh` mirrors that distinction when deciding whether to reroute after a failure.

Opus 5.5 changes the inputs to that policy. It costs less per token than Opus 4.8, but its always-on thinking may consume more quota than Opus 4.8 with adaptive thinking off. The fleet runs on flat subscriptions, so weekly quota rather than sticker price is the binding constraint.

Options:

- **A: register only.** Register Opus 5.5 at `mentor`; leave automatic mentor work downshifted to Opus 4.8.
- **B: raise the ceiling (recommended, open).** Remove the anthropic downshift so automatic mentor work uses Opus 5.5. Retire the matching reaper exception.
- **C: retarget the ceiling.** Resolve the ceiling directly to `claude-opus-5-5`. This adds special-case code without an advantage over B.

Run a bounded canary comparing quota consumption per completed automatic job for Opus 5.5 at `medium` and Opus 4.8 before choosing B. Option A can land independently.

## Exact changes

A follow-up build implements the selected option:

1. Add `anthropic\tclaude-opus-5-5\tmentor` to `scripts/jobs/model-tier-inventory.tsv`, ordered before `claude-opus-5`.
2. Add `claude-opus-5-5` to the anthropic patterns in `scripts/jobs/model-routing-defaults.tsv` and the inline fallback in `scripts/jobs/common.sh`. Optionally add an `opus55` short alias for hand pins.
3. If option B is selected, remove the anthropic mentor downshift from `scripts/jobs/handlers/monk-claude.sh` and its matching ceiling-suppression case from `scripts/jobs/reaper.sh`.
4. Extend `scripts/jobs/test/gardener-claude-tier-serving-test.sh` and the inventory tests. Under option B, update `reroute-role-floor-test.sh` too.
5. Update [`designs/provider-model-catalog.md`](provider-model-catalog.md) and [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md).

## Alternative considered

Considered and rejected: a new tier for a cheaper Opus. Reason: tiers express thoughtfulness; the rate card expresses cost.

## Open questions

- **Which automatic ceiling should the garden use?** Choose A now, or choose B after a bounded Opus 5.5-at-`medium` versus Opus 4.8 quota-burn canary? What effort should automatic Opus 5.5 work use?
- **Should Opus 5 remain registered?** The recommendation is to keep it selectable but stop making it the mentor default.
- **Is the pricing still current?** Recheck the live Anthropic catalog before the build lands.

## Grounding

- Opus 5.5 pricing and behavior: the bundled `claude-api` model catalog.
- Tier vocabulary and model-change checklist: [`skills/model-selection/SKILL.md`](../skills/model-selection/SKILL.md).
- Current implementation: `tier_model_for_provider` and the routing fallback in `scripts/jobs/common.sh`; the automatic-work ceiling in `scripts/jobs/handlers/monk-claude.sh`; its reroute mirror in `scripts/jobs/reaper.sh`.
