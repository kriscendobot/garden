---
created: 2026-08-01
updated: 2026-08-20
author: gardener
---

# Host-addressed root-repo maintenance (`maintain`)

## Decision

Add `maintain` to the sysop's closed operation vocabulary
([the sysop design](sysop.md) §4). The operation means: **on the addressed host,
authorize the root-repo guard to break a *confirmed-stale* `git gc` lock and run one
bounded `git gc`** on the deployed root repo (`$GARDEN_ROOT/.git`). It carries no
argument other than `authorized_by` — an arbitrary repo surgery is unrepresentable in
the message, exactly as `local-model` carries no `model`/`tag`/`url`.

This is a **sibling** of `local-model`, not a replacement for it. `local-model`
([sysop-local-model.md](sysop-local-model.md)) already shipped and its orchestration
(`sysop-local-model-provisioning`) is complete; nothing about it is retired or
subsumed. `maintain` reuses the **same async start/poll shape** that op established
(a fixed non-enabled unit started `--no-block`, polled on later ticks), so the sysop
grows one more op of a known shape rather than a second execution model.

### The gap this closes (the trigger case, 2026-08-01)

Host `endolin-garden-ece02cb4` (`/home/kris/garden`) reports its root object store
UNMAINTAINABLE:

```
fatal: gc is already running on machine 'endolin-garden-ece02cb4' pid 3728245 (use --force if not)
```

