---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage10n
priority: normal
posted_by: producer
posted_at: 2026-07-20T06:30:11Z
---

---
model: opus
---
# stage-10n child 0: diagnose the s10e live-round-trip stall (host-gated error-trace pin) — OUTAGE RE-CUT

**This is a re-cut of stage-10m child 2 (`xs2rust-endor-stage10m-live-env-diagnosis`), which was
poisoned requeue-exhausted by an opus API outage 05:22–06:13Z 2026-07-20 with ZERO work done (no
pushes, no artifacts expected — check `$HOME/tmp/s10m-diagnosis/` anyway and resume any partial trail
you find). Same shape, same question.**

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep DRAFT), branch `xs2rust-endor`.
**This is a DIAGNOSIS job: default to zero engine pushes.** An engine fix is in scope ONLY if you
root-cause a genuine engine/bundle defect AND it fits the clock with the full binding bars; otherwise
deliver the classification + a minimal repro + a findings report via tada.

## The question (binding for the program's sweep-observability)

At tip `1481757f7f` the LIVE daemon round trip (`error-trace.test.js` under
`ENDO_WORKER_BIN='<abs>/endor worker -e rust'`) is **deterministically 7/7 green on
`/home/kris/garden/tmp/s9r` (endolin-garden)** — the pin MOVED there, with genuine frames (stage-10l
child 1, two runs) — but **deterministically stalls on `/home/kris/garden2/tmp/s10e`
(endolin-garden2)**: only `host exposes a traces facet` passes; the first worker-eval test hangs until
timeout with `CapTP client exception: Error: Connection stream ended` (`connection.js:197`). Same tip,
same binary recipe, opposite outcomes. WHY?

**The branch has ADVANCED since the stall was recorded:** stage-10m children 0/1 landed
`8b9c050825` (`set_property_at` integer-index frontier + `SideTable::ObjectIndices`) and
`d268092d7b` (native-fn `length`/`name` reflection), and the hourly press may have advanced or
REBASED further (read the latest `xs2rust-endor-press-*` tadas; if a press is live, message it to
defer). So FIRST: fetch the REAL remote tip, re-sync the s10e env's rust/ to it, rebuild
(`cargo build --release -p endo --bin endor`, BUILD_EXIT=0 by exit code), regenerate the 3 XS
bundles, and RE-RUN the repro — if the stall vanished at the new tip, say so, capture the evidence
(two clean 7/7 runs), and you are done early.

**What s43 already localized (endolin-garden2, `~/tmp/s43-results/error-trace-live-s43.log` + the
stage-10l remeasure's `/home/kris/garden2/tmp/s10l-results/error-trace-{isolated,longto}.log`):**
- The engine-hosted daemon (ENDO_BIN is the rust `endor`; the daemon bundle runs ON the rust engine)
  boots fully: both workers spawn, `endor-worker: init handshake OK`, guests boot
  (`serving envelopes`), `WORKER_READY` both, socket listener up, client sessions form,
  `CTP_BOOTSTRAP` and the first `CTP_CALL` get `CTP_RETURN`s.
- The eval IS formulated (`T+61ms  9e62a1ebfe92  eval  FORMULATE`) but the second `CTP_CALL` never gets
  a `CTP_RETURN` and there is NO `daemon-xs: SEND to worker` for the eval — the daemon stalls between
  formulation and worker delivery. Then a `kill <pid> SIGTERM` line and the stream-ended teardown.
- NOT the three env-artifact classes: single AF_UNIX sock at 91 chars (< 108), no provisioning-race
  asserts, fresh target. Not load (reproduced idle), not a tight deadline (hangs > 6 min at
  `--timeout=120s`). Node v22.23.1 on endolin-garden2. Daemon per-test state under
  `packages/daemon/tmp/<test>/state/endo.log` is where the trace above came from.

## Procedure

Work on endolin-garden2 in `/home/kris/garden2/tmp/s10e`. Artifacts to `$HOME/tmp/s10n-diagnosis/`
(mkdir first; `$HOME` IS the garden root). Suggested attack order:
1. Re-run the single file at the current tip; capture `state/endo.log` per test dir. Bisect the stall
   INSIDE the daemon: add `endor: [trace]`-style host tracing if needed (the `trace` host global rides
   `host_trace_fns`/`host_trace_outbox`) — LOCAL, uncommitted instrumentation is fine.
2. Compare the environments: node version on s9r was proven-good — check what differs (node minor,
   kernel, ulimits, cgroup cpu quota, tmpfs vs disk, path lengths in DERIVED strings even where the
   listener sock fits). A deterministic env-conditioned branch suggests a concrete threshold (a path
   byte-length, an fd count, a pipe buffer size, a timer coalescing difference), not a race.
3. Classify: (a) env deficiency of s10e → deliver the remediation (an env change making the flip
   observable in sweeps on endolin-garden2) and prove it by running the file 7/7 green twice; or
   (b) genuine engine/bundle defect that s9r masks → minimal repro + findings report (and a fix only if
   it fits the clock with full bars); or (c) honest checkpoint with the evidence trail if the clock runs
   out — say exactly where the trail ends.

HARD STOP: size to one 2400s invocation; reassess the clock after every consequential step. A
classified checkpoint short of a root cause is an honest success — tada with the trail rather than
overrun. Report via your tada completion report ONLY (never inbox-send the parked supervisor).
