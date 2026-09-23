---
title: "kriskowal/garden/journal/jobs/README.md — the job-board contract; the document cycle 299 and cycle 303 both named as 'the contract'"
source-slug: garden--journal-jobs-README-md
url: https://github.com/kriskowal/garden/blob/journal/jobs/README.md
authors: [Endo project (collective; role-as-author convention)]
repo: kriskowal/garden
path: journal/jobs/README.md
total-lines: 143
ingest-cycle: 306
ingest-date: 2026-06-11
lane: chat
branch: journal
---

# `kriskowal/garden/journal/jobs/README.md`

A 143-line document — the job-board contract. **The eleventh garden source ingested**. **The second journal-branch source** (after cycle 305's conventions.md). §eleven-cycles-with-garden-repo-source-ingest (281 + 297 + 298 + 299 + 300 + 301 + 302 + 303 + 304 + 305 + 306). §eleven-named-shapes-of-garden-self-documentation (proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control + standing-subagent-instructions + skill-procedural-playbook + role-specific-orchestrator-instructions + per-feed-watcher-stub + library-conventions + job-board-contract).

**§the-named-fourth-design-and-instance-pair-across-the-garden-cluster**: cycle 299 CLAUDE.md named "contract at journal/jobs/README.md"; cycle 303 liaison AGENT.md named "See journal/jobs/README.md for the board's contract"; cycle 306 IS that contract. **§the-named-double-claim-and-single-realization**: companion to cycle 304's quadruple-claim shape.

## Key moves

- **§the-named-job-board-contract-shape** (the eleventh named shape).
- **§the-named-distributed-work-queue-shape** — opening line names "The job board IS the garden's distributed work queue."
- **§three-named-producer-shapes** (liaison + returning subagent + scheduled-engagement firing) + **§two-named-consumer-roles** (steward + general-contractor; §the-named-stale-reference-witness for contractor retired 2026-06-03).
- **§the-named-board-lifecycle-IS-the-journal-lifecycle** — append-and-commit + push + fetch + retry; §three-cycles-with-named-git-push-as-the-serialization-point (299 + 301 + 306); §the-named-four-named-coresidents-on-the-journal-branch (entries + inboxes + presence files + worktree indices).
- **§the-named-contract-vs-procedure-split** — "This README IS the contract"; `skills/job-board/SKILL.md` IS the procedure; §two-named-contract-and-procedure-pairs (305 + 306).
- **§two-named-board-layouts** (flat + per-role) — §the-named-coexisting-flat-and-per-role-boards; §the-named-migration-discipline-shape; §six-named-per-role-boards (cleaner + judge + fixer + weaver + shepherd + conductor); §the-named-shared-queue-discipline (judge board shared across solicitor + barrister + justice); §three-cycles-with-design-pointer-back-to-driver-design (281 + 304 + 306).
- **§six-named-filename-components** (UTC + host + role + sid + short-id + slug) — §the-named-monotonically-growing-filename-shape; §the-named-find-recipe-via-stable-identity; §the-named-job-identity-IS-set-once-at-post-time-and-never-changes; §four-cycles-with-6-hex-short-id-discipline (297 + 298 + 301 + 306); §the-named-timestamp-IS-the-transition-time; §four-named-UTC-semantics (post + claim + done + abandon).
- **§the-named-three-phase-frontmatter-accumulation** (post-time + claim-time + completion-time); §the-named-frontmatter-grows-monotonically-across-transitions; §four-named-target-shapes (repo + pr + issue + design); §the-named-authorizations-frontmatter-shape (identity_switch + comment_repos; extends cycle 301's named-three-stage-authorization-pipeline); §two-named-priority-levels (normal + urgent); §the-named-staleness-threshold (deadline); §the-named-explicit-default-discipline (eligible_roles default = [steward]; extends cycle 303); §the-named-informational-only-field (preconditions).
- **§the-named-body-IS-the-named-same-brief-as-message-entries** — §the-named-channel-change-not-content-change; §the-named-the-board-changes-the-where-not-the-what; §three-cycles-with-named-2026-05-18-channel-split-or-equivalent (299 + 303 + 306).
- **§four-named-job-transitions** (post + claim + complete-done + complete-abandoned) — §the-named-atomic-git-commit-per-transition; §the-named-prescribed-commit-message-format (`jobs: post <short-id> <verb> <slug>`); §the-named-no-auto-recycle-discipline; §the-named-fresh-short-id-on-re-post.
- **§the-named-four-directory-structure-IS-the-producer-consumer-signal** — §the-named-directory-IS-the-named-state-machine; §the-named-ls-IS-the-state-query; §four-named-job-states (open + claimed + done + abandoned); §the-named-state-transitions-via-git-mv.
- **§the-named-claim-race-resolution** — §the-named-claim-race-resolution-via-git-push; §the-named-git-push-IS-named-serial-against-origin-journal; §the-named-loser-hard-resets-and-moves-on; §the-named-no-retry-with-rebase-on-claim; §the-named-rejection-IS-named-meaningful-not-noise; §the-named-anti-force-fight-discipline; §the-named-single-commit-invariant; §the-named-discipline-makes-the-destructive-operation-safe; §the-named-git-mv-atomicity-discipline; §the-named-edit-after-not-before-move; §two-cycles-with-named-back-off-without-retry (299 + 306); §the-named-graceful-degradation-under-heavy-concurrency.
- **§the-named-bash-poll-daemon-shape** — §two-cycles-with-named-30-second-default-daemon-cadence (304 + 306); §the-named-30-seconds-IS-named-garden-wide-daemon-cadence-default; §two-named-state-change-markers (NEW + GONE); §three-named-state-files-on-tmp (log + state + pid); §the-named-parallel-daemon-shape (job-board-poll parallel to monitor-poll); §three-cycles-with-named-bash-daemon-owned-state-survives-LLM-ticks (301 + 304 + 306); §the-named-two-tier-poll-and-monitor.
- **§two-cycles-with-named-where-things-are-section** (301 + 306) — six-row table mapping path → owner → what; §three-named-job-board-helpers (post-job + claim-job + job-board-poll); §two-cycles-with-named-bash-daemon-state-locations (304 + 306).
- **§the-named-inventory-cap-IS-named-absent** — §the-named-no-hard-cap; §the-named-empty-IS-named-success-state; §the-named-queue-depth-IS-named-capacity-signal; §the-named-bulletin-IS-the-named-escalation-surface (extends cycle 301's named-bulletin-IS-the-maintainer-dashboard).
- **§the-named-composition-with-the-message-bus** — §the-named-orthogonal-channels; §three-named-channel-routing-examples; §two-cycles-with-named-act-vs-read-discrimination-question (303 + 306); §the-named-act-vs-read-IS-the-named-discriminator; §the-named-bi-directional-cross-reference (contract → roles → contract); §the-named-document-mutual-citation-shape.
- **§the-named-cycle-306-IS-the-named-eleventh-garden-source-and-the-second-journal-branch-source-and-the-fourth-design-and-instance-pair-realization**.

## Section files

- [§eleven-cycles-with-garden-repo-source-ingest + §the-named-job-board-contract-shape + §two-named-board-layouts + §six-named-filename-components + §three-phase-frontmatter-accumulation + §four-named-job-transitions + §the-named-claim-race-resolution + §the-named-bash-poll-daemon-shape + 30+ more first-explicit-observations](../sections/garden--journal-jobs-README-md--eleventh-garden-source-and-job-board-contract-and-fourth-design-instance-pair.md) — full 143-line document in scope.

## Ingest scope

Cycle 306 (chat-lane after cycle 305's designs-lane journal/library/conventions.md; the second journal-branch source in the garden cluster). Full 143-line contract in scope. **First-explicit-observations (thirty-plus)** at full scope: §the-named-job-board-contract-shape (the eleventh named shape), §the-named-double-claim-and-single-realization (cycles 299 + 303 named jobs/README.md + cycle 306 IS the contract), §the-named-distributed-work-queue-shape with §three-named-producer-shapes and §two-named-consumer-roles, §the-named-board-lifecycle-IS-the-journal-lifecycle, §two-named-board-layouts (flat + per-role) with §six-named-per-role-boards and §the-named-shared-queue-discipline, §six-named-filename-components with §the-named-find-recipe-via-stable-identity, §the-named-three-phase-frontmatter-accumulation, §the-named-body-IS-the-named-same-brief-as-message-entries (channel-change-not-content-change), §four-named-job-transitions with §the-named-atomic-git-commit-per-transition, §the-named-four-directory-structure-IS-the-producer-consumer-signal, §the-named-claim-race-resolution-via-git-push with §the-named-no-retry-with-rebase-on-claim and §the-named-git-mv-atomicity-discipline, §the-named-bash-poll-daemon-shape with §two-named-state-change-markers and §the-named-parallel-daemon-shape, §the-named-where-things-are-table, §the-named-inventory-cap-IS-named-absent with §the-named-bulletin-IS-the-named-escalation-surface, §the-named-composition-with-the-message-bus with §the-named-orthogonal-channels.
