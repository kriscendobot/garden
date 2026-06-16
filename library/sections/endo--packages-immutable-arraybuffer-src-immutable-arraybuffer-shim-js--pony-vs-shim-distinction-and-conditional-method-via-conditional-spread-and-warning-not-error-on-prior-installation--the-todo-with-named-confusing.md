---
title: §The TODO with named confusing-warning acknowledgment
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

```js
// TODO, if the primordials are frozen after the prior implementation, such as
// by `lockdown`, then this precludes overwriting as expected. However, for
// this case, the following warning text will be confusing.
```

§The-TODO-names-a-known-confusing-case + §the-fix-is-not-attempted-yet + §the-comment-is-the-acknowledgment. §When-a-design-discipline-conflicts-with-another-discipline-in-a-specific-scenario, §name-the-conflict-as-a-TODO + §don't-pretend-the-conflict-doesn't-exist.

§The-specific-conflict: §post-lockdown-primordials-are-frozen + §the-shim-cannot-overwrite + §but-the-warning-text-still-mentions-`About to overwrite`-which-is-confusing. §When-a-warning-message-can-be-misleading-in-an-edge-case, §name-the-edge-case-as-a-TODO + §don't-rewrite-the-message-prematurely-because-the-overwhelming-case-is-the-common-case.

§Sibling-pattern-to-cycle-235's-`sanity-check-with-c8-ignore` — §two-cycles-with-explicit-acknowledgment-of-a-known-imperfection. §Cycle-235's-c8-ignore-acknowledges-unreachable-code; §cycle-245's-TODO-acknowledges-misleading-warning-text.
