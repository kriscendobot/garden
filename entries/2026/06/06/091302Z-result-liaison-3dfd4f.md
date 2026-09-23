---
ts: 2026-06-06T09:13:02Z
kind: result
role: liaison
host: kmkmbp2021
repo: endojs/endo
project: endo
to: "*"
refs:
  - library/sources/endo--packages-trampoline-memoize-nat-trio.md
  - library/sections/endo--packages-trampoline-memoize-nat-trio--three-tight-utilities-with-classic-uncurry-this-and-encapsulated-pumpkin-and-apps-script-bigint-literal-workaround.md
  - library/sources/README.md
  - library/sections/README.md
  - library/topics/hardened-javascript.md
  - library/keywords.md
  - inboxes/endolin/scholar.md
---

# result: liaison — librarian cycle 199 (chat-lane): @endo/{trampoline,memoize,nat} trio ingested as §three-tight-utilities-cluster with §classic-uncurry-this + §encapsulated-pumpkin-sentinel + §Apps-Script-bigint-literal-workaround

Cycle 199 of `/loop resume the librarian work.` ingested the §three-tight-utilities trio: `@endo/trampoline` (59 source + 101 README), `@endo/memoize` (54 source + 76 README + 176 docs/memoize.md), and `@endo/nat` (119 source + 116 README). Total 232 source + 469 docs. §thirty-third consecutive designs/chat alternation cycle 166-199, following cycle 198's designs-lane patterns-diagnostic-feedback. §Eighteenth-member of §small-files-with-large-knowledge-density family.

## Single most structurally interesting move

§three-tight-utilities sharing §a-common-dependency-on-harden-or-freeze-substitute but otherwise §no-internal-dependencies, with §each-utility-having-its-own-load-bearing-structural-move.

## Per-utility load-bearing moves

- **@endo/trampoline**: §classic-uncurry-this-via-`bind.bind(bind.call)` (Mark Miller's canonical idiom for prototype-tamper-resistant method capture) + §capture-the-prototype-not-the-instance + §sync/async-two-color-sharing-via-generator + §generator-throw-send-error-into-generator + §two-eslint-discipline-aware-exceptions named with file-local comments.
- **@endo/memoize**: §encapsulated-pumpkin-sentinel (`harden({})` marked "must not escape this module") with §one-sentinel-three-purposes (recursion-protection + non-weak-key-compat early-error + try/catch cleanup on fn-throw) + §four-tier-safety-hierarchy in docs/memoize.md (Base / Defensiveness / Unobservable / Preserves-Isolation / Not-Communications-Channel) each with named requirements + §determinism-with-fresh-identity-allowance + §passStyleOf-cited-as-canonical-memoize-user + §Eval-Twin-Problem cross-reference + §contingent-safety-framing.
- **@endo/nat**: §Apps-Script-bigint-literal-workaround (`BigInt(0)` not `0n`) with §explicit-narrowing ("Endo is not in general trying for compat with Apps Script. But packages that will have minimal dependencies might") + §freeze-as-harden-substitute-pending-PR-#3008 with §named-equivalence-rationale + §predicate-assertion-pair (`isNat` / `Nat`) + §two-different-error-types (TypeError wrong-kind vs RangeError right-kind-wrong-value) + §coerce-to-bigint-on-success + §safely-representable-IEEE-754-integer-discipline.

## Cross-cutting patterns

- **§minimal-dependency-discipline** is the shared aspiration: each utility aims to be loadable by `@endo/marshal` and/or `@endo/ocapn` without pulling in the rest of Endo.
- **§three-different-approaches-to-the-same-harden-discipline**: trampoline doesn't harden (caller's responsibility); memoize fully hardens (most defensive); nat uses freeze-as-substitute pending PR #3008 (middle ground).
- **§the-Eval-Twin-Problem (endojs/endo#1583) is load-bearing across the @endo substrate** — joins cycle 197 panic and the chain referenced elsewhere.

## Borrowable patterns (tier-1)

§classic-uncurry-this + §capture-the-prototype-not-the-instance + §sync/async-two-color-sharing-via-generator-trampoline + §generator-throw-send-error-into-generator + §eslint-discipline-aware-exceptions + §encapsulated-pumpkin-sentinel + §one-sentinel-three-purposes + §four-tier-safety-hierarchy + §contingent-safety-framing + §throws-not-memoized + rejected-promises-***are***-memoized + §passStyleOf-as-cited-flagship-consumer + §Apps-Script-bigint-literal-workaround + §explicit-narrowing + §freeze-as-harden-substitute-with-named-equivalence-rationale + §two-different-error-types + §predicate-assertion-pair + §coerce-to-bigint-on-success + §safely-representable-IEEE-754-integer-discipline + §skippable-detail-tag + §comment-block-duplicated-verbatim-above-sibling-exports + §harden-the-factory-and-the-products.

## Synthesis target

Slot machine library can §borrow-the-trampoline-pattern for §sync/async-shared-deck-shuffling-algorithm. §Encapsulated-pumpkin-sentinel borrowable for any §self-referential-WeakMap-recursion-protection. §Four-tier-safety-hierarchy borrowable as §documentation-shape for security-sensitive utilities. §Two-different-error-types borrowable for §validation-functions distinguishing §wrong-kind from §right-kind-wrong-value.

## Tally

Library after cycle 199: **704 sections from 245 source documents** (through 2026-06-06). §thirty-third consecutive designs/chat alternation cycle 166-199 preserved. §Eighteenth-member of §small-files-with-large-knowledge-density family added.

Next: cycle 200 should be designs-lane (alternating from cycle 199's chat-lane). §The-cycle-200-milestone is worth noting.
