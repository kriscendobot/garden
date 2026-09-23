---
title: §Two named error cases — SyntaxError augmented, others rethrown
source-slug: endo--packages-check-bundle-src-json-js
source-url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
ingest-cycle: 247
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new
---

§The-`catch`-block-discriminates: §SyntaxError-gets-augmented + §non-SyntaxError-rethrown-unchanged. §When-a-try-catch-augments-errors, §discriminate-which-errors-to-augment + §rethrow-the-rest-unchanged + §don't-over-catch.

§The-`instanceof SyntaxError` check — §the-discrimination-IS-the-narrow-augmentation-scope. §When-JSON.parse-throws-something-other-than-SyntaxError-it's-a-bug-not-a-parse-failure + §rethrow-the-unexpected-error-without-wrapping-so-the-caller-sees-it-undisguised.

§Sibling-pattern-to-cycle-241's-`.catch(reject)` propagates-failure — §two-cycles-with-explicit-error-propagation-discrimination: §cycle-241-propagates-failure-on-the-deferred-path + §cycle-247-rethrows-non-SyntaxError-on-the-augmentation-path.

§Two-named-error-cases as design discipline: §expected-error-augmented-with-context + §unexpected-error-rethrown-undisguised. §When-an-error-handler-handles-only-one-kind-of-error, §discriminate-explicitly + §rethrow-the-rest-not-just-ignore-them.
