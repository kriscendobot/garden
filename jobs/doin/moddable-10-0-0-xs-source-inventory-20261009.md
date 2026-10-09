---
role: researcher
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-09T22:48:25Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Moddable SDK 10.0.0 source and oracle inventory

Research only; do not implement any IronHorse ports.

Verify the engine-relevant claims in the Moddable SDK 10.0.0 prerelease notes against the actual commits in `Moddable-OpenSource/moddable` between 2026-09-04 and 2026-10-08, ending at `5f215f776f93039755343dbe75a09aa2615045f4`. For every listed item below, identify the relevant commit(s), changed XS symbols/files, and the corresponding test262 test(s) or specification expectation. Separate engine semantics from ECMA-419/device/Piu/board/TypeScript/xsdb work. Explicitly determine whether immutable ArrayBuffer becoming enabled in all builds changes the minimum oracle `xst` version or any hardened262/ironhorse matrix assumption, and note any other ratchet-baseline implication. Read `context/operations/ironhorse-ratchet.md` for the local baseline conventions.

Items to cover: immutable ArrayBuffer; Math.round subnormals; charAt/charCodeAt 32-bit position truncation; setFromHex bounds-vs-odd-length order; revoked Proxy IsCallable; TypedArray set/fill/constructor/species ordering and detached checks; String repeat/replace/search edge cases; Symbol.for no-arg; Array.from ToLength and iterator-callable order; Reflect.apply/construct argument-read order; Object.prototype.toString Symbol.toStringTag through a handler; Array.fromAsync non-object next; ArrayBuffer resize rejection order; Set methods size over 2^31-1; Atomics.wait leak/deadlock; Math.irandom integer math; SyntaxError for functions over 65535 scope slots; switch labelled break/continue stack leak; and the String.prototype.replace capture-group memory-safety fix.

The completion report is the durable research artifact for the successor jobs. Use a compact table with one row per item and include stable commit URLs, test paths/names, and concise behavioral expectations. State uncertainties rather than guessing.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T22:56:17Z
