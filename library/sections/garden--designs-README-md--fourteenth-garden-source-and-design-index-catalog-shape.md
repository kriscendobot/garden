---
title: "garden/designs/README.md — fourteenth garden source; §fourteen-cycles-with-garden-repo-source-ingest; §the-named-design-index-catalog-shape (the twelfth named shape); §twelve-named-shapes-of-garden-self-documentation; §the-named-shape-addition-mode-resumes (cycles 281-306 added shapes; 307-308 extended shapes; 309 returns to addition; §the-named-modal-alternation); §the-named-meta-designs-vs-project-designs-distinction; §four-named-status-values-for-designs (Proposed + Accepted + Implemented + Withdrawn); §two-named-four-status-value-sets-in-the-garden (sections from cycle 305 + designs from cycle 309); §the-named-PR-against-garden-exception (extends cycle 299); §three-named-design-metadata-fields (Created + Author + Status); §the-named-substantial-vs-smaller-change-discriminator"
section-slug: garden--designs-README-md--fourteenth-garden-source-and-design-index-catalog-shape
source-slug: garden--designs-README-md
url: https://github.com/kriskowal/garden/blob/main/designs/README.md
authors: [Endo project (collective; role-as-author convention)]
repo: kriskowal/garden
path: designs/README.md
total-lines: 30
ingest-cycle: 309
ingest-date: 2026-06-11
lane: designs
scope: full
---

# `garden/designs/README.md` (fourteenth garden source ingest)

A 30-line document — the index catalog for garden meta-designs. **The fourteenth garden source ingested**. **§fourteen-cycles-with-garden-repo-source-ingest** (281 + 297 + 298 + 299 + 300 + 301 + 302 + 303 + 304 + 305 + 306 + 307 + 308 + 309). **§twelve-named-shapes-of-garden-self-documentation** (adds **§the-named-design-index-catalog-shape** as the twelfth shape).

**§the-named-shape-addition-mode-resumes**: cycles 281-306 added new shapes (eleven shape-additions); cycles 307-308 extended existing shapes (two shape-extensions); cycle 309 returns to shape-addition. **§the-named-modal-alternation**: the cluster IS now {shape-addition, shape-extension, shape-addition} across {cycles 281-306, 307-308, 309}.

## Key moves

- **§the-named-design-index-catalog-shape** (first-explicit-observation): the twelfth named shape. A short README that catalogs the directory's meta-designs with a status-and-summary table. Distinct from cycle 281's named-proposed-design (an individual design doc) because the catalog IS the meta-index, not an individual design.

§the-named-twelve-named-shapes-of-garden-self-documentation: proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control + standing-subagent-instructions + skill-procedural-playbook + role-specific-orchestrator-instructions + per-feed-watcher-stub + library-conventions + job-board-contract + **design-index-catalog**.

§the-named-modal-alternation: shape-addition (cycles 281-306) + shape-extension (cycles 307-308) + shape-addition (cycle 309). The cluster IS now demonstrably modal-alternating. **§the-named-three-shape-events**: 11 additions + 2 extensions + 1 addition.

- **§the-named-meta-designs-vs-project-designs-distinction** (first-explicit-observation):

> Meta-designs for the garden itself: architectural proposals for how the garden's roles, skills, journal, and host infrastructure should evolve. ... Project-specific designs (e.g. for `endojs/endo-but-for-bots`) do not live here; they live under that project's upstream repo (typically `designs/<slug>.md` on a roadmap branch like `llm`).

**§the-named-two-named-design-locations**: garden-meta-designs (here) + project-specific-designs (upstream repo). **§the-named-meta-vs-object-distinction-extends** from cycle 303's named-meta-vs-object-distinction-at-the-role-level. **§two-cycles-with-named-meta-vs-object-distinction** (303 + 309).

§the-named-four-named-meta-design-subjects: roles + skills + journal + host infrastructure. **§the-named-four-named-garden-evolution-axes**.

§the-named-llm-IS-named-roadmap-branch-shape: "designs/<slug>.md on a roadmap branch like `llm`" names the design-on-roadmap-branch convention.

- **§four-named-status-values-for-designs** (first-explicit-observation):

> | Status  | Proposed \| Accepted \| Implemented \| Withdrawn |

**§four-named-design-status-values**: Proposed + Accepted + Implemented + Withdrawn. **§two-named-four-status-value-sets-in-the-garden**: cycle 305 conventions.md named §four-named-status-values-for-sections (current + stale + superseded + conflicted); cycle 309 designs/README.md names §four-named-status-values-for-designs (Proposed + Accepted + Implemented + Withdrawn). Same arity (four), distinct semantics. **§the-named-arity-shared-distinct-semantics**.

§the-named-status-semantics-IS-named-explicit: each named status has a named meaning paragraph. **§four-named-status-meanings-IS-explicit**.

