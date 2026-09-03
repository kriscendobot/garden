---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T00:04:51Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendation 10 of `designs/cybernetics-audit.md` § 7 [wrong
sensor, low urgency]: alert when the deploy loop's sensor goes silent. A
garden self-improvement job (`skills/self-improvement/SKILL.md`).

Changes:
1. `upgrade-monitor.sh` currently exits 0 silently on fetch or resolve
   failure (audit § 2.7); its only backstop is the 3-day stalled-deploy
   alert. Count consecutive silent-skip ticks and raise ONE keyed alert past
   a threshold — use the `watchdog-notice.sh` keyed amend-while-unread
   discipline so the alert never duplicates.
2. Make the stalled-deploy window (currently 3 days) configurable per host
   class: a bot-only host that cannot host the human deploy actuator (the
   liaison session — audit § 4.5, the deliberate-deploy design) deserves a
   shorter fuse than 3 days.

Evidence: audit § 2.7 (silent detectors), § 4.5 (the human as deploy
actuator), and § 2.4: the weeks-long silent deploy blockage — the candidate
gate unpacking to noexec `/tmp`, failing rc=126 — presented as a code
regression until `3411c580d3` (2026-09-01). A counting, alerting monitor
would have surfaced the silence in days, not weeks.

Verify with `skills/local-verify/SKILL.md` + `skills/pre-push-gates/SKILL.md`;
land bare on `main2` per CLAUDE.md § Conventions.
