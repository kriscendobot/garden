---
title: §The module doc-comment names the architectural discipline
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

Lines 8-18 (the most structurally important block of the file):

> *The PassStyleHelper are only used to make a `passStyleOf` function. Thus, it should not depend on an ambient one. Rather, each helper should be pure, and get its `passStyleOf` or similar function from its caller.*
>
> *For those methods that have a last `passStyleOf` or `passStyleOfRecur`, they must defend against the other arguments being malicious, but may *assume* that `passStyleOfRecur` does what it is supposed to do. Each such method is not trying to defend itself against a malicious `passStyleOfRecur`, though it may defend against some accidents.*

§This-doc-comment-IS-the-named-architectural-discipline of the helpers cluster:

### §Discipline 1 — helpers-are-pure-not-ambient

§"each helper should be pure, and get its `passStyleOf` or similar function from its caller"

- §**No ambient `passStyleOf`** — the helpers don't reach for a module-level binding.
- §**Caller-provided dependency** — the core invokes the helper and passes `passStyleOfRecur` in as a parameter.
- §**Inversion of control** — sibling-pattern to cycle 262's §passStyleOfRecur-as-named-callback observation; here at the type level, the architectural reason is named: §to-avoid-cyclic-module-dependency + §to-allow-the-core-to-vary-its-passStyleOf-implementation-without-the-helpers-knowing.

§First-explicit-observation in library: **§the-helpers-cluster's-`helpers-are-pure-not-ambient`-discipline-named-explicitly-in-the-internal-types-doc-comment**.

§The-discipline-IS-named-at-the-type-level-not-at-the-instance-level — §the-three-concrete-helpers-instantiate-the-discipline + §the-typedef-file-DECLARES-the-discipline; §the-architectural-rationale-IS-named-where-the-protocol-is-defined-not-where-it's-implemented.

### §Discipline 2 — the trust model

§"they must defend against the other arguments being malicious, but may *assume* that `passStyleOfRecur` does what it is supposed to do"

§Three-attack-classes-implicit-in-the-trust-model:

1. **§Malicious-candidate** — the helper **MUST defend**. The candidate is untrusted input; the helper's whole job is to validate it.
2. **§Bugs in passStyleOfRecur** — the helper **MAY defend** against "some accidents" (line 17). Best-effort defensive coding, not a security boundary.
3. **§Malicious passStyleOfRecur** — the helper need **NOT defend**. The core is trusted; the helper assumes its callback does what it's supposed to.

§First-explicit-observation in library: **§the-three-attack-classes-implicit-in-the-trust-model-named-explicitly-in-the-internal-types-doc-comment — §the-helpers-defend-against-malicious-candidates + §may-defend-against-bugs-in-passStyleOfRecur + §need-not-defend-against-malicious-passStyleOfRecur**.

§The-trust-model-IS-asymmetric — §the-helpers-trust-the-core-but-not-the-candidates; §sibling-pattern to capability-systems' asymmetric-trust between caller-and-callee.

§The-`*assume*`-emphasis (markdown italic in the comment) — §the-italicization-IS-the-named-emphasis-on-the-trust-relationship; §the-emphasis-IS-load-bearing-because-the-discipline-IS-not-the-default; §first-explicit-observation in library of §the-italicized-`*assume*`-as-named-emphasis-on-a-load-bearing-trust-assumption.

§"may defend against some accidents" (line 17) — §explicit-bug-defense-allowance + §not-a-security-boundary; §the-spectrum-of-defense (must-defend + may-defend + need-not-defend) IS named at the type level.
