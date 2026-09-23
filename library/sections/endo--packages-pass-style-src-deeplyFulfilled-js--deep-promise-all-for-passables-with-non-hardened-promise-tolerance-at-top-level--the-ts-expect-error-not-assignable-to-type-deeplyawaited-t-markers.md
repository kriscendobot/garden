---
section: deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
source: endo--packages-pass-style-src-deeplyFulfilled-js
topics: [pass-style, eventual-send]
status: current
title: The §`@ts-expect-error not assignable to type 'DeeplyAwaited<T>'` markers
parent: endo--packages-pass-style-src-deeplyFulfilled-js--deep-promise-all-for-passables-with-non-hardened-promise-tolerance-at-top-level
---

Five `@ts-expect-error` markers appear throughout the function,
each tagged *not assignable to type 'DeeplyAwaited<T>'*. The
§TypeScript-limitation acknowledgement:

> *TODO Figure out why we need these at-expect-error directives
> below and fix if possible.
> https://github.com/endojs/endo/issues/1257 may be relevant.*

The §DeeplyAwaited recursive type is hard for TypeScript to
verify; the `@ts-expect-error` markers acknowledge the gap
without resolving it. The §honest-known-limitation discipline.
