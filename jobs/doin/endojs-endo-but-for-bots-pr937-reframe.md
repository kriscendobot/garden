---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
role: weaver

# Reframe PR #937 to its actual remaining scope

`https://github.com/endojs/endo-but-for-bots/pull/937` was rebased onto a
fresh `llm-0c3598a` snapshot after `#903` merged. That rebase found `#903`
already landed a refined superset of nearly all of `#937`'s substance — 9 of
its 10 commits went empty. The one surviving commit is a small `bundle:xs`
npm-script consolidation (net +2/-3 across `package.json` + `ci.yml`),
already verified building clean on the new base.

**Maintainer decision: keep the PR open, small, reframed to that remaining
scope — do not close it as superseded.**

## Task

- Retitle the PR to accurately describe the actual diff (something like
  `chore: consolidate bundle:xs npm script`, not the original
  "restore XS bundle generation on llm" framing — that goal is already met
  on `llm` via #903).
- Rewrite the PR body/description to match: state plainly that this PR
  originally proposed restoring XS bundle generation, that #903 landed a
  superseding implementation first, and that the remaining diff is the small
  `bundle:xs` script consolidation — link to #903 for context.
- Do not change the code itself (it's already verified building on the new
  base per the rebase job's report) — this is a title/description edit to
  match reality, not a new implementation pass.
- Do not merge or request review — reframing is the deliverable.

## Report

Confirm the new title/body, and that CI/mergeability are unaffected by the
metadata-only change.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-13T16:17:51Z
