---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-22T09:07:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Child 3 of 3 in the `openrouter-zdr-and-stealth-orchestration` orchestration.
Runs after `openrouter-stealth-lane` lands (needs the real `openrouter-promo`
kind/arm shape to migrate from). Splits out Decision 2b from the doomed
monolithic job `openrouter-zdr-policy-and-stealth-lane` (deadline-overrun
after 40 min handler wall-clock; that record is superseded by this
decomposition, do not resurrect it). Builds on `design-openrouter-provider`
(`designs/openrouter-provider.md`, commit `9790c4f4db`) and whatever
`openrouter-stealth-lane` built.

## The maintainer's decision (net-new — not in the original design)

When a stealth id's identity is later revealed (OpenRouter publishes what it
was, or the maintainer otherwise learns it), the garden should be able to
**carry the accumulated reputation forward** onto the now-named model's
arm(s) rather than discarding it and starting that model at zero history.
Design and build a maintainer-triggered (never automatic — an unmask is an
external fact only a human confirms) reputation-arm migration:

- Read `reputation.sh` / the reducer (`reputation-reduce.sh`, described
  elsewhere as the sole writer of arm projections) before proposing a
  mechanism — the migration must go through whatever the reducer considers
  its single source of truth, not hand-edit a projection file.
- Shape: an operator script, `rerecord-reputation-arm.sh <old-arm-key>
  <new-arm-key> --authorized-by <maintainer>` (or fold into an existing
  attested-op pattern if one already fits better — the sysop's
  `authorized_by:` attestation gate on destructive ops is the precedent to
  follow for who may trigger this and how it's recorded) that relabels the
  stealth arm's history onto the real model's arm, idempotently, with a
  journal record of the migration (what was renamed, when, by whom) so it's
  auditable and never silently double-applied.
- If a full merge (combining history if the target arm already has some) is
  materially harder than a clean rename (target arm didn't exist before),
  it's fine to build the rename case now and leave merge-on-collision as an
  explicit open question rather than guessing at reducer semantics you
  haven't verified.

## Out of scope for this job

Actually supplying `OPENROUTER_API_KEY` or enabling any worker — both pools
stay at zero. Container recreation with the key is a separate, host-side,
maintainer-run step the liaison is handling directly.

## Precedents to read first

- `designs/openrouter-provider.md`, `context/operations/openrouter.md`, and
  whatever `openrouter-zdr-data-policy` and `openrouter-stealth-lane` landed
  (read their commits/reports first).
- `jobs/plan/openrouter-zdr-policy-and-stealth-lane.md` (the doomed
  original, for full context — but only Decision 2b is this job's scope).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-22T09:07:09Z
