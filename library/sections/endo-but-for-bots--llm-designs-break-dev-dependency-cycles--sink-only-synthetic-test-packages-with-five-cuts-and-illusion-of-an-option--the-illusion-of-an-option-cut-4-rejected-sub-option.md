---
source: designs/break-dev-dependency-cycles.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/break-dev-dependency-cycles.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - repository-governance
  - tooling
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sink-only-package-pattern
cycle: 186
lane: designs
status: current
title: §The-"illusion of an option" (Cut 4 rejected sub-option)
parent: endo-but-for-bots--llm-designs-break-dev-dependency-cycles--sink-only-synthetic-test-packages-with-five-cuts-and-illusion-of-an-option
---

§Cut-4-(`@endo/harden`):

```
Considered and rejected: an in-place rewrite that replaces
each `import 'ses'` with `import './_lockdown.js'` (the file
already exists alongside the other tests in
packages/harden/test/).  `_lockdown.js` itself imports
`'ses'`, so this only renames the edge rather than cutting it.
Per kriskowal review (PR #206 [#discussion_r3216062975](...))
this is "an illusion of an option" and is dropped from the
proposal.
```

§"An illusion of an option" — kriskowal's review phrase
preserved verbatim. §The-proposed-shim-renames-the-edge-rather-
than-cutting-it because `_lockdown.js` itself imports `'ses'`.
§The-edge-from-`@endo/harden`-to-`ses` survives the rename.

§This-is-§see-through-the-form-to-the-substance discipline.
§The-rewrite looks like a cycle-break but isn't, because the
import target is still in the SCC.

§Tier-1-borrowing: §illusion-of-an-option pattern — §a-fix-
that-looks-like-a-cycle-break-but-only-renames-the-edge. §The-
substantive-test: does the cycle-break candidate live outside
the SCC?

§Compare-to-cycle-182-debugger's §three-option-architectural-
decision (A chosen; B rejected because xsDebug.c internals not
public API; C rejected because massive fork divergence). §Both-
are-§rejected-options-named-with-reasoning. §Cycle-186's
§illusion-of-an-option-rejection-language is the §sharpest in
the corpus.
