---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Moddable SDK 10.0.0: what ports to IronHorse?

Source: https://github.com/Moddable-OpenSource/moddable/releases/tag/10.0.0
(pre-release, 2026-10-09, commit 5f215f776f93039755343dbe75a09aa2615045f4, covers 2026-09-04..2026-10-08; becomes default 2026-10-12).

IronHorse is the Rust XS-compatible engine in `endojs/endo-but-for-bots` (`rust/engine`, base `llm`). Parity is judged against Moddable XS (see context/operations/ironhorse-ratchet.md, tracker kriscendobot/garden#51). Consider which 10.0.0 XS changes IronHorse must mirror, then plan the work.

Release items that look engine-relevant (verify each against the actual commits; the notes are a summary):
- Immutable ArrayBuffer proposal now enabled in all builds (check hardened262/ironhorse immutable-arraybuffer matrices; needs Moddable 9.0.0+ xst for validation).
- XS conformance fixes: Math.round subnormals; charAt/charCodeAt 32-bit position truncation; setFromHex bounds-vs-odd-length order; revoked Proxy IsCallable; TypedArray set/fill/constructor/species ordering and detached checks; String repeat/replace/search edge cases; Symbol.for no-arg; Array.from ToLength and iterator-callable order; Reflect.apply/construct arg-read order; Object.prototype.toString Symbol.toStringTag via handler; Array.fromAsync non-object next; ArrayBuffer resize rejection order; Set methods size > 2^31-1; Atomics.wait leak/deadlock; Math.irandom integer math; SyntaxError for functions over 65535 scope slots; switch labelled break/continue stack leak.
- Security: String.prototype.replace capture-group memory-safety fix (check whether IronHorse has an analogous issue).
- Out of scope unless shown otherwise: ECMA-419 / device / Piu / board / TypeScript typing / xsdb changes.

Deliverable: a design/plan (per designer role) that (1) classifies each item as already-conformant, needs-port, not-applicable, or Temporal/host-excluded, with evidence from the IronHorse code and test262 expectations; (2) lists the resulting port work as sized, ordered child jobs, with the recommended orchestration shape (skills/orchestration); (3) flags any item that changes the oracle xst version or the ratchet baseline. Do not start the ports; post the plan and park children per the standing multi-part pattern.

<!-- garden-reaped: 0 -->

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-09T21:38:37Z
