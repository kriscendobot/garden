---
title: §Why this trick matters for capability systems
source-slug: endo--packages-promise-kit-src-is-promise-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/is-promise.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/is-promise.js
total-lines: 12
ingest-cycle: 252
ingest-date: 2026-06-09
lane: chat
parent: endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines
---

§In-an-Endo-context-isPromise-IS-load-bearing — §the-distinction-between-a-genuine-Promise-and-a-thenable-affects-trust + §a-malicious-thenable-could-have-an-arbitrary-`.then`-method + §calling-its-`then`-runs-attacker-code. §Genuine-Promises-have-the-fixed-Promise-prototype + §their-`then`-method-is-the-canonical-Promise.prototype.then.

§When-the-application-deals-with-untrusted-values-and-needs-to-know-if-something-is-a-real-Promise, §the-`Promise.resolve`-trick-is-the-only-reliable-check. §The-trick's-load-bearing-role-IS-the-defense-against-malicious-thenables. §First-explicit-observation in library of §Promise.resolve-trick-as-defense-against-malicious-thenables.

§Sibling-pattern-to-cycle-249's-`applyMethod`-as-atomic-lookup-of-method-and-apply — §two-cycles-with-named-defense-against-substrate-confusion-attacks: §cycle-249-against-method-detach + §cycle-252-against-thenable-impersonation. §Two-different-shapes-of-substrate-confusion-attack-with-named-defenses.
