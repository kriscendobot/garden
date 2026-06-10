---
title: "endo-but-for-bots/designs/README.md — the cross-document tracking artifact"
source-slug: endo-but-for-bots--llm-designs-README-md
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/README.md
authors: [Endo project (collective)]
repo: endojs/endo-but-for-bots
path: designs/README.md
total-lines: 926
ingest-cycle: 267
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `endo-but-for-bots/designs/README.md`

A 926-line cross-document tracking artifact. **Closes the loop with cycle 265's CLAUDE.md spec** — the spec prescribed five named artifacts the README must contain; cycle 267 verifies all five are present.

## Key moves

- **§The spec prescribes five artifacts and the README instantiates all five** — summary table + Mermaid dep graph + milestone tables + size/time estimates + Gantt timeline.
- **§118-design summary table sorted by cluster-prefix** (not by date or status).
- **§Status-field carries PR-number when implementation is in flight** — *"In Progress (PR #133)"* etc.
- **§Each Mermaid graph node carries its Status as an `<i>...</i>` suffix inside the node label** — the graph encodes Status redundantly with the table.
- **§The M½ naming convention** when a milestone is extracted from another.
- **§Two-question criterion for milestone membership** — *"not user-facing capability AND substrate/prereq for M1 capability work"*.
- **§The calibration round IS six named sub-sections** — Sample + Headline ratio + Per-size velocity + Per-milestone aggregate + Review-queue latency + Recalibration applied.
- **§The canonical velocity shape** — N + Median estimate + Median actual + Ratio.
- **§Additive review-queue correction vs multiplicative velocity correction** — two named recalibration strategies.
- **§Three named PR-to-design matching disciplines** — branch-slug + `Refs:` body + `Forwarded from #N` body.
- **§Strategic Early Items as foundational-not-features** — endoclaw-timer and endoclaw-network-fetch surfaced before later milestones because foundational.
- **§The chrono-log IS a rolling window** — Last updated + Recently added + Earlier additions; promote/demote/fall-off discipline.
- **§Progress markers as named anchors in the timeline with explicit deltas** — *"39 of 118 designs complete/implemented"* with prior-snapshot comparison.
- **§Two named update disciplines** — status-only-sweep + calibration-round operate on the same README at different cadences.

## §Century milestone

Cycle 267 IS the **one-hundredth consecutive designs-chat alternation** (cycles 166-250 + 252-267; cycle 251 was the only out-of-band papers-lane). §A-named-milestone-IS-100-cycles-of-alternation-discipline.

## Three-cycle loops closed

- §**Three cycles with spec-and-instance loops closed** (263 fragment-deviates-from-template + 265 spec-prescribes-template + 267 README-instantiates-spec's-prescriptions).
- §**Three cycles from different angles meeting the same pattern** (261 substrate-Use-Cases-omission + 265 explicit-template-permission-for-section-omission + 267 README-instance-honors-spec's-five-artifact-prescription).

## Section files

- [§Cross-document tracking artifact closes loop with cycle 265 CLAUDE.md spec + five artifacts all present + Strategic Early Items + 100-cycle alternation milestone](../sections/endo-but-for-bots--llm-designs-README-md--cross-document-tracking-artifact-closes-loop-with-cycle-265-CLAUDE-md-spec-and-five-artifacts-all-present-and-strategic-early-items-and-100-cycle-alternation-milestone.md) — structural pattern observations (926-line file ingested in pattern-scope; the table/graph rows are not enumerated individually but the structural shape is fully observed).

## Ingest scope

Cycle 267 (designs-lane after cycle 266's chat-lane internal-types.js). 926-line file ingested in pattern-scope (structural observations of the table/graph/timeline shape rather than per-row enumeration). **First-explicit-observations (ten)**: the-spec-and-the-instance-completely-agree + the-summary-table-is-sorted-by-cluster-prefix + Status-field-carries-PR-number-when-implementation-is-in-flight + each-Mermaid-graph-node-carries-its-Status-as-an-italic-suffix + the-M½-naming-convention + two-question-criterion-for-milestone-membership-named-explicitly + the-calibration-round-IS-six-named-sub-sections + additive-review-queue-correction-vs-multiplicative-velocity-correction + three-named-PR-to-design-matching-disciplines + foundational-vs-feature-distinction-named-explicitly. **Century milestone**: 100th consecutive designs-chat alternation.
