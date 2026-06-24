---
source: packages/init + packages/lockdown (entry-point files)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/init
source_path: packages/init/*.js, packages/lockdown/*.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - getting-started
genre: §endo-source-comment-fragment §canonical-bootstrap-pattern
cycle: 183
lane: chat
status: current
title: The canonical bootstrap entry taxonomy with two-phase init, tolerance ladder, sniff-LOCKDOWN_OPTIONS escape hatch, and NOTE-TO-REVIEWERS discipline
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

> §Chat-lane after cycle 182's designs-lane. §The-seventeenth-
> consecutive designs/chat alternation cycle (166-183). §This-
> cycle-ingests the §bootstrap-package-pair: `@endo/init` (8
> entry-point files, ~70 lines) + `@endo/lockdown` (4 entry-
> point files + post.js, ~275 lines). §Together-they-define
> how a hardened-JS program starts up.

`packages/init/` and `packages/lockdown/` form the §canonical-
bootstrap-entry-taxonomy. §The-12-entry-point-files compose a
§tolerance-ladder from default-safe through debug-tolerant to
unsafe-fast, all built on a §two-phase-init pattern (pre →
commit) that separates §shim-installation from §lockdown-
invocation.

§The-single-most-structurally-interesting-move is §two-phase-
init-with-tolerance-ladder + §sniff-LOCKDOWN_OPTIONS-as-
pragmatic-escape-hatch + §NOTE-TO-REVIEWERS-pattern. §All-three-
disciplines are §honest-confessions about the awkwardness of
initialization: the design admits the violations rather than
hiding them.
