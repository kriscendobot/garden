---
title: Key moves
section-slug: garden--journal-library-conventions-md--tenth-garden-source-and-library-conventions-shape-and-third-design-instance-pair
source-slug: garden--journal-library-conventions-md
url: https://github.com/kriskowal/garden/blob/journal/library/conventions.md
authors: [Endo project (collective; bootstrap-author = liaison 2026-05-13)]
repo: kriskowal/garden
path: journal/library/conventions.md
total-lines: 483
ingest-cycle: 305
ingest-date: 2026-06-11
lane: designs
scope: full
branch: journal
parent: garden--journal-library-conventions-md--tenth-garden-source-and-library-conventions-shape-and-third-design-instance-pair
---

- **§the-named-library-conventions-shape** (first-explicit-observation): the tenth named shape. The conventions document IS the data-structure spec for the garden's library; library-lookup SKILL.md (cycle 302) IS the operation; conventions.md IS the structure. **§the-named-spec-and-procedure-pair-now-realized** (cycle 302 named the pair; cycle 305 completes it by ingesting the spec).

§the-named-cross-branch-source: this IS the first journal-branch document in the garden cluster. Cycle 297 WORKTREES.md (main branch) named the journal-branch worktree shape; cycle 305 ingests a document FROM that worktree. **§the-named-WORKTREES-design-pointer-to-journal-implementation** extends across cycles 297 + 305.

§the-named-bootstrap-attribution: "Authored by: liaison (bootstrap, 2026-05-13)." The attribution names BOTH role AND a specific named bootstrap date. **§the-named-bootstrap-marker**. **§the-named-creation-date-IS-named-bootstrap-not-just-creation**.

- **§the-named-file-naming-discipline** (first-explicit-observation):

```
sections/<source-slug>--<section-slug>.md
sources/<source-slug>.md
topics/<topic-slug>.md
```

**§the-named-three-named-file-shapes-in-the-library**: section + source-index + topic-page. Each lives in its own named directory with its own named slug shape.

§the-named-source-slug-IS-kebab-case-with-directory-boundaries-flattened: "compresses the source path into kebab-case with directory boundaries flattened to single hyphens, prefixed by the upstream project." **§the-named-path-flattening-discipline**.

§the-named-three-named-prefix-shortenings: `pkg-<short>` vs `packages/<long>`; `docs-<file>` vs `docs/<file>`. **§the-named-pragmatic-slug-shortening** — extends cycle 302's reference to the cycle's slug evolution; conventions names the abbreviation rules explicitly.

§the-named-three-named-source-slug-examples: `endo--agents` + `endo--docs-lockdown` + `endo--pkg-ses-readme` + `endo--pkg-ses-docs-secure-coding-guide`. **§four-named-canonical-examples**.

§the-named-section-slug-IS-kebab-case-of-section-heading: "drop backticks, drop possessives". **§the-named-typographic-stripping-discipline**.

§the-named-H2-as-default-section-boundary: "Use the H2 heading as the section boundary by default; descend to H3 only when an H2 is a thin wrapper around several substantially-different H3 topics." **§the-named-default-section-granularity** + **§the-named-conditional-deeper-descent**.

- **§the-named-eleven-named-section-frontmatter-fields** (first-explicit-observation):

```yaml
title + source + source_repo + source_commit + source_date +
source_authors + ingested + ingested_by + topics + status +
supersedes (optional) + contradicts (optional) + notes (optional)
```

**§eleven-named-section-frontmatter-fields** (eight required + three optional). **§the-named-required-vs-optional-frontmatter-distinction**.

§the-named-file-specific-commit-not-repo-HEAD: the `source_commit:` field IS the FILE-SPECIFIC commit, NOT the repo's HEAD. The convention names the warning explicitly: "Recording the repo's HEAD here breaks the idempotency check because every cycle would see a mismatch." **§the-named-idempotency-check-via-file-specific-commit**. **§the-named-anti-divergence-by-recording-the-right-anchor**.

§the-named-file-specific-commit-recipe: `git --git-dir=worktrees/<owner>-<repo>.git log -1 --format=%H <branch> -- <path>`. **§the-named-recipe-IS-named-with-named-git-flags**.

§the-named-status-values: `current | stale | superseded | conflicted`. **§four-named-status-values-for-sections**.

§the-named-body-shape-IS-named-three-named-parts: frontmatter + Abstract + body + Source footer. **§the-named-Abstract-IS-named-specific-enough-to-use-as-exit-criterion** (per skills/context-library/SKILL.md).

