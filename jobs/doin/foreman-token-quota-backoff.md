# Foreman: deterministically check the weekly token quota and back off near the limit

Map: **build** (garden infra) on the garden's own repo, branch main2. Build in an
ISOLATED worktree off origin/main2 (the shared /home/kris tree is concurrently
mutated); commit explicit pathspecs (`git commit -- <paths>`), push HEAD:main2.

Goal (maintainer directive 2026-06-27): the foreman is where the garden spends
tokens autonomously — it auto-promotes deferred plan jobs and generates new
milestone steps via `claude -p`, each of which can ignite a full design/build/
panel chain. Before that pump, the foreman must DETERMINISTICALLY (plain code, no
LLM) check the garden's weekly token quota and BACK OFF (pump nothing this tick,
stay silent or emit one throttled maintainer note) when the garden is at risk of
hitting the quota.

State of play: there is currently NO token-quota/usage tracking anywhere in
scripts/ or designs/ (grep for quota/token-budget/usage finds none). So this job
must FIRST establish a deterministic usage signal, then gate the foreman on it.

Scope:
1. Establish a deterministic weekly-usage measurement and a configurable ceiling
   (e.g. GARDEN_TOKEN_WEEKLY_QUOTA + a GARDEN_TOKEN_BACKOFF_FRACTION high-water
   mark, default ~0.85). Pick the most reliable usage source available in this
   environment (e.g. a host-local rolling counter the claude handlers append to,
   or an existing usage/cost report if one exists) and document the choice. The
   week boundary should align with the maintainer's actual quota reset cadence —
   surface as an open question if unknown; default to a rolling 7-day window.
2. In foreman.sh, BEFORE the deferred-plan auto-promote AND before the `claude -p`
   step-generation (both pump paths), consult the usage signal; if spend is at or
   past the high-water mark, skip the pump for this tick. Back-off must be silent
   except for a single throttled maintainer note (note_once-style) so the pause is
   visible but not spammy. A missing/unreadable usage signal must FAIL OPEN with a
   logged warning (never wedge the pump on a broken meter) OR fail closed — pick
   and justify; lean fail-open-with-warning so a meter bug can't freeze the fleet.
3. Tests: extend scripts/jobs/test/run-test.sh foreman subtest — under-quota pumps
   as today; at/over-quota promotes nothing and runs no handler; the back-off note
   is throttled; a missing meter degrades per the chosen policy.

Keep it deterministic and cheap (runs every foreman tick). Document the new env
knobs where the other GARDEN_FOREMAN_* defaults are declared.

---
claim:
  host: endolinbot
  gardener: 12
  claimed_at: 2026-06-27T05:08:42Z
