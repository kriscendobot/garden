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
title: §Cohesion notes
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

- §The-bootstrap-pair-init+lockdown is the §canonical-bootstrap-
  entry-taxonomy. 17 files total (8 init + 9 lockdown).
- §Two-phase-init (pre / commit) separates §shim-installation
  from §lockdown-invocation. Lets consumers choose between
  side-effect-import-only and import-the-function-without-
  running-it.
- §Tolerance-ladder via separate entry-point files: index <
  debug < legacy < unsafe-fast. Each is a one-import affordance.
- §Sniff-LOCKDOWN_OPTIONS-as-pragmatic-escape-hatch — global
  first, env var second; both warn on detection. §Honest-
  admission of ocap discipline violation in the prose comment.
- §"Initialization is often awkward" is the §design-anchor for
  the entire package. The honest framing.
- §NOTE-TO-REVIEWERS-pattern with §two-polarities (commented-
  out-means-accident-in-debug-file / not-commented-out-means-
  accident-in-production-file). §Grep-friendly + §mechanical-
  review.
- §domainTaming-unsafe-always-injected is the §named-mitigation-
  for-a-named-hole pattern.
- §post-lockdown-explicit-hardening with §per-platform-
  availability-comments (TextEncoder absent in eshost; URL
  absent on XSnap; Base64 present only on XSnap).
- §Shim-assembly-order in pre.js is load-bearing: lockdown
  (wrapped function) → base64 (atob/btoa globals) → promise-kit
  → eventual-send (in pre-remoting).
- §DEPRECATED-with-redirect-comment names the replacement
  imports in source.