§the-named-Source-footer-format: `Source: [<path>](https://github.com/...<sha>/<path>) at commit `<short-sha>`.` **§the-named-named-footer-format**.

- **§the-named-source-document-index-frontmatter-IS-distinct-from-section-frontmatter** (first-explicit-observation): the source-index file has fewer fields (no topics, but has section_count). **§two-named-frontmatter-shapes-within-the-library-discipline** (section + source-index).

§the-named-Section-Topics-Status-table-format: the source-index body has a three-column table listing the section files. **§the-named-three-column-table-shape**.

- **§the-named-topic-pages-have-NO-frontmatter** (first-explicit-observation): "topics are catalog pages, not first-class content". **§the-named-three-content-classes-of-the-library-files**: first-class (sections + sources, with frontmatter) + catalog (topics, no frontmatter). **§the-named-frontmatter-IS-named-content-class-marker**.

§the-named-topic-page-three-named-body-parts: Abstract + Sections-table + See-also-list. **§the-named-three-body-parts**.

- **§the-named-staleness-supersession-contradiction-section** (first-explicit-observation):

> The journal is append-only. We do not edit prior section files in place when they become wrong; instead:
> - Mark a section's `status` field as `stale`, `superseded`, or `conflicted` and add a `notes:` line explaining.
> - If a new section replaces an older one, the new section's `supersedes:` list names the older's slug; the older section's `status` flips to `superseded`.
> - If two sections conflict but neither cleanly supersedes the other, both get `status: conflicted` and `contradicts:` lists naming each other.

**§the-named-journal-IS-append-only-IS-explicit-across-the-discipline**: extends cycle 301's named-append-only-with-most-recent-wins-semantics + cycle 302's named-append-style-where-possible. **§three-cycles-with-named-append-only-discipline** (301 + 302 + 305).

§the-named-three-named-rotation-mechanisms: stale + superseded + conflicted. **§the-named-three-named-deprecation-classes**. **§the-named-deferred-resolution**: "The next reader (likely an indexer or scholar) resolves later."

§the-named-status-flip-IS-named-the-only-in-place-edit: cycle 302's State-section named the skill's mutate-list; cycle 305 names the status-flip exception explicitly. **§the-named-in-place-edit-exception-to-append-only**.

- **§the-named-soft-flag-vs-hard-flag-distinction** (first-explicit-observation):

> ### Soft-flag for cross-source overlap (not contradiction)
>
> When two sources address the same material at different abstraction levels (reference-shaped summary vs background-shaped detail vs tutorial-shaped walkthrough), keep both with `status: current` and use the `notes:` field to cross-reference. This is **not** a contradiction; the shapes serve different reader needs. Reserve `status: conflicted` for actual semantic disagreements about the same concept at the same level.

**§two-named-overlap-handling-shapes**: soft-flag (keep both + cross-reference) + hard-flag (conflicted status). **§the-named-default-IS-soft-flag-NOT-hard-flag**. **§the-named-shape-determines-the-handling**.

§the-named-three-canonical-overlap-examples: `docs/lockdown.md` (canonical detail) vs `docs/reference.md` (reference summary) vs `docs/guide.md` (guide-shape); per-API-verb sections vs api-overview; ses/README's ecosystem-compatibility vs guide's library-compatibility. **§the-named-three-shapes-of-the-same-material** (reference + background + tutorial).

§the-named-dated-pattern-emergence: "The pattern of soft-flagging rather than hard-flagging emerged after the docs/reference.md cycle (cycle 8) and was used uniformly through cycle 12 (docs/guide.md)." **§the-named-dated-pattern-emergence-discipline**.

- **§the-named-library-vs-project-distinction** (first-explicit-observation):

> - Library (`journal/library/`): reusable conceptual material, API documentation, security policies, design rationale, agent-facing technical notes. Cross-cutting; one section may apply to multiple projects.
> - Project (`journal/projects/<slug>/`): rules of engagement, identity and credentials, project-specific authority structure, project-bound topic files the scholar grows from `project:`-tagged journal entries.

**§the-named-cross-cutting-vs-project-specific-distinction**. **§the-named-two-named-journal-content-areas** (library + projects).

§the-named-discriminator-IS-named-by-content-shape: "operational rules" → projects; "technical content" → library. **§the-named-operational-vs-technical-distinction**.

