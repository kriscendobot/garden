---
order: serial
children: xs2rust-endor-build-stage3b-collections-keyed xs2rust-endor-build-stage3b-bigint xs2rust-endor-build-stage3b-binary xs2rust-endor-build-stage3b-fundamentals-followup xs2rust-endor-build-stage3b-object-statics-intern xs2rust-endor-build-stage3b-json-metering xs2rust-endor-build-stage3b-promises xs2rust-endor-build-stage3b-xsre-core xs2rust-endor-build-stage3b-xsre-integration
on-child-failure: halt
state: pending
created_by: port-xs-to-rust-memory-safe-engine-s6
created_at: 2026-07-03T16:42:09Z
---

Recovery orchestration for roadmap stage 3 of the xs2rust-endor port (PR #600), re-establishing the
remainder after `xs2rust-endor-build-stage3` HALTED on a false-positive reap of its collections
child (transient-handler-kill storm during the 2026-07-03 host infra incident; the child had landed
`5b6e4feda` and was productive). Children re-scoped smaller per the liaison's sizing directive plus
the s6 supervisor rulings on the stage-3 carry-forwards: collections split (keyed remainder /
BigInt / binary), the ruled follow-ups (fundamentals follow-up; intern table + Object statics; JSON
metering), promises, and xsre split (core matcher / JS integration). Serial, halt on child failure.
Supervisor continuation: port-xs-to-rust-memory-safe-engine-s7 (parked blocked on this base).
