---
role: gardener
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: https://github.com/kriscendobot/garden. Land on main2 (no PR — CLAUDE.md
§ Conventions). Follow [rename-discipline](skills/rename-discipline/SKILL.md).

# Rename the "poison" job-state vocabulary to "doomed", holistically

**Maintainer directive (kriskowal, 2026-08-04):** "poisoned" is the wrong word for
this state. Replace it with **`doomed`** throughout the garden.

The term was chosen deliberately over the alternatives. `doomed` states what the
reaper actually detects — *this job will fail identically on every requeue*, i.e.
deterministic future failure — rather than bad luck (`ill-fated`) or mere stuckness.
**Do NOT use `wedged`**: the garden already uses it for a different thing (the
wedged auto-gc; "a stale producer lock wedges posts"), and reusing it would make
both grep and prose ambiguous.

## Migration posture — DUAL-READ, migrate live state, leave history

Also maintainer-directed. Three distinct surfaces, three different treatments:

1. **Code + docs — rename fully.** ~72 files across `scripts/`, `roles/`, `skills/`,
   `designs/`, `context/`, `CLAUDE.md`; ~360 occurrences.
2. **Live job state — migrate.** As of 2026-08-04, **38 jobs parked in `jobs/plan/`**
   carry `poisoned: true` and friends. Rewrite them to the new field names in one
   batched journal commit.
3. **History — DO NOT rewrite.** ~211 journal paths contain "poison" (completed
   `tada/` reports, past maintainer notices, entries). The ledger should stay honest
   about what it said at the time. Leave them.

**Dual-read is load-bearing and must land BEFORE anything else.** Peer hosts deploy
independently (`endolin-garden-ece02cb4` is currently ~27 commits ahead of
`endolin-garden2-5bcdff64`'s deployed root), so for a window there WILL be hosts
running old code against new state and vice versa. Every reader must accept BOTH
spellings; only writers switch to the new one. Sequence it:

    a. teach every reader both spellings (old still authoritative for reads)
    b. switch writers to the new spelling
    c. migrate the 38 live parked jobs
    d. leave the compatibility shim in place; note in the design/doc when it may be
       dropped (suggest: after every host's deployed sha includes step (a))

A hard cutover would orphan any job a peer claimed under the old code — the reaper
would stop recognizing it as doomed and could re-run a job known to fail identically.

## The exact surface

Frontmatter fields (all appear in real parked jobs today):

    poisoned:          -> doomed:
    poison_signature:  -> doom_signature:
    poison_count:      -> doom_count:
    poisoned_at:       -> doomed_at:
    poisoned_on:       -> doomed_on:
    poison_base:       -> doom_base:
    poison:            -> doom:            (check each use; some are prose)

Env knobs — **operator-facing, so this changes a documented contract**:

    GARDEN_REAP_POISON_THRESHOLD -> GARDEN_REAP_DOOM_THRESHOLD
    GARDEN_POISON_SPOOL          -> GARDEN_DOOM_SPOOL

Honor the OLD knob names as deprecated aliases if set, so an operator's existing
env/unit override does not silently stop working. Log once when an alias is used.

Maintainer-notice filenames: `poison-<base>-<signature>.md` -> `doomed-<base>-<signature>.md`.
Do not rename existing notices already on the journal; new ones use the new pattern.

Script named for the concept: `scripts/jobs/poison-notice.sh` -> `doom-notice.sh`
(keep a thin forwarding shim only if something outside this repo could call it;
otherwise rename outright and fix callers).

The read/write core is: `scripts/jobs/reaper.sh`, `scripts/jobs/poison-notice.sh`,
`scripts/jobs/orchestrate.sh`, plus these tests, which must be renamed and updated
rather than deleted:
`test/{outage-poison-pause,proxy-park-body-hygiene,promote-plan-poison-reset,productive-cycle,orchestrate,reaper-poison-park,run,timeout-classifier}-test.sh`.

## Also fix the wording the rename exposes

While you are in the reaper's notice text: the current message asserts
"Its handler hit its OWN wall-clock budget every cycle (rc=124,
elapsed≈GARDEN_HANDLER_TIMEOUT=2400s)" **as fixed boilerplate**, and it is often
FALSE. Verified 2026-08-01/02: jobs that died in 1–2s to a Claude usage-cap
rejection were parked with signature `deadline-overrun` because the
elapsed-constancy early-escalation stamps the overrun counter on constant-elapsed
cycles. The notice then prints the literal 2400s default even for jobs declaring
`handler-timeout: 7200`, and its triage advice ("split the job, raise
GARDEN_HANDLER_TIMEOUT") is actively wrong for a cap casualty.

Make the notice state the ACTUAL elapsed time and the ACTUAL budget in force, and
distinguish a genuine wall-clock overrun from a fast repeated failure. This is a
separate defect from the rename — if it is larger than a wording fix, say so in your
report and leave it, rather than silently expanding scope.

## Verify

`bash -n` on every edited script; run the renamed tests; grep that no `poison`
token remains under `scripts/ roles/ skills/ designs/ context/ CLAUDE.md` EXCEPT
deliberate compatibility shims and any quoted historical text; confirm the 38
migrated parked jobs still read as doomed to `promote-plan.sh` (its marker-clearing
path must clear the new names).

## Report

Name the landed main2 revision, the count of files changed, the count of parked jobs
migrated, and state explicitly which compatibility shims you left and what condition
retires them.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-04T05:30:25Z