§the-named-canonical-discriminator-example: "how the boatman ferries syrups-class work to endo upstream" (project) vs "what `harden` does to an object" (library). **§the-named-canonical-discrimination-examples**.

- **§the-named-topic-taxonomy-seed** (first-explicit-observation):

twenty named topic slugs: hardened-javascript + capability-security + compartments + marshal + eventual-send + captp + ocapn + exo + patterns + bundles + daemon + errors + streams + testing + tooling + repository-governance + agent-conventions + typescript-conventions + security-disclosure + getting-started. **§twenty-named-topic-slugs-in-the-seed-taxonomy**.

§the-named-seed-taxonomy-IS-named-starting-partition: "The seed taxonomy below is a starting partition. Add new topics as the corpus reveals them; merge or split topics if their abstracts begin overlapping per the context-library partitioning rule." **§the-named-grow-and-merge-discipline**.

§the-named-each-topic-IS-named-with-named-scope: each row has the topic slug and a short scope description. **§the-named-topic-IS-named-with-named-one-line-abstract**.

- **§the-named-eight-step-ingestion-procedure** (first-explicit-observation):

```
1. Identify the source: path, commit, last-modified date, primary authors.
2. Read the source heading structure; decide section boundaries.
3. For each section: extract the body, write sections/<source-slug>--<section-slug>.md.
4. Write sources/<source-slug>.md with the section table.
5. For each topic the section touches, append a row to topics/<topic-slug>.md.
6. Update topics/README.md with any new topic abstracts.
7. Update sources/README.md with the new source row.
8. Update sections/README.md (or rely on directory listing if it grows beyond pragmatic).
```

**§eight-named-ingestion-steps**. **§the-named-procedural-recipe-IS-named-explicitly-in-the-conventions**.

- **§the-named-sectioning-shapes-by-source-type** (first-explicit-observation):

> Default: one section per H2 (with H3 descent only when an H2 wraps several substantially-different H3 topics).
>
> Exceptions:
> - Alphabetical or otherwise non-thematic reference documents: aggressively consolidate into 1–3 sections.
> - Single-screen reference docs: consider a single `overview` section if the H2s do not partition naturally into distinct concepts.

**§two-named-sectioning-exceptions**. **§the-named-pragmatic-consolidation-discipline-for-alphabetical-references**. **§the-named-pragmatic-overview-discipline-for-single-screen-docs**.

§the-named-dated-pattern-from-cycle-29: "Pattern from cycle 29's agoric-sdk/docs/env.md." **§the-named-pattern-attribution-IS-named-with-the-source-cycle**.

- **§five-named-consolidation-steps** (first-explicit-observation): pick canonical + flip others' status + update canonical notes + reorganize topic pages + topic-section counts stay the same. **§five-named-steps-for-consolidating-soft-flagged-sections**.

§the-named-canonical-selection-IS-named-by-three-criteria: "the one with the most context, the cleanest framing, or the broadest reader audience". **§three-named-canonical-criteria**.

§the-named-superseded_by-superseded_on-superseded_reason-fields: extends the simple `supersedes:` field with reason + date. **§three-named-supersession-metadata-fields**.

§the-named-superseded-rows-IS-named-moved-out-of-main-table: "move the superseded rows out of the main *Sections* table into a *Superseded sections* subsection that points to the canonical". **§the-named-deferred-visibility-discipline**.

§the-named-soft-flag-remains-the-DEFAULT-discipline: "Soft-flagging (keep both, cross-reference via `notes:`) remains the **default** when the overlap serves different reader audiences ... Hard-supersede only when the overlap is at the same shape and the canonical strictly dominates." **§the-named-bolded-default-emphasis**.

- **§three-named-cycle-derived-principles** (first-explicit-observation): the convention names three principles that emerged during specific cycles (41-43):
  1. **§the-named-shape-not-content-for-upstream-meta-tables** (from cycle 41).
  2. **§the-named-consumers-own-rendering-producers-own-typed-shape** (from cycle 42).
  3. **§the-named-hidden-intrinsic-sampling-via-throwaway-instance-prototype-walk** (from cycle 43).

**§three-named-cycle-derived-principles**. **§the-named-principles-IS-named-with-named-cycle-and-named-source**.

§the-named-each-principle-IS-named-with-named-example: each principle row links to the section file where the principle was first surfaced. **§the-named-principle-IS-named-with-named-section-reference**.

- **§the-named-sources-from-unmerged-PRs-discipline** (first-explicit-observation):

