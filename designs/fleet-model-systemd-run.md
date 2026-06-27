# design(fleet-model-systemd-run): transient `systemd-run` workers vs. the fixed gardener-loop pool

| Created | 2026-06-27 |
| Author  | gardener (researcher → designer) |
| Status  | Proposed — DRAFT for maintainer review |
| Suggested by | Josh Corbin |

**Design only. DRAFT for maintainer review.** Per `CLAUDE.md` § Conventions the garden
opens no PRs against itself; this is the explicit exception the maintainer asked for (a
reviewable design PR, base `main2`), the same flow as garden#4. **No change to the live
fleet model is executed here** — this PR is the proposal.

The investigation was prompted by **Josh Corbin's** suggestion that `systemd-run`
(transient units spawned on demand) might serve the garden better than the current
~100 always-running gardener loops. Credit to him for the question.

## Summary

The headline question — *"does spawning a transient `systemd-run` worker per job beat
keeping ~100 gardener loops always resident?"* — turns out to rest on a premise the
measurements do not support. The resident pool's cost is **not** memory (100 idle loops
are ~340 MB on a 128 GB host — a rounding error), and a transient unit that blocks for
hours on a maintainer reply costs **the same** as a blocked bash loop (both are one
parked process plus a few kB of kernel state). So the naive "transient-per-job saves the
cost of 100 idle workers" win is largely illusory: the expensive thing is the blocked
`claude -p` process, and `systemd-run` does not make a blocked process cheaper.

What the measurements **do** surface is that the resident pool's real cost is something
the original framing understates: **100 gardeners each `git fetch` the shared journal
every `GARDEN_IDLE_SLEEP` (5 s) whether or not there is work** — the pool *polls*, it is
not "cheaply idle-blocked." That is ~20 fetches/second of self-inflicted journal
contention, the same contention the reaper's stuck-fetch janitor and the clone-lock
hardening keep fighting (the 2026-06-25 fleet wedge). `systemd-run`-per-job does **not**
fix that either: *something* still has to poll the board to know when to spawn a worker.

The genuinely useful application of `systemd-run` is therefore **not** "replace the
loops" but **split claim from work**: a *small* resident **dispatcher** pool polls and
wins claims, then `systemd-run`s the `claude -p` worker as a transient per-job unit that
exits on completion. That buys three things the current model lacks — **per-job resource
caps and accounting** (cgroup `MemoryMax`/`CPUWeight`, `MemoryCurrent`/`CPUUsageNSec` per
unit), **per-job status and logs** (`systemctl --user status garden-job@<base>`), and a
**free deploy story** (every job's unit runs the latest script; the `deploy-sync`
busy-marker re-exec dance disappears) — while *shrinking* the number of pollers and
leaving the concurrency cap where it belongs. The recommendation is a **hybrid**, adopted
incrementally and behind measurement, not a fleet rebuild.

## The current model, and its actual rationale

A host runs `garden-gardener@1..N` long-running loop services (`scripts/jobs/gardener.sh`),
reconciled to the journal `hosts/<host>` count by `gardener-scaler`. `CLAUDE.md` and
`designs/job-board.md` state the count is sized **for concurrency, not CPU**: most
gardeners are "cheaply idle-blocked" waiting for a job or a message, so ~100 is a
concurrency cap, not 100 active workers.

The concurrency-cap rationale is sound — the binding resource is *how many `claude -p`
jobs may run at once*, and a parked worker waiting on a maintainer reply must hold its
slot for the duration. But "cheaply idle-blocked" deserves scrutiny, because the loop
body (`gardener.sh`) is not a blocking wait:

```
while :; do
  read-msgs.sh   gardener-$id role/gardener broadcast   # reads the clone
  claim-job.sh   $id                                     # sync_clone → git fetch origin/journal2
  # rc==3 (empty board) → sleep GARDEN_IDLE_SLEEP (5s); continue
done
```

