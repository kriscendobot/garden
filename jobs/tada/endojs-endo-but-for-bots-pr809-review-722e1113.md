Addressed review 4749702996’s sole inline comment at `packages/daemon/designs/daemon-persistent-stores.md:156`.

Pushed `f9ad77780`: keys now explicitly require `makeEncodePassable` or an equivalent order-preserving rank codec; values remain codec-flexible. Posted the inline reply and top-level PR summary, re-requested kriskowal’s review.

Verification: Prettier and diff checks passed; all PR CI checks passed.