The conventions name when ingesting from an unmerged PR IS appropriate, how to record provenance, the slug-stability requirement, and a three-row lifecycle table. **§the-named-PR-source-lifecycle-shape**.

§the-named-when-it-IS-appropriate: "the PR IS the **canonical source-of-truth** for a design that has not landed because implementation work IS in flight (the design and the implementation are co-evolving and the design IS stable enough to teach from)."

§the-named-do-not-ingest-speculative-or-provisional-PRs: explicit anti-pattern.

§the-named-two-extra-frontmatter-fields-for-PR-sources: source_branch + source_pr + source_pr_state.

§the-named-do-NOT-invent-a-new-status-value: "do **not** invent a new `status:` value (e.g. `draft`) — taxonomy proliferation makes the library harder to query. The combination of fields IS sufficient." **§the-named-anti-taxonomy-proliferation-discipline**.

§the-named-slug-stability-across-merge: "Do not embed the PR number or branch name in the slug; the slug should remain stable across the PR's merge → default-branch transition so that section identities (and inbound cross-references) survive the merge." **§the-named-slug-stability-discipline**.

§the-named-three-named-lifecycle-transitions: force-push + merge + close-without-merge. **§three-named-PR-source-transitions**.

§the-named-fetch-PR-head-recipe: `git --git-dir=worktrees/<owner>-<repo>.git fetch origin pull/<N>/head:refs/pull/<N>/head`. **§the-named-PR-head-fetch-recipe**.

- **§the-named-three-source-kinds** (first-explicit-observation): repo + paper + comment-fragment. Discriminated by `source_kind:` field in frontmatter. **§the-named-source-kind-discriminant-shape**. **§three-distinct-source-kind-schemas**.

§the-named-source-kind-IS-discriminant-for-backward-compatible-schema-evolution: "The discriminant lets future schema additions (`source_kind: chat-cluster`, `source_kind: standards-doc`) stay backward-compatible without breaking the existing source-file shape." **§the-named-discriminant-IS-named-extension-point**.

§the-named-implicit-repo-kind: "Repo sources are `source_kind: repo` (implicit if absent for backward compatibility)". **§the-named-implicit-default-for-backward-compatibility**.

- **§the-named-paper-source-schema** (first-explicit-observation):

Distinct fields: source_kind + source_authors + source_title + source_year + source_venue + source_url + source_pdf_sha256 + source_pdf_pages + source_mirror_url + ingested + ingested_by + section_count + status. **§twelve-named-paper-frontmatter-fields** (with section_count and status as inherited core).

§the-named-source_pdf_sha256-IS-named-idempotency-anchor-for-papers: "replaces source_commit as the anchor for the idempotency check. Papers are static (the bytes do not change once published)". **§the-named-discriminant-determines-the-idempotency-anchor**.

§the-named-canonical-URL-vs-mirror-URL-distinction: "one canonical URL even if you fetched from a mirror". **§the-named-canonical-IS-fixed-mirror-IS-variable**. **§the-named-canonical-URL-IS-pointer-mirror-URL-IS-actual-source**.

§the-named-degenerate-paper-idempotency-check: "Papers are static (the bytes do not change once published), so the check is degenerate". **§the-named-degenerate-check-IS-named-explicit**.

§the-named-revision-handling-shape: "If a paper IS re-published with revisions (rare; usually a new venue with a new SHA), the new ingest gets its own source slug." **§the-named-revisions-are-distinct-sources-not-updates**.

- **§the-named-Translation-block-convention** (first-explicit-observation):

> E-vat-language papers use idiom that diverges from Endo's surface (send vs E(), vat vs compartment, sealer vs brand, etc.). Each section file authored under a paper source includes a brief `## Translation` table where the idiom differs, mapping paper-side terms to Endo equivalents.

**§the-named-domain-translation-table-discipline**. **§the-named-not-an-exhaustive-glossary-just-section-specific-terms**. **§the-named-translation-discipline-as-named-bridging-shape**.

§the-named-universal-translation-table-IS-pulled-in-when-stable: "Recurring translations ... may be lifted into this conventions file once a few papers are in." **§the-named-deferred-lift-shape**.

- **§six-named-PDF-sources-in-priority-order** (first-explicit-observation):

1. Original venue PDF (Springer LNCS, ACM Digital Library, IEEE)
2. Author / collaborator faculty pages
3. CiteSeerX cached copies
4. Google Scholar's cached-PDF link
5. `papers.agoric.com`
6. arXiv (later SES / verification work only)

