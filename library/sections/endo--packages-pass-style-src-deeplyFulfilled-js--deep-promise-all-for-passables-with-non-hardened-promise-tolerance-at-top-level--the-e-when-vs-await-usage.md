---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The §E.when vs await usage
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

The function uses `E.when(...)` to await promises rather than
plain `await`. The §rationale:

- `await` operates on JavaScript promises only.
- `E.when(...)` operates on JavaScript promises *and* on
  HandledPromises (cycle 66) — including those routed through
  CapTP to remote vats.

The §use-E.when-not-await discipline lets `deeplyFulfilled`
work on *remote* promises (eventual-send promises that haven't
returned to the local vat yet). The §lifted-promise-monad
discipline.

The §`async val =>` declaration: the outer function is `async`
because it always returns a promise; the body uses `E.when`
internally for HandledPromise compatibility.
