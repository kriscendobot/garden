---
title: §Borrowable patterns (tier-1)
source: endo packages/{trampoline,memoize,nat}/{src/*.js,README.md,docs/memoize.md}
source-slug: endo--packages-trampoline-memoize-nat-trio
ingest-cycle: 199
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo--packages-base64 (cycle 181: §three-tier-dispatch + §Reflect.apply capture sibling)
  - endo--packages-cli-src-utility-cluster (cycle 195: §six-tight-utilities-with-no-internal-dependencies sibling)
  - endo--packages-panic (cycle 197: §Eval-Twin-Problem cross-reference; memoize.md cites endojs/endo#1583)
  - endo--packages-pass-style (cycle 71+: passStyleOf is the §canonical-memoize-user named in memoize.md)
keywords:
  - three-tight-utilities cluster
  - classic-uncurry-this via bind.bind(bind.call)
  - encapsulated-pumpkin sentinel for recursion-protection
  - contingent-safety framing
  - four-tier safety hierarchy (defensiveness / unobservable / preserves-isolation / not-communications-channel)
  - sync/async two-color sharing via generator trampoline
  - generator-throw send-error-into-generator
  - Apps-Script-bigint-literal-workaround
  - two-different-error-types (TypeError type / RangeError range)
  - safely-representable IEEE-754 integer discipline
  - freeze-as-harden-substitute pending PR #3008
parent: endo--packages-trampoline-memoize-nat-trio--three-tight-utilities-with-classic-uncurry-this-and-encapsulated-pumpkin-and-apps-script-bigint-literal-workaround
---

1. **§classic-uncurry-this-via-bind.bind(bind.call)** for §prototype-tamper-resistant method capture; captures `Function.prototype.bind` once and produces functions that take receiver as first arg.
2. **§capture-the-prototype-not-the-instance** — the original `.next`/`.throw` come from `getPrototypeOf(function*(){})`, not from individual iterator instances.
3. **§sync/async-two-color-sharing-via-generator-trampoline** — write one generator function body, pick the trampoline at call site.
4. **§generator-throw-send-error-into-generator** for §propagating-errors-from-effect-handler-back-into-effect-source.
5. **§eslint-discipline-aware-exceptions** with §file-local-comment for §specific-need-overrides-general-rule.
6. **§encapsulated-pumpkin-sentinel** (`harden({})` that must not escape module) for §recursion-protection AND §non-weak-key-compat-early-error AND §try/catch-cleanup-on-fn-throw — §one-sentinel-three-purposes.
7. **§four-tier-safety-hierarchy** (Base / Defensiveness / Unobservable / Preserves-Isolation / Not-Communications-Channel) for §progressive-disclosure-of-safety-requirements.
8. **§contingent-safety-framing** — name the §if-then-property AND acknowledge §the-tooling-cannot-check-or-enforce.
9. **§throws-not-memoized + §rejected-promises-memoized** distinction — §the-docs-make-this-explicit; consumers must understand both cases.
10. **§passStyleOf-as-cited-flagship-consumer** — name the canonical pattern-emulator so readers know §what-to-look-at-as-the-exemplar.
11. **§Apps-Script-bigint-literal-workaround** as §named-future-portability-target with §explicit-narrowing ("Endo is not in general trying for compat with Apps Script. But packages that will have minimal dependencies might").
12. **§freeze-as-harden-substitute pending PR #3008** with §named-equivalence-rationale (§freeze-is-equivalent-to-harden-on-unadorned-arrow-functions because §arrow-functions-have-no-prototype-property).
13. **§two-different-error-types** (TypeError = wrong-kind; RangeError = right-kind-wrong-value) for §finer-error-classification-helping-callers-distinguish-caller-bug-from-runtime-domain-error.
14. **§predicate-assertion-pair** (`isNat` + `Nat`) — boolean for branching, throwing-with-coercion for assertion.
15. **§coerce-to-bigint-on-success** — even when input is a number, output is bigint for type-uniformity.
16. **§safely-representable-IEEE-754-integer discipline** — `Number.isSafeInteger` for §contiguous-range-guarantee.
17. **§skippable-detail tag** as §explicit-named-skip-marker for §progressive-disclosure-in-prose.
18. **§one-sentinel-three-purposes** as §code-density-with-named-effect.
19. **§comment-block-duplicated-verbatim** above sibling exports — each export stands alone with its own justification (six paragraphs of prose explaining two lines of code).
20. **§harden-the-factory-and-the-products** — both `memoize` and the closure-returned `memoFn` get hardened.