**§six-named-PDF-sources-in-priority-order**. **§the-named-fallback-priority-list**.

§the-named-compute-SHA-on-the-bytes-you-fetched-regardless-of-source: "Compute the SHA-256 of the bytes you actually ingested, regardless of which source you fetched from. The SHA pins the bytes; the canonical URL stays a fixed pointer for the source-file frontmatter." **§the-named-anchor-vs-pointer-distinction**.

§the-named-erights-org-IS-named-intermittently-down: explicit anti-source named for unreliability. **§the-named-anti-source-IS-named-with-reason**.

- **§the-named-comment-fragment-source-schema** (first-explicit-observation):

Distinct fields: source_kind: comment-fragment + source_line_range + comment_subject + (file-specific source_commit). **§the-named-comment-fragment-frontmatter-three-distinguishing-fields**.

§the-named-line-range-IS-named-snapshot-not-live-cursor: "the range *as of the recorded source_commit*; document this is a snapshot, not a live cursor". **§the-named-snapshot-vs-live-cursor-distinction**. **§the-named-point-in-time-marker**.

§the-named-four-named-longform-comment-shapes:
1. JSDoc block (≥25 lines / ≥3 paragraphs OR ≥40 lines)
2. Bare-block comment (similar length)
3. Run of `// ...` lines (≥8 consecutive)
4. File-level header comment (≥20 lines of prose)

**§four-named-longform-comment-shapes** with named-quantitative-thresholds.

§the-named-skip-pure-type-annotation-JSDoc: explicit anti-pattern. **§the-named-trivial-comment-anti-pattern**.

§the-named-slug-divergence-from-older-pkg-short-form: "The new slug convention diverges from the older `endo--pkg-<short>-...` shortening that existed for repo doc-file sources ... new repo doc-file ingests are not retroactively renamed." **§the-named-slug-evolution-with-no-retroactive-rename-discipline**.

§the-named-line-range-update-IS-named-second-permitted-in-place-edit: "If it was just moved, update `source_line_range` (this IS the second permitted in-place edit on a section file, alongside the `status` flip)." **§two-named-permitted-in-place-edits** (status flip + line-range update).

- **§the-named-Notice-Investigate-Propose-discipline** (first-explicit-observation):

> If a longform comment makes a claim the surrounding code does not honor (drift between comment and code), the scholar should *notice* during ingest, investigate against the rest of the codebase, and if a real divergence is found draft a boatman missive proposing whichever direction is right.

**§the-named-three-named-actions-on-comment-vs-code-drift**: notice + investigate + propose. **§the-named-three-named-stages**. **§the-named-highest-payoff-upstream-contribution-class**.

§the-named-maintainer-values-comment-accuracy-IS-named-rationale: "since the maintainer values comment accuracy." **§the-named-explicit-rationale-grounded-in-maintainer-preference**.

- **§the-named-keyword-index-and-concept-directory-section** (first-explicit-observation):

The conventions name the third indexing axis (alongside sources and topics): the keyword index + concept directory. **§three-indexing-axes-NAMED-AGAIN** (extends cycle 301 + 302). **§three-cycles-with-named-three-indexing-axes** (301 + 302 + 305).

§the-named-concept-pages-IS-named-third-axis-and-name-for-the-axis-of-the-named-unit-IS-reader-looking-up: "Topics partition by subject; sources partition by provenance; concepts partition by the unit a reader IS actually looking up." **§the-named-three-named-partition-axes** (by-subject + by-provenance + by-unit).

- **§the-named-concept-page-shape** (first-explicit-observation):

```yaml
---
id: <concept-id>                    # kebab-case slug, stable across rename
aliases: [keyword1, keyword2, ...]  # all the keywords that resolve here
topics: [topic1, topic2, ...]       # topic pages this concept files under
---
```

```markdown
# <concept-id>

One-paragraph definition / framing.

## Sections that touch this concept

| Section | One-line summary |
|---|---|

## See also

- [[other-concept-id]] — relationship.
```

**§the-named-concept-page-three-named-frontmatter-fields**: id + aliases + topics. **§the-named-concept-page-three-named-body-parts**: definition + sections-table + see-also. **§the-named-aliases-IS-named-multi-keyword-shape**.

