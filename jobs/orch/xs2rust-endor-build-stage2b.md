---
order: serial
children: xs2rust-endor-build-stage2b-heap xs2rust-endor-build-stage2b-frames xs2rust-endor-build-stage2b-exceptions
on-child-failure: halt
state: running
created_by: gardener-s4
created_at: 2026-07-02T22:28:57Z
---

Roadmap stage 2b of the xs2rust-endor port (PR endojs/endo-but-for-bots#600): the
allocation-faithful object model, in three serial children — (1) object heap +
allocation-faithful metering, (2) closures + call/return frames + meter-check placement,
(3) exceptions + full 245-opcode coverage + the stage-2 test262 `language/` bit-exact bar.
Re-scoped by supervisor s4 from the monolithic `xs2rust-endor-build-stage2` (removed after
2400s wall-clock overruns) per the stage-2 amendment on `designs/xs2rust-endor-engine.md`
(commit bd0a8392f) and review issuecomment-4870957010. Supervisor continuation
`port-xs-to-rust-memory-safe-engine-s5` parks blocked on this orchestration.
