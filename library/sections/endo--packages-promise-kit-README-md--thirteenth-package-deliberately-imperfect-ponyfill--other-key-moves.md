---
title: Other key moves
source: endo--packages-promise-kit-README-md
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/promise-kit/README.md
total-lines: 71
ingest-cycle: 335
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-deliberately-imperfect-ponyfill
  - the-named-ponyfill-with-named-deliberate-divergence
  - the-named-makePromiseKit-IS-named-canonical-promise-deferred
  - the-named-eventual-send-pipelining-IS-named-accommodation
  - the-named-example-with-both-branches
  - the-named-three-named-returns
  - the-named-multiple-promise-kits-example-shows-composability
  - the-named-License-section-Apache-2.0
  - the-named-six-section-README-shape
  - the-named-Agoric-smart-contract-OR-JavaScript-program
  - twenty-six-cycles-with-named-pivot-domain-stay
  - thirteen-named-packages-in-the-pivot-cluster
  - forty-nine-citation-arc-closures-in-pivot-now
  - two-cycles-with-named-ponyfill-vs-polyfill-distinction
parent: endo--packages-promise-kit-README-md--thirteenth-package-deliberately-imperfect-ponyfill
---

- **§the-named-makePromiseKit-IS-named-canonical-promise-deferred** (line 3, 13, 17) — the central API. Returns `{ promise, resolve, reject }`. **§the-named-three-named-returns** — the canonical "deferred" pattern that many JS libraries provide; @endo/promise-kit names it canonically.

- **§the-named-Agoric-smart-contract-OR-JavaScript-program** (line 8) — *"in an Agoric smart contract or JavaScript program"* — names two example contexts. Sibling to cycles 321 + 323 Agoric-citation discipline. **§three-cycles-with-named-Agoric-citation** (321 money-flow + 323 Agoric-modules + 335 Agoric-smart-contract).

- **§the-named-example-with-both-branches** (line 12-40) — Basic Example shows BOTH the success path AND the failure path via `if (success) ... else { reject(...) }`. The comment *"Simulating success or failure"* hints at both branches even though the variable is hardcoded to `true`. Sibling to cycle 327 patterns README's §the-named-Quick-Start-shows-error-output discipline. **§two-cycles-with-named-example-with-both-branches** (327 + 335).

- **§the-named-multiple-promise-kits-example-shows-composability** (line 42-56) — second worked example explicitly titled *"Creating Multiple Promise Kits"*. Shows that multiple kits are independent and composable. **§the-named-second-example-for-composability**. First-explicit-observation.

- **§the-named-API-section-minimal** (line 58-66) — six lines of API documentation: function signature + three Returns bullets. **§the-named-minimal-API-section** — the API documentation is *terse* because the function is *simple*. First-explicit-observation. Compare to cycle 321's twelve-section substrate README (deep API with many subsections) vs cycle 333's seventeen-line collection README (no API section at all). The package's API-section-depth tracks the package's complexity.

- **§the-named-Links-section** (line 68-69) — single-link section pointing to the package's GitHub repository. Different from cycle 321's See Also (multiple links) or cycle 327's Deep Dives (internal docs). **§the-named-single-link-Links-section** — first-explicit-observation. The minimalism matches the simplicity of the package.

- **§the-named-License-section-Apache-2.0** (line 71-72) — explicit License section. Compare to cycle 333 @endo/common which had NO License section (the LICENSE file is authoritative). The two utility-packages made *different* choices about License sections. **§the-named-License-section-presence-varies** — first-explicit-observation. The variation isn't arbitrary; it tracks the README's purpose: collection-package (cycle 333) defers to LICENSE file; utility-package (cycle 335) includes inline.

- **§the-named-six-section-README-shape** — heading-less intro + Usage (with two examples) + API + Links + License. Six sections including the heading-less intro. Mid-size utility-package shape. Compare to cycle 317 hex (4 sections, 60 lines) and cycle 311 nat (6 sections, 116 lines).

- **§the-named-ponyfill-with-named-API-name** — the ponyfill names `Promise.withResolvers` *with full path*. The reader can find the standard via the name. §the-named-cite-the-spec-API-by-name.
