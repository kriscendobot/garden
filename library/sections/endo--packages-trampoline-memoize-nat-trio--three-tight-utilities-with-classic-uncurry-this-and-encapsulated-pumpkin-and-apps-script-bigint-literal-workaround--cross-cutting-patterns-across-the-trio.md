---
title: §Cross-cutting patterns across the trio
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

### §All-three-import-harden-or-use-freeze-substitute

- **trampoline**: §does-not-harden (no exported functions are hardened in source). Relies on §the-caller-harden-the-trampoline-functions-if-needed. §Subtle-difference from memoize and nat.
- **memoize**: §`import harden from '@endo/harden'`; both `memoFn` and `memoize` are explicitly hardened.
- **nat**: §`const { freeze } = Object` as §harden-substitute; both `isNat` and `Nat` are frozen.

§Three-different-approaches-to-the-same-discipline depending on §where-in-the-loading-order the package sits. §trampoline-as-most-permissive (no harden), §memoize-as-most-defensive (full harden), §nat-as-middle-ground (freeze-as-substitute pending PR).

### §All-three-target-`@endo/marshal`-and/or-`@endo/ocapn`-minimal-dependency

- **trampoline**: used for §sync/async-shared-algorithm patterns; bundle-source uses it.
- **memoize**: §passStyleOf-uses-it (the @endo/marshal substrate).
- **nat**: §`@endo/marshal` and `@endo/ocapn` are named explicitly as the consumers PR #3008 targets.

§Minimal-dependency-discipline is §the-shared-constraint: §each-utility-aims-to-be-loadable-by-marshal-without-pulling-in-the-rest-of-Endo. §The-tiny-package-discipline is §enforced-by-the-marshal-aspiration.

### §All-three-tested-by-the-larger-consumer

- §trampoline: tested in `endo/packages/trampoline/test/` (integration tests)
- §memoize: tested in `endo/packages/memoize/test/` and §implicitly-tested by passStyleOf's test suite
- §nat: tested in `endo/packages/nat/test/`

§Per-package-unit-tests + §integration-tests-via-the-larger-consumers — §sibling to cycle 195 cli/src cluster's §implicitly-tested-by-the-CLI-itself.
