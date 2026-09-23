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
title: §Synthesis-target
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

The §slot-machine-library's bootstrap module (if it has one)
can §borrow-the-tolerance-ladder: separate entry-point files
(`/init`, `/debug`, `/legacy`, `/unsafe-fast`) so consumers
pick the shape they need with a single import path. §The-
NOTE-TO-REVIEWERS-pattern is borrowable for any §development-
default-vs-production-default configuration that risks merge-
time accidents.

§The-LOCKDOWN_OPTIONS-sniff-pattern is borrowable for
§initialization-parameters-without-explicit-argument-passing
when ocap-discipline-strictness is impractical. The pattern:
sniff + warn + JSON-parse + type-validate + last-merge-injection
of safety overrides.