§the-named-Proposed-IS-named-PR-open-state: "the design has a PR open against the garden and IS under maintainer review." **§the-named-PR-IS-the-Proposed-marker**.

§the-named-Accepted-IS-named-merged-state: "the maintainer has approved the design; implementation IS in flight or queued. The merged design document IS the canonical statement". **§the-named-merge-marks-Accepted-transition**.

§the-named-Implemented-IS-named-roles-skills-scripts-exist-on-main: "the roles / skills / scripts described by the design exist on `main` and are in active use." **§the-named-design-IS-named-realized-when-implementation-exists**.

§the-named-Withdrawn-IS-named-non-adopted-but-preserved: "The document remains as the record of what was considered and why it was not pursued." **§the-named-rejected-design-IS-named-preserved-not-deleted**. Extends cycle 302's named-additive-pruning-NOT-deletion + cycle 305's named-append-only-discipline + cycle 308's named-do-not-rewrite-history-discipline. **§five-cycles-with-named-preservation-over-deletion-discipline** (302 + 305 + 308 + ... + 309).

- **§the-named-PR-against-garden-exception** (first-explicit-observation):

> The garden's `CLAUDE.md` § Conventions states that the garden does not generally open pull requests against itself. Garden designs are the deliberate exception: a substantial architectural change IS opened as a PR so the maintainer can review and comment in GitHub's PR interface, rather than landing directly on `main`. Smaller changes (single role edits, skill additions, notes-from-the-field rows) continue to land directly on `main` per the existing convention.

**§the-named-PR-against-garden-exception**: garden-meta-designs are the deliberate exception to the named-no-PR-workflows-for-the-garden's-own-repo (cycle 299). **§two-cycles-with-named-no-PR-vs-PR-exception** (299 + 309). **§the-named-exception-IS-named-deliberate-not-incidental**.

§the-named-substantial-vs-smaller-change-discriminator: substantial architectural change → PR; smaller changes (single role edits + skill additions + notes-from-the-field rows) → main. **§the-named-magnitude-discriminator**. **§three-named-smaller-change-classes** (role-edits + skill-additions + notes-from-the-field-rows).

§the-named-PR-IS-named-discussion-venue: "the maintainer can review and comment in GitHub's PR interface". **§the-named-PR-IS-named-deliberation-surface**. **§the-named-GitHub-PR-IS-named-the-named-deliberation-substrate**.

- **§three-named-design-metadata-fields** (first-explicit-observation):

> | Created | YYYY-MM-DD |
> | Author  | <role-or-name> |
> | Status  | Proposed \| Accepted \| Implemented \| Withdrawn |

**§three-named-design-metadata-fields**: Created + Author + Status. **§the-named-metadata-table-at-top-discipline**.

§the-named-named-metadata-table-shape-IS-named-distinct-from-frontmatter: this IS a Markdown table at the top, not a YAML frontmatter block. Contrast with cycle 305 conventions.md's §eleven-named-section-frontmatter-fields and cycle 299/301/302/303 named-three-named-frontmatter-fields. **§two-named-metadata-shapes-in-the-garden**: YAML frontmatter (most garden docs) + Markdown metadata table (garden-meta-designs). **§the-named-metadata-shape-IS-not-universally-YAML**.

§the-named-Author-named-role-OR-name: "<role-or-name>" — the author field accepts either a role slug or a name. **§the-named-author-field-IS-multi-format**.

- **§the-named-design-index-table-shape** (first-explicit-observation):

> | Design | Status | Summary |
> | --- | --- | --- |
> | [driver.md](driver.md) | Proposed | Pivot the PR-creation flow from claude-on-top orchestration to claude-under-script worker pool with role-specific job boards. |

**§three-named-design-index-table-columns**: Design + Status + Summary. **§the-named-index-table-shape**.

