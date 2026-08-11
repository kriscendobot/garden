---
gate: orchestrated
orchestrated_by: telemetry-minion-town-orchestration
priority: normal
role: designer
posted_by: producer
posted_at: 2026-08-11T18:30:01Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: kriscendobot/minion.town (branch: main)
role: designer

Follow this repo's OWN design conventions (`# Design: <title>`, bold
Status/Mandate/Grounded against/Companion header block, numbered sections,
mermaid diagrams). Design docs land as a **pull request against `main`**
(journal `projects/minion-town/README.md` § Rules of engagement).

This job runs AFTER (blocked on) two sibling jobs in the same orchestration:
`telemetry-minion-town-surfacing-design` (garden repo, `main2`) and
`minion-town-git-content-substrate-design` (this repo). Read both landed
documents first — this design is grounded on both, cite them as Companions.

## Task

Design the concrete first weblet built on the git-content substrate from
`minion-town-git-content-substrate-design`: a **vitals/telemetry weblet**
that surfaces the garden fleet's operational health, reading directly off
the garden repo's public `journal2` branch:

- `vitals/fleet.json` (once the garden's `fleet-telemetry-and-anomaly-response`
  design — as amended by `telemetry-minion-town-surfacing-design` — is
  actually built; note the dependency plainly if it isn't built yet at
  design time) — the nine vitals, host-liveness strip, open-incidents list.
- `usage/*.jsonl` and `reputation/` for on-demand cost/yield views, mirroring
  what `scripts/jobs/cost.sh` / `reputation.sh` already answer on the garden
  side.

Render the same status/trend view the garden's own bulletin panel would show
(status row, sparklines, host-liveness strip, open incidents) — this weblet
is a **frontend on the same data**, not a new data source or a redesign of
what's measured.

## Explicit non-goal

This is **not** the full bulletin migration. The maintainer separately wants
the garden's entire existing GitHub-Pages bulletin (board state, maintainer
dashboard, everything — not just Vitals) eventually moved to minion.town "in
due course." Record that as a stated future direction this weblet's design
should not foreclose, but do not design or scope it here — this job is
Vitals only, deliberately the first, smallest real exercise of the new git
substrate.

## Carry over unchanged: the garden design's privacy posture

`journal2` is public and so is minion.town's web surface — same threat model
as the GitHub Pages bulletin, so carry these constraints from
`fleet-telemetry-and-anomaly-response.md` § Storage/retention/privacy
verbatim into this weblet's rendering, don't re-derive or relax them:

- No dollars in absolute — indices/ratios only (spend-per-landed vs a rolling
  baseline), never raw `total_cost_usd`.
- No account identity, provider account, email, or credentials, ever.
- Host identity stays the opaque `<hostname>-…-hash8` GARDEN id or coarser;
  anything finer is a SHA-256 digest, pseudonymity limitation stated.

## Deliverable

A design PR against `main` on `kriscendobot/minion.town`. If either
prerequisite document leaves an open question that blocks a concrete answer
here, say so explicitly in this design's own "Open questions" rather than
guessing past it.
