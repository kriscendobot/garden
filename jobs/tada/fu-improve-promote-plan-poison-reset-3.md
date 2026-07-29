Landed on `main2` as `1fbce7bfe3`.

## What I did

`promote-plan.sh` already cleared the reaper/gardener cycle markers on the way **out** of `plan/`; `post-plan.sh` still passed bodies through verbatim on the way **in**. A producer that re-parks a body it read off the board therefore smuggled a stale `<!-- garden-deadline-overrun: N -->` into `plan/`, and at `GARDEN_REAP_OVERRUN_THRESHOLD=1` that counter re-poisons the job on its *first* evaluation after promotion — the same inescapable-promotion failure the promote half was written for, entering through the other door.

## What changed

- **`scripts/jobs/common.sh`** — hoisted the strip out of `promote-plan.sh` into shared helpers beside the marker regexes they match: `CYCLE_MARKER_RE`, `strip_cycle_markers` (stdin→stdout), `cycle_marker_summary <file>`. One spelling of the family, so a marker-format change (or a sixth marker) can't half-land.
- **`scripts/jobs/post-plan.sh`** — strips the family from the body before composing the plan file, and records what it cleared in a `cleared:` frontmatter field emitted **only** when something actually was, so an ordinary post's frontmatter is byte-for-byte unchanged. Idempotent by construction (marker-free body passes through identical); drops only whole cycle-marker lines, so a body's own `---` rules and non-cycle HTML comments survive.
- **`scripts/jobs/promote-plan.sh`** — now calls the common helpers instead of its local copies; header notes the parking half.
- **`scripts/jobs/test/promote-plan-poison-reset-test.sh`** — SUBTEST 3 (park-time strip, `cleared:` provenance, no stray field on a clean post, rules/comments preserved, idempotence) and SUBTEST 4 (end-to-end: re-park via `post-plan` → promote → **requeues** instead of re-poisoning).
- **`skills/job-board/SKILL.md`** — documents the parking half and cross-links the two.

## Verification

`promote-plan-poison-reset-test.sh` 20/20. No regressions in `run-test.sh` (367/367), `productive-cycle-test` (10/10), `outage-poison-pause-test` (10/10), `annotate-plan-test` (45/45), `orchestrate-test` (18/18), `producer-arg-guard-test` (13/13), `stale-lock-test` (9/9). `bash -n` + shellcheck clean (only the pre-existing `GARDEN_TAG` SC2034).

## Follow-ups (not in scope, same defect family)

1. **`scripts/jobs/proxy.sh` § `park_blocked_jobs`** writes `plan/<base>.md` *directly* (not via `post-plan.sh`) from the live `doin/`/`todo/` file, so it still carries cycle markers into `plan/` — **and** it carries the trailing `---\nclaim:` block into the parked body, which `promote-plan.sh`'s `strip_frontmatter` does not remove. Worth a follow-up job: route it through the same `strip_cycle_markers` and a `clean_body`-style claim-block cut.
2. **`scripts/jobs/annotate-plan.sh`** appends producer-supplied note text to a parked plan verbatim; a producer that pipes a job body as a note could reintroduce a marker. Low likelihood, one-line fix if wanted.

The reaper's own poison-park deliberately keeps markers in the parked body (its `requeue_cycles`/`deadline_overruns` frontmatter is the audit record, and `promote-plan.sh` clears the body on release) — I left that path untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-improve-promote-plan-poison-reset-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 101 tokens (4402630 cached reads)
- Output: 27527 tokens
- Cost: $3.8377280000000003
- Wall-clock: 493s

<!-- garden-usage-end -->
