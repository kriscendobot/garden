---
title: §the-named-ENDO_SOCK-override-with-named-rationale
source: endo--packages-where-index-js
url: https://github.com/endojs/endo/blob/master/packages/where/index.js
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/where/index.js
total-lines: 115
ingest-cycle: 348
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline
  - the-named-XDG-FIRST-platform-SECOND-fallback-pattern
  - the-named-Endo-canonical-storage-taxonomy
  - the-named-four-functions-locate-four-kinds-of-storage
  - the-named-state-vs-ephemeral-vs-sock-vs-cache
  - the-named-progressive-degradation-fallback
  - the-named-named-pipes-have-special-place-comment
  - the-named-ashen-hearts-comment-as-frustration-marker
  - the-named-LOCALAPPDATA-favoring-rationale
  - the-named-five-step-fallback-chain-for-Windows-home
  - the-named-ENDO_SOCK-override-with-named-rationale
  - the-named-XDG-doesnt-fit-so-we-invent-our-own
  - the-named-info-vs-env-as-two-sources
  - the-named-protocol-versioned-socket-path
  - the-named-CapTP0-as-protocol-versioning
  - the-named-typedef-as-types-imports
  - the-named-complementary-lens-re-ingest
  - eight-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-fourteenth-instance
  - thirty-nine-cycles-with-named-pivot-domain-stay
  - one-hundred-thirty-citation-arc-closures-in-pivot-now
parent: endo--packages-where-index-js--eighth-complementary-lens-XDG-first-platform-second-fallback-and-Endo-canonical-storage-taxonomy
---

Lines 81-83:

> It must be possible to override the socket or named pipe location, but we cannot use XDG_RUNTIME_DIR for Windows named pipes, so for this case, we invent our own environment variable.

**§the-named-ENDO_SOCK-override-with-named-rationale** — first-explicit-observation. The comment names:
1. **The need**: must be overridable
2. **The constraint**: XDG_RUNTIME_DIR doesn't cover Windows named pipes
3. **The solution**: invent ENDO_SOCK custom env var

**§the-named-XDG-doesnt-fit-so-we-invent-our-own** — first-explicit-observation as a tier-3 meta-pattern. When a cross-platform spec doesn't cover a case, invent a project-specific env var with the project's prefix. Compare to cycle 342 @endo/lockdown's `LOCKDOWN_OPTIONS` — both use project-prefix-named env vars for override functionality.

**§two-cycles-with-named-project-prefix-env-var** (342 LOCKDOWN_OPTIONS + 348 ENDO_SOCK) — first-explicit-observation as a tier-2 multi-cycle pattern.
