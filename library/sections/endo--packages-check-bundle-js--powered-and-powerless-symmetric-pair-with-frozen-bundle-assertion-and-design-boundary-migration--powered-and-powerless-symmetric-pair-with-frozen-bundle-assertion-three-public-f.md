---
source: packages/check-bundle/{index,lite,src/json}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_path: packages/check-bundle/index.js, packages/check-bundle/lite.js, packages/check-bundle/src/json.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - capability-security
  - bundles
  - hardened-javascript
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
status: current
title: Powered and powerless symmetric pair with frozen-bundle assertion, three-public-function progression, and design-boundary migration observed in source
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

> §Chat-lane after cycle 184's designs-lane. §The-nineteenth-
> consecutive designs/chat alternation cycle (166-185). §Cycle-180-
> hex-package design's §audit-table named check-bundle/index.js
> as a §boundary-site §retained-as-is; §the-actual-source-uses-
> encodeHex-from-@endo/hex which means §the-§boundary-site-was-
> migrated-despite-the-design-saying-it-shouldn't-be. §A-rare-
> opportunity to record a §gap-between-design-and-implementation
> through library cross-reference.

`packages/check-bundle/` is a small 158-line package across
three files:

- `index.js` (43 lines) — the §powered shim with `fs` +
  `crypto` imports.
- `lite.js` (93 lines) — the §powerless core taking
  `computeSha512` as a parameter.
- `src/json.js` (22 lines) — `parseLocatedJson` helper that
  wraps `SyntaxError` with file location.

§The-single-most-structurally-interesting-move is §powered-
and-powerless-symmetric-pair-where-powered-is-a-thin-shim-over-
powerless-core. §Two-`checkBundle`-functions-share-a-name-but-
differ-by-power-axis: the powered version provides crypto +
fs; the powerless core accepts cryptography as an explicit
parameter. §The-§ocap-discipline-via-explicit-power-injection
pattern in its most distilled form.
