---
order: serial
children: xs2rust-endor-stage8-daemon-bundle-imports xs2rust-endor-stage8-boot-generators xs2rust-endor-stage8-cxs-baseline xs2rust-endor-stage8-class-construction xs2rust-endor-stage8-boot-surface-remainder xs2rust-endor-stage8-gate-remeasure
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-07-17T10:51:53Z
---

Stage 8 of the XS→Rust (Endor) port (PR endojs/endo-but-for-bots #600, branch xs2rust-endor,
kept DRAFT): serial A-then-B — daemon groundwork first (bundle Node-import fix → boot
generators → libxs provisioning + C-XS `test:rust` baseline, the probe's dependency-ordered
recipe), then the engine boot-surface remainder (class-instance construction, then the smaller
items), closing with a boot-gate re-measure + whole-stage verify. Dispatched by supervisor
port-xs-to-rust-memory-safe-engine-s23 at stage-7 acceptance
(issuecomment-5002369752). Halt on child failure; the parked s24 supervisor is blocked on this
orchestration. The endor-vm path-dep + daemon spawn wiring and the Debugger row (deferred for
the last permitted time) go to stage 9.
