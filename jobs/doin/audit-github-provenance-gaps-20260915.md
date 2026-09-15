---
role: researcher
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-15T21:22:07Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Audit posted GitHub comments for missing/incomplete provenance

Depends on both prior children in this orchestration having landed (the fixed
mechanism + the field conventions this audit checks against).

Scope: our own posted comments/reviews on the garden's ACTIVE watched repos
(at minimum endojs/endo-but-for-bots; check config/fork-owners and the
watched-repo set in the journal for the full current list — do not expand
scope to repos outside what the garden already interacts with).

For each garden-authored comment/review found (author `kriscendobot` or the
fleet's current bot identity — resolve via bot-identity-defaults.tsv, don't
hardcode), classify:
- has a complete provenance footer (model+harness+provider, or explicit
  "automatic") -> fine, no action;
- has a footer missing one or more facts (like PR #1125's comment: garden sha
  present, model/harness absent) -> a gap;
- has no footer at all -> a gap (older comments predating the mechanism are
  expected here; note the mechanism's rollout date so you can distinguish
  "predates the feature" from "the feature existed and still failed to fire").

Produce a report (in your completion, and/or as a durable journal artifact if
the list is long) naming: repo, PR/issue, comment URL, what's missing, and —
where determinable from surrounding context (the comment's own content,
timing, which job/PR thread it's part of) — a best-effort guess at which
role/job path posted it, to help root-cause any NEW-mechanism gaps (i.e.
comments posted after prov-child1 landed that are STILL incomplete — those
are the ones that matter; pre-existing historical gaps are expected and lower
priority).

Do NOT attempt to retroactively edit other parties' or even our own
already-posted comments to add a missing footer in this job — editing
historical GitHub review record is a maintainer judgment call, not a
mechanical fix. Report the gaps; flag in your completion whether you think
retroactive editing is worth a maintainer decision, but do not do it
unprompted.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-15T21:22:14Z