Every idle pass runs `sync_clone` → `journal_fetch` — **a real `git fetch` against
`origin/journal2`** (`scripts/jobs/common.sh:487`, `claim-job.sh:34`). An idle gardener is
a *poller on a 5 s cadence*, not a process blocked in a syscall. This is the single most
important correction the investigation makes, and it reframes which costs are real.

### Measured costs (this host, systemd 255, 128 GB RAM)

| Quantity | Measurement | Implication |
|---|---|---|
| Idle bash loop RSS | **~3.5 MB** each → ~340 MB for 100 | Memory is **not** the constraint |
| `systemd-run --user --wait` startup+exit | **~5–7 ms** warm, **~24 ms** cold | Spawn cost is negligible vs a minutes-long `claude -p` job (<0.05%) |
| Transient scope memory overhead | the cgroup itself is a few kB; cost = the process inside it | A unit blocked for hours ≈ a bash loop blocked for hours |
| Idle-pool journal fetches | 100 gardeners × 1 fetch / 5 s = **~20 fetch/s** | The resident pool's **real** cost is journal/poll contention |
| `user@.service` `TasksMax` | **23006** | Hundreds of transient units fit with headroom |
| Transient `--user` unit outliving its spawner | **confirmed active** after the spawning shell exited | A dispatcher can spawn a worker and immediately free itself |
| Per-unit accounting | `MemoryCurrent`/`CPUUsageNSec` populated per unit | Per-job observability is real, not theoretical |

The numbers say plainly: the case *against* the resident pool is not memory and not spawn
latency. It is (a) the steady poll-fetch load 100 loops put on the shared journal, and (b)
the operational seams the long-lived loop forces — the `deploy-sync` busy-marker re-exec
to swap in new code mid-pool, and the absence of per-job resource isolation.

## What `systemd-run` offers

`systemd-run --user [--unit=NAME] [--scope|--service] [-p Prop=val ...] CMD` asks the user
manager to create a **transient unit** on demand — no unit file, no `daemon-reload`. It is
a first-class unit while it runs: cgroup-isolated, individually addressable
(`systemctl --user status/stop NAME`), individually logged (`journalctl --user -u NAME`),
and with `--collect` it self-unloads on exit so it leaves no residue. `--wait` blocks the
caller until the unit finishes and propagates its exit code; **without** `--wait` the unit
is fire-and-forget and (confirmed above) **outlives the process that launched it** because
it is parented to the user manager, not the spawner. Resource control properties
(`MemoryMax=`, `CPUWeight=`, `TasksMax=`, `MemoryAccounting=yes`) attach per invocation, so
each job can carry its own cgroup budget.

Two unit kinds matter here: a `--scope` adopts the caller's forked process into a new
cgroup (the caller forks the worker); a `--service` (the default) has the *manager* fork
and supervise the command. For a dispatcher that wants to spawn-and-forget, `--service`
(no `--wait`) is the right shape: the manager owns the worker's lifecycle, so the
dispatcher returns to claiming immediately.

## Candidate models

### A. Transient-per-job (the literal suggestion)

Replace the resident loops entirely: a thin dispatcher claims a job, then
`systemd-run`s a one-shot worker (`garden-job@<base>.service`) that runs the handler and
exits. Concurrency is capped by the dispatcher refusing to spawn beyond N live workers.

- **Buys:** per-job cgroup isolation, per-job status/logs, free code deploys (each unit
  runs current scripts), clean failure capture (`Result=`/`ExecMainStatus=` per unit).
- **Does not buy:** any relief on the message-blocked case — a job parked for hours on a
  maintainer reply holds its transient unit for hours, exactly as a loop would. And it
  does not remove the poller — *the dispatcher still polls the board*.
- **Costs:** you still need a poller; you have merely renamed "gardener loop" to
  "dispatcher loop" and added a spawn per job. If the dispatcher is 1:1 with would-be
  gardeners, you have not reduced the poll-fetch load at all.

### B. Dynamic pool (spawn up to a cap as work arrives)

A single supervisor watches the board depth and `systemd-run`s workers up to a
concurrency cap, scaling to zero when the board drains.

