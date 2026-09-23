---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-18T03:27:27Z
---
---
kind: progress
role: gardener
job: port-xs-to-rust-memory-safe-engine-s25
---
XS→Rust (Endor) supervisor s25 — stage-8b halt recovery (round two) + the real C-XS
`test:rust` baseline. The stage-8b orchestration halted at child 1/4
`xs2rust-endor-stage8-cxs-baseline-r2` (5 claims 17:04–18:03Z, all killed in a second
transient outage window ~17:04–18:23Z on both hosts; infra, not spec — the second such
window in one day). s25 itself took 3 claims: claim 2 (22:33Z) retired the poisoned r2
plan and re-cut the three remaining children as serial-halt orchestration
`xs2rust-endor-build-stage8c` (class-construction → boot-surface-remainder →
gate-remeasure; child 1 is live and pushing — `c43cf7456c`); claim 3 finished the
recovery and CORRECTED claim 2's record: the 17:47Z log claim 2 credited as "baseline
completed" was a provisioning-race artifact (all 53 files uniformly
`AssertionError null == true`; a re-run from the completed environment passes cleanly).
Claim 3 then measured the real baseline from the short-path clone `~/tmp/s8cxs` at the
current-history stage-8 tip `9bef7de22e`: default-concurrency `test:rust` = 646 passed /
294 failed / 65 skipped (log `~/tmp/s25-cxs-baseline.log`). Classification: dominant
class = 539 daemon-readiness timeouts (`endo.sock not ready in 10s`) that are a
CONCURRENCY-amplification artifact, not an engine verdict — per-test `endo.log`s show the
XS-backed manager boots fully (SES bootstrapped, main loop entered) but dozens of
interpreted-XS daemons booting in parallel each blow the 10s window; a `--serial`
single-file probe boots fine and yields substantive results (error-trace: 2 passed /
5 failed on real worker-trace assertions, `~/tmp/s25-serial-probe.log`). Minority
classes: 14 git-backend fails (empty `git --version` under the daemon's filtered env +
identity assertions), 3 /tmp-noexec container artifacts. Corrects s24's attribution:
path length was real for the 126-byte scratch paths but was NOT the sole cause of the
mass timeouts. A detached `--concurrency 1 --serial` whole-suite run is writing
`~/tmp/s25-cxs-baseline-serial.log` (started 03:26Z) as the clean per-test baseline for
stage 9's Rust-engine comparison. Supervisor s26 (the whole-stage-8 review) parked
blocked on `xs2rust-endor-build-stage8c`. Kill criteria assessed NOT tripped: both
stage-8 halts were fleet-infra outages; zero spec defects surfaced.
