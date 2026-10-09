---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: designer
split_source_handler_timeout: 2400
split_orchestration: moddable-10-0-0-ironhorse-port-plan-20261009-split
reposted_by: reaper:endolin-garden2-5bcdff64
reposted_at: 2026-10-09T22:43:05Z
---

# Deliberate overrun decomposition for `moddable-10-0-0-ironhorse-port-plan-20261009`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, park every child with `post-plan.sh --orchestrated --orchestrated-by moddable-10-0-0-ironhorse-port-plan-20261009-split`, then record `moddable-10-0-0-ironhorse-port-plan-20261009-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by moddable-10-0-0-ironhorse-port-plan-20261009-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS moddable-10-0-0-ironhorse-port-plan-20261009-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: moddable-10-0-0-ironhorse-port-plan-20261009-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

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
