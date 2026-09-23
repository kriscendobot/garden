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
title: §post-lockdown-explicit-hardening (post.js)
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

```js
export default () => {
  // Even on non-v8, we tame the start compartment's Error constructor so
  // this assignment is not rejected, even if it does nothing.
  Error.stackTraceLimit = Infinity;

  harden(globalThis.TextEncoder); // Absent in eshost
  harden(globalThis.TextDecoder); // Absent in eshost
  harden(globalThis.URL); // Absent only on XSnap
  harden(globalThis.Base64); // Present only on XSnap
};
```

§Four-platform-aware-hardens. §Each-line-has-an-availability-
comment naming the §platform-matrix:

| Platform | TextEncoder | TextDecoder | URL | Base64 |
|----------|-------------|-------------|-----|--------|
| Node.js / V8 | ✓ | ✓ | ✓ | — |
| eshost | — | — | ✓ | — |
| XSnap | ✓ | ✓ | — | ✓ |

§harden-of-undefined-is-a-no-op (because typeof undefined !==
'object'); §the-four-harden-calls-are-cheap-on-missing-platforms.

§Compare-to-cycle-167-where/index.js' §per-platform-naming-
conventions (POSIX lowercase-dotted / macOS CapitalE-space /
Windows CapitalE-backslash). §Both-encode-platform-knowledge-
in-source-comments-and-conditional-paths.

§The-`Error.stackTraceLimit = Infinity` line has a tamed-
constructor comment explaining why it's safe (assignment is
silently ignored on non-v8). §Sibling-discipline to cycle 87
ses error/console taming: §preserve-developer-affordance-
without-introducing-leak.
