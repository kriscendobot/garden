---
role: builder
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-13T22:01:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: the garden journal branch `journal2` (read source from endojs/endo-but-for-bots `llm`)

Migrate the `PLAN/`, `TODO/`, and `TADA/` document trees off the
endojs/endo-but-for-bots `llm` branch and into the garden journal. This stage
COPIES IN. A sibling stage deletes from the branch afterward; do not delete
anything here.


## Relationship to the date-sharding chain (advisory, NOT blocking)

An earlier attempt at this stage carried a precondition that
`garden-tada-shard-orchestration` must finish first. That was a scoping error and
has been removed: this stage is forbidden from writing under `jobs/` at all, and
that chain only ever touches `jobs/tada/`. The two do not overlap, so there is
nothing to wait for. Both write to `journal2`, so ordinary push races may occur;
re-sync and retry as usual.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-13T22:01:12Z
