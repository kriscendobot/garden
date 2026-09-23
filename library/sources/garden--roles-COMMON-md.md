---
title: "kriskowal/garden/roles/COMMON.md — the standing instructions every dispatched subagent reads first"
source-slug: garden--roles-COMMON-md
url: https://github.com/kriskowal/garden/blob/main/roles/COMMON.md
authors: [Endo project (collective; current-frontmatter = gardener + liaison)]
repo: kriskowal/garden
path: roles/COMMON.md
total-lines: 204
ingest-cycle: 301
ingest-date: 2026-06-11
lane: designs
---

# `kriskowal/garden/roles/COMMON.md`

A 204-line document — the standing instructions every dispatched subagent reads first. The sixth garden source ingested. §six-cycles-with-garden-repo-source-ingest (281 + 297 + 298 + 299 + 300 + 301). §six-named-shapes-of-garden-self-documentation (proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control + standing-subagent-instructions). The garden-meta cluster IS now the library's largest single-repo cluster at six sources.

## Key moves

- **§the-named-standing-subagent-instructions-shape** — sixth garden source; three named tiers of subagent context (standing/COMMON.md + role/AGENT.md + on-demand/SKILL.md); progressive disclosure; named-on-demand-skill-loading.
- **§the-named-explicit-load-vs-auto-load** — two distinct mechanisms for "load this first": auto-load (CLAUDE.md, Claude Code does it) + explicit-load (COMMON.md / AGENT.md, dispatch prompt names them). §two-named-shapes-of-load-first-instructions. Cycle 299 named the discipline against auto-load; cycle 301 IS the document that the rule shapes. §the-named-discipline-design-and-instance-pair-across-two-cycles.
- **§the-named-subagent-vs-orchestrator-distinction-at-the-document-level** — the document explicitly names which sections apply to every role including the liaison and which apply only to dispatched subagents.
- **§the-named-three-prose-style-rules-as-skills** — em-dash-style + relative-paths + no-latin-shorthand; prose-style IS named-skill not inline norm; §the-named-discipline-of-keeping-COMMON.md-small.
- **§the-named-vendored-content-exemption** — references/ exempt from all three style rules; §the-named-explicit-exempt-discipline; §the-named-snapshot-IS-read-only-shape.
- **§the-named-document-frontmatter-IS-three-named-fields** — created + updated + author; §four-cycles-with-named-role-as-author-shape (281 + 297 + 299 + 301); §the-named-trivial-fixes-do-NOT-warrant-an-authorship-change; §two-named-frontmatter-shapes-in-the-garden (persistent-doc + journal-entry).
- **§two-named-statements-of-the-same-monitoring-safety-constraint** — same constraint stated in CLAUDE.md (cycle 299; orchestrator framing) and COMMON.md (cycle 301; subagent framing); §the-named-DRY-discipline-IS-violated-deliberately-for-safety-critical-rules; §the-named-redundancy-IS-the-named-anti-miss-discipline.
- **§the-named-external-repo-etiquette** — default-deny on comments + reviews + reactjis + cross-references + issue/PR opens/edits/closes; explicit dispatch-prompt authorization required; §the-named-Why-section-naming-the-rationale; §the-named-rationale-prevents-rule-rot.
- **§the-named-per-role-authorization-table** — eight roles (fixer + weaver + shepherd + conductor + designer + scout + botanist + major-general) each with named-implicit + named-per-action authorization shapes; §the-named-fine-grained-authorization-discipline.
- **§the-named-boatman-exception** — `identity_switch_authorized: true` IS the named single-authorization that covers the cross-link; §the-named-one-named-flag-IS-the-named-broad-authorization.
- **§the-named-three-stage-authorization-pipeline** — originate (maintainer) + record (bulletin or message entry) + inline (steward at fire time); §the-named-asymmetric-authorization-origination; §the-named-late-binding-of-authorization.
- **§the-named-named-authority-structure** — default technical authority on a repo IS its maintainer; named-senior-contributors (e.g., erights on endo) IS non-default-authority-actor; §the-named-technical-authority-vs-authorization-chain-distinction; §the-named-project-README-IS-the-named-actor-registry.
- **§the-named-project-specifics-live-in-the-journal** — §three-named-tiers-of-information-locality (project-agnostic roles+skills + project-specific journal + per-dispatch dispatch-prompt); §the-named-grep-recipe-IS-named-self-service-API; §the-named-append-only-with-most-recent-wins-semantics.
- **§the-named-library-IS-three-indexing-axes** — sources (provenance) + topics (taxonomy) + keywords+concepts (term-lookup); §the-named-multi-axis-knowledge-graph; §the-named-self-referential-shape-of-the-library.
- **§the-named-skill-rather-than-read-by-eye** — library-lookup IS the named-skill-mediated-access; §the-named-index-on-the-fly-IS-the-compounding-property; §the-named-index-improvements-by-one-role-benefit-every-subsequent-caller-in-every-other-role.
- **§the-named-orphan-branch-journal** — independent history from main; never enters PRs or pollutes code-side blame; §the-named-orphan-IS-the-named-deliberate-isolation.
- **§the-named-bulletin-IS-the-maintainer-dashboard** — agents own the bulletin entirely; named-bulletin-lifecycle-IS-named-post-then-clear; §the-named-action-IS-out-of-band-detection-IS-in-band.
- **§the-named-journal-archives-terminated-long-living-subagents** — under agents/, indexed by date / role / subject; §the-named-agent-archive-IS-named-by-three-axes; named-skill-for-meta-procedure (agent-termination).
- **§the-named-entry-layout-IS-named-six-component-filename** — YYYY/MM/DD/HHMMSS-kind-role-shortid.md; §three-cycles-with-6-hex-short-id-discipline (297 named + 298 implemented + 301 names purpose); §the-named-collision-avoidance-IS-effectively-impossible.
- **§the-named-five-named-entry-kinds** — dispatch + tick + message + result + worktree; §the-named-discrete-finite-state-set.
- **§the-named-broadcast-to-IS-the-asterisk** — `to: "*"` IS broadcast; otherwise a role name; §the-named-OR-grep-pattern-for-both-directed-and-broadcast.
- **§the-named-project-field-IS-optional-but-recommended** — kebab-case upstream name (endo, agoric-sdk), not fork owner; §the-named-canonical-upstream-name-IS-the-slug.
- **§two-named-worktree-path-shapes** — ephemeral (dispatch-root-relative) + standing (long-lived absolute-style); §the-named-path-shape-encodes-lifetime.
- **§the-named-journal-sync-skill-IS-the-named-anti-divergence-mechanism** — §the-named-DO-NOT-roll-your-own-concurrent-append; §the-named-canonical-skill-IS-the-named-single-source-of-truth; §the-named-honest-difficulty-claim.
- **§three-named-distinct-reading-recipes** — overview (--since) + role-directed (grep OR pattern) + specific-path; §the-named-recipe-per-query-shape.
- **§the-named-worktree-triple-IS-ephemeral** — only journal survives dispatch teardown; §the-named-.garden-monitor/-naming-discipline.
- **§the-named-standing-monitor-exception** — bash-daemon-owned state survives dispatch teardown; §the-named-LLM-vs-daemon-ownership-distinction; §two-cycles-with-named-standing-exception (297 + 301).
- **§the-named-do-not-rename-move-or-remove-worktree** — orchestrator owns the worktree lifecycle.
- **§the-named-journal-worktrees-host-index** — `journal/worktrees/$(hostname -s)/<basename>.md`; named-hostname-as-the-index-key; §the-named-heartbeat-IS-named-liveness-marker.
- **§the-named-result-entry-AND-final-message** — §the-named-dual-channel-reporting (journal-durable + final-message-convenience).
- **§the-named-mandatory-`Self-improvement:`-one-line** — §the-named-mandatory-meta-improvement-line; §the-named-explicit-named-null-shape ("nothing this time."); §the-named-continuous-improvement-discipline.
- **§the-named-message-on-interruption-or-blocker** — addressed to liaison; named-tried-plus-need-pair.
- **§the-named-cycle-301-IS-the-named-sixth-garden-source-and-the-third-cycle-of-the-second-hundred-after-300-milestone** — named-post-milestone-continuation; named-cadence-IS-named-unbroken-discipline.

