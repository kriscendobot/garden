---
title: §the-named-progressive-degradation-fallback
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

`whereHomeWindows` (lines 7-25) implements a **FIVE-STEP fallback chain** for Windows home detection:

```js
if (env.LOCALAPPDATA !== undefined) return `${env.LOCALAPPDATA}`;
if (env.APPDATA !== undefined) return `${env.APPDATA}\\Local`;
if (env.USERPROFILE !== undefined) return `${env.USERPROFILE}\\AppData\\Local`;
if (env.HOMEDRIVE !== undefined && env.HOMEPATH !== undefined) return `${env.HOMEDRIVE}${env.HOMEPATH}\\AppData\\Local`;
return `${info.home}\\AppData\\Local`;  // last resort
```

**§the-named-five-step-fallback-chain-for-Windows-home** — first-explicit-observation. Each fallback is LESS PREFERABLE than the previous. The discipline: try the cleanest convention first; degrade gracefully through progressively more reconstructed paths.

**§the-named-progressive-degradation-fallback** — first-explicit-observation as a tier-3 meta-pattern. When a platform doesn't have a single canonical home directory, try each environment-variable approach in preference order, falling through to the lowest-level reconstruction.

**§the-named-LOCALAPPDATA-favoring-rationale** — first-explicit-observation. Lines 9-12 explain WHY LOCALAPPDATA is preferred over roaming APPDATA:

> Favoring local app data over roaming app data since I don't expect to be able to listen on one host and connect on another.

The comment names the discipline: local app data because **roaming doesn't make sense for socket-bound daemons**.
