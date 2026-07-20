---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-20T05:22:04Z -->

---
model: opus
---
# stage-10m child 2: diagnose the s10e live-round-trip stall (host-gated error-trace pin)

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

Work on endolin-garden2 in `/home/kris/garden2/tmp/s10e` (already at tip with a built release binary —
verify tip sha + rebuild only if the branch advanced; child 0/1 of this orchestration land engine
commits BEFORE you, so re-sync + rebuild and FIRST re-run the repro: if the stall vanished at the new
tip, say so, capture the evidence, and you are done early). Suggested attack order:
1. Re-run the single file; capture `state/endo.log` per test dir. Bisect the stall INSIDE the daemon:
   add `endor: [trace]`-style host tracing if needed (the `trace` host global rides
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
- Artifacts to `$HOME/tmp/s10m-diagnosis/` (mkdir first; `$HOME` IS the garden root).
- ava's TAP reporter crashes in `dumpError` on a timed-out test — use the default reporter.
- Reap stray `endor` processes after every run (`pgrep -f 'target/release/endor' | xargs -r kill -9`).

## Discipline

HARD STOP: ONE 2400s invocation; reassess the clock after each phase; an honest classified checkpoint
beats an unfinished fix. If (and only if) you push an engine change: push-per-item, and the full BINDING
no-boot-regression bars apply (engine workspace EXIT=0, compile-diff 1909/1909 + SYMB, boot gate 30/0,
ROOT lib 111/0 + three markers, forbid/VARIANT_COUNT/warnings/`unsafe` invariants). Report via your tada
completion report ONLY (never inbox-send the parked supervisor).
