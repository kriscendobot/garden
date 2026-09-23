---
kind: result
role: liaison
dispatch-root: dispatches/liaison--b5388f
host: endolin
date: 2026-06-16
purpose: refactor-multisection-docs
refs:
  - entries/2026/06/16/003708Z-dispatch-liaison-b5388f.md
---

# Result — refactor multi-section library docs into frontmatter-plus-single-body invariant

## Outcome

The end-state invariant is achieved: **no file under `journal/library/sections/*.md` (excluding `README.md`) has any `^#` or `^##` heading in the body**. A programmatic scan of all 5450 final files reported zero violations.

## Numbers

- **867 source documents surveyed** (the original count was 868; the dispatch prompt cited 868 but the actual `ls` count when work started was 867).
- **53 were already single-section** (no body H1/H2 headings).
- **291 were single-section with one repeated title heading** (an H1 or H2 matching the frontmatter title). Stripped the heading; no children created.
- **523 were multi-section** (multiple body headings). Split into a parent index plus per-subsection child files.
- **4583 child files created** across the 523 splits.
- **Final file count**: 5450 sections (867 parents + 4583 children).
- **Pushed in 19 commits** to `origin/journal`: 18 refactor batches of ~50 originals each, plus one README regeneration commit.

## What got written

For each multi-section document:
- The **parent file** keeps its original filename (so existing cross-references in `library/concepts/`, `library/topics/`, and other section docs continue to resolve). Frontmatter gains `kind: index` and `section_count: N`. Body becomes the original preamble (the abstract paragraph) plus a `Sections:` label and a bulleted markdown list of child links, plus the trailing `Source:` footer.
- **Each child file** copies frontmatter from the parent with `title:` set to the subsection's heading text and a new `parent:` field naming the parent slug. Body is the subsection's content with the heading line removed (the title is in frontmatter now). The `Source:` footer from the parent is propagated to each child so children are self-contained.

For each single-heading document, the heading line was removed (the title is already in frontmatter). No structural change otherwise.

`library/sections/README.md` was regenerated with a new `## Current sections (auto-generated index, alphabetical by source)` block at the top that groups every file by source-slug prefix, with parents listed and children nested below. The historical per-cycle ingest log is preserved unchanged under `## Historical ingest log (preserved for chronological context)`.

## Patterns observed in multi-section docs

These will be useful for the librarian's future authoring discipline:

- **Repeated title in body**: 291 files (third of all docs) had a single H2 (or H1) that simply repeated the frontmatter `title:`. This is the most common shape and the easiest to flatten. The original author's reflex was to render the title twice — in frontmatter and again as the first body heading. Going forward, librarian authors should not include a redundant title heading.
- **Multi-section abstract-then-subsections**: the canonical multi-section shape is a `> Abstract: ...` block (or untagged paragraph) followed by 2-22 `## Subsection` headings, with a final `Source: [link]` footer. The new structure renders the abstract on the parent only (above the bullet list) and propagates the source footer to every child.
- **`## Source` as its own subsection**: many multi-section docs from the Ymax / endo-but-for-bots / agoric-sdk corpus put provenance ("source repo, source path, commit, ingest cycle") under a `## Source` H2 inside the body. This now becomes a tiny child file. The librarian could move this content into frontmatter in future authoring.
- **H1 doc-title plus H2 subsections**: a small subset (mostly from the agoric-labs / endo-but-for-bots ingest streams) opens the body with a redundant `# Long Title` and then proceeds with `## Subsection` headings. The refactor detects this case (H1 matches frontmatter title and has no content before the first H2) and drops the H1 so the H2s become the real subsection set.
- **Pure-H1 multi-section**: 10 files used `# Subsection` (rather than `## Subsection`) as section dividers. Handled identically to H2 splits.
- **Very long filenames**: a handful of original section slugs are 230+ bytes (compound titles like `assets-should-outlive-execution-paths-and-three-state-router-authorization-and-self-dispatch-with-calldata-rewrite-and-resolvers-as-bounded-fact-reporters`). Children of those parents would exceed the 255-byte `NAME_MAX` limit if naively concatenated. The refactor truncates the parent slug to a short hash-suffixed prefix when the naive name exceeds 240 bytes, keeping children below the FS limit.

## Caveats and remaining work

- **Child filenames are sometimes truncated**. When `<parent_slug>--<child_slug>.md` would exceed 240 bytes, the refactor truncates the parent component and appends an 8-character SHA1 prefix of the full parent slug for disambiguation. About 30-50 files have these truncated names; they remain unique and resolvable but are less self-describing than the parent. Future librarian authoring should keep section slugs concise enough that compound forms stay under 200 bytes.
- **Cross-references unchanged**. The 2432 `../sections/<file>.md` cross-references from `library/concepts/`, `library/topics/`, etc., all point at parent slugs that were preserved as parent index files. Zero references used anchor fragments (`...#anchor`), so no link updates were needed. If a future reader follows one of those links and wants a specific subsection, they navigate from the parent index's bullet list.
- **The Sections: bullet list is plain prose, not a heading**. Each parent index uses a `Sections:` label followed by a blank line and a markdown bullet list. The label is *not* an H2 (`^##`), so it does not violate the invariant. If the librarian later wants the bullet list under an explicit heading, the invariant would need to be relaxed first.
- **`library/sources/*.md` left as-is**. The user excluded these from the refactor unless they had broken links. None did (no anchor fragments, all parent slugs preserved), so the sources index was not touched.
- **`library/sections/README.md` is the only file in the directory that retains body headings**. The user explicitly carved it out as the index file. Its body now starts with `## Current sections ...` and includes `### <source-slug>` per source group.
- **Tools live under `dispatches/liaison--b5388f/tools/`** and will be removed when the orchestrator tears the dispatch root down. The refactor script (`refactor.py`) is reproducible from the description in this entry if a future librarian needs to re-run it.

## Self-improvement

Nothing this time. The dispatch was a one-off structural refactor with an explicit invariant; the operating norms in the liaison and `roles/COMMON.md` files were sufficient as-is.
