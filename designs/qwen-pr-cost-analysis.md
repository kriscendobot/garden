# Qwen PR completion-cost analysis

| Measured | 2026-09-09 |
| --- | --- |
| Population | 59 archived completion receipts after historical backfill |
| Question | Does local `hermit` / `qwen3.6` save machine cost but consume more maintainer review effort? |

## Result

The completed historical corpus does **not** show higher total cost for the small
Qwen-carried sample. Its mean total was **$255.74** versus **$427.87** for matched
non-Qwen PRs; medians were **$178.18** and **$211.42**. The result is descriptive,
not a model-ranking claim: there are only three qualifying Qwen PRs, one per work
class, and one comparison PR has exceptionally large human prose volume. Within the
classes, Qwen was tied on `build:m`, modestly cheaper on `weave:s`, and above the
non-Qwen median but below its outlier-driven mean on `fix:s`.

The premise that human effort dominates is strongly confirmed. MRE was **$255.00 of
$255.74 (99.7%)** of the mean Qwen total and **$427.00 of $427.87 (99.8%)** of the
comparison mean. Optimizing or accounting for raw tokens alone would miss virtually
all measured cost.

## Population and cohort rule

The audit started from all 51 `reputation/events/*.md` records for
`kind: hermit`, `provider: local`, `model: qwen3.6`. The cost join plus researched
historical overrides resolves 26 of these engagements to PRs: 22 terminal PRs and
four still-open PRs. The remaining 25 are presses, direct-to-main cycles, issue-bus
work, tests, or other work with no completed PR. Every one of the 22 terminal PRs now
has a receipt; open PRs correctly receive no completion receipt.

“Carried” is narrower than “Qwen appears somewhere in the receipt.” I included an
accepted Qwen engagement only when its job report showed the primary, delivery-critical
work for that intervention class, and excluded review retrospectives, shepherding,
dependency handling, metadata-only un-drafting, and administrative closure. This left:

- [`finbot#1`](https://github.com/kriscendobot/finbot/pull/1), `build:m`: Qwen
  implemented the SES compartment attenuator.
- [`endo-but-for-bots#707`](https://github.com/endojs/endo-but-for-bots/pull/707),
  `weave:s`: Qwen performed the primary accepted weave.
- [`endo-but-for-bots#719`](https://github.com/endojs/endo-but-for-bots/pull/719),
  `fix:s`: Qwen performed the maintainer-requested documentation fix. This is the
  weakest inclusion: the full PR has 22 joined bases and substantial work from other
  arms, so it should not be read as a Qwen-authored design.

Notably, [`finbot#4`](https://github.com/kriscendobot/finbot/pull/4) has a Qwen
`build:l` event, but its report says it only changed DRAFT to READY on already-built,
green work. Counting that as Qwen-carried would be label leakage, so it is excluded.

The matched set uses the same repo and class where possible: `finbot#2` and `#3` for
`build:m`; endo-but-for-bots `#691`, `#705`, `#876`, and `#878` for `weave:s`; and
`#661`, `#796`, `#889`, and `#910` for `fix:s`. All were primarily carried by
gardener/monk/cleric/mystic rather than hermit. Six additional `build:m` and related
historical receipts were backfilled for broader future analysis but are not mixed
into the exact-repo build comparison.

## Cost and MRE results

`total = calibrated measured machine cost + MRE`; OpenAI modelling ceilings remain
excluded, consistently with the receipt design.

| Work class | Qwen PRs | Qwen mean / median total | Matched PRs | Other mean / median total |
| --- | ---: | ---: | ---: | ---: |
| `build:m` | 1 | $20.06 / $20.06 | 2 | $20.05 / $20.05 |
| `weave:s` | 1 | $178.18 / $178.18 | 4 | $199.44 / $211.42 |
| `fix:s` | 1 | $568.97 / $568.97 | 4 | $860.21 / $520.40 |
| **All matched** | **3** | **$255.74 / $178.18** | **10** | **$427.87 / $211.42** |

The `fix:s` comparison mean is pulled upward by
[`#796`](https://github.com/endojs/endo-but-for-bots/pull/796): its human comments
contain 557,103 characters and the heuristic assigns $2,245 MRE. The median is the
more stable summary for this small, skewed sample.

| Work class | Cohort | Mean MRE | Mean sitting-days | Mean human comments | Mean comment chars |
| --- | --- | ---: | ---: | ---: | ---: |
| `build:m` | Qwen / other | $20.00 / $20.00 | 1.0 / 1.0 | 0 / 0 | 0 / 0 |
| `weave:s` | Qwen / other | $177.50 / $198.75 | 5.0 / 6.5 | 9 / 9 | 12,752 / 10,575 |
| `fix:s` | Qwen / other | $567.50 / $858.75 | 14.0 / 9.25 | 45 / 26 | 35,438 / 172,797 |
| **All matched** | **Qwen / other** | **$255.00 / $427.00** | **6.67 / 6.50** | **18 / 14** | **16,063 / 73,349** |

The only hint in favor of the “free model costs human attention” hypothesis is the
Qwen `fix:s` PR: more sitting-days and comments than its comparison average. It does
not translate to higher mean cost because comparison prose volume is much larger, and
it is confounded by #719's unusually long, multi-arm path. `build:m` is identical and
`weave:s` needs fewer sitting-days. Historical `panel_rounds` records do not join
reliably to these old PRs (the receipts report zero), so the reproducible human
sitting-day count is the review-round proxy used here; no missing panel value was
silently treated as evidence of zero review.

## Closed-without-merge outcomes

The evidence-gated classifier found **no roll-forward Qwen failure** in the terminal
engagement universe:

- `productive-redirect`: [`#263`](https://github.com/endojs/endo-but-for-bots/pull/263)
  redirected from universal URL-power removal to #719's materially different
  Date-style split; [`#861`](https://github.com/endojs/endo-but-for-bots/pull/861)
  contributed the coverage caveat carried into the better-named and better-evidenced
  #864 implementation.
- `administrative-continuation`: [`#379`](https://github.com/endojs/endo-but-for-bots/pull/379)
  moved the same work to frozen-base #779; Qwen-carried #719 landed upstream as
  endojs/endo#3332; [`minion.town#19`](https://github.com/kriscendobot/minion.town/pull/19)
  moved a byte-identical diff to #31 after base deletion; and
  [`agoric-sdk#16`](https://github.com/kriscendobot/agoric-sdk/pull/16) moved upstream
  as Agoric/agoric-sdk#12805.
- `unresolved`: [`minion.town#16`](https://github.com/kriscendobot/minion.town/pull/16)
  has no explicit closing/successor evidence strong enough to classify. It is not
  guessed into either outcome.

Thus #719, the only closed PR in the headline Qwen cohort, is not a failed build whose
cost rolled forward: it is a successful upstream landing represented by an
administratively closed fork PR.

## Implication for `qwen-mentor-tier-trial`

Do not use this retrospective sample alone to promote or reject Qwen: three observations
cannot separate model effect from PR difficulty. The trial should pre-register the
carried/co-author rule, record a durable base-to-PR edge at job creation, and balance
several PRs per work class. Its primary endpoint should be MRE sitting-days/minutes and
comment volume, with total cost as MRE plus measured machine cost. It should separately
flag metadata-only and reviewer/fixer roles so they cannot be mislabeled as primary
builds, and should require evidence-backed classification for every non-merge.
