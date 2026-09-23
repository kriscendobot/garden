---
title: §Synthesis target — slot machine library
source-slug: endo--packages-pass-style-src-internal-types-js
section-slug: the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/internal-types.js
source-repo: endojs/endo
source-path: packages/pass-style/src/internal-types.js
source-author: Endo project (collective)
total-lines: 30
ingest-cycle: 266
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
---

§The-internal-types.js-pattern-applies-to-game-engine-as-a-§game-engine-internal-types.js:

- §**`export {};`-typedef-only-file** for game-engine-protocol types.
- §**Two-cross-module-typedef-references** — `GameRejector` from `@game/errors/rejector.js` + `GameStyle` from `./types.js`.
- §**The module doc-comment names the architectural discipline** — §game-helpers-are-pure-not-ambient + §game-helpers-get-their-`gameStyleOfRecur`-from-the-caller-not-from-a-module-level-binding.
- §**Three attack classes implicit in the trust model** — §game-helpers-defend-against-malicious-game-tokens + §may-defend-against-bugs-in-the-game-core's-recursion + §need-not-defend-against-malicious-game-cores.
- §**The `GameStyleHelper` typedef** with three properties (styleName + confirmCanBeValid + assertRestValid).
- §**The mutual-exclusivity property** named explicitly — when one game-helper's confirmCanBeValid returns true, no other game-helper's would also return true.
