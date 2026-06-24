---
title: §Rejector canonical home (rejector.js)
source-slug: endo--packages-errors
section-id: public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home
url: https://github.com/endojs/endo/tree/master/packages/errors
authors: [Endo contributors]
repo: endojs/endo
path: packages/errors/{index.js,rejector.js,README.md}
status: shipping
ingest-cycle: 217
ingest-date: 2026-06-07
lane: chat
parent: endo--packages-errors--public-API-for-SES-assert-with-renamed-utilities-and-tolerate-missing-bare-and-makeError-and-Rejector-canonical-home
---

The §Rejector type is referenced throughout @endo/patterns and @endo/exo (cycles 102, 104, 110, 115, 120, 123, 125, 127, 150). The canonical definition lives here:

```js
/**
 * Either
 * - `false`
 * - or an object like `Fail`
 *
 * A `Rejector` should be used as
 * ```js
 * cond || reject && reject`...`
 * ```
 * If `cond` is truthy, that is the value of the expression.
 * Else if `reject` is false, it is the value
 * Otherwise, invoke `reject` just like you would invoke `Fail`, with the
 * same template arguments. This throws the same kind of Error object that
 * `Fail` would throw, typically because it is the `Fail` template literal
 * tag itself.
 *
 * See rejector.test.js for illustrative examples.
 *
 * @typedef {false | typeof Fail} Rejector
 */
```

§Rejector = false | typeof Fail. §Three-line-idiom: `cond || reject && reject\`...\``. §Three-cases:
1. `cond` truthy → value of expression.
2. `cond` falsy + `reject` false → `false` is the value.
3. `cond` falsy + `reject` is Fail-like → throws.

§The-dual-mode-pattern lets one function-shape serve as both §a-predicate (when called with `reject = false`) and §an-assertion (when called with `reject = Fail`). §Borrowable-pattern: §parameter-controlled-error-vs-silent-failure makes one implementation serve both checking patterns.

§Tests-as-illustrative-examples — §See-rejector.test.js-for-illustrative-examples; §the-test-file-is-the-second-half-of-the-documentation.

§Borrowable-pattern: §when-a-pattern-is-hard-to-express-in-prose-or-types, §point-readers-at-the-test-file as the §living-documentation.
