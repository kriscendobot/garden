---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`gh_api_retry`'s admission-refusal branch in scripts/jobs/common.sh (~line 5825-5831, inside `gh_api_retry`, right after `if ! _gh_api_admit "$need" "$label"; then`) returns `GARDEN_TRANSIENT_RC` (75) with empty stdout AND empty stderr whenever `_gh_api_admit` refuses admission quietly (the non-first suppressed caller, `emit=0`). Every caller that classifies gh_api_retry failures by grepping captured stderr (`is_gh_primary_rate_limit_text`, `_gh_api_stderr_is_transient` — used in scripts/jobs/handlers/mirror-pr-state-gh.sh and scripts/jobs/handlers/comment-source-gh.sh's note_fetch_failure) sees empty text and misclassifies the refusal as a definitive/structural failure instead of a quota/cooldown condition, causing a loud `die()`/FATAL. Observed signature: garden-mirror-closer tick where all unresolved mappings across multiple unrelated upstream repos fail simultaneously with "gh api graphql pullRequest state for X failed (no usable PR state for the closer)" and empty stderr preceding each FATAL. Fix: in the admission-refusal branch, before `return "${GARDEN_TRANSIENT_RC:-75}"`, always write a stable diagnostic line to stderr (e.g. `gh api $label admission refused: host-shared gh-api cooldown live (API rate limit already exceeded for user)`) regardless of `_gh_api_admit`'s `emit` flag — `emit` should continue to gate only the service's own `log()`-based WARN (to avoid repeat log spam), not the stderr text callers rely on for classification. This makes every existing caller's `is_gh_primary_rate_limit_text` check correctly recognize the cooldown refusal as quota-like, without changing any caller's code.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-04T20:56:24Z
