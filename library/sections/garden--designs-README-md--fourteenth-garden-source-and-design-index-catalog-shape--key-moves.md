---
title: Key moves
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
parent: garden--designs-README-md--fourteenth-garden-source-and-design-index-catalog-shape
---

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
