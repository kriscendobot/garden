---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T00:04:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendation 4 of `designs/cybernetics-audit.md` § 7 [missing
loop, already designed]: arm the ironhorse fuzz lane's designed backpressure
BEFORE it is ever un-paused. This is the biggest, riskiest child of the
cybernetics-audit remediation — treat it with care and follow the existing
design exactly: `designs/ironhorse-fuzz-triage-and-batch.md` (Proposed,
2026-08-31). Implement THAT design, not a fresh redesign.

What the design specifies (verify against the design itself, which is
authoritative): a triage stage between capture and release; doom-signature
feedback from the reaper to the producer (a policy-refusal cluster stops
release — N consecutive same-signature dooms from one target is a
producer-side stop signal regardless of queue depth); the hysteretic band
(high water 24 total or 8 per target stops fuzzing; resume below 12 and 4 —
the only hysteretic band in the repo); and the journal CAS op that migrates
the ~77 quarantined `jobs/plan/ironhorse-fuzz-*-repair` jobs per the design.

Evidence: audit § 3.2 — `repair_is_live` counts `plan/` as live
(`ironhorse-fuzz.sh:363-369`), so serialization held and the board never
flooded; what was missing is triage between capture and release and any
reader for the reaper's doom classification (`doom_signature:
policy-refusal` written 60+ times, zero readers). 73 quarantined at pause,
77 in `plan/` on 2026-09-01.

Hard constraints:
- The lane STAYS PAUSED until the triage stage actually lands:
  `garden-ironhorse-fuzz.{timer,service}` are in `EXCLUDED_UNITS`
  (`scripts/jobs/install-units.sh`, re-verified 2026-09-02). Do NOT re-arm
  the lane in this job — re-arming is a deliberate two-part maintainer act
  per the comment above EXCLUDED_UNITS (delete the entry AND enable the
  timer). Your deliverable is the machinery, verified paused.
- The audit's "Not recommended, deliberately" list forbids any new
  autonomous promoter for doomed work: the reaper's park-and-human-promote
  is correct. The migration op is the design's CAS op over board files, not
  a promoter. Also note § 4.4: `promote-plan.sh` deliberately strips doom
  provenance on promotion — do not build anything that depends on parked
  doom counters surviving promotion.
- The plan/ migration mutates ~77 board files on `journal2` — use the
  design's CAS shape, batch sanely, and never touch the deployed root's
  journal worktree directly (use the scripts' own clone/CAS path).

Verify with `skills/local-verify/SKILL.md` + `skills/pre-push-gates/SKILL.md`;
land bare on `main2` per CLAUDE.md § Conventions unless a genuine open
maintainer question surfaces (then the design-with-open-questions PR
carve-out).

<!-- garden-transient-elapsed: kind=signature through=0 values=1126 -->

<!-- garden-reaped: 1 -->
