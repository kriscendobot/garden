---
title: Single most structurally interesting move
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

§three-tight-utilities sharing §a-common-dependency-on-harden-or-freeze-substitute but otherwise §no-internal-dependencies (sibling pattern to cycle 195 cli/src cluster). Each utility has its own load-bearing structural move:

- **@endo/trampoline**: §classic-uncurry-this-via-bind.bind(bind.call) (Mark Miller's canonical idiom) + §sync/async-two-color-sharing-via-generator + §try/catch-around-generator-next-calling-generator-throw-to-send-errors-back.
- **@endo/memoize**: §encapsulated-pumpkin-sentinel (`harden({})` that "must not escape this module") for §recursion-through-memoization detection AND §non-weak-key-compat early-error AND §try/catch-deletes-on-fn-throw cleanup, all via the same set-pumpkin-then-detect mechanism + §four-tier-safety-hierarchy in docs/memoize.md (Base / Defensiveness / Unobservable / Preserves-Isolation / Not-Communications-Channel).
- **@endo/nat**: §Apps-Script-bigint-literal-workaround (`BigInt(0)` and `BigInt(1)` not `0n`/`1n`) preserved for `@endo/marshal` and `@endo/ocapn` minimal-dependency aspiration (PR #3008) + §two-different-error-types (TypeError for non-bigint-non-number; RangeError for out-of-range or non-safe-integer) + §`freeze`-as-`harden`-substitute pending PR #3008 with §explicit-honest-deferral-comment.
