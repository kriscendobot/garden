---
title: §the-named-protocol-versioned-socket-path
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

Lines 88, 91, 95, 99, 102 — every reference to the socket path includes `${protocol}` where `protocol = 'captp0'` (default):

```js
export const whereEndoSock = (platform, env, info, protocol = 'captp0') => {
  // ...
  return `\\\\?\\pipe\\${user}-Endo\\${protocol}.pipe`;  // Windows
  return `${env.XDG_RUNTIME_DIR}/endo/${protocol}.sock`;  // XDG
  return `${home}/Library/Application Support/Endo/${protocol}.sock`;  // Darwin
  return `${temp}/endo-${user}/${protocol}.sock`;  // POSIX default
};
```

**§the-named-protocol-versioned-socket-path** — first-explicit-observation. The socket path includes the **protocol version** so different protocol versions can coexist (a v1 server and v2 server can both listen on the same machine without conflict).

**§the-named-CapTP0-as-protocol-versioning** — first-explicit-observation. *"captp0"* is the canonical zero-th version of the CapTP protocol; future versions can coexist by varying the protocol prefix.

**§the-named-protocol-version-in-path-for-coexistence** — first-explicit-observation as a tier-3 meta-pattern. When a daemon's wire protocol may evolve, encode the protocol version in the socket/pipe path so multiple versions can run side-by-side.
