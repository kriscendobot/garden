---
title: Calibration round 2026-05-08 + Estimation methodology
source: designs/README.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 510630411ebc26a6d9327928b4d71e5155802ea4
source_date: 2026-05-09
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
notes: The 2026-05-08 calibration is rigorously methodology-tracked — N=14 implementation-bearing designs with merged PRs, separated from N=8 design-only PRs. The key finding: **review-queue latency (median 13.9 days)** is the binding constraint, not author throughput. The recommendation "additive review-queue weeks rather than multiplying per-design estimates" is a load-bearing process correction.
---

> Abstract: The 2026-05-08 calibration round recalibrated estimates against observed PR-merge velocity. **Sample**: N=14 implementation-bearing designs with merged PRs (M0 narrative actuals + M1 PRs `#17`, `#21`, `#61`, `#92`, `#93`, `#94`, `#99`, `#104`, plus `gateway-bearer-token-auth`). **Headline ratio**: median actual/estimate **1.10**, mean **1.01** — size-3 estimates are roughly accurate when work actually completes. **Per-size velocity**: S median ratio 0.64 (5 samples; surgical fixes); M 1.20 (7 samples; ~20% over); L 1.53 (1 sample, `daemon-make-archive`, ~11 days across PRs #17 + #21); XL no completed sample. **The binding constraint is review-queue latency**, not throughput: 14 implementation PRs forwarded under the bot in the 2026-04-23/04-24 batch (`#122`–`#135`) sit at a median 13.9 days open — recommendation is **additive review-queue weeks rather than multiplying per-design estimates**. **Estimation methodology** (recalibrated 2026-03-02): 15 active work days, ~9 commits/day, ~500-2500 LOC/day, 14 designs completed Feb 15 – Mar 2. Per-size LOC ranges: S < 500 (1d), M 500-1500 (2-3d), L 1500-3000 (1-1.5w), XL > 3000 (2-3w). Original Feb-24 estimates assumed 200-300 LOC/day; actual velocity 2-3× higher.

### Calibration round 2026-05-08

Recalibrated against observed PR-merge velocity since the prior round.

**Sample.** N = 14 implementation-bearing designs with merged PRs, plus 8 design-only PRs (treated separately because their time-to-merge measures CI + review latency, not design effort). Sources: M0 narrative actuals (7 designs) + M1 merged PRs `#17`, `#21`, `#61`, `#92`, `#93`, `#94`, `#99`, `#104`, plus `gateway-bearer-token-auth`. PRs matched to designs via branch slug + design-doc-to-impl `Refs:` body convention + (for recreated-under-bot pattern) the "Forwarded from #N" body line.

**Headline ratio.** Median actual / estimate ratio across the 14 completed designs: **1.10**. Mean: **1.01**. Size-3 estimates are roughly accurate when work actually completes. The bigger story: completion is not the bottleneck.

**Per-size velocity (completed implementation PRs):**

| Size | N | Median estimate | Median actual | Ratio |
|------|---|-----------------|---------------|-------|
| S    | 5 | 1.0 d           | 0.6 d         | 0.64  |
| M    | 7 | 2.5 d           | 3.0 d         | 1.20  |
| L    | 1 | 7.0 d           | 10.7 d        | 1.53  |
| XL   | 0 | n/a             | n/a           | n/a   |

S-sized designs land faster than estimated (surgical fixes that took an afternoon). M-sized designs run ~20% over. The single L data point (`daemon-make-archive`, ~11 days across PRs `#17` and `#21`) ran ~50% over. XL has no completed sample yet.

**Review-queue latency (the binding constraint).** 14 implementation PRs forwarded under the bot in the 2026-04-23/04-24 batch (`#122`–`#135`) remained open as of 2026-05-08 with a median elapsed-since-original-branch of **13.9 days**. For a queue this deep, additive review-queue weeks are a more honest correction than multiplying per-design estimates.

**Recalibration applied:**

- S-sized estimates left at 1 day (slightly conservative; observed median 0.6 d).
- M-sized estimates bumped by ~20% (observed ratio 1.20).
- L-sized estimates bumped by ~50% (observed ratio 1.53; single sample, provisional).
- XL estimates left as-is for lack of data.
- Per-milestone totals lengthened by an additional 1–2 weeks of "review queue" carry.

### Estimation Methodology (2026-03-02 baseline)

Recalibrated 2026-03-02 using observed velocity from 15 active work days (Feb 15 – Mar 2) by one full-time developer.

1. **Velocity measurement** (git history on `llm` 2026-02-15 to 2026-03-02): active days 15/16; ~9 commits/active-day (138 commits / 15 days); ~500-2500 LOC/day depending on feature type; 14 completed designs in period.

2. **Per-feature reference points** (actuals, one developer): UI-heavy features (Chat) at 1300-2500 LOC/day; cross-cutting daemon features (forms, value messages) at 500-700 LOC/day; architectural refactors (256-bit identifiers) fast when well-defined.

3. **Key observation**: original Feb-24 estimates assumed 200-300 LOC/day; actual velocity is 2-3× higher. Original estimates significantly overstated duration.

4. **Recalibrated size categories**:

| Size | LOC Impact | Duration (1 dev) | Description |
|------|------------|-------------------|-------------|
| S | < 500 | 1 day | Localized changes, single subsystem |
| M | 500-1500 | 2-3 days | Multiple files, moderate complexity |
| L | 1500-3000 | 1-1.5 weeks | Architectural changes, new subsystems |
| XL | > 3000 | 2-3 weeks | Cross-cutting, platform-specific, or research-heavy |

Source: [designs/README.md](https://github.com/endojs/endo-but-for-bots/blob/510630411ebc26a6d9327928b4d71e5155802ea4/designs/README.md) at commit `51063041` on branch `llm`.