## Section files

- [§six-cycles-with-garden-repo-source-ingest + §the-named-explicit-load-vs-auto-load + §the-named-standing-subagent-instructions + §the-named-three-prose-style-rules-as-skills + §the-named-two-statements-of-the-monitoring-safety-constraint + §the-named-external-repo-etiquette + 40+ more first-explicit-observations](../sections/garden--roles-COMMON-md--sixth-garden-source-and-standing-subagent-instructions-and-explicit-load-vs-auto-load.md) — full 204-line document in scope.

## Ingest scope

Cycle 301 (designs-lane after cycle 300's chat-lane garden daemons triple; the first cycle after CYCLE-MILESTONE-300). Full 204-line document in scope. **First-explicit-observations (forty-plus)** at full scope: §the-named-standing-subagent-instructions-shape, §the-named-explicit-load-vs-auto-load, §the-named-subagent-vs-orchestrator-distinction-at-the-document-level, §the-named-three-prose-style-rules-as-skills, §the-named-vendored-content-exemption, §the-named-document-frontmatter-IS-three-named-fields, §two-named-statements-of-the-same-monitoring-safety-constraint, §the-named-external-repo-etiquette with default-deny + Why-section, §the-named-per-role-authorization-table (eight roles), §the-named-boatman-exception, §the-named-three-stage-authorization-pipeline, §the-named-named-authority-structure with named-senior-contributors, §the-named-project-specifics-live-in-the-journal with three named tiers of information locality, §the-named-library-IS-three-indexing-axes, §the-named-skill-rather-than-read-by-eye, §the-named-orphan-branch-journal, §the-named-bulletin-IS-the-maintainer-dashboard, §the-named-journal-archives-terminated-long-living-subagents, §the-named-entry-layout-IS-named-six-component-filename, §the-named-five-named-entry-kinds, §the-named-broadcast-to-IS-the-asterisk, §the-named-project-field-IS-optional-but-recommended, §two-named-worktree-path-shapes, §the-named-journal-sync-skill-IS-the-named-anti-divergence-mechanism, §three-named-distinct-reading-recipes, §the-named-worktree-triple-IS-ephemeral, §the-named-standing-monitor-exception, §the-named-journal-worktrees-host-index, §the-named-result-entry-AND-final-message, §the-named-mandatory-`Self-improvement:`-one-line, §the-named-message-on-interruption-or-blocker.
