---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
title: §Two-directory-structure-choices
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

> *Simple platform variants: `my-package/src/<platform>/`*
> *Complex feature-platform combinations: `my-package/src/
> <feature>/<platform>`*

§Simple-or-complex-choice. The doc gives §explicit-
permission-for-both — §convention-with-justified-flexibility
discipline.

§Why-two-shapes: simple when a package has *one* platform
split; complex when a package has *multiple features*
each with platform splits. §Don't-force-deep-nesting-when-
shallow-works.

§Cycle-157's-exo-zip-package-design has a sibling pattern:
§Don't-formalize-what-doesn't-need-formalizing applies to
directory structure too.
