---
source: packages/{eventual-send,promise-kit,ses-ava}/* (shim + prepare-endo cluster)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_path: packages/eventual-send/{shim,utils}.js, packages/eventual-send/src/postponed.js, packages/promise-kit/{shim,index}.js, packages/promise-kit/src/is-promise.js, packages/ses-ava/{index,prepare-endo,prepare-endo-config}.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
status: current
title: "The shim-and-prepare-endo cluster: two shim strategies side by side, default-export-masking for AVA config, and BestPipelinablePromise dispatch"
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

> §Chat-lane after cycle 186's designs-lane. §The-twenty-first-
> consecutive designs/chat alternation cycle (166-187). §This-
> cycle-ingests the §shim-and-prepare-endo-cluster that
> cycle 183-init's §shim-assembly-order names load-bearing:
> "lockdown → base64 → promise-kit → eventual-send".

`packages/eventual-send/`, `packages/promise-kit/`, and
`packages/ses-ava/` together hold the §canonical-shim-pattern
that cycle 183-init's `pre.js` and `pre-remoting.js` assemble.
158 lines across 9 files:

| File | Lines | Role |
|------|-------|------|
| `eventual-send/shim.js`           |  6 | Conditional HandledPromise install |
| `eventual-send/utils.js`          |  2 | Barrel re-export |
| `eventual-send/src/postponed.js`  | 46 | Postponed handler with interlock promise |
| `promise-kit/shim.js`             |  4 | Unconditional Promise.race replacement |
| `promise-kit/index.js`            | 53 | makePromiseKit + BestPipelinablePromise |
| `promise-kit/src/is-promise.js`   | 12 | Canonical Promise-detection |
| `ses-ava/index.js`                |  1 | Barrel |
| `ses-ava/prepare-endo.js`         | 27 | Three-purpose prepare module |
| `ses-ava/prepare-endo-config.js`  |  7 | Default-export-masking for AVA config |

§The-single-most-structurally-interesting-move is §two-shim-
strategies-side-by-side. §Both-files-named-shim.js live in
sibling packages, sit at the same point in cycle 183's
§shim-assembly-order, but use §opposite-disciplines-on-
existing-globals:

- **`eventual-send/shim.js`** uses §conditional-install:
  "don't override existing HandledPromise installation."
- **`promise-kit/shim.js`** uses §unconditional-replacement:
  "Promise.race is broken; always replace."

§The-asymmetric-shim-discipline is named here for the first
time across the library. §Cycle-183-init named the §pre-
lockdown-shim-discipline; §this-cycle reveals that the shim-
discipline is itself asymmetric: §conditional-vs-unconditional-
depends-on-whether-the-target-is-correct.
