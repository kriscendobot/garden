---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §take_debug_flag atomic-removal discipline
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

```rust
debug_flags: RwLock<HashSet<Handle>>,
// ...
let debug = sup.take_debug_flag(handle);
// ... in the worker thread:
if debug {
    xsnap::powers::debug::debug_enable();
}
```

The §take-not-just-read shape: `take_debug_flag` *atomically
removes* the handle from the HashSet *and* returns whether
it was present. The flag is *one-shot*:

- Set: flag goes in the HashSet.
- Take: flag is removed; returned value indicates whether
  debug was requested.

§one-shot-flag-not-persistent: a subsequent resume of the
same handle (without re-setting the flag) is a *normal*
resume. The §opt-in-per-resume property prevents accidental
debug mode bleed-through.