- **Buys:** zero resident workers when idle — but recall idle workers cost ~3.5 MB, so
  "scale to zero" saves megabytes, not a meaningful resource.
- **Costs:** the supervisor is now a single point of failure and a single poller; worse,
  scaling on *board depth* misreads the garden's load, because a claimed-but-blocked job
  (waiting on a reply) is not "done" yet occupies a concurrency slot the board no longer
  shows. Board depth is the wrong signal for a fleet whose jobs block on messages.

### C. Hybrid — small resident dispatcher pool, transient per-job workers (recommended)

Keep a **small** resident pool of **dispatchers** (`garden-dispatcher@1..D`, D ≪ today's
N). A dispatcher's loop is *claim-only*: poll, win a claim via the existing CAS, then
`systemd-run --user --service --no-block --unit=garden-job@<base>` the worker and
**immediately return to claiming**. The worker unit runs `gardener.sh`'s
handler+complete half, carries a per-job `MemoryMax`/`CPUWeight`, and exits (with
`--collect`) on completion. Concurrency is capped not by the dispatcher count but by a
**slice** (`garden-jobs.slice` with `TasksMax`/`MemoryMax`) or a live-unit count the
dispatcher checks before spawning.

- The dispatcher is free the instant it spawns a worker, so **D dispatchers sustain far
  more than D concurrent jobs** — the poll-fetch load drops from N (≈100) to D (≈ a
  handful), directly attacking the one real cost of the resident pool.
- The message-blocked job holds only its own cheap transient unit, not a dispatcher.
- Per-job isolation, status, logs, and the free-deploy property all come for free.
- The killswitch, reaper, and scaler translate cleanly (below).

## Recommendation

**Adopt the hybrid (C), incrementally and behind measurement; do not pursue A or B as
stated.** Concretely:

1. **First, fix the cheaper thing first.** The largest measured cost of the *current*
   model — ~20 journal fetches/second from idle pollers — is partly addressable **without
   `systemd-run` at all**, by lengthening/jittering `GARDEN_IDLE_SLEEP` under sustained
   idle (back-pressure the poll) or by having the watchman/foreman wake idle gardeners via
   the message bus instead of every gardener self-polling. This is worth doing regardless
   and de-risks the bigger change. *(If this alone makes the pool cheap enough, the
   `systemd-run` migration becomes purely an observability/deploy-ergonomics decision, not
   a cost decision — which is the honest framing.)*

2. **Then pilot the dispatcher/worker split** behind the existing handler seam. The
   `GARDEN_JOB_HANDLER` indirection already separates *claim/complete* (in `gardener.sh`)
   from *do the work* (the handler). The pilot is: a dispatcher that, instead of running
   the handler in-process, `systemd-run`s it as `garden-job@<base>.service`, and a
   `garden-jobs.slice` carrying the concurrency cap. Run it as a **single dispatcher lane
   alongside the existing pool** on one host, compare per-job observability and deploy
   ergonomics, and only then decide whether to shrink the resident pool.

3. **Keep the journal-CAS claim protocol exactly as-is.** None of this touches the
   compare-and-swap; the dispatcher claims with today's `claim-job.sh` before it spawns.

The recommendation is deliberately *not* "rip out the loops." The loops are cheap in the
dimension everyone worried about (memory) and the `systemd-run` win is real but narrow
(observability, deploy ergonomics, poll-load reduction via the claim/work split). A
hybrid captures that win without betting the fleet on it.

## Migration implications

- **Scaler.** `gardener-scaler` reconciles `hosts/<host>` → `garden-gardener@N`. Under the
  hybrid it reconciles `hosts/<host>` → `garden-dispatcher@D` (a *different, smaller*
  number) **and** sets the concurrency cap on `garden-jobs.slice`. Two knobs (dispatcher
  count, concurrency cap) replace one (gardener count); the journal `hosts/<host>` record
  grows a field. The scaler's enable/disable logic is otherwise unchanged.
