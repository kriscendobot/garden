---
title: "@endo/trampoline + @endo/memoize + @endo/nat — three-tight-utilities cluster"
source-slug: endo--packages-trampoline-memoize-nat-trio
url:
  - https://github.com/endojs/endo/tree/master/packages/trampoline
  - https://github.com/endojs/endo/tree/master/packages/memoize
  - https://github.com/endojs/endo/tree/master/packages/nat
authors: [Mark Miller, Kris Kowal, Endo contributors]
repo: endojs/endo
path:
  - packages/trampoline/{src/trampoline.js,src/types.ts,README.md}
  - packages/memoize/{src/memoize.js,README.md,docs/memoize.md}
  - packages/nat/{src/index.js,README.md}
total-lines: 232 source (59 + 54 + 119) + 469 docs (101 + 76 + 176 + 116)
license: Apache-2.0
ingest-cycle: 199
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/{trampoline,memoize,nat} trio

Three tight @endo utility packages sharing a common §minimal-dependency-discipline aspiration: each is loadable by `@endo/marshal` and/or `@endo/ocapn` without pulling in the rest of Endo. Each has a distinctive structural move worth borrowing.

## Per-package one-liner

- **@endo/trampoline** — generator-based sync/async trampolining with §classic-uncurry-this method capture. §Two-color-sharing: one generator body, sync or async trampoline at the call site.
- **@endo/memoize** — single-arg memoize over a WeakMap with §encapsulated-pumpkin sentinel for §one-sentinel-three-purposes (recursion-protection + non-weak-key-compat early-error + try/catch cleanup). §Four-tier-safety-hierarchy documented in docs/memoize.md.
- **@endo/nat** — isNat predicate + Nat assertion + ZERO_N/ONE_N bigint constants. §Apps-Script-bigint-literal-workaround named (BigInt(0) not 0n) for `@endo/marshal` and `@endo/ocapn` portability. §Two-different-error-types (TypeError for type-mismatch, RangeError for range-violation).

## Key design moves per package

### @endo/trampoline (59 lines)

- **§classic-uncurry-this-via-bind.bind(bind.call)** — Mark Miller's canonical idiom for prototype-tamper-resistant method capture.
- **§capture-the-prototype-not-the-instance** — `generatorPrototype.next`/`.throw` captured once at module load; iterator instances might be tampered with.
- **§sync/async-two-color-sharing-via-generator** — same generator body works in both colors; trampoline picked at call site.
- **§generator-throw-send-error-into-generator** — `generatorThrow(iterator, err)` resumes the generator at the yield with throw, letting the generator's try/catch handle effect-failures.
- **§eslint-discipline-aware-exceptions** named with file-local comments (`@endo/no-polymorphic-call`, `@jessie.js/safe-await-separator`).
- **§types.d.ts** encodes the color asymmetry: `SyncTrampolineResult<TFn>` rejects Promise-typed results so sync trampoline can't run an async generator function.

### @endo/memoize (54 lines source + 76 README + 176-line docs/memoize.md)

