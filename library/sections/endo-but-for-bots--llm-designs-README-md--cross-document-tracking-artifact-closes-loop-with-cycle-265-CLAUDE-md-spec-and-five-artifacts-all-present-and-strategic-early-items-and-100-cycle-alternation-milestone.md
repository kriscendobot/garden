---
title: "endo-but-for-bots/designs/README.md — the cross-document tracking artifact that closes the loop with cycle 265's CLAUDE.md spec + five named artifacts all present + Strategic Early Items + 100-cycle alternation milestone"
source-slug: endo-but-for-bots--llm-designs-README-md
section-slug: cross-document-tracking-artifact-closes-loop-with-cycle-265-CLAUDE-md-spec-and-five-artifacts-all-present-and-strategic-early-items-and-100-cycle-alternation-milestone
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/README.md
source-repo: endojs/endo-but-for-bots
source-path: designs/README.md
source-author: Endo project (collective)
total-lines: 926
ingest-cycle: 267
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `endo-but-for-bots/designs/README.md` — closes the loop with cycle 265's CLAUDE.md spec

A 926-line **cross-document tracking artifact** that instantiates **all five named artifacts** prescribed by cycle 265's `designs/CLAUDE.md` spec. Closes another loop: cycle 265 established what the README MUST contain; cycle 267 verifies that the README actually contains it.

§First-explicit-observation in library: **§the-spec-prescribes-five-artifacts-and-the-README-instantiates-all-five — §when-a-spec-prescribes-a-cross-document-tracking-shape, §the-instance-IS-evidence-of-the-spec-being-followed-rather-than-the-spec-being-aspirational**.

## §All five named README artifacts cross-checked from cycle 265's spec

| Spec-prescribed artifact                          | Present in README | Location                          |
|---------------------------------------------------|-------------------|-----------------------------------|
| Summary table with Created/Updated/Status columns | ✓                 | Lines 48-173 (~120 designs)       |
| Mermaid dependency graph                          | ✓                 | Lines 178-307 (9 subgraph clusters)|
| Milestone tables with exit criteria               | ✓                 | Lines 309-542 (M0 through M6)     |
| Size/time estimates calibrated against velocity   | ✓                 | Lines 544-749 (Calibration rounds)|
| Gantt timeline                                    | ✓                 | Lines 802-832 (mermaid gantt)     |

§The-five-artifacts-IS-the-canonical-cross-document-tracking-shape — §the-spec-and-the-instance-agree-completely; §first-explicit-observation in library of §the-spec-and-the-instance-completely-agree-as-named-evidence-of-process-discipline.

## §The Summary section as 118+ row table

Lines 48-173 carry the §Summary-table — at the 2026-05-19 sweep noted in the Progress text (line 869), **118 designs** total with 39 complete/implemented + 18 in progress.

§The-table-IS-sorted-by-cluster-prefix-not-by-date — §designs-grouped-by-prefix (chat-* + daemon-* + endoclaw-* + endopi-* + endor-* + familiar-* + lal-* + ocapn-* + etc.); §the-cluster-prefix-IS-the-implicit-grouping; §sibling-pattern to cycle 263's `-design-doc-2` suffix observation.

§First-explicit-observation in library: **§the-summary-table-is-sorted-by-cluster-prefix-not-by-date-or-status**.

§Status-values-with-PR-number-suffixes — *"In Progress (PR #133)"* appears at line 62; §the-Status-field-can-carry-a-PR-link-when-implementation-is-in-flight; §the-Status-field-evolves-from-the-spec's-eight-values-to-include-PR-tracking; §first-explicit-observation in library of §Status-field-carries-PR-number-when-implementation-is-in-flight.

§Bolding-applied-to-Complete-and-Implemented per the spec's bolding convention; §the-instance-honors-the-bolding-convention.

## §The Dependency Graph as Mermaid with 9 named subgraph clusters

Lines 178-307 carry a Mermaid `flowchart TD` with **9 named subgraph clusters**: Daemon Core + Daemon Messaging + LLM Agents + Familiar + Remote Access + Agent Capabilities + OCapN + plus more.

§The-cluster-shapes-in-the-dep-graph-match-the-cluster-prefixes-in-the-summary-table — §two-axes-of-organization-coincide: the table sort and the graph subgraph; §the-organizational-discipline-IS-consistent-across-the-table-and-the-graph.

