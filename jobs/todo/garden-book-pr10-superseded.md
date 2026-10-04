---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/garden-book. PR #11 (feat(build): weave the illuminated plates into the edition) just merged to main, wiring the 25 MANIFEST-approved illuminations from PR #9 into the build via a placement table (build/illuminations.mjs).

PR #10 ("feat(art): wire illuminated chapter illustrations", branch garden-book-chapter-illustrations-build, still DRAFT, mergeable, 2 ahead/3 behind main) independently wired a *different* set of 25 SVGs (e.g. art/illus-ch1-market.svg, art/illus-ch1-metamorphoses.svg — short names, none listed in art/MANIFEST.md) directly into build/assemble-book.mjs, build/render-book.mjs, and build/styles.css. It predates and duplicates the now-landed #11 weave with an unapproved, parallel art set.

Verify the overlap (diff #10 against #11's placement table and MANIFEST.md) and, once confirmed superseded, close #10 with a comment pointing to merged #11 as the landed equivalent. Do not merge #10's art or build changes.