§the-named-only-one-design-listed-IS-named-evidence-of-design-discipline-density: as of the file's snapshot, only driver.md IS in the index. The garden's meta-designs are deliberately scarce (most garden changes are "smaller changes" that don't need a PR). **§the-named-scarce-design-list-IS-named-evidence-of-meta-design-restraint**.

§the-named-driver-md-IS-the-named-only-named-design-in-the-current-index: extends cycle 281's named-driver-md-design-ingest. **§the-named-cycle-281-ingested-the-only-design-in-the-index-as-of-2026-06-11**.

- **§the-named-cycle-309-IS-the-fourteenth-garden-source-and-the-resumption-of-shape-addition-mode** (first-explicit-observation):

§fourteen-cycles-with-garden-repo-source-ingest (281 + 297 + 298 + 299 + 300 + 301 + 302 + 303 + 304 + 305 + 306 + 307 + 308 + 309).

§twelve-named-shapes-of-garden-self-documentation: cycle 309 adds the twelfth shape (design-index-catalog), breaking the cycle 307-308 shape-extension streak. **§the-named-extension-streak-IS-named-bounded-at-two**.

§the-named-modal-alternation-IS-named-established-as-a-pattern: the cluster IS now demonstrably modal between addition and extension. **§the-named-modes-IS-named-two**. **§the-named-modal-alternation-IS-named-pattern**.

§the-named-thirty-line-source-IS-the-smallest-garden-ingest-yet: cycle 309's source IS 30 lines, the smallest in the cluster (next smallest: cycle 304 watcher.sh at 60 lines + cycle 308 self-improvement at 84 lines). **§the-named-smallest-source-IS-the-named-catalog**: the design-index-catalog IS structurally small because it's an INDEX, not the indexed content.

## Cross-cycle pattern accumulation

- **§fourteen-cycles-with-garden-repo-source-ingest**: 281 + 297 + 298 + 299 + 300 + 301 + 302 + 303 + 304 + 305 + 306 + 307 + 308 + 309.
- **§twelve-named-shapes-of-garden-self-documentation**: proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control + standing-subagent-instructions + skill-procedural-playbook + role-specific-orchestrator-instructions + per-feed-watcher-stub + library-conventions + job-board-contract + design-index-catalog.
- **§the-named-modal-alternation**: shape-addition (281-306; eleven additions) + shape-extension (307-308; two extensions) + shape-addition (309; one addition resumes the mode).
- **§the-named-three-shape-events-now**: 11 additions + 2 extensions + 1 addition = 14 cycles.
- **§two-cycles-with-named-meta-vs-object-distinction**: 303 (role-level) + 309 (design-location-level).
- **§two-named-four-status-value-sets-in-the-garden**: 305 sections-status (current + stale + superseded + conflicted) + 309 designs-status (Proposed + Accepted + Implemented + Withdrawn). **§the-named-arity-shared-distinct-semantics**.
- **§two-cycles-with-named-no-PR-vs-PR-exception**: 299 (named the convention) + 309 (named the deliberate exception). **§the-named-rule-and-exception-pair-across-cycles**.
- **§five-cycles-with-named-preservation-over-deletion-discipline**: 302 + 305 + 308 + 309 (Withdrawn-preserved) + the various append-only cycles. Actually counting strictly: 302 (named-additive-pruning-NOT-deletion + named-no-delete-discipline) + 305 (named-journal-IS-append-only + named-staleness-supersession-contradiction) + 308 (named-do-not-rewrite-history-discipline) + 309 (named-rejected-design-IS-named-preserved-not-deleted). **§four-cycles-with-named-preservation-over-deletion-discipline** (more conservatively).
- **§two-named-metadata-shapes-in-the-garden**: YAML frontmatter (most docs) + Markdown metadata table (design docs). **§the-named-metadata-shape-IS-not-universally-YAML**.
- **§the-named-fourteen-cycle-bridge**: 296-309.

## Notes

- Cycle 309 IS the **return to shape-addition mode** after two consecutive shape-extension cycles (307 + 308). The named-modal-alternation IS now demonstrably established as a pattern.
- The named-design-index-catalog-shape IS structurally distinct from the named-proposed-design shape (cycle 281): the catalog IS the meta-index; the proposed-design IS an individual design doc. **§the-named-index-vs-indexed-content-distinction**.
- The named-four-status-values-for-designs (Proposed + Accepted + Implemented + Withdrawn) IS a *workflow-stage* taxonomy; the named-four-status-values-for-sections (current + stale + superseded + conflicted) IS a *correctness-state* taxonomy. **§the-named-distinct-taxonomy-axes-with-same-arity**. **§the-named-coincidence-of-arity-not-of-meaning**.
- The named-PR-against-garden-exception IS a §two-cycles-with-named-rule-and-named-exception-pair (cycle 299 named the rule; cycle 309 names the exception). This IS a new shape of cross-cycle pair: **§the-named-rule-and-exception-pair-across-cycles**. Distinct from the four design-and-instance pairs (where the second cycle realizes what the first cycle named); here the second cycle *qualifies* what the first cycle stated.
- The named-thirty-line-source IS the smallest garden ingest in the cluster. The named-pattern-of-pattern enumeration now includes: smallest = 30 (cycle 309); next smallest = 60 (cycle 304); next = 84 (cycle 308); largest = 621 (cycle 307). **§the-named-size-variation-across-the-cluster**.
- The cluster IS now fourteen sources deep with twelve named shapes, four design-and-instance pairs, the named-rule-and-exception-pair, and the named-modal-alternation. The named-pattern-of-pattern has accumulated rich enough that further extensions risk diminishing returns; cycle 310 might be best pivoted away from garden self-reference entirely.
