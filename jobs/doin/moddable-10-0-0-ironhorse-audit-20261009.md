---
role: researcher
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-10T00:08:24Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# IronHorse conformance audit for Moddable SDK 10.0.0

Research and classification only; do not implement any ports.

Audit the Rust XS-compatible engine in `endojs/endo-but-for-bots` (`rust/engine`, roadmap base `llm`) against every engine-relevant Moddable SDK 10.0.0 item listed below. Obtain an isolated checkout with `scripts/jobs/ensure-project-worktree.sh moddable-10-0-0-ironhorse-audit-20261009 endojs/endo-but-for-bots llm`. Before classifying, fetch fresh `origin/journal2` from the garden job worktree and read the completed report for `moddable-10-0-0-xs-source-inventory-20261009` using `tada_find_tree`; treat it as source evidence, and independently inspect the current IronHorse code and tests.

For each item, assign exactly one of: `already-conformant`, `needs-port`, `not-applicable`, or `Temporal/host-excluded`. Cite concrete IronHorse modules/functions/tests and the relevant test262 expectation. Distinguish missing behavior from behavior already inherited through Rust/host facilities. For the String.prototype.replace capture-group security fix, explicitly analyze whether IronHorse has an analogous ownership/indexing hazard. For immutable ArrayBuffer, inspect hardened262/ironhorse matrices and state any `xst`/ratchet-baseline implications.

Items to cover: immutable ArrayBuffer; Math.round subnormals; charAt/charCodeAt 32-bit position truncation; setFromHex bounds-vs-odd-length order; revoked Proxy IsCallable; TypedArray set/fill/constructor/species ordering and detached checks; String repeat/replace/search edge cases; Symbol.for no-arg; Array.from ToLength and iterator-callable order; Reflect.apply/construct argument-read order; Object.prototype.toString Symbol.toStringTag through a handler; Array.fromAsync non-object next; ArrayBuffer resize rejection order; Set methods size over 2^31-1; Atomics.wait leak/deadlock; Math.irandom integer math; SyntaxError for functions over 65535 scope slots; switch labelled break/continue stack leak; and the String.prototype.replace capture-group memory-safety fix.

The completion report is the durable audit artifact for the synthesis job. Use a compact evidence table and end with a provisional grouping of actual port candidates, but do not create code or implementation jobs.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-10T00:27:46Z
