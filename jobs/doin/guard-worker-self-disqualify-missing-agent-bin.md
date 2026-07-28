<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-28T06:49:05Z -->

scripts/jobs/gardener.sh

# A worker that cannot resolve its agent binary must self-disqualify, not claim

Stop-the-bleeding half of the **ps23 outage** (see the companion orchestration
`fix-ps23-claude-path-outage`). Garden-library change on `main2` (direct push, no
PR — CLAUDE.md § Conventions).

## The outage, in one line

Every gardener on host **ps23** fails every job it claims with

```
<3> [jobs] FATAL: claude not on PATH; cannot run default gardener handler for '<base>'
```

(captured output, `refs/captures/gardener/7/finbot-progress-20260727-175002`).
Evidence as of 2026-07-28T06:30Z: **249 journal entries mentioning ps23, ZERO
`tada` completions**, and **all 52 claims in `jobs/doin/` are held by ps23**.

## Why this is a fleet-wide problem, not a ps23 problem

A broken host is not merely idle — it is a **work sink**. Its handler fails in
about a second, so its gardeners return to the poll loop far faster than a
healthy worker that is actually doing a job. A fast-failing host therefore **wins
claim races disproportionately**, pulls jobs off the shared board, fails them,
leaves them in `doin/` for the reaper, and the reaper requeues them until they
**poison**. One misconfigured host can drain the whole fleet's board into poison
while every other host sits idle. That is what is happening now.

Two facts make this un-fixable from outside, which is why the guard has to live
in the worker itself:

- **There is no remote kill switch.** `set-gardeners.sh 0 ps23` from another host
  is refused by design: *"a host may set only its own worker counts."* That
  guardrail is correct and should stay — but it means a peer cannot take a broken
  host out of rotation.
- **`drain-fleet.sh` is host-local** (the marker is `$GARDEN_ROOT/.garden-state/draining`),
  so a peer cannot drain it either.

The only actor that can stop a broken worker from claiming is that worker.

## What to build

**A pre-claim health gate in the worker spine.** Before a worker claims anything,
it must verify it can actually execute a job; if it cannot, it must **not claim**.

1. **Gate before the claim, not at handler dispatch.** Today the binary is probed
   inside the handler (`scripts/jobs/handlers/gardener-claude.sh` ~line 182,
   `command -v claude || die`) — *after* the job has already been claimed and thus
   already stolen from the board. Move the probe **before** the claim attempt in
   `gardener.sh`'s poll loop. The invariant: **a worker that cannot run a job never
   takes one.**
2. **Self-disqualify, don't crash-loop.** On an unresolvable binary the worker
   should idle-poll (re-probing on a backoff, so it self-heals the moment the
   binary reappears after e.g. an `npm install -g` window) rather than exit into a
   systemd restart loop. It must **stay parked as long as it is unhealthy**.
3. **Report exactly once, not once per tick.** ps23 has been emitting a journal
   `error` entry per failed job for hours — hundreds of near-identical entries that
   bury real signal. Emit **one** error entry on the healthy→unhealthy edge and one
   `progress` on recovery. Respect the silent-until-error discipline; a parked
   worker is not news every 30 seconds.
4. **Cover every worker kind.** The same bare-probe-then-die shape is in the
   sibling handlers (`triager-claude.sh:64`, `watchman-claude.sh:42`,
   `bulletin-claude.sh:26`, `proxy-claude.sh:38`, `follow-up-claude.sh:99`), and the
   spine also runs clerics, mystics, hermits, and fireworkers. Put the health probe
   in `common.sh` and use it from the one place each kind claims.

## Relationship to the existing job

**`improve-gardener-claude-bin-resolution` already exists and is currently
STRANDED in `jobs/doin/` — claimed by `ps23/gardener-8`, the very host that cannot
run it.** The fix for the outage is trapped inside the outage. That job holds a
good analysis of the *resolution* half (a `claude_bin()` resolver probing PATH then
known install locations `/usr/local/bin/claude`, `$HOME/.local/bin`,
`$HOME/.claude/local`; pinning `Environment=PATH` on the units; a bounded retry
across an `npm install -g` window). **Read it, and do not duplicate it** — the
companion child job requeues it so it can run on a healthy host.

Division of labour: that job makes the binary **easier to find**; this job makes a
worker that still cannot find it **stop taking work**. Both are needed — a
resolver alone still fails open on a host where the CLI is genuinely absent.

## Definition of done

- A worker with an unresolvable agent binary **claims nothing** — verifiable by
  simulating it (e.g. run the poll loop with PATH scrubbed and confirm the board
  is untouched and no `doin/` entry appears).
- That worker parks and recovers on its own when the binary returns; no systemd
  restart loop.
- One journal entry per health transition, not per tick.
- Existing healthy behavior is unchanged: a host with a working CLI claims exactly
  as before. Include the check that proves this.
- Pushed to `main2`; `tada` report states the invariant as landed and names the
  simulation used to verify it.

---
claim:
  host: ps23
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-28T06:49:09Z
