---
source: packages/where/index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/where/index.js
source_path: packages/where/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - tooling
  - daemon
  - getting-started
genre: §endo-source-comment-fragment
cycle: 167
lane: chat
status: current
title: §whereHomeWindows — the four-fallback Windows helper
parent: endo--packages-where-index-js--four-state-domain-path-resolution-with-XDG-precedence-and-platform-fallback-chain
---

```js
const whereHomeWindows = (env, info) => {
  if (env.LOCALAPPDATA !== undefined) return `${env.LOCALAPPDATA}`;
  if (env.APPDATA !== undefined) return `${env.APPDATA}\\Local`;
  if (env.USERPROFILE !== undefined) return `${env.USERPROFILE}\\AppData\\Local`;
  if (env.HOMEDRIVE !== undefined && env.HOMEPATH !== undefined) {
    return `${env.HOMEDRIVE}${env.HOMEPATH}\\AppData\\Local`;
  }
  return `${info.home}\\AppData\\Local`;
};
```

§Four-env-var-fallback-chain reflects §Windows-historical-
accretion: each env-var was introduced in different Windows
versions, with §earlier-ones-superseded-by-later-ones. The
code preserves backward compat by checking the §most-
specific-first and falling back to §progressively-more-
reconstructive forms.

§Why-five-candidates: §LOCALAPPDATA (the canonical modern
var) → §APPDATA (older, points at Roaming; we suffix
\Local) → §USERPROFILE (the home dir) → §HOMEDRIVE+HOMEPATH
(the §historical-DOS-split) → §info.home (the §JS-runtime-
reported home as last resort).

§Comment-with-honest-reasoning:

> *Favoring local app data over roaming app data since I
> don't expect to be able to listen on one host and connect
> on another.*

§Roaming-AppData-not-supported-because-listen-on-one-host-
not-applicable. §Endo's-CapTP-sock is §host-bound. §TODO-
named for §future-roaming-support-with-content-addressable-
state-merge.
