---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T00:04:28Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendation 7 of `designs/cybernetics-audit.md` § 7 [wrong
sensor]: validate job frontmatter at the write side. A garden
self-improvement job (`skills/self-improvement/SKILL.md`).

Changes:
1. `post-job.sh` and `post-plan.sh` WARN (or refuse, behind a flag) on a
   `tier:` outside `job_tier`'s vocabulary — `job_tier`
   (`common.sh:5743-5747`) recognizes exactly `mentat|mentor|minion|myrmidon`
   and returns rc 1 silently for anything else — and on a non-integer
   `handler-timeout:` (currently silently ignored; only
   `set-schedule.sh:75-83` validates the ceiling at write time — that is the
   write-side validation shape to copy).
2. `job_tier` itself logs ONE WARN on the silent rc-1 path.

Evidence: audit § 2.6 — the observed `tier: builder` mis-specification
silently cost the intended 7200 s handler budget (the budget derives from
`role:`, `job_handler_budget_base` `common.sh:6230-6247`, defaulting to
2400 s), the job overran the 2400 s wall, and the reaper's overrun doom was
correct on its own terms while the actual defect was upstream at admission.
The class: frontmatter is an interface with a closed vocabulary on the read
side and no validation on the write side.

Keep it write-side and warning-first: do not change read-side semantics or
budgets, and do not break existing producers whose bodies carry no tier at
all (empty stays valid).

Verify with `skills/local-verify/SKILL.md` + `skills/pre-push-gates/SKILL.md`
(post-job/post-plan tests must pass); land bare on `main2` per CLAUDE.md
§ Conventions.


<!-- garden-reaped: 1 -->

<!-- garden-transient-elapsed: kind=signature through=1 values=2,2 -->
<!-- garden-elapsed-constancy: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T20:02:22Z