- **§encapsulated-pumpkin = harden({})** marked "must not escape this module" — §the-honor-system-discipline.
- **§one-sentinel-three-purposes**: recursion-protection + non-weak-key-compat early-error + try/catch cleanup.
- **§throws-not-memoized + §rejected-promises-***are***-memoized** distinction made explicit in docs.
- **§four-tier-safety-hierarchy** with named requirements per tier: Base / Defensiveness / Unobservable / Preserves-Isolation / Not-Communications-Channel.
- **§determinism-with-fresh-identity-allowance** — the strongest tier (preserves-isolation) accepts fresh-allocation per call as long as results are equivalent-aside-from-object-identity.
- **§Eval-Twin-Problem cross-reference** to [endojs/endo#1583](https://github.com/endojs/endo/issues/1583) — joins cycle 197 panic's chain.
- **§passStyleOf-cited-as-canonical-memoize-user** — passStyleOf case-splits and only memoizes its internal algorithm for WeakMap-key cases.
- **§contingent-safety-framing** — the docs name the if-then property AND acknowledge "we do not currently have the tooling to check or enforce the above requirements".
- **§harden-both-the-factory-and-the-product** — `harden(memoize)` after the inner `harden(memoFn)`.

### @endo/nat (119 lines source + 116 README)

- **§Apps-Script-bigint-literal-workaround** — `ZERO_N = BigInt(0)` and `ONE_N = BigInt(1)` not `0n`/`1n` because Apps Script's parser doesn't support BigInt literal syntax.
- **§explicit-narrowing**: "Endo is not in general trying for compat with Apps Script. But packages that will have minimal dependencies after adapting to [PR #3008] might, such as @endo/marshal and @endo/ocapn."
- **§comment-block-duplicated-verbatim** above `ZERO_N` and `ONE_N` — each export stands alone with its own justification (six paragraphs of prose explaining two lines of code).
- **§freeze-as-harden-substitute pending PR #3008** with §named-equivalence-rationale: "freeze in this case is actually equivalent to harden" because "we're only using it on unadorned arrow functions" (which have no prototype property).
- **§predicate-assertion-pair** — `isNat` (returns boolean) + `Nat` (returns bigint or throws).
- **§two-different-error-types**: TypeError (wrong kind of value — caller passed string/object/undefined) vs RangeError (right-kind-wrong-value — number/bigint failed value constraint).
- **§coerce-to-bigint-on-success** — `Nat(5)` returns `5n`; consumers can rely on output being bigint.
- **§safely-representable-IEEE-754-integer discipline** — `Number.isSafeInteger` (`Number(2**53+1) === Number(2**53)`, so safe range is `-(2**53-1)` to `2**53-1`; safe natural numbers are `0` to `2**53-1`).
- **§skippable-detail tag** as §explicit-named-skip-marker for progressive disclosure in prose.

## §Cross-cutting patterns

- **§minimal-dependency-discipline** is the shared aspiration: each utility aims to be loadable by `@endo/marshal` and/or `@endo/ocapn` without pulling in the rest of Endo. §The-tiny-package-discipline enforced by the marshal aspiration.
- **§harden-or-freeze-substitute** discipline varies by package: trampoline does not harden (caller's responsibility); memoize fully hardens; nat uses freeze-as-substitute pending PR #3008. §Three-different-approaches-to-the-same-discipline depending on where in the loading order the package sits.
- **§implicitly-tested-by-the-larger-consumer** sibling-pattern to cycle 195 cli/src cluster (per-package unit tests + integration tests via the larger consumers).
- **§Eval-Twin-Problem cited in this cluster's memoize.md** joining cycle 197 panic and references elsewhere — §the-Eval-Twin-Problem-is-load-bearing-across-the-@endo-substrate.

## Ingest scope

Cycle 199 (chat-lane): full ingest of the three packages' source files, READMEs, and `docs/memoize.md`. One section file for the trio because §three-tight-utilities-share-a-common-discipline and §borrowable-patterns-cluster-together.

## Related material in the library

- **cycle 195 endo--packages-cli-src-utility-cluster**: sibling-pattern six-utility chat-lane cluster with §no-internal-dependencies; 199 has tighter coherence via the shared harden-or-freeze discipline.
- **cycle 197 endo--packages-panic**: §Eval-Twin-Problem (endojs/endo#1583) cross-reference; both ingests cite the same SES design concern.
- **cycle 181 endo--packages-base64**: §Reflect.apply capture pattern sibling to trampoline's §uncurry-this; both pre-lockdown discipline.
- **cycle 175 endo--packages-harden-selector**: §race-to-install-with-pin discipline at the @endo/harden layer; memoize imports from `@endo/harden`.
- **cycle 71+ endo--packages-pass-style**: passStyleOf is the cited §canonical-memoize-user in docs/memoize.md.
- **cycle 152 endo--packages-marshal-Hilbert-Hotel encoding**: §coerce-on-success sibling-pattern to Nat's bigint coercion.
- **cycle 150 endo--packages-pass-style-typeGuards**: §predicate-assertion-pair sibling (`isCopyArray`/`assertCopyArray` etc).
- **cycle 102 endo--packages-pass-style-checkKey**: §three-tier-Rejector pattern sibling to memoize's three-uses-of-one-sentinel.
- **cycle 195 endo--packages-cli-src-utility-cluster**: §strict-regex-bigint-parser (`number-parse.js`) sibling-pattern to Nat's safe-integer check; both reject leading-zero, signs, decimals.
- **cycle 146 endo--packages-eventual-send-src-E-js**: §freeze-but-not-harden-the-proxy-target sibling-pattern to nat's freeze-as-harden-substitute.