§Inline-Status-via-italic-tag inside graph nodes (e.g. `d256[daemon-256-bit-identifiers<br/><i>COMPLETE</i>]`) — §each-graph-node-carries-its-Status-as-an-`<i>...</i>`-suffix; §the-graph-and-the-table-encode-the-Status-redundantly.

§First-explicit-observation in library: **§each-Mermaid-graph-node-carries-its-Status-as-an-`<i>...</i>`-suffix-inside-the-node-label — §the-graph-encodes-Status-redundantly-with-the-summary-table**.

## §The Roadmap with seven Milestones (M0 through M6, plus M½)

Lines 309-542 carry §seven-named-Milestones-plus-M½: M0 (AI Agent Experience, complete) + M½ (Project Hygiene, extracted from M1 at 2026-05-14) + M1 (Remote Access) + M2 (Networking) + M3 (Weblets) + M4 (UX) + M5 (Confinement) + M6 (Rust Daemon).

§The-M½-naming-convention — §when-a-milestone-IS-extracted-from-another, §the-fractional-name-encodes-the-relationship; §sibling-pattern to git's commit-fixup-and-squash conventions; §first-explicit-observation in library of §the-M½-naming-convention-when-a-milestone-IS-extracted-from-another.

§Two-question-criterion-for-milestone-membership (lines 905-907):
> *"not user-facing capability AND substrate/prereq for M1 capability work"*

§First-explicit-observation in library: **§two-question-criterion-for-milestone-membership-named-explicitly — §the-criterion-IS-not-implicit + §the-author-names-the-decision-procedure-when-extracting-a-milestone**.

§Six-designs-moved-from-M1-to-M½ via the two-question criterion.

## §Size and Time Estimates — calibration-round velocity discipline

Lines 544-749 carry the §calibration-round-velocity-discipline that cycle 265's CLAUDE.md spec named with *"calibrated against observed velocity"*.

### §The 2026-05-14 calibration round structure — six named sub-sections

1. **Sample** — N = 13 new S + 3 M + 1 L; cumulative N = 18 S + 10 M + 2 L.
2. **Headline ratio** — Median actual/estimate = **0.9**.
3. **Per-size velocity** (S/M/L/XL table with N + Median estimate + Median actual + Ratio).
4. **Per-milestone aggregate** (Milestone + Completed + Median actual + Median estimate + Ratio).
5. **Review-queue latency** — *"the binding constraint, updated"*; 21-day median elapsed time.
6. **Recalibration applied** — explicit ratio adjustments per size class.

§First-explicit-observation in library: **§the-calibration-round-IS-six-named-sub-sections-each-encoding-one-aspect-of-velocity-measurement**.

§The-canonical-velocity-shape (N + Median estimate + Median actual + Ratio) — §the-Ratio-column-IS-the-correction-factor + §the-multiplier-IS-applied-to-future-estimates.

§Review-queue-latency-as-binding-constraint — §when-a-system's-throughput-IS-bottlenecked-on-review-not-on-implementation, §the-correction-IS-additive-time-not-multiplicative-ratio; §first-explicit-observation in library of §additive-review-queue-correction-vs-multiplicative-velocity-correction-as-two-named-recalibration-strategies.

### §PR-to-design matching disciplines named

Lines 558-560: §three-named-PR-to-design-matching-disciplines:
1. **Branch slug** — the PR's branch name matches the design slug.
2. **`Refs:` body convention** — the PR body carries `Refs: designs/<slug>.md`.
3. **`Forwarded from #N` body line** — for the recreated-under-bot pattern, points back at the original.

§First-explicit-observation in library: **§three-named-PR-to-design-matching-disciplines (branch-slug + Refs-body + Forwarded-from-N-body)**.

§The-recreated-under-bot-pattern — §sibling-pattern to the garden's `roles/boatman` identity-switch-authorized discipline; §two-cycles-with-the-bot-identity-switch-discipline-named (boatman-role-in-garden-meta + 267 designs/README.md).

## §Strategic Early Items — foundational-not-features

Lines 859-867: *"Two EndoClaw capabilities are surfaced before the last two milestones because they are foundational rather than features"*.

§The-two-strategic-early-items: §endoclaw-timer (M1) + §endoclaw-network-fetch (M1) — **both of which cycle 244 (timer) and cycle 261 (network-fetch) ingested**. §two-cycles-already-ingested-the-strategic-early-items.

