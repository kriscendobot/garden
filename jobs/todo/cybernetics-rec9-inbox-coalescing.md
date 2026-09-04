---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T00:04:46Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendation 9 of `designs/cybernetics-audit.md` § 7 [missing
loop]: extend the proven coalescing discipline to the raw maintainer-inbox
path. A garden self-improvement job (`skills/self-improvement/SKILL.md`).

Change: require or default STABLE message ids for the autonomous callers of
`inbox-send.sh` — today it mints a random message id unless the caller
supplies one (`inbox-send.sh:99-102`), so every call is a new file. The
callers with no dedup of their own: `orchestrate.sh:426`, `gauntlet.sh:188`,
the follow-up liaison handler, and `message-user.sh` (every gardener's
channel — give it a per-job episode key). Repeats then AMEND instead of
accumulate, reusing `watchdog-notice.sh`'s amend-while-unread mechanics
(keyed amend-or-post, occurrence counting, the 1 h per-key delivery
throttle — the discipline born from the 2026-07-28 incidents' 94 and 37
duplicate messages).

Boundaries:
- Messages must NOT be dropped — the correct backpressure here is
  per-sender, per-episode coalescing, never discard (audit § 3.3).
- This deliberately does NOT solve inbox inflow being proportional to fleet
  activity — that is the telemetry ladder's digest/priority rung, separately
  decided (audit "Not recommended, deliberately": the telemetry layer is not
  a prerequisite). Do not build a digest here.
- Distinct human-authored messages with the same sender must still get
  distinct ids — key on (sender, episode), not sender alone.

Evidence: audit § 3.3 — roughly 100 messages per 9 undrained hours, a full
muster shrank the backlog by one; the two disciplined write paths
(`watchdog-notice.sh`, `doom-notice.sh`) are already correct and
incident-proven (§ 6); the raw path is what bypasses them.

Verify with `skills/local-verify/SKILL.md` + `skills/pre-push-gates/SKILL.md`
(message-bus tests must pass); land bare on `main2` per CLAUDE.md
§ Conventions.



<!-- garden-transient-elapsed: kind=signature through=1 values=2,3 -->

<!-- garden-reaped: 2 -->
