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
title: §Tier-1 borrowing
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

- §two-phase-init pre→commit (separate shim assembly from
  lockdown invocation)
- §tolerance-ladder via separate entry-point files (one-import
  affordance per shape)
- §sniff-LOCKDOWN_OPTIONS-as-pragmatic-escape-hatch (global
  first, env var second, both warn on detection)
- §honest-confession-in-prose-comment ("Initialization is often
  awkward"; "we are resigned to leave this hole open")
- §NOTE-TO-REVIEWERS-with-two-polarities (debug-file expects
  set; production-file expects unset; same pattern, opposite
  polarity)
- §domain-Taming-unsafe-always-injected (named-hole-with-named-
  mitigation)
- §per-platform-availability-comments-on-harden-calls (cheap
  no-op when absent; explicit comment on which platform)
- §shim-assembly-order-as-load-bearing (lockdown → base64 →
  promise-kit → eventual-send)
- §DEPRECATED-with-redirect-comment (name the replacement
  imports in source)
- §console-warn-on-discipline-violation (make the violation
  visible rather than hiding it)
- §re-export-then-invoke discipline (consumers choose side-
  effect vs function-form)
