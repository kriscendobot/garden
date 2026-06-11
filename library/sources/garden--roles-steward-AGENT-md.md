---
title: "kriskowal/garden/roles/steward/AGENT.md — the operating brief for the steward role (the autonomous counterpart to the liaison)"
source-slug: garden--roles-steward-AGENT-md
url: https://github.com/kriskowal/garden/blob/main/roles/steward/AGENT.md
authors: [Endo project (collective; current-frontmatter = gardener + steward + liaison)]
repo: kriskowal/garden
path: roles/steward/AGENT.md
total-lines: 621
ingest-cycle: 307
ingest-date: 2026-06-11
lane: designs
---

# `kriskowal/garden/roles/steward/AGENT.md`

A 621-line document — the operating brief for the steward role. **The twelfth garden source ingested**. **The second role file** (after cycle 303's liaison AGENT.md). §twelve-cycles-with-garden-repo-source-ingest. The eleven named shapes stay at eleven; cycle 307 extends the role-specific-orchestrator-instructions shape (named at cycle 303) with a second instance.

**§the-named-orchestrator-pair-IS-now-fully-realized**: the named-two-postures-divide-one-job-by-trust-posture pair (liaison excess-authority + steward bounded-authority) IS now both halves explicitly in the library. §two-cycles-with-named-role-specific-orchestrator-instructions (303 + 307).

## Key moves

- **§the-named-autonomous-counterpart-to-the-liaison** — §the-named-no-user-in-the-loop-discipline; §six-named-steward-cycle-phases (wake + survey + dispatch + journal + schedule + exit); §the-named-bounded-authority-by-design.
- **§six-named-must-nots-of-the-steward** (talk-to-user + edit-roles/skills/top-level-docs + adopt-from-references + cross-identities-to-push-upstream + originate-cross-repo-cross-link + modify-gitignore-CLAUDE-WORKTREES) — §the-named-explicit-negative-discretion-list; §the-named-positive-vs-negative-discretion-pair (303 liaison's five-mays + 307 steward's six-must-nots).
- **§five-named-mays-of-the-steward** — read + write journal-entries + create-update-collect-worktrees + dispatch-any-active-role + schedule-own-next-wakeup.
- **§seven-named-steward-skills** (journal-sync + inbox-drain + autonomous-loop-pacing + self-improvement + at-mention-surveillance + job-board + style skills) — §the-named-skill-roster-IS-named-asymmetric-across-the-pair; §the-named-conditional-vs-unconditional-skill-invocation-across-the-pair (liaison conditional + steward unconditional); §the-named-safety-by-construction-IS-named-the-authorization-substitute; §the-named-canonical-call-site-discipline (autonomous-loop-pacing IS the single ScheduleWakeup call site); §the-named-write-report-not-commit-discipline (self-improvement report side only).
- **§the-named-workspace-presence-job-board-three-piece-composition** — §three-named-composition-pieces-for-the-clear-survival-posture (designated workspace + presence file + job board).
- **§three-named-workspace-check-steps** — pwd + branch + sync; §the-named-drift-escalates-via-message-and-refuses-to-act; §the-named-precipitating-incidents-named-explicitly (2026-05-17 + 2026-05-18 silent failures).
- **§eight-named-presence-frontmatter-fields** — hostname + role + status + session_started + last_heartbeat + cadence_seconds + workspace_path + bootstrap; §the-named-presence-file-IS-the-named-durable-breadcrumb-for-/clear-re-anchoring; §the-named-90-seconds-IS-named-heartbeat-default; §two-named-cadence-defaults-in-the-garden (30s daemons + 90s heartbeat); §the-named-presence-IS-named-self-anchoring-not-named-routing.
- **§three-named-claim-disciplines** (frontmatter-only read + re-check eligibility + opportunistic concurrency) — §the-named-frontmatter-only-read-discipline; §the-named-body-verbatim-forwarding; §the-named-routing-without-reading-the-payload-discipline; §the-named-one-claim-per-cycle-IS-named-steady-state.
- **§eight-named-per-job-lifecycle-steps** (read-frontmatter + prepare-triple + write-dispatch + invoke-Agent + write-result + complete-job + teardown + return-to-idle) — §the-named-per-job-substance-IS-confined-to-the-dispatch-context; §the-named-context-isolation-by-construction; §the-named-maintainer-framing-quote (2026-05-18 "clear context and return to its designated workspace").
- **§four-named-parent-context-Monitors** — daemon-log tail + inbox-drain + @-mention surveillance + job-board tail; §the-named-Monitor-IS-named-real-time-vs-cycle-delayed; §three-named-precipitating-incidents (three forwarded messages 2026-05-14 + jcorbin's @-mention 2026-05-15); §the-named-maintainer-directive-verbatim ("arm all of its monitors"); §the-named-per-cycle-re-arm-discipline.
- **§the-named-path-fallback-discipline-for-wrapped-skill-scripts** — §the-named-canonical-then-legacy-fallback-shape; §the-named-rebase-mid-tree-state-defense; §the-named-silent-not-loud-with-out-of-band-escalation-discipline; §the-named-discipline-IS-named-with-named-provenance (two same-pattern outages within 48 hours on endolinbot).
- **§the-named-issue-surveillance-IS-first-class-signal** — §the-named-loud-floor (per-skill tables cannot reduce below); §the-named-standing-principle-vs-per-repo-bespoke-distinction; §the-named-maintainer-framing-quote ("the role of steward should do this generally"); §three-cycles-with-named-monitor-garden-asymmetry-or-equivalent (299 + 301 + 307).
- **§six-named-operational-flake-steps** (detect + broadcast + resilience PR + merge + retire + validate) — §three-named-components-of-the-retirement-transaction (name-the-broadcast + enumerate-affected-PRs + re-run-failed-CI); §the-named-transaction-IS-named-atomic-not-streamed; §the-named-step-5c-IS-named-the-precipitating-missing-step.
- **§the-named-shepherd-to-fixer-auto-pickup-chain** — §the-named-subordinate-verdict-IS-the-authorization-signal; §the-named-one-role-hop-discipline; §the-named-classification-discriminates-fixer-vs-deeper-problem; §the-named-maintainer-correction-precipitates-the-encoded-rule (2026-05-23T07:07:53Z directive on PR #345).
- **§the-named-parked-followup-revisit** — §five-named-parked-followup-revisit-steps; §three-named-PR-state-outcomes (MERGED + CLOSED + OPEN); §the-named-merge-triggers-actioning-of-deferred-followups.
- **§twenty-three-named-subordinate-roles** — monitor + review-queue + boatman + researcher + builder + assayer + cleaner + solicitor + barrister + justice + appellate + fixer + groom + investigator + weaver + shepherd + conductor + designer + journalist + scout + botanist + major-general + scholar; §the-named-steward-dispatches-more-roles-than-the-liaison; §the-named-three-judge-pattern (solicitor + barrister + justice; PR-stage-determines-which-judge); §two-named-autonomous-loop-roles-in-the-garden (scholar + steward via `<<autonomous-loop-dynamic>>`); §the-named-evaluator-IS-named-NOT-dispatched-by-the-steward (meta-evolution input outside the steward's authority).
- **§the-named-jury-fixer-loop-IS-named-explicit-loop-construct** — extends cycle 303's named-PR-creation-flow-chaining-IS-the-orchestrator's-job; §the-named-loop-IS-named-orchestrator-managed-not-stage-managed.
- **§seven-cycles-with-named-role-as-author-shape** (281 + 297 + 299 + 301 + 302 + 303 + 307); §five-cycles-with-named-`---` YAML-frontmatter-with-three-fields (299 + 301 + 302 + 303 + 307); §the-named-multi-role-author-count-varies-by-role (303 two-role + 307 three-role).
- **§the-named-cycle-307-completes-the-orchestrator-pair-IS-explicit** — §the-named-pair-IS-named-complete; §the-named-orchestrator-pair-IS-named-foundational.

## Section files

- [§twelve-cycles-with-garden-repo-source-ingest + §the-named-orchestrator-pair-IS-now-fully-realized + §six-named-must-nots-of-the-steward + §five-named-mays-of-the-steward + §seven-named-steward-skills + §the-named-workspace-presence-job-board-three-piece-composition + §four-named-parent-context-Monitors + §the-named-path-fallback-discipline + §six-named-operational-flake-steps + §the-named-shepherd-to-fixer-chain + 30+ more first-explicit-observations](../sections/garden--roles-steward-AGENT-md--twelfth-garden-source-and-orchestrator-pair-completes.md) — first ~350 lines focused; remaining ~270 lines covered at summary level.

## Ingest scope

Cycle 307 (designs-lane after cycle 306's chat-lane journal/jobs/README.md). The 621-line role brief IS in scope; the section file focuses its first-explicit-observations on the first ~350 lines (Posture + Skills + Workspace/Presence/Job-board + Subordinate roles + Standing monitors + Operational-flake + Auto-pickup chains + Parked followup revisit). The remaining ~270 lines (Vocabulary tables + per-cycle procedure + various invariants and disciplines) are covered at summary level; future scholar cycles can re-ingest deeper sections of this document if specific second-pass coverage IS warranted.

Cycle 307 IS the first cycle in the garden cluster to **extend an existing named shape with a second instance** rather than introduce a new shape. The §eleven-named-shapes count stays at eleven; the **role-specific-orchestrator-instructions** shape (named at cycle 303) now has two instances. **§the-named-shape-extension-vs-shape-addition-distinction**.