State: **51 packs** (past the guard's ceiling of 50), 8 loose, **0** stale `gc.log`,
and **0 missing objects**. This is a **stale `gc.pid` lock, not corruption**: the
recorded gc process died (or its pid was recycled to an unrelated process), but its
`$GARDEN_ROOT/.git/gc.pid` lock outlived it, so every subsequent `git gc` fails at
lock acquisition. While gc cannot run, git's automatic cleanup stays disabled, packs
grow unbounded, and every git call in that repo — including **every journal sync**,
since `journal/` is a worktree of it — pays for it. That host runs the fleet's
workers.

`garden-root-repo-guard` already **detects** this and deliberately **refuses** to
repair it: its `attempt_root_gc` runs a plain `git gc` (which hits the lock and
fails), tries a non-destructive `--refetch` (additive — cannot clear a lock), retries
gc (still locked), and then alerts. It never removes `gc.pid` and never passes
`--force`, because breaking a lock that *might* belong to a live gc is a destructive
act it will not take unattended. **That refusal is correct and stays.** `maintain`
does not make the guard bolder on its own timer; it gives the **maintainer** a way to
authorize the escalation for one named host.

## Delegation, not reimplementation

`maintain` grows **no gc logic of its own**. The async worker
(`scripts/jobs/root-maintenance.sh`) invokes the existing
`scripts/jobs/root-repo-guard.sh` with a single new **authorized-escalation flag**,
`GARDEN_ROOT_GUARD_UNLOCK_STALE_GC=1` (plus `GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS=0`
to bypass the guard's own once-per-6h back-off for this deliberate request, and
`GARDEN_ROOT_GUARD_ESCALATION_RESULT=<path>` so the worker can read the outcome). The
escalation is checked **inside `guard_object_store`** — the one place that already
owns `gc.pid`/`gc.log` semantics — so the sysop and the worker add addressing, a
trust gate, and a permission bit, never new privileged mechanics. Running the full
guard from the worker is intentional: it is exactly the same repair path the ~30m
timer runs, with one extra capability enabled.

### What the flag permits — and what it never does

With `GARDEN_ROOT_GUARD_UNLOCK_STALE_GC=1`, `guard_object_store` gains exactly one new
behavior before its gc attempt: **if a `gc.pid` lock is blocking and is confirmed
stale, remove it and run an ordinary `git gc`.** It deliberately does **not** pass
`git gc --force`: `--force` ignores liveness and would clobber a genuinely running gc.
Confirming the lock is stale and then running a *normal* gc is strictly safer and
achieves the same recovery for the trigger case.

Everything else about the guard is unchanged. In particular, the **genuinely-corrupt
path stays permanently out of scope**: if gc still fails after the lock is cleared
(e.g. objects reachable from real refs are missing), the guard does **not** drop refs
or history — it takes its existing non-destructive `--refetch` and, failing that,
**alerts a human** with the back-up-refs-first reconciliation recipe. No automation,
escalated or not, ever decides to drop history. The trigger case (0 missing objects)
never reaches that path; a store with unreachable history is a different, human-only
decision.

### Liveness check before unlock

The difference between a safe unlock and clobbering a running gc is confirming the
recorded holder is actually dead. `gc.pid` records `<pid> <hostname>`. A shared helper
`gc_lock_holder_alive <pid>` (in `common.sh`, used by both the sysop precheck and the
guard) answers **"is a live git gc holding this lock?"**:

- pid absent / unparseable, or `kill -0 <pid>` fails → **dead → stale → safe to
  unlock**;
- pid alive but its `/proc/<pid>/cmdline` (or `ps`) is **not** a `git … gc`/`repack`
  process → the original gc is gone and the pid was **recycled** to an unrelated
  process → **stale → safe to unlock**;
- pid alive **and** it is a `git … gc`/`repack` → a real gc may be running → **NOT
  stale → refuse.**

The check runs in **two places**, on purpose:

1. **Synchronously in the sysop `maintain` op**, as a cheap precheck: if a live gc
   holds the lock, the op refuses **immediately** (a clean synchronous `refused` ack)
   and never starts the async unit. This reads only the plain file
   `$GARDEN_ROOT/.git/gc.pid` (a file read, not a git command — the sysop never runs
   git in `$GARDEN_ROOT`).
2. **Authoritatively in `guard_object_store`** during the escalated run: the state may
   change between the precheck and the async run, so the guard re-checks and, if it
   now finds a live gc, records `refused-live-gc` and does not touch the lock. The
   worker surfaces that as a terminal `refused`.

When the pid **is** alive-and-git, the op does nothing destructive and reports
`refused` with the pid/host in the detail, so an operator can decide whether that gc
is genuinely wedged (and, if so, kill it by hand and re-issue).

## Trust tier — destructive (attestation required)

`maintain` **joins the destructive tier** with `deploy`, `unit`, and `local-model`:
the journal-push boundary permits any garden host to originate it, and it requires
`authorized_by: <login>` naming a login on
`maintainers/allowlist`.

Argued from consequence: `maintain` force-removes a lock file and repacks the **shared
root git store that backs journal sync host-wide**. Even with the liveness check, the
check is a heuristic (pid recycling, cmdline matching), and running gc on the repo the
whole host depends on is not a self-healing, transiently-reversible act the way a
benign-tier `drain on`/`reset-failed` is. Attestation is *attestation, not
authentication* (a compromised journal writer could forge it, same caveat as every
other destructive op — [sysop.md](sysop.md) §6); its value is that this cannot be
triggered by an **accident** (a truncated body, a benign op message reused), only by a
message that deliberately names a maintainer. That is proportionate to "break a lock
and repack the host's root repo," and it keeps the tiering rule consistent: irreversible
/ host-spanning ⇒ destructive tier.

## Message

```sh
scripts/jobs/send-host-op.sh <GARDEN> op=maintain authorized_by=<maintainer-login>
```

The op accepts **no** operation-specific field other than `authorized_by`
(`reply_to`, when present, remains common sysop routing metadata). A `path`, `ref`,
`force`, `action`, or any other field is a **parse-error** — as with `local-model`,
this makes an arbitrary maintenance unrepresentable in the vocabulary. There is
currently exactly one maintenance action (break-stale-gc-lock + bounded gc); if a
second is ever added it earns its own `action:` grammar and its own scope argument
then, deliberately, never an open-ended passthrough.

## Async execution and state

`maintain` is **async**, reusing the `local-model` shape so the sysop stays a
timer-driven oneshot and a slow gc never starves a fast `drain off`:

- **`garden-root-maintenance.service`** — a static `Type=oneshot` unit with **no
  `[Install]` section** (a routine `install-units.sh` copies but never enables it; it
  is started only by an accepted, attested request), `Slice=background.slice`, and a
  **bounded** `TimeoutStartSec` sized to cover the guard's worst-case internal budget
  (unlock + gc + refetch + gc + missing-scan). Unlike the model-pull unit (a
  tens-of-GiB download → `TimeoutStartSec=infinity`), maintenance is internally bounded
  by the guard's per-step timeouts, so the unit carries a finite ceiling.
- **`scripts/jobs/root-maintenance.sh`** — the unit's `ExecStart`. It invokes
  `root-repo-guard.sh` with the escalation flag, reads the guard's recorded escalation
  result, and writes one terminal `result` (outcome + detail) to host-local state.
- **`sysop.sh maintain`** (destructive tier): attestation → schema check (no extra
  fields) → **synchronous liveness precheck** (fast `refused` if a live gc holds the
  lock) → serialize on a host-local `flock`; if a maintenance run is already in flight,
  **attach** to it (idempotent — maintenance has no distinct "target"), else freeze the
  execution record, start the unit `--no-block`, and ack `accepted-in-progress`.
- **`poll_root_maintenance`** runs at the top of every tick (before consuming new
  messages, like `poll_local_model`): if a terminal `result` exists it finalizes every
  attached message (updates `sysop-log`, sends the terminal ack) and clears the record;
  while the unit is active it emits a throttled `accepted-in-progress` heartbeat; an
  inactive unit with no result is a terminal `failed: interrupted`.

Outcome mapping from the guard's escalation result to the sysop ack:

| guard escalation result | terminal ack | meaning |
| --- | --- | --- |
| `noop-healthy` | `accepted-and-applied` | store already maintainable, no lock to break |
| `gc-ok` | `accepted-and-applied` | gc ran and succeeded (no stale lock was in the way) |
| `unlocked-gc-ok` | `accepted-and-applied` | a stale `gc.pid` was removed, gc then succeeded |
| `refused-live-gc` | `refused` | a live `git gc` holds the lock; nothing touched |
| `gc-failed` | `failed` | gc still failed after unlock (+ refetch); a human alert was raised, history untouched |

State lives under `$GARDEN_STATE/sysop/root-maintenance/` (outside the journal and the
deployed checkout), holding one execution record, the guard's escalation result, one
terminal result, and the attached msgid set — the same layout `local-model` uses.

### Interaction with drain

`maintain` honors the guard's existing **drain deferral**: if the fleet is draining, a
`deploy` owns the root tree, and `guard_object_store` already defers maintenance rather
than fight it. Under escalation the deferral stands (recorded as `gc-failed`/deferred →
`failed` with a "draining, deferred" detail, retriable once the drain lifts). The sysop
itself still ticks under drain and still processes `drain off` while a maintenance unit
is active — the async shape guarantees it.

## Host and fleet safety

`maintain` preserves every standing sysop boundary
([sysop.md](sysop.md) §5, [sysop-local-model.md](sysop-local-model.md) § Host and fleet
safety):

- runs on leaders **and** followers (the unattended follower is the whole point);
  each daemon reads only `msgs/host/<its-own-GARDEN>`;
- still ticks under drain; a maintenance run in flight does not block `drain off`;
- mutates only the addressed host's own root repo, host-local state, user systemd,
  audit path, and ack topic — no broadcast, no cross-host action;
- runs no `claude`, claims no jobs, interprets no prose, touches no credentials, and
  adds **no ferry or identity-switch surface**;
- the sysop never runs git in `$GARDEN_ROOT`: it only *reads the file*
  `$GARDEN_ROOT/.git/gc.pid`; the one actor that runs git there is `root-repo-guard.sh`
  (the sanctioned root-repo mover, like `deploy-garden.sh`), invoked via the async
  unit.

## Scope boundary

**IN** (this op, permanently the whole of it unless a future `action:` is designed):

- remove a **confirmed-stale** `$GARDEN_ROOT/.git/gc.pid` lock (holder dead or pid
  recycled to a non-git process);
- run one **bounded** `git gc` afterwards (the guard's existing `attempt_root_gc`);
- the guard's existing non-destructive companions on that path: `tmp_*` pack-garbage
  sweep, stale-`gc.log` clearing (only after a gc that *succeeds*), and additive
  `git fetch --refetch` recovery.

**OUT** (permanently, not merely deferred):

- passing `git gc --force` (ignores liveness) — replaced by liveness-checked unlock;
- clobbering a lock held by a **live** git gc — refused;
- **anything that drops refs or history**: no `rev-list`-driven ref deletion, no
  reset/rewrite, no prune of reachable objects. A store with genuinely missing objects
  is alerted to a human with the back-up-refs-first recipe, exactly as today;
- any repo other than the deployed root (`$GARDEN_ROOT`);
- ferry / identity switch — out of the entire sysop vocabulary.

## Verification plan

A deterministic stub harness (no real `git gc --force` against `$GARDEN_ROOT`, no real
systemd) demonstrates:

- **trust gate**: `maintain` without `authorized_by`, and with a non-allowlist
  `authorized_by`, is refused before any unit start;
- **schema**: an extra op field (e.g. `force=1`) is a parse-error, no unit started;
- **already-healthy no-op**: no `gc.pid`, store maintainable → guard records
  `noop-healthy`/`gc-ok` → terminal `accepted-and-applied`, no destructive action;
- **pid-still-alive refusal**: a `gc.pid` naming a live git-gc process → the sysop's
  synchronous precheck refuses, no unit started; and the guard, run directly with the
  escalation flag against a live-gc lock, records `refused-live-gc` and leaves the lock
  in place;
- **stale-lock unlock**: a `gc.pid` naming a dead/recycled pid → the guard removes it
  and a subsequent gc succeeds (`unlocked-gc-ok`);
- **bounded async happy path**: tick 1 starts the unit and acks
  `accepted-in-progress`; a stubbed terminal result on tick 2 finalizes
  `accepted-and-applied` and clears the execution record;
- **not starved under drain**: a fast `drain off` is processed while a maintenance run
  is active;
- every outcome leaves a committed `sysop-log/<GARDEN>/<msgid>.md` and an ack, and no
  path invokes `claude`, touches a foreign host, or enables the maintenance/guard unit.

## Considered and rejected

- **Run the escalated gc synchronously inside the sysop tick.** Rejected: the guard's
  worst-case internal budget (gc + refetch + gc + scan) approaches the sysop's 900s
  oneshot ceiling and would starve a fast `drain off` for a whole tick. The async unit
  keeps the sysop responsive, the same reason `local-model` is async.
- **Pass `git gc --force`.** Rejected: `--force` ignores whether a gc is actually
  running. Liveness-checked lock removal + a normal gc is strictly safer and recovers
  the trigger case identically.
- **Make the guard break stale locks on its own 30m timer (no operator step).**
  Rejected: the guard's unattended refusal to act destructively is correct; a stale
  lock and a lock held by a wedged-but-live gc are indistinguishable without a
  deliberate human authorization for the ambiguous case. `maintain` is that
  authorization.
- **A new benign-tier op with only journal-push authorization.** Rejected: force-
  unlocking and repacking the host's shared root repo is not transiently-reversible
  like the benign ops; consequence puts it in the destructive tier.
- **Carry `path=`/`ref=`/`force=` in the message.** Rejected: it would hand journal
  issuers an arbitrary repo-surgery selector. The op targets exactly `$GARDEN_ROOT` and
  performs exactly the closed escalation.
- **Fold `local-model` and `maintain` into one `maintain` class.** Rejected:
  `local-model` already shipped and is orthogonal (model provisioning vs object-store
  repair); retrofitting a tested op into a new umbrella is churn with no benefit. They
  share the async *substrate shape*, not an operation.