§The-rationale-named-explicitly:
- §endoclaw-timer — *"SES lockdown removes `setTimeout` and `setInterval`. Timer is the *only* mechanism for scheduled agent execution. Without it, agents are purely reactive."*
- §endoclaw-network-fetch — *"A self-hosted agent that cannot reach external APIs is inert. OAuth, channel bridges, and all integrations depend on it."*

§Foundational-vs-feature-distinction — §a-foundational-design-blocks-many-downstream-designs + §a-feature-design-is-leaf; §first-explicit-observation in library of §foundational-vs-feature-distinction-named-explicitly-as-criterion-for-Strategic-Early-Item-surfacing.

§The-"agents-are-purely-reactive"-failure-mode-named — §when-a-capability-IS-the-only-mechanism-for-X, §its-absence-IS-the-failure-mode + §the-failure-mode-IS-named-in-the-Strategic-Early-Items-justification.

## §The chrono-log structure — rolling-window attention-management

Lines 3-46 carry §three-named-chronological-sections at the top of the README:

1. **Last updated** — explains the sweep producing the current snapshot.
2. **Recently added or revised** — items added since the last sweep.
3. **Earlier additions** — items added in the prior period.

§The-chrono-log-IS-a-rolling-window — §recent-items-promote + §older-items-demote + §oldest-items-fall-off-the-log + §the-Summary-table-IS-the-canonical-record.

§First-explicit-observation in library: **§the-chrono-log-IS-a-rolling-window-with-Last-updated + Recently-added + Earlier-additions-as-named-sections**.

## §Progress markers as named anchors

Lines 869+: *"Progress as of 2026-05-19 (consolidated status sweep): 39 of 118 designs complete/implemented, 18 in progress."*; *"Progress as of 2026-05-14: 28 of 106 designs complete/implemented, 17 in progress."*

§Progress-markers-encode-deltas-over-time without the reader needing to diff git history.

§First-explicit-observation in library: **§progress-markers-as-named-anchors-in-the-timeline-with-explicit-deltas**.

## §The "consolidated status sweep" discipline named

Lines 869-886: *"This sweep only reconciles the Status field with the implementation state on `llm`."*

§Two-named-update-disciplines (status-only-sweep + calibration-round) operating on the same README at different cadences; §first-explicit-observation in library of §two-named-update-disciplines-operating-on-the-same-README-at-different-cadences.

## §Cycle 267 first-explicit-observations roundup (ten)

1. §the-spec-and-the-instance-completely-agree-as-named-evidence-of-process-discipline.
2. §the-summary-table-is-sorted-by-cluster-prefix-not-by-date-or-status.
3. §Status-field-carries-PR-number-when-implementation-is-in-flight.
4. §each-Mermaid-graph-node-carries-its-Status-as-an-`<i>...</i>`-suffix-inside-the-node-label.
5. §the-M½-naming-convention-when-a-milestone-IS-extracted-from-another.
6. §two-question-criterion-for-milestone-membership-named-explicitly.
7. §the-calibration-round-IS-six-named-sub-sections-each-encoding-one-aspect-of-velocity-measurement.
8. §additive-review-queue-correction-vs-multiplicative-velocity-correction-as-two-named-recalibration-strategies.
9. §three-named-PR-to-design-matching-disciplines (branch-slug + Refs-body + Forwarded-from-N-body).
10. §foundational-vs-feature-distinction-named-explicitly-as-criterion-for-Strategic-Early-Item-surfacing.

Plus: §progress-markers-as-named-anchors-in-the-timeline-with-explicit-deltas + §the-chrono-log-IS-a-rolling-window + §two-named-update-disciplines-operating-on-the-same-README-at-different-cadences.

## §Recurring meta-pattern counters bumped at cycle 267

