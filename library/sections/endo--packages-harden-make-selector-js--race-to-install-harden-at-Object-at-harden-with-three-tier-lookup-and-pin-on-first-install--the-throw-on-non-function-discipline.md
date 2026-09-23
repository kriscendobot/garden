---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: §The-throw-on-non-function discipline
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

```js
if (typeof objectHarden !== 'function') {
  throw new Error('@endo/harden expected callable Object[@harden]');
}
```

§Fail-loud-on-corruption: §if-something-else-took-the-
slot-throw. §Don't-silently-fall-through.

§Why-loud-not-silent: §the-slot-has-a-known-purpose; if
something else is there, §the-program-state-is-broken.
§Better-to-throw-at-first-call-than-to-silently-use-the-
wrong-function.

§The-two-error-messages-are-symmetric: tier 1 and tier 2
both throw the same shape, with different slot names.
