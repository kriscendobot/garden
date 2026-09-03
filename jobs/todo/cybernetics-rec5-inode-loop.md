---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-03T00:04:20Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendation 5 of `designs/cybernetics-audit.md` § 7 [missing
loop]: close the inode loop that already has both halves. A garden
self-improvement job (`skills/self-improvement/SKILL.md`).

The two halves, currently unwired (audit § 4.2): `root-repo-guard.sh`
invariant D measures free-inode percent (`df -Pi`, threshold 5%) and alerts;
`state-clone-keeper.sh` deletes leaked per-identity journal clones — but
sweeps at a fixed rate (hourly, at most 200) whether the filesystem is at 99%
or 1% free, and every failure branch keeps clones, including the
journal-unreachable branch (`state-clone-keeper.sh:104-111`), which is
precisely the symptom of the exhaustion it exists to prevent.

Changes:
1. `state-clone-keeper.sh` reads the same `df -Pi` free-inode measurement
   invariant D already computes; below the 5% threshold it TIGHTENS — a
   shorter idle floor WITHIN the existing four liveness guards (never bypass
   them), more ticks/higher sweep cap — and ALERTS if a full sweep cannot
   recover headroom.
2. Fix the silent `INODE-CHECK-UNKNOWN` branch: an unparseable `df` leaves
   alert state unchanged with only a log line (`root-repo-guard.sh:589-590`);
   alert after consecutive failures instead (audit § 2.7 — a silent detector
   is indistinguishable from a missing one).

Evidence: § 4.2; two near-zero-inode incidents (the journal-clone leak, see
memory/incident record) whose failure suppressed its own alarm.

Verify with `skills/local-verify/SKILL.md` + `skills/pre-push-gates/SKILL.md`
(the state-clone-keeper tests must pass); land bare on `main2` per CLAUDE.md
§ Conventions.
