---
title: §Synthesis-target
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

Slot machine library can §borrow-the-trampoline-pattern for §sync/async-shared-deck-shuffling-algorithm — same algorithm body, two effect colors. §uncurry-this idiom borrowable for any §pre-lockdown-utility that needs §prototype-tamper-resistance.

§Encapsulated-pumpkin-sentinel borrowable for any §self-referential-WeakMap-recursion-protection. §The §one-sentinel-three-purposes shape is §a-template-for-tight-utility-code.

§Four-tier-safety-hierarchy borrowable as §documentation-shape for any §security-sensitive-utility that has multiple property-levels callers might want to rely on. §Contingent-safety-framing is §the-honest-shape when §the-tooling-cannot-check-the-requirements.

§Apps-Script-bigint-literal-workaround is borrowable wherever §minimal-dependency-package-discipline meets §exotic-runtime-target-constraints. §The §"Endo is not in general trying for compat" §explicit-narrowing prevents §scope-creep.

§Two-different-error-types pattern borrowable for §any-validation-function that distinguishes §wrong-kind from §right-kind-wrong-value (§a-bug-in-the-caller vs §a-runtime-domain-error).

§Predicate-assertion-pair (isNat + Nat) borrowable wherever §the-caller-might-want-either-branching-or-asserting. §Coerce-to-bigint-on-success borrowable for §type-uniformity-at-the-output even when input types vary.
