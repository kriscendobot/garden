---
role: designer
tier: mentor
posted_at: 2026-11-04T22:15:15Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-04T22:19:16Z cleared=none -->

---
role: designer
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: designer.** **Design a `mechanic` role: the standing playbook for diagnosing and repairing garden hosts** (maintainer request, kriskowal, 2026-11-04: "construct a 'mechanic' role for fixing hosts like oros. We have some experience we could collect."). Project: the garden itself; the design lands as `designs/mechanic-role.md` on `main2`, direct (garden convention), unless it carries a non-empty `## Open questions` section, in which case follow the CLAUDE.md review-PR carve-out. A builder job follows this one automatically (orchestration), so make the design buildable as written.

**Scope:** general host repair (oros-style followers first; the leader and any new host are in scope where the playbook transfers). The mechanic repairs a HOST; it does not repair a PR, a repo, or the job board.

**Collect the experience first (cite it; do not invent):**
- `journal/jobs/tada/**` for `oros-health-checkup-*` (recurring since 2026-10-12) and `oros-health-watch-*`, plus `fix-oros-heartbeat-canary-drain-20261001`, `fix-oros-canary-probe-latency-20261014`, `fix-oros-endojs-review-403-panel-routing-20261027`, `diagnose-oros-studio-policy-refusal-test-20260915`, `calibrate-oros-studio-budget-pool-20260917`, `oros-hardware-report-20261011`, `auto-derotate-offline-host-worker-capacity`, and the sysop builds (`build-sysop-*`).
- `projects/garden/oros-health-log.md` on journal2 (2,500+ lines of per-run snapshots).
- The maintainer-inbox watchdog notices about hosts (`watchdog-rolling-deploy-*`, `watchdog-worker-derotate-*`, `watchdog-namespace-clone-packs-*`, `watchdog-journal-*`, `watchdog-worker-agent-bin-*`) and their recoveries.
- `unblock-oros-canary-drain-20261104` (posted the same day; if it has reported by the time you run, use its findings as the worked example).
- `context/operations/{host-operations,health,deploy,leader-follower,scaling}.md`, and skills `restore`, `self-healing-wrapper`, `host-disposition-report`.

**The design should settle:**
1. The role's purpose, when a mechanic is dispatched (watchdog-triggered, recurring check-up, maintainer ask), and where it runs (a drained or offline target cannot claim; usually the leader acting through the sysop bridge).
2. A diagnose order (health record, sysop log, unit and journal logs, load/disk/lock state) and the recurring failure shapes with their evidence signatures and known fixes.
3. The **op ladder**: which benign sysop ops to try first, and exactly where maintainer attestation is required (`unit`, `deploy`, `local-model`, `maintain`) so the mechanic stops and asks rather than guessing.
4. Drain rules: who may lift a roll-induced drain, and when it is safe.
5. How the existing recurring `oros-health-checkup` / `oros-health-watch` jobs fold into (or are rewritten as) mechanic jobs so they stop carrying long bespoke prompts.
6. A standard report shape, and what the mechanic records for the next one (so it improves with use).
7. Hard limits: no ferry or identity switch, no worker-count or pool-ceiling changes on the leader, no auto-rollback.

Keep it short and concrete; the maintainer wants to improve it with use, not perfect it up front. Include a tiny first-draft `roles/mechanic/AGENT.md` outline in the design.


<!-- garden-annotation: key=00da17f586fe by=producer at=2026-11-04T22:15:46Z -->

SCOPE AMENDMENT (maintainer kriskowal, 2026-11-04): make the mechanic role GENERAL to ALL leaders and followers and to any mechanical host failure, not oros-style followers first. Treat oros only as the first worked example. The playbook must cover leader-specific failures (stuck deploy, root-repo corruption, singleton-service duplicates, journal worktree stale, leader-marker handoff) as well as follower ones (canary, drain, offline host, derotation, heartbeat, load). Where leader and follower procedure differ, state both.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-04T22:20:50Z