- **Reaper.** Unchanged in its core duty (requeue `doin/` claims older than
  `GARDEN_CLAIM_TTL`) — the claim file is still the source of truth, and a worker that dies
  still leaves a stale claim. *Gains* a capability: it can cross-check `systemctl --user
  is-active garden-job@<base>` to distinguish "worker still running, claim legitimately
  young" from "worker dead, requeue now," tightening the TTL heuristic. The stuck-fetch
  janitor stays relevant (dispatchers still fetch), but against far fewer fetchers.
- **Killswitch.** `touch $GARDEN_STATE/NOPE` today makes each loop exit cleanly at the top
  of its next iteration. Under the hybrid it must (a) stop dispatchers from spawning new
  workers (same top-of-loop check) and (b) optionally `systemctl --user stop
  'garden-job@*'` to drain in-flight workers. A two-level killswitch (pause-dispatch vs.
  drain-all) is a small addition and arguably an improvement.
- **Observability.** The clear win: `systemctl --user status garden-job@<base>`,
  `journalctl --user -u garden-job@<base>`, and per-job `MemoryCurrent`/`CPUUsageNSec`
  replace grepping one shared loop's journal. The existing failure-capture-by-hash path
  (`gardener.sh`'s capture → `report-error.sh` → inbox SHA) still runs inside the worker
  and is complementary.
- **Deploy.** `deploy-sync`'s busy-marker re-exec (restart a gardener only *between*
  claims so new code is picked up) becomes unnecessary for workers: each `garden-job@`
  unit starts a fresh process that runs the current scripts by construction. Only the
  small dispatcher pool needs the between-claims re-exec, shrinking that machinery's blast
  radius.
- **Message-bus blocking model.** Unchanged. A worker still drains its inbox and can block
  on a maintainer reply; it simply does so inside a transient unit instead of a loop
  iteration. The hybrid neither simplifies nor complicates the blocking semantics — it
  only moves where the blocked process lives.
- **Tests.** `scripts/jobs/test/run-test.sh` runs gardeners as plain background processes
  (no systemd) precisely because the coordination lives in the scripts, not systemd. That
  stays true: the dispatcher/worker split is testable by having the test's dispatcher
  `exec` the handler directly instead of `systemd-run`-ing it, so the CAS subtests are
  unaffected.

## Open questions for the maintainer

1. **Is the poll-fetch load actually a felt problem today,** or is the journal contention
   already adequately tamed by the clone-lock + stuck-fetch hardening? If the latter, the
   `systemd-run` migration is justified by observability/deploy ergonomics alone — is that
   enough to warrant the change?
2. **Idle-poll back-pressure first?** Should we land the cheap `GARDEN_IDLE_SLEEP`
   back-pressure / bus-wakeup change independently and re-measure before committing to the
   dispatcher split?
3. **Concurrency cap mechanism:** a `garden-jobs.slice` `TasksMax`/`MemoryMax` (kernel
   enforces, dispatcher need not count) vs. the dispatcher counting live `garden-job@*`
   units before spawning. The slice is more robust; the count is simpler. Preference?
4. **Dispatcher count D:** how small can the resident dispatcher pool be while still
   winning claims fast enough under burst? This is the one number the pilot should measure
   directly.
5. **Worker unit naming/collision:** `garden-job@<base>` keys on the job basename (already
   the system's spine). A re-claimed job after a reap reuses the base — does
   `--collect` + the reaper's TTL fully avoid a stale-unit-name collision, or do we need a
   `<base>-<claim-epoch>` suffix?
6. **Scope of adoption:** pilot on one host's single lane first (recommended), or model it
   across all hosts in the design before any code?

---

*Investigation method: `systemd-run` behaviour and costs were measured directly on a live
systemd 255 user manager (not assumed); the journal/poll costs were read from the actual
`gardener.sh`/`common.sh`/`claim-job.sh` call paths. The current-model rationale
(concurrency-not-CPU) is taken from `CLAUDE.md` and `designs/job-board.md` and engaged with
on its own terms.*
