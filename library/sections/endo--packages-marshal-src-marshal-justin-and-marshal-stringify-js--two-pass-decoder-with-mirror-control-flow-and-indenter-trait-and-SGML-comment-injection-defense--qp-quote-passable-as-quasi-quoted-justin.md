---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §`qp` — quote-passable-as-quasi-quoted-Justin
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
/**
 * `qp` for quote passable as a quasi-quoted Justin expression.
 *
 * Both `q` from `@endo/errors` and this `qp` from `@endo/marshal` can
 * be used together with `Fail`, `X`, etc from `@endo/errors` to mark
 * a substitution value to be both
 * - visually quoted in some useful manner
 * - unredacted
 *
 * Differences:
 * - given a pattern `M.and(M.gte(-100), M.lte(100))`,
 *   `${q(patt)}` produces "[match:and]", whereas
 *   `${qp(patt)}` produces quasi-quotes Justin:
 *   `makeTagged("match:and", [
 *     makeTagged("match:gte", -100),
 *     makeTagged("match:lte", 100),
 *   ])`
 * - `q` is lazy, minimizing the cost for using it in an error that's never
 *   logged. Unfortunately, due to layering constraints, `qp` is not
 *   lazy, always rendering to quasi-quoted Justin immediately.
 */
export const qp = payload => `\`${passableAsJustin(harden(payload), true)}\``;
```

§The-§qp-template-tag pairs with `q` from `@endo/errors`.
§Both-can-be-used-with-`Fail`, `X`, etc. for §unredacted-
visually-quoted-substitution-values.

§Key-difference: `q` is lazy (cheap when error never logged);
§`qp` is eager (always renders). §The-eagerness-named: "due to
layering constraints, qp is not lazy." §Honest-limitation-
named-in-comment.

§The-output-wraps-in-backticks: `` `${rendered}` ``. §This-
makes-the-rendered-Justin-look-like-a-template-string in the
final error message, §visually-distinguishing-quoted-from-
plain-substitution.

§Compare-to-cycle-87-ses-error/assert.js' §`q`-template-tag.
§Both-are-§Fail-companion-template-tags. §`q`-is-redacting-and-
lazy; §`qp`-is-unredacting-and-eager. §The-pair-covers-§two-
use-cases-with-two-tag-shapes.

§Tier-1-borrowing: §qp-vs-q-template-tag-pair as a §lazy-vs-
eager + §redact-vs-unredact + §plain-vs-quasi-quoted matrix
for error message substitution.
