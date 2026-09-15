---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-15T21:07:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Per-section provenance footnotes for aggregated multi-agent reports

Depends on the field/rendering conventions landed by
`fix-comment-provenance-provider-and-automatic-mark` (provider fact,
"automatic" marker) — read that job's tada report first and reuse its
conventions rather than inventing new ones.

`comment-provenance.sh` appends exactly ONE footer to the end of a whole `gh`
comment body. That is correct for a single-author comment, but wrong for an
AGGREGATED report stitched together from multiple agents/automations — e.g.:

- a **panel review** comment (`skills/panel-review/SKILL.md`,
  `scripts/jobs/gardening/panel.sh`): one seat block per juror, each seat run
  as its own `claude -p` invocation, potentially at a different model/tier
  than its peers or the supervising gardener;
- a **PR completion summary** comment (`skills/pr-completion-summary-comment/
  SKILL.md`): sections contributed by different roles/jobs over a PR's
  lifetime.

A single whole-body footer misattributes every section but one. Add a
PER-SECTION footnote: after each seat's/section's block, in the same visual
style as the existing whole-body footer (`<sub>...</sub>`, reuse
`provenance_line`'s rendering — refactor it to accept explicit
model/harness/provider values rather than only reading them from the current
process's env, since a caller composing a multi-section body knows each
section's own facts, which may differ from the composing process's own).

Concretely:
- `panel.sh` / the panel-review skill: as each seat's `claude -p` block is
  assembled into the aggregate body, capture that seat's actual resolved
  model/harness/provider (or automatic, if a seat ever runs deterministically
  — unlikely today, but handle it) and append a footnote to that section
  before concatenating.
- `pr-completion-summary-comment`: same shape — each contributing
  section/job's facts, footnoted at that section, not just the final
  composer's.
- The whole-body footer from `comment-provenance.sh`'s `gh` wrapper
  interception can stay too (or be dropped in favor of a closing "assembled
  by garden <sha>" line) — your call, but don't leave a reader unable to
  tell, section by section, which model/harness/provider (or automatic)
  produced it.

Keep existing tests green (`comment-provenance-test.sh`, plus panel/
completion-summary tests if present) and add coverage for the per-section
case: an aggregated body with 2+ sections from different (mocked) model/
harness values renders 2+ distinct footnotes, not one.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-15T21:07:14Z