- §**three-cycles-from-different-angles-meeting-the-same-pattern** (261 substrate-Use-Cases-omission + 265 explicit-template-permission-for-section-omission + 267 README-instance-honors-spec's-five-artifact-prescription).
- §**three-cycles-with-spec-and-instance-loops-closed** (263 fragment-deviates-from-template + 265 spec-prescribes-template + 267 README-instantiates-spec's-prescriptions).
- §**fourteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested** (cycle 265's count + the README itself).
- §**one-hundredth consecutive designs-chat alternation cycles 166-250 + 252-267** (251 was out-of-band) — §century-milestone.
- §**library-reaches-773-sections at cycle 267**.

## §Century milestone

Cycle 267 IS the **one-hundredth consecutive designs-chat alternation** (cycles 166-250 + 252-267, with cycle 251 the only out-of-band papers-lane). §a-named-milestone-IS-100-cycles-of-alternation-discipline — §the-alternation-discipline-IS-now-canonical-across-100-cycles + §the-discipline-IS-recorded-explicitly-at-each-cycle's-counter-update; §first-explicit-observation in library of §the-100-cycle-alternation-milestone.

## §Synthesis target — slot machine library

§The-cross-document-tracking-discipline applies to the §game-engine-rule-cluster:

- §game-rule-README.md as the cross-document tracking artifact prescribed by the §game-rule-CLAUDE.md spec.
- §five-named-artifacts in the game-rule-README.
- §chrono-log structure as rolling-window attention-management.
- §two-question-criterion-for-milestone-membership for game-rule milestones.
- §calibration-round velocity discipline for game-rule implementation velocity.
- §Strategic-Early-Items — game-engine-foundational-game-rules surfaced before non-foundational features.
- §three-named-PR-to-design-matching-disciplines for game-rule PRs.

## §Tier-1 borrowing

§the-spec-and-the-instance-completely-agree-as-named-evidence-of-process-discipline + §the-summary-table-is-sorted-by-cluster-prefix + §each-Mermaid-graph-node-carries-its-Status-as-an-italic-suffix + §the-M½-naming-convention + §two-question-criterion-for-milestone-membership-named-explicitly + §the-calibration-round-IS-six-named-sub-sections + §additive-review-queue-correction-vs-multiplicative-velocity-correction + §three-named-PR-to-design-matching-disciplines + §foundational-vs-feature-distinction-named-explicitly + §the-chrono-log-IS-a-rolling-window + §progress-markers-as-named-anchors-in-the-timeline-with-explicit-deltas + §two-named-update-disciplines-operating-on-the-same-README-at-different-cadences.

## §Tier-2 borrowing

§Status-field-carries-PR-number-when-implementation-is-in-flight + §the-organizational-discipline-IS-consistent-across-the-table-and-the-graph + §the-graph-and-the-table-encode-the-Status-redundantly + §the-"agents-are-purely-reactive"-failure-mode-named.

## §Tier-3 borrowing

§three-cycles-from-different-angles-meeting-the-same-pattern (261 + 265 + 267) + §three-cycles-with-spec-and-instance-loops-closed (263 + 265 + 267) + §fourteen-design-docs-from-endo-but-for-bots-designs-cluster-ingested + §the-100-cycle-alternation-milestone + §library-reaches-773-sections at cycle 267 + §one-hundredth consecutive designs-chat alternation cycles 166-250 + 252-267.

## Pattern summary (tag-prefixed)

§the-cross-document-tracking-artifact-that-cycle-265's-CLAUDE.md-spec-prescribes + §the-spec-and-the-instance-completely-agree-as-named-evidence-of-process-discipline + §five-named-README-artifacts-all-present + §the-118-design-summary-table-sorted-by-cluster-prefix + §Status-field-carries-PR-number-when-implementation-is-in-flight + §each-Mermaid-graph-node-carries-its-Status-as-an-italic-suffix + §nine-named-subgraph-clusters-in-the-dependency-graph + §seven-named-Milestones-plus-M½ + §the-M½-naming-convention-when-a-milestone-IS-extracted-from-another + §two-question-criterion-for-milestone-membership-named-explicitly + §the-calibration-round-IS-six-named-sub-sections + §the-canonical-velocity-shape + §additive-review-queue-correction-vs-multiplicative-velocity-correction + §three-named-PR-to-design-matching-disciplines + §the-recreated-under-bot-pattern-named-explicitly + §Strategic-Early-Items-as-foundational-not-features + §foundational-vs-feature-distinction-named-explicitly + §the-"agents-are-purely-reactive"-failure-mode-named + §the-chrono-log-IS-a-rolling-window + §progress-markers-as-named-anchors-in-the-timeline-with-explicit-deltas + §two-named-update-disciplines + §the-100-cycle-alternation-milestone.
