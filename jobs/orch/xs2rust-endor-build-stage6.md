---
order: serial
children: xs2rust-endor-stage6-seam-flip xs2rust-endor-stage6-snapshot-atoms xs2rust-endor-stage6-machine-surface xs2rust-endor-stage6-roundtrip-fuzz xs2rust-endor-stage6-supervisor-integration xs2rust-endor-stage6-verify
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-07-16T21:30:18Z
---

Stage 6 (Snapshots) of the XS→Rust (Endor) port, PR endojs/endo-but-for-bots#600 — serial,
halt-on-child-failure. Children: (1) compiler-seam default flip (endor-compile replaces
oracle-compile; endor emits its own SYMB atom), (2) endor-snapshot crate (XS_M atom
writer/reader, side-table-complete heap serialization), (3) Machine snapshot surface + meter
state across suspend, (4) round-trip-invariance + malformed-atom fuzz targets with locked
fixtures, (5) supervisor suspend/resume integration on -e endor-rs (gap-revealing probe if
unreachable), (6) whole-stage verify (snapshot bars + stage-5 bars hold at the tip + README
ledger). Supervisor: port-xs-to-rust-memory-safe-engine-s19; s20 parked blocked on this
orchestration. Stage-5 acceptance: PR #600 issuecomment-4996709674.