§the-named-See-also-allows-contradicting-concept-references: "The `See also` block IS allowed (and encouraged) to point at concept-ids that *contradict* or *abandon* the same concept under a different framing." **§the-named-See-also-IS-named-multi-perspective** (extends cycle 302's named-concept-pages-may-point-at-sections-that-contradict-the-concept).

§the-named-canonical-example: `crdt-in-formula-persistence` — extends cycle 302's named-canonical-example. **§two-cycles-with-named-canonical-example-crdt-in-formula-persistence** (302 + 305).

- **§the-named-keyword-index-shape** (first-explicit-observation):

```
<keyword or phrase> | <concept-id>
```

**§the-named-pipe-delimited-keyword-row-shape**. **§two-cycles-with-named-pipe-delimited-keyword-row-shape** (302 + 305).

§the-named-code-symbol-keywords-IS-backticked: extends cycle 302's named-backticks-for-code-symbols-discipline. **§two-cycles-with-named-backticks-for-code-symbols-discipline** (302 + 305).

§the-named-letter-case-IS-preserved-when-meaningful: "Letter case IS preserved when meaningful." **§the-named-meaningful-case-preservation**.

§the-named-grepped-not-read-IS-EXPLICIT: "The index IS meant to be **grepped, not read by eye**." **§two-cycles-with-named-grepped-not-read-discipline** (302 + 305).

§the-named-library-lookup-skill-IS-named-as-the-named-mediator: "Use the [`library-lookup`](...) skill rather than reading `keywords.md` linearly." **§two-cycles-with-named-skill-mediated-access** (302 + 305).

- **§the-named-indexing-on-the-fly-discipline** (first-explicit-observation):

> The librarian's job is not just to find information but to ensure that the *next* search for the same information either succeeds where it did not before, or succeeds faster than it did before. Every lookup is therefore both a *find* operation and an *index-improvement* operation. The `library-lookup` skill is the operational form of this discipline.

**§the-named-three-cycle-property-procedure-rationale-chain**: cycle 301 (COMMON.md) named the property; cycle 302 (library-lookup SKILL.md) IS the procedural realization; cycle 305 (conventions.md) IS the explanatory rationale (the *why*). **§three-cycles-naming-the-same-discipline-from-three-angles**.

§the-named-three-corresponding-maintenance-actions: add the shortcut + prune the distraction + draft the missing concept. **§three-named-corresponding-maintenance-actions**.

§the-named-three-vs-four-writeback-actions-distinction: conventions.md names THREE actions; cycle 302's library-lookup SKILL.md names FOUR (4a + 4b + 4c + 4d queue-scholar-review). The 4d action IS named in conventions.md ("a follow-up missive to scholar (one per cycle, not one per page) requests review and topic-page integration") but NOT counted as a fourth action — it IS a downstream consequence rather than a discrete writeback. **§the-named-three-vs-four-writeback-actions-distinction**.

§the-named-permission-statement-IS-named-by-skill-not-by-role: "any role that uses the `library-lookup` skill may write these inline maintenance updates." **§the-named-skill-mediated-permission-discipline**.

§the-named-major-restructuring-stays-scholars-province: "Major restructuring (new topics, source-index changes, concept merges) remains scholar's province." **§the-named-scope-IS-named-by-action-magnitude**. **§the-named-scholar-province-extends** from cycle 302's named-scholar-vs-librarian-province-boundary.

- **§the-named-skill-responsibility-IS-named-make-the-discipline-trivial** (first-explicit-observation):

> The skill's responsibility is to make this discipline trivial — its procedure section names when to perform each of the three actions, and the skill packages the writeback so the caller does not have to remember the file paths.

**§the-named-skill-IS-named-discipline-trivializer**. **§the-named-pre-package-the-writeback-discipline**. **§the-named-caller-IS-named-relieved-of-file-path-memory**.

- **§the-named-cycle-305-IS-the-named-tenth-garden-source-and-the-first-journal-branch-source** (first-explicit-observation):

The garden cluster IS now ten cycles deep. **§ten-cycles-with-garden-repo-source-ingest**. **§ten-named-shapes-of-garden-self-documentation**.

§the-named-cross-branch-shape: nine cycles main-branch + one cycle journal-branch. **§the-named-nine-to-one-main-to-journal-ratio**. **§the-named-multi-branch-self-documentation-shape**.

§the-named-third-design-and-instance-pair: cycle 302 named conventions.md as the spec; cycle 305 IS the spec. **§three-named-design-and-instance-pairs-across-the-garden-cluster** (299→301 + 301→302 + 302→305).
