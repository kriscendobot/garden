# Port the v1 capture skills into v2 (retarget journal2)

Per designs/self-healing-audit.md (Part A, role/skill gaps): two foundational
skills are still v1-only.

Port into v2 (skills/):
- v1/skills/prompt-on-failure-capture/SKILL.md — the capture-by-SHA playbook
  (capture -> known-SHA short-circuit -> four-slot brief -> claude -p -> apply).
- v1/skills/gardener-inbox-error-reporting/ (SKILL.md + report-error.sh) — the
  helper that hashes a transcript and appends only the SHA to the gardener
  inbox.
Retarget the `journal` branch references to `journal2` (v2 uses JOURNAL_BRANCH
=journal2 per scripts/jobs/common.sh). Keep report-error.sh shellcheck/`bash -n`
clean. Build in an isolated worktree off origin/main2.

---
claim:
  host: endolinbot
  gardener: 69
  claimed_at: 2026-06-24T20:00:07Z
