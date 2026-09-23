# Kimi K3 credit exhaustion accounting — 2026-07-30

## Scope and method

The activation-to-exhaustion evidence window is 2026-07-29T17:41:42Z through
2026-07-30T03:15:29Z. It contains 42 Kimi engagements. Twenty-eight have actual
usage telemetry and are funded below; 14 later attempts have zero input, output,
cache-creation, and cache-read tokens, so receive $0.00 and are identified as
quota/outage attempts rather than productive spend.

The 28 funded records total 1,642,503 input tokens, 510,533 output tokens, zero
cache-creation tokens, and 43,764,736 cache-read tokens: 45,917,772 recorded
token-units. Moonshot per-class prices are not in the journal, so this is a
token-unit attribution, not an invented price calculation. For each engagement
`exact_cents = 6400 * token_units / 45917772`; allocate its floor, then award the
remaining 14 cents to the largest fractional remainders, ties by base name. This
deterministic largest-remainder result is exactly 6,400 cents.

Every completed allocation has a matching append-only adjustment at
`reputation/adjustments/<base>/20260730T051000Z-kimi-credit-exhaustion.md`; it
records the usage source, method, invoice authority, and high confidence. Four
token-bearing failed attempts are retained in this table but have no finalized
reputation event to adjust.

| Base | Outcome | Token-units | Cents |
| --- | --- | ---: | ---: |
| design-npm-dev-publisher-attenuation | tada | 10,965,427 | 1,528 |
| endojs-endo-but-for-bots-pr403-shepherd | fail | 2,488,430 | 347 |
| endojs-endo-but-for-bots-pr556-conduct | tada | 413,032 | 58 |
| endojs-endo-but-for-bots-pr558-conduct | tada | 248,939 | 35 |
| endojs-endo-but-for-bots-pr652-conduct | tada | 1,100,147 | 153 |
| endojs-endo-but-for-bots-pr652-fbc8cd33 | tada | 1,889,197 | 263 |
| endojs-endo-but-for-bots-pr652-shepherd | tada | 2,681,213 | 374 |
| endojs-endo-but-for-bots-pr652-weave | fail | 788,772 | 110 |
| endojs-endo-but-for-bots-pr676-conduct | tada | 305,760 | 43 |
| endojs-endo-but-for-bots-pr713-conduct | tada | 394,586 | 55 |
| endojs-endo-but-for-bots-pr721-conduct | tada | 676,705 | 94 |
| endojs-endo-but-for-bots-pr761-0ba46b9f | tada | 1,178,872 | 164 |
| endojs-endo-but-for-bots-pr778-review-95a2b3a4 | tada | 1,342,866 | 187 |
| endojs-endo-but-for-bots-pr778-shepherd | tada | 1,390,547 | 194 |
| endojs-endo-but-for-bots-pr836-review-03bd85ff | tada | 1,186,862 | 165 |
| endojs-endo-but-for-bots-pr836-shepherd | tada | 2,748,994 | 383 |
| endojs-endo-but-for-bots-pr848-conduct | tada | 750,733 | 105 |
| endojs-endo-but-for-bots-pr857-conduct | tada | 350,891 | 49 |
| endojs-endo-but-for-bots-pr857-gauntlet-clean | tada | 125,617 | 18 |
| endojs-endo-but-for-bots-pr859-conduct | tada | 439,310 | 61 |
| endojs-endo-but-for-bots-pr860-conduct | tada | 286,861 | 40 |
| endojs-endo-but-for-bots-pr869-conduct | tada | 276,255 | 39 |
| endojs-endo-but-for-bots-pr870-conduct | tada | 353,060 | 49 |
| endojs-endo-but-for-bots-pr873-conduct | fail | 144,444 | 20 |
| endojs-endo-but-for-bots-pr875-review-51bf66b1 | fail | 277,787 | 39 |
| exo-git-follow-root-advancement-design | tada | 8,383,574 | 1,168 |
| garden-pr-review-sequence-refresh | tada | 2,166,877 | 302 |
| model-tier-effectiveness-review-20260729-172004 | tada | 2,562,014 | 357 |
| **Total** |  | **45,917,772** | **6,400** |

The zero-telemetry attempts are pr876-conduct, pr876-review-ac5d6dfa,
pr877-review-1eec395e, pr880-conduct, pr878-conduct, pr885-conduct,
pr885-review-c5f39398, pr886-conduct, garden-approval-reconciler-build,
garden-fireworks-glm52-register-retry, pr-ebfb-877-bundle-endo-base64,
xs2rust-endor-s2-test-rust-green, endo-sturdyref-press-20260729-195004, and
build-endo-regexp-conservative-subset. Their 161–174 second cluster after the
credit exhaustion is treated as provider/quota wait, not a duration proxy.

## Mentor-tier effectiveness carry-forward

Kimi's comparable completed sample is 24 productive completions, 4
token-bearing failures, and 14 post-exhaustion zero-token provider failures.
Productive wall time is 17,577 seconds across the 28 funded attempts; cost is
$64.00. Completed work is mixed: 13 operations/conductor jobs, 5 review or
shepherd jobs, 3 design/doc jobs, a gardener clean, and the prior tier review.
The 24 completion-backed records have acceptance true; the four failures have
no acceptance observation. This is completion-censored evidence, not a claim
that all downstream PRs are approved or merged.

The 2026-07-29 baseline identifies Kimi as the only operational mentor candidate;
Fireworks GLM 5.2 was still an explicit-only one-canary lane, and Claude Fable is
mentat/manual-only. There is therefore no matched same-tier model sample with the
same role/size mix. Do not infer a Kimi-versus-mentor superiority result. Compared
with the baseline's minion Codex/Opus work, Kimi's burst is disproportionately
ops/review work and includes a credit-exhaustion outage, so cost, wall time,
completion, PR approval/merge, requeue/poison, and fix-loop rates are not
causally comparable without matched trials. Retain Kimi disabled and explicit-only;
the evidence raises measured spend but does not support automatic mentor routing.

The next weekly review must use this report, count the four productive failures
separately from the 14 quota failures, use $64.00 as Kimi's attributed cost, and
seek matched mentor trials before a retier recommendation.
