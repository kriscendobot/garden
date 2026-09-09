---
created: 2026-09-08
updated: 2026-09-09
author: gardener
---

# Bounded qwen3.6 mentor-tier trial

## Decision

Admit local `qwen3.6` to at most **six distinct, curated mentor-shaped jobs** through
explicit canary pins. Do not change its reviewed `local / qwen3.6 / minion` row in
`model-tier-inventory.tsv`, and do not make it eligible for ordinary mentor-tier
auctions. Six jobs are enough to expose repeated failure while limiting substantive
work, maintainer review, and the capable-reference probe to a small batch. The sibling
receipt/cost work landed while this trial was being built. Its
[`pr-completion-receipts.md`](pr-completion-receipts.md) records the existing finding
that human review dominates machine cost by roughly 50–190× at the median, and its
three-PR validation estimates $20–$68 of maintainer attention against sub-$5 machine
cost. That evidence supports the conservative cap and serial cadence: cheap inference
does not make a failed or review-heavy mentor attempt cheap overall.

This follows the OpenRouter promo lane's safety shape without copying its rotating-model
inventory: explicit admission only, a separate reputation namespace, deterministic
read-side gates, a fixed cap, and a rip-cord. Qwen's identity is stable and remains in
the closed inventory, so it needs numbered experiment permits rather than a second
model inventory.

## Admission

An authorized curator posts each real job with:

```sh
scripts/jobs/post-job.sh --qwen-mentor-trial <slot-1-through-6> \
  --role <role> <base> <body-file>
```

The producer stamps `trial: qwen3.6-mentor-v1`, `trial-tier: mentor`, the numbered
`trial-slot`, `provider: local`, `model: qwen3.6`, and `dispatch: canary`. The body should describe real
mentor-difficulty work: a substantive build or fix, infrastructure change, or
panel-adjacent analysis with an independently judgeable outcome. The curator, not the
router, decides that the work is mentor-shaped.

Claim-time admission requires the exact marker, model, canary dispatch, mentor-shaped
label, and slot 1–6. Exactly one lifecycle record may use each slot; a duplicate fails
closed even after the original reaches `tada/`. Completion and verified-demerit events
retain the slot as a durable consumed permit, so a verified failure cannot re-enter on a
reaper retry. Only one trial job may be in `doin/` at a time; the board CAS makes that a
fleet-wide serial gate even when several hermits are running. Any worker kind except `hermit` leaves
the job. Conversely, a malformed or foreign trial marker is not treated as ordinary
work. Ordinary `tier: mentor` jobs remain unavailable because the inventory still has
no local mentor model. This is an experiment lane, not a classification escape hatch.

## Measurement and arm isolation

The existing `hermit-capability-probe.sh` remains the signal. The ordinary gardener
failure classifier invokes it only after a real deterministic local failure, after
excluding signal kills, timeouts, environmental/offline failures, transient provider
failures, and policy refusals. Its existing `GARDEN_HERMIT_PROBE=0` kill switch,
fleet-budget brake, bounded reference run, measurement-only worktree, and once-per-base
probe record apply unchanged to trial jobs.

Trial completion and demerit events use the synthetic reputation kind
`hermit-mentor-trial`, with provider `local` and model `qwen3.6`. Ordinary minion work
continues to use `hermit/local/qwen3.6`. Since kind is part of the arm key, neither
population can pool with the other, while claims and execution still truthfully record
the actual `hermit` worker kind.

## Stop and review

Admission stops before the next claim when either:

- two verified demerits exist; or
- at least three attributable outcomes exist and verified demerits are at least 25%.

The fixed six slots are the hard stop even with zero demerits. In-flight work is never
cancelled. Operators inspect the ledger with
`scripts/jobs/qwen-mentor-trial-status.sh`. `GARDEN_HERMIT_PROBE=0` and scaling hermits
to zero are immediate rip-cords; disabling the probe also removes the trial's intended
signal, so no further trial jobs should be admitted while it is off.

At the stop or six-job cap, a maintainer explicitly chooses one of three outcomes:

1. keep `qwen3.6` at minion and retire the trial;
2. authorize a new, separately bounded experiment after reviewing cost and failure
   classes; or
3. promote it through a reviewed `model-tier-inventory.tsv` change whose justification
   cites the `hermit-mentor-trial` arm data.

There is no automatic promotion and no unattended continuation. A reference probe is
spent only on a real deterministic failure, but each admitted job consumes local compute
and potentially maintainer review, so unused slots are not a target to fill blindly.
