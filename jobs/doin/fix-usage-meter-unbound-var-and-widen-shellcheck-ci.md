---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
## Grounding incident
While filing a fix job on 2026-08-23, `scripts/jobs/post-job.sh` printed:

    scripts/jobs/usage-meter.sh: line 302: cutoff: unbound variable

a live `set -u` failure in the fleet budget-state read path (the WARN text
confirms it fell back fail-open: "fleet budget state unreadable; posting ...
to todo/"). This is exactly the class of bug `shellcheck` catches
(`SC2154`/unset-variable-under-`set -u` patterns) — but `usage-meter.sh` is
not in `.github/workflows/checks.yml`'s shellcheck file list, which is a
curated allowlist (daemons, watcher stub, checks gates, per-test scripts),
not the full `scripts/jobs/` tree. The workflow's own comment already
concedes the gap: "Pre-existing scripts outside this scope have known
issues; widening the lint surface is a separate effort."

Separately (already fixed directly, not part of this job): `checks.yml`'s
`on: push/pull_request: branches: [main]` pointed at the abandoned `main`
branch (last touched 2026-07-05, since diverged from `main2`) instead of
`main2`, the actual development branch — so shellcheck/bash-n/gate-tests
have not run on a real commit in weeks; only `pages-build-deployment` was
firing. That trigger fix landed separately; this job is the file-scope
widening plus the specific bug.

## Ask

1. **Fix the specific bug**: `scripts/jobs/usage-meter.sh:302` references
   `$cutoff` unset under some code path. Trace the call graph, fix the
   unbound reference (declare/default it, or guard the read), and add or
   extend a regression test if the file has one (check
   `scripts/jobs/test/` for a usage-meter test harness first).

2. **Widen `checks.yml`'s shellcheck step to mandatory, broad coverage.**
   The maintainer wants shellcheck genuinely in the mandatory pre-commit/CI
   testing, not a narrow allowlist that happens to exclude the very file
   that broke. Concretely:
   - Add `scripts/jobs/*.sh` (at minimum) to the shellcheck file list,
     ideally the same broad `find scripts skills -name '*.sh'` sweep the
     `bash -n` step already uses, so newly added scripts are covered by
     construction rather than requiring a per-file allowlist edit forever.
   - `shellcheck -S warning` across the full `scripts/jobs/` tree will
     likely surface real pre-existing warnings beyond the one bug above
     (the workflow comment already anticipates this) — triage and fix each
     one rather than silently loosening the severity or excluding files
     wholesale. Where a finding is a deliberate/false-positive pattern
     (e.g. an intentionally-unbound variable a caller is expected to set),
     use a scoped `# shellcheck disable=SCxxxx` with a one-line reason,
     not a file-level exclusion.
   - If the full sweep is too large for one pass, land it in the widest
     scope you can clear in this job and note remaining excluded paths
     explicitly in the workflow comment (mirroring the existing "known
     issues" note) rather than leaving the gap implicit.
   - Keep the check genuinely mandatory: it should fail the workflow (not
     just warn) on any finding at `-S warning` or above, matching the
     existing step's behavior.

3. Confirm the retargeted workflow (now triggering on `main2`) actually
   runs green on your PR-equivalent push and report the run URL.

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-23T16:43:17Z
