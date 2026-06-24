---
title: §the-named-named-pipes-have-special-place-comment
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

Line 94 in `whereEndoSock`:

```js
// Named pipes have a special place in Windows (and in our ashen hearts).
const user = env.USERNAME !== undefined ? env.USERNAME : info.user;
return `\\\\?\\pipe\\${user}-Endo\\${protocol}.pipe`;
```

**§the-named-named-pipes-have-special-place-comment** — first-explicit-observation. The comment uses **humor** to acknowledge a difficult platform constraint.

**§the-named-ashen-hearts-comment-as-frustration-marker** — first-explicit-observation as a tier-3 meta-pattern. When a platform-specific code path requires significant accommodation, a humor-frustration comment can mark the maintenance burden. Compare to cycle 337 @endo/harden's §the-named-precise-technical-language-without-pejorative-tone — cycle 348's "ashen hearts" is the OPPOSITE: emotional language deliberately included.

**§two-shapes-of-emotional-tone-in-source-comments** (cycle 337 precise-without-pejorative + cycle 348 emotional-frustration-marker) — first-explicit-observation as a tier-3 meta-pattern.
