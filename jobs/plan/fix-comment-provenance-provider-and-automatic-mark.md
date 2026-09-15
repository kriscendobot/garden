---
gate: orchestrated
orchestrated_by: github-post-provenance-audit-20260915
priority: normal
role: fixer
posted_by: producer
posted_at: 2026-09-15T20:49:53Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix comment-provenance.sh: add `provider`, make "automatic" explicit

Triggered by a maintainer-flagged gap: https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4009312397
posted with a provenance footer naming only the garden commit — no model, no
harness — because GARDEN_JOB_MODEL/GARDEN_WORKER_KIND were unresolved in
whatever code path posted it (an instrumentation gap, not a config choice).

`scripts/jobs/comment-provenance.sh` is the shared footer mechanism (sourced by
the fleet's `gh` wrapper, `scripts/jobs/bin/gh` — see its own header comment
for the full design). Two changes:

## 1. Add an explicit `provider` fact, distinct from `harness`

Today the footer renders `model` + `harness` + `garden` (commit sha). `harness`
alone does not disambiguate provider: the `codex` harness alone fronts
openai/fireworks/openrouter/local depending on worker kind (cleric, hermit,
fireworker, openrouter/openrouter-promo all render harness=`codex` but are
different providers). Add a third fact, `provider`, sourced the same way
`common.sh`'s `worker_kind_field`/provider taxonomy already classifies each
worker kind (monk/friar->anthropic, cleric->openai, hermit->local,
fireworker->fireworks, openrouter/openrouter-promo->openrouter,
mystic->moonshot, opencode-anthropic->anthropic-via-opencode or similar —
follow the existing provider taxonomy in common.sh/rate-card docs, don't
invent a new one). Render as `provider <code>...</code>` alongside model/
harness in `provenance_line`.

## 2. Distinguish "automatic" (no LLM in the loop) from an unresolved-fact bug

Today, when GARDEN_JOB_MODEL/GARDEN_WORKER_KIND are unset, the field is
silently OMITTED (fail-open) — this is indistinguishable from "no LLM
produced this text" (e.g. a deterministic watcher/reactji/sysop-authored
comment) and "an LLM produced this but the caller forgot to export the
facts" (a real bug — what happened on PR #1125). These need different
handling:

- Add an explicit signal a DETERMINISTIC (no-LLM) caller sets deliberately —
  e.g. `GARDEN_NO_LLM=1` — read by comment-provenance.sh. When set, render
  `model <code>automatic</code>` (harness/provider omitted or also
  `automatic`, your call — keep it simple and legible) instead of the
  model/harness/provider facts. Audit the fleet's existing no-LLM `gh`
  callers (comment-watcher acks, ci-watcher, dependabot-watcher, sysop acks,
  reactji-acknowledgment, the bulletin, any script posting via `gh` with no
  `claude -p`/`codex`/`kimi` in its own process) and have each of them set
  this flag before their `gh` call.
- When NOT marked automatic and model/harness/provider still fail to
  resolve, that is now a detectable INSTRUMENTATION GAP, not a quiet
  degrade. Keep the fail-open POSTING behavior (never block a comment on
  missing provenance — designs/... already establishes this invariant,
  preserve it), but also surface the gap somewhere durable (e.g. a
  maintainer alert similar to the existing `missing-tools-<host>` pattern in
  common.sh, keyed so it doesn't spam) so silent gaps get found and fixed
  going forward instead of accumulating unnoticed like PR #1125's comment.

Keep `scripts/jobs/test/comment-provenance-test.sh` green, and extend it to
cover: provider field rendering, the automatic-marker path, and the new
gap-alert path. This file is the fleet's single `gh` PATH chokepoint — treat
it with the care its own header comment describes (every fleet `gh` call
passes through it; a bug here can break commenting fleet-wide). Verify with a
real (non-mocked) `gh api` dry-run path if the test harness supports one, not
just unit-level argv-rewrite assertions.

Do NOT attempt to retroactively edit already-posted GitHub comments in this
job — that is scoped separately (see the audit child of this orchestration).
