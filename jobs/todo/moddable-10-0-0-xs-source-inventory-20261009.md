---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: researcher
split_source_handler_timeout: 2400
split_orchestration: moddable-10-0-0-xs-source-inventory-20261009-split
reposted_by: reaper:endolin-garden2-5bcdff64
reposted_at: 2026-10-09T23:53:05Z
---

# Deliberate overrun decomposition for `moddable-10-0-0-xs-source-inventory-20261009`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by moddable-10-0-0-xs-source-inventory-20261009-split`, then record `moddable-10-0-0-xs-source-inventory-20261009-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by moddable-10-0-0-xs-source-inventory-20261009-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS moddable-10-0-0-xs-source-inventory-20261009-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: moddable-10-0-0-xs-source-inventory-20261009-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

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
