# Design: the sysop — a per-host daemon that receives and executes host-local system operations off the bus

A deterministic systemd unit on **every** host whose sole job is to receive
**host-directed system operations** over the journal message bus and execute a
**closed set** of them on the host it runs on. It gives the fleet a reliable
delivery path for "do X to host Y" — most importantly to an **unattended follower**,
where today such a directive simply waits for a human to sit down at that host.

Maintainer directive (kriskowal, 2026-07-28): *"Having a systemd unit on each host
that is solely responsible for receiving and handling system operations would be
handy, if we don't have one. We can call it the sysop, operator, or something
similar."*

This is a **design**; the build is a separate orchestrated child that follows from
this doc. Sibling watchers to model on: the issue inbox
([`designs/issue-inbox.md`](issue-inbox.md)) and the fork-watch provisioner
([`designs/auto-provision-fork-watchers.md`](auto-provision-fork-watchers.md)) —
each a deterministic, no-LLM-before-the-gate producer that reads per-instance
journal config and stays inert until armed.

---

## 0. The gap this closes (verified 2026-07-28)

A host-directed operation today has **no deterministic delivery path**:

- **The bus cannot address a host.** `scripts/jobs/send-msg.sh` accepts exactly
  `role/<name>`, `job/<base>`, and `broadcast`, and hard-fails anything else
  (`die "illegal address '$addr' (use role/<name>, job/<base>, or broadcast)"`).
  There is no `host/<GARDEN>` address, so a message cannot be aimed at one host.
- **No role owns host operations.** `proxy` answers gating questions; `watchman`
  broadcasts library changes; `foreman` pumps an idle board; `orchestrator`
  sequences jobs. None *execute host-local operations*.
- **The job board cannot pin a job to a host.** There is no `only_host`/affinity
  field, so a job that must run on host X cannot be guaranteed to land there — any
  eligible gardener on any host races to claim it.
- **So the only route is an attended liaison.** Live case: `ps23` declared
  `gardeners: 8` and held 43 of 45 in-flight claims; the maintainer asked to
  throttle it to 2. `set-workers.sh` correctly refuses cross-host writes
  (*"refusing to write hosts/$host from $GARDEN; a host may set only its own worker
  counts"*), so the liaison could only send a `role/liaison` message and hope
  someone was sitting at `ps23`. On an unattended host the directive simply waits.

The sysop is the missing consumer: a standing per-host daemon that **is** the "sit
down at that host and run the command" actor, driven by a message instead of a
human.

---

## 1. The invariant to preserve, not bypass

`set-workers.sh`'s cross-host refusal is **correct and stays**. A host owns its own
records (`hosts/<GARDEN>`), and no other host may write them; that is what keeps one
host's local action from silently resizing another host's pool.

The sysop does **not** circumvent this. The sysop **runs on the target host**, so
when it acts on a `set-workers` op it invokes `set-workers.sh` *on that host*, which
writes `hosts/<its-own-GARDEN>` and passes the refusal by construction. The bus
carries the *request* from an operator to host Y; the *write* is still performed by
host Y about itself.

This generalizes to a rule the whole design obeys: **the sysop only ever mutates the
host it runs on.** It never writes another host's journal state, never enables/
disables another host's units, never touches another host's worker pool. Any design
in which one host's sysop reaches across to another host is wrong. Addressing (§3)
enforces this structurally: a sysop reads only messages addressed to *its own*
`GARDEN` identity, so the only host it can be told about is itself.

---

## 2. Name: **sysop**

**`sysop`** (system operator). Recommended over the alternatives:

- **`operator`** reads as a near-synonym of the existing **`orchestrator`** and will
  be conflated with it in conversation and in the `roles/` index — the orchestrator
  already "operates" a multi-part job. `sysop` names the distinct thing precisely: a
  *system* operator, the host's local systems-operations attendant.
- **`sysop`** is a single, established, unambiguous word for exactly this posture
  (the person/daemon who runs privileged host operations), it collides with no
  existing role or skill, and it is filesystem- and ref-safe.

Used consistently below for the unit (`garden-sysop.{service,timer}`), the script
(`scripts/jobs/sysop.sh`), the sender helper (`scripts/jobs/send-host-op.sh`), and
the journal audit trail (`sysop-log/<GARDEN>/`). The sysop is **not a `roles/`
role** — it runs no `claude`, claims no jobs, and reads no free-form prose; it is a
deterministic script + unit, sibling to the watchers under `scripts/jobs/`, not an
`AGENT.md` posture.

---

## 3. Addressing: the `host/<GARDEN>` bus address

### Send path

Extend `send-msg.sh`'s address grammar with a fourth kind, `host/<GARDEN>`:

```
case "$addr" in
  role/?*|job/?*|host/?*|broadcast) :;;
  *) die "illegal address ...";;
esac
```

The **existing single-segment guard is reused unchanged** and covers the new kind
for free: after the kind prefix, the address must be exactly one path segment
matching `[A-Za-z0-9._-]+` with no leading dot and no embedded slash
(`die "illegal address segment ... (one [A-Za-z0-9._-]+ segment, no leading dot)"`).
This is the property that stops a relpath like `host/../../x` from escaping `msgs/`,
and it must be **preserved** — the sysop address kind adds no new escape surface.

**`<GARDEN>` fits this charset by construction.** A `GARDEN` identity is
`<hostname>-<basename>-<hash8>` of the canonical checkout path (§ Host environment,
CLAUDE.md). It may contain `-` and `.` — both are in `[A-Za-z0-9._-]` — and the
`hostname -s` short name and hex hash never introduce a leading dot or a slash. So
`msgs/host/<GARDEN>/<msgid>.md` is a single-segment, filesystem-safe, git-add-safe
path. (These are *file paths under `msgs/`, never git refs*, so the stricter
ref-name rules — no `..`, no trailing `.`, no `.lock` — do not apply; the leading-dot
ban in the segment guard already excludes `.`/`..` regardless.)

### Read path

Host-directed messages are a **fan-out topic read by exactly one reader** (the
addressed host's sysop), so they use the **topic** mechanism, not the directed
inbox. The directed inbox (`inbox/<doer>/`) is created at job claim and destroyed at
completion — a job doer's lifetime — and `inbox-send.sh` *refuses a recipient that
is not currently active*. The sysop is a **standing daemon**, not a job doer with a
claim lifetime, so the topic model is the correct fit:

```
scripts/jobs/read-msgs.sh sysop-<GARDEN> host/<GARDEN>
```

`read-msgs.sh` prints each not-yet-seen message under `msgs/host/<GARDEN>/`, advances
a **seen-marker kept outside the journal** (`$GARDEN_STATE/seen/sysop-<GARDEN>`), and
returns the count. The out-of-journal cursor is load-bearing: a `git reset --hard`
of any worktree never rewinds the sysop's read position, and each op is surfaced
**exactly once** (§6 idempotency builds on this). The seen-key is namespaced by the
host's own identity so two hosts never share a cursor.

A convenience sender, `send-host-op.sh <GARDEN> op=… key=…`, wraps `send-msg.sh
host/<GARDEN>` and emits the structured op frontmatter (§4), so operators and the
liaison never hand-format a message body.

---

## 4. Operation vocabulary — a closed set, never arbitrary shell

This is the security crux. The sysop dispatches on a **fixed enumeration of ops**,
each with an **exact key:value grammar and bounded arguments**, parsed
deterministically in plain bash **before anything executes** (§5). An op message is
structured frontmatter — *never* an interpreted prose body:

```
op: set-workers
kind: gardener
count: 2
```

The sysop reads `op:` and the op's declared keys with `grep`/`sed`, validates each
against the grammar below, and on any deviation **refuses** (logs + acks a
`refused`/`parse-error`, §8) rather than guessing. Unknown `op:` → refused. Missing
or out-of-grammar argument → parse-error. There is **no `op: shell`, no `op: run`,
no passthrough** — the vocabulary is the whole of what the sysop can do.

The ops, split into two trust tiers (§6):

### Benign tier (reversible, self-healing, host-scoped)

| op | args (grammar) | delegates to | may NOT |
| --- | --- | --- | --- |
| `set-workers` | `kind: <known worker kind>`, `count: <non-negative int>` | `set-workers.sh <kind> <count>` (this host) | scale gardeners to 0 (the script's floor-of-1 refusal stands); write another host's record (cross-host refusal stands); invent an unknown kind (`worker_kind_field` rejects it) |
| `drain` | `state: on\|off`, optional `reason: <text, single line, logged only>` | `drain-fleet.sh on [reason]` / `drain-fleet.sh off` | interpret `reason` as anything but an opaque logged note; touch any host but its own |
| `reset-failed` | *(none)* | `systemctl --user reset-failed 'garden-*'` | reset units outside the `garden-*` glob; `start`/`stop`/`enable` anything |
| `restore` | *(none)* | the deterministic recovery one-shots only: `reset-failed` + `reaper.sh` + `deadmail.sh` | perform the liaison-judgement half of the [restore](../skills/restore/SKILL.md) skill (doom triage / redispatch); read or interpret maintainer-inbox prose |

### Destructive tier (less reversible — stricter gate, §6)

| op | args (grammar) | delegates to | may NOT |
| --- | --- | --- | --- |
| `deploy` | optional `to_sha: <40-hex>` (guard: refuse if it doesn't match `origin/main2` HEAD) | `deploy-garden.sh` (its own drain→quiesce→merge→record→lift→restart sequence) | run git in `$GARDEN_ROOT` itself; deploy a sha other than the current `origin/main2`; bypass the deploy script's own drain/quiesce safety |
| `unit` | `action: start\|stop\|restart`, `name: <installed garden-* unit>` | `systemctl --user <action> <name>` after validating `name` is a currently-installed `garden-*.{service,timer}` | act on any unit not matching `garden-*` and not present in `~/.config/systemd/user/`; ever `enable`/`disable`/`mask`; stop `garden-sysop.*` itself (self-preservation guard — see §7 deploy note) |
| `local-model` | *(none but `authorized_by`)* — the target is resolved on the host from the deployed `local` routing default; **no** `model`/`tag`/`url`/`registry` field (an arbitrary pull is unrepresentable) | starts the non-enabled `garden-local-model-pull.service` (`pull-local-model.sh` runs one `ollama pull` of the frozen target) — an **async** op; acks `accepted-in-progress` then a terminal `done`/`failed` on a later tick | carry a model/tag/url; enable or start `garden-ollama`; delete models/blobs to make room; retarget an active pull. Full design: [sysop-local-model.md](sysop-local-model.md) |
| `maintain` | *(none but `authorized_by`)* — targets exactly `$GARDEN_ROOT`; **no** `path`/`ref`/`force`/`action` field (an arbitrary repo op is unrepresentable) | starts the non-enabled `garden-root-maintenance.service` (`root-maintenance.sh` invokes `root-repo-guard.sh` with the authorized gc-lock escalation) — an **async** op; a cheap synchronous liveness precheck refuses a lock held by a LIVE gc, else it acks `accepted-in-progress` then a terminal `applied`/`refused`/`failed` on a later tick | pass `git gc --force`; clobber a lock held by a live gc; **drop any ref or history** (a store with genuinely missing objects still alerts a human); touch any repo but `$GARDEN_ROOT`. Full design: [sysop-repo-maintenance.md](sysop-repo-maintenance.md) |

Every op is **idempotent by nature** (set-workers to N, drain on/off, reset-failed,
deploy-to-current-sha, unit start/stop to a target state), which combines with the
exactly-once cursor (§3) to make replay safe (§6).

The enumeration is deliberately small. Each entry delegates to an **existing,
hardened, same-host tool** — the sysop adds *addressing and a trust gate*, not new
privileged mechanics. Widening the set later is a deliberate design act (a new op
row, its grammar, its tier), never an open-ended `exec`.

---

## 5. Refusals — hard invariants

The sysop **must never**, stated as invariants the build encodes and tests pin:

1. **Never execute an arbitrary command or a shell string from a message.** There is
   no op that takes a command; the closed set (§4) is exhaustive. A message key the
   grammar does not name is ignored; an `op:` the table does not list is refused.
2. **Never run `claude -p` or any LLM on message content.** The sysop invokes no
   model at all. All parsing and dispatch is plain bash. This mirrors the
   *no-LLM-before-the-gate* shape of `mention-watcher.sh`, `issue-inbox-watcher.sh`,
   and `comment-watcher.sh`'s sender gate: the deterministic check runs in code,
   before anything, and here there is not even a downstream LLM step to gate — the
   sysop's entire behavior is deterministic.
3. **Never touch credentials.** No op reads, writes, or moves any token, key, or
   `~/.config/gh` state. The `gh` identity pin is not in the sysop's path.
4. **Never perform a ferry or any identity switch.** `identity_switch_authorized` is
   maintainer-only and must remain **un-originable by an agent** (§ The ferry,
   CLAUDE.md). The sysop has no ferry op and never sets that flag; it commits its own
   journal writes (acks, audit log) under the ordinary bot identity via the standard
   producer clone, never `GARDEN_GH_IDENTITY=kriskowal`.
5. **Never run git inside `$GARDEN_ROOT`.** The sysop does all its own journal I/O
   through the producer clone under `$GARDEN_STATE` (`GARDEN_PRODUCER_CLONE`), the
   same path every producer uses. The one op that advances the root checkout,
   `deploy`, delegates to `deploy-garden.sh` — the *sanctioned* mover — and never
   itself runs a git command with `$GARDEN_ROOT` as the enclosing repo.
6. **Parsing is deterministic, in plain code, before anything executes.** The gate
   (§6) and the grammar validation (§4) both complete before a single op is carried
   out. A malformed or unauthorized message produces a logged refusal and an ack,
   and nothing runs.

---

## 6. Trust model

### The real boundary is journal push access — say it plainly

The bus **is** `journal2`. A message's `from:`/`from_host:` fields are **self-
asserted by the sender** (`send-msg.sh` writes `from: ${GARDEN_SENDER:-…}` and
`from_host: $GARDEN` verbatim); nothing signs or authenticates them. So the honest,
load-bearing boundary is **"anyone who can push to the journal"** — i.e. the whole
fleet, including a confused or compromised agent. No field *inside* a message can be
a cryptographic auth gate against a party that already has push access.

In this garden that boundary is acceptable as the *foundation*, because journal push
access is held entirely by **the maintainer's own bot instances** (`kriscendobot` et
al.) — the same trust basis every other bus consumer already relies on. The sysop
does not lower that bar; it adds defense-in-depth *on top* of it and bounds the blast
radius of the one threat the boundary admits (a buggy or captured fleet member).

### A conscious departure from the issue-inbox / fork-watch precedent

`issue-inbox.md` and `auto-provision-fork-watchers.md` gate on the **GitHub login of
an external, untrusted text author** — their threat is *prompt injection from a
stranger who can write a comment*. The sysop has **no external author**: every op
sender already has journal push access, and the sysop feeds message content to *no
LLM* (§5.2), so an author-login injection gate is the wrong tool here. The sysop
**consciously departs** from that shape. Its gate is not "is this stranger trusted to
be heard" but two different questions:

1. **Confine the issuance path** (defends against an *accidental* or *stray* op from
   a confused agent). The sysop reads a journal `config/sysop-issuers` — a list of
   `GARDEN` identities permitted to originate ops (default: the **leader** identity,
   since the liaison, the human-facing relay, runs on the leader). An op whose
   `from_host` is not on that list is **dropped, logged, and acked as refused**,
   before any execution. This makes a mis-addressed op from an unexpected host both
   inert and *visible*, rather than silently obeyed.
2. **Attest destructive intent** (raises the bar for the irreversible tier). The
   destructive ops (`deploy`, `unit`, `local-model`, `maintain`) additionally require the message
   to carry `authorized_by: <login>` with `<login>` on the journal `maintainers/allowlist`
   (the same driver-tier list the issue inbox uses). This is **attestation, not
   authentication** — a compromised issuer could forge it — and the doc says so
   plainly; its value is that the destructive tier cannot be triggered by an
   *accident* (a benign-tier op message reused, a truncated body), only by a message
   that *deliberately names a maintainer as authorizer*, which is auditable in the
   journal trail (§8).

Benign-tier ops (`set-workers`, `drain`, `reset-failed`, `restore`) need only the
issuer gate. Their blast radius justifies the lighter bar: each is **reversible and
self-healing** — a forged `set-workers 0`… is refused by the floor-of-1; a forged
`drain on` is lifted by a later `drain off`; a forged `reset-failed` is a no-op on a
healthy host. The worst a forger with push access achieves is transient, host-local,
and self-correcting.

### Why this is safe even against a compromised fleet member

A compromised agent with journal push access could already write its **own** host's
`hosts/<its-GARDEN>` or drop a drain marker on its own host directly — the sysop
grants it no *new* power over itself. It **cannot** use the sysop to reach another
host, because (a) `host/<GARDEN>` addressing means the target host only ever reads
ops aimed at *its own* identity (§3), and (b) even if it forges such a message, the
target's sysop still performs every write *as that target host about itself*,
preserving the §1 invariant. The sysop widens *who can conveniently ask* a host to
act on itself; it does not widen *what any host can do to another*.

### Idempotency / replay

Three layers make a replayed or duplicated op safe:

1. **Exactly-once delivery.** The out-of-journal seen-marker (§3) surfaces each
   `msgid` once; a re-synced or duplicated file already past the cursor is never
   re-processed. `msgid`s are unique (`timestamp + random`) and add-only.
2. **Natural op idempotency.** Every op converges to a target state (§4), so even a
   cursor loss re-applying an op is harmless.
3. **Durable applied-record.** The sysop writes each processed op to
   `sysop-log/<GARDEN>/<msgid>.md` (§8) and skips a `msgid` already recorded there —
   a belt-and-suspenders idempotency check that survives a wiped seen-marker.

---

## 7. Unit shape

### Runs on every host — never leader-gated

The **entire motivation** is the unattended follower (the `ps23` case), so the sysop
must run on **leader and follower alike**. It is therefore the deliberate exception
to the leader-only-singleton rule: `garden-sysop.service` carries **no**
`ExecCondition=is-main-host.sh`. This is safe because the sysop is host-scoped by
construction — it only ever acts on its own host (§1), so there is no double-post /
double-act hazard that motivates leader-gating the other singletons. Each host's
sysop reads only `msgs/host/<its-own-GARDEN>`, so two hosts' sysops never contend.

### Timer + oneshot, self-healed

A **timer-driven oneshot**, matching the fleet idiom rather than a bespoke long-poll:

- `garden-sysop.timer`: `OnCalendar` on an absolute wall-clock schedule (e.g.
  `*:*:00/20` — every ~20s, or `*-*-* *:*:00` per-minute), **not** a relative
  `OnUnitActiveSec` (a relative first-elapse larger than the ~1-minute daemon-reload
  cadence can be re-armed before it fires and starve — the lesson pinned in
  `garden-orchestrate.timer` / `garden-library-source-drift-scan.timer`).
  `Persistent=true` catches up a missed run across downtime. The cadence is a
  responsiveness-vs-churn tradeoff for the build to tune; host ops are rare, so a
  ~20–60s tick is ample and reading an empty topic is nearly free.
- `garden-sysop.service`: `Type=oneshot`, `SuccessExitStatus=143 130 SIGTERM
  SIGINT`, `ExecStart=… self-heal-run.sh garden-sysop -- … sysop.sh`, wrapped by the
  self-heal responder like every other tick. `WantedBy=timers.target` so
  `install-units.sh enable-services` derives and enables it **automatically** (it is
  a normal non-template, non-excluded unit — unlike `garden-mention-watcher`, it is
  *not* on the monitoring-gated exclusion list, because it feeds no external text to
  an LLM).

### Interaction with drain — the undrainable-fleet hazard

**The sysop must run even while the host is drained.** `drain-fleet.sh` gates
*gardeners* (the `fleet_draining` predicate stops new claims); it must **not** gate
the sysop. If the sysop were skipped under drain, a drained host could never receive
its `drain off` op — the fleet would be **wedged undrainable** from the bus, exactly
the failure this design exists to prevent. So `garden-sysop.service` has no
`fleet_draining` guard; a drained host still ticks the sysop and still accepts and
executes ops (including, especially, `drain off`).

### Behavior during a deploy

`deploy-garden.sh` restarts the fleet's units. Two consequences the build handles:

1. **The sysop restarts cleanly.** As a oneshot timer unit, a deploy restart just
   re-arms the next tick; nothing is lost (the seen-cursor and audit log are durable,
   §6). `SuccessExitStatus` already treats the SIGTERM of a restart as a clean exit.
2. **A `deploy` op must ack before it restarts itself.** The sysop tick that runs a
   `deploy` op will be torn down by the deploy's own fleet restart. So the sysop
   **records the accepted op to `sysop-log/` and emits the ack (§8) *before*
   invoking `deploy-garden.sh`**, and marks the op `applied` in the same pre-restart
   write — so the sender learns "deploy started here" even though the acking process
   is about to be replaced. The `unit` op's self-preservation guard (§4) forbids
   `stop garden-sysop.*`, so the sysop can never be told to silence itself.

---

## 8. Observability + ack

**Every accepted op, every refusal, and every parse failure is logged** — to
journald via the `GARDEN_TAG=sysop` `log`/`die` helpers under the self-heal wrapper,
the same as every fleet script.

Beyond logs, the sysop produces **both** a durable record and a bus ack, because the
motivating failure is precisely that a sender **cannot tell "done" from "never
arrived":**

1. **Durable journal audit trail.** For each processed message the sysop writes
   `sysop-log/<GARDEN>/<msgid>.md` with structured, non-prose fields:
   `op`, `from_host`, `outcome ∈ accepted-and-applied | refused | parse-error |
   failed`, a short `detail`, and `at`. This is the idempotency record (§6.3) *and*
   the audit surface — a permanent, greppable "what did host Y do and why" that
   outlives any process.
2. **Bus ack back to the sender.** The sysop replies with a message the sender can
   read, distinguishing the outcomes above, so the failure mode is closed:
   - **applied** — "op `set-workers gardener=2` applied on `<GARDEN>` at `<ts>`";
   - **refused** — "op refused: `from_host` not in `sysop-issuers`" / "unknown op
     `frobnicate`" / "destructive op missing `authorized_by`";
   - **parse-error** — "op `set-workers` missing/invalid `count`";
   - **failed** — the delegated tool exited non-zero; the ack carries its rc/tail.

   The ack is delivered to the **issuer host** as a `host/<from_host>` message (the
   issuer's own sysop-topic doubles as its ack inbox) or, when the op came from a
   live job doer, via `inbox-send <that-doer>` — the build picks the reply channel
   from the message's `reply_to`/`from` fields, defaulting to `host/<from_host>`. A
   sender that sees no ack within a tick or two, and no `sysop-log/<target>/<msgid>`
   record, knows the op **never arrived** (target host down, unit not enabled) — a
   diagnosable, distinct state from "arrived and refused."

The ack and the audit record are written **before** any self-restarting op proceeds
(§7 deploy note), so an op that restarts the host still reports that it started.

---

## 9. Out of scope for the first build

Explicitly deferred, to keep the first cut small and its blast radius legible:

- **No new ops beyond the §4 closed set.** No `enable`/`disable`/`mask`, no
  arbitrary `systemctl`, no package/OS management, no filesystem ops. Widening the
  set is a later, deliberate design act (a new op row + grammar + tier).
- **No cross-host or fan-out ops.** Each op targets exactly one host via its
  `host/<GARDEN>` address. "Drain the whole fleet" is N addressed ops (or the
  existing per-host tools), not one broadcast op — a broadcast op would tempt the
  cross-host action §1 forbids.
- **No scheduled / deferred / conditional ops.** The sysop executes on receipt; "do
  X at time T" or "do X when condition C" belongs to the scheduler, not here.
- **No cryptographic sender authentication.** The trust model (§6) is issuer-
  confinement + maintainer-attestation over the journal-push boundary; a real signed-
  token scheme (a per-host key the sysop verifies) is a possible future hardening,
  noted and not built.
- **The liaison-judgement half of `restore`.** The `restore` op runs only the
  deterministic recovery one-shots (§4); doom triage and redispatch stay with the
  liaison/maintainer.
- **Ferry and any identity switch — permanently out, not merely deferred** (§5.4).
- **No role or skill file.** The sysop is a script + unit, not a `roles/` posture;
  the follow-on build writes `scripts/jobs/sysop.sh`, `scripts/jobs/send-host-op.sh`,
  the `garden-sysop.{service,timer}` units, the `send-msg.sh` `host/` grammar
  extension, the `read-msgs.sh`-based consume loop, and the test coverage (a
  deterministic-stub harness in `scripts/jobs/test/` asserting: benign op applied;
  destructive op refused without `authorized_by`; unknown op refused; parse-error
  acked; issuer-gate drop; exactly-once replay; ack + audit record on each outcome;
  runs under drain; accepts `drain off` while drained; never invokes `claude`).

---

## 10. Alternatives considered

- **A `roles/sysop/AGENT.md` claimed off the board.** Rejected: host operations must
  be *deterministic and un-attended*, and a role runs `claude -p` on a job body —
  precisely the LLM-on-host-ops surface §5 forbids. The board also cannot pin a job
  to a host (§0), so a claimed sysop job could run on the wrong host. A deterministic
  per-host unit is the right shape.
- **An `only_host`/affinity field on the job board.** A more invasive change to the
  claim protocol (every claimer would filter on it), and it still leaves *execution*
  to an LLM gardener. Host ops want a dedicated deterministic consumer, not a
  host-filtered job. Considered and set aside; a host-affinity board field may still
  be worth it for *other* work, independently of the sysop.
- **Reusing the directed inbox (`inbox/<doer>/`) instead of a `host/` topic.**
  Rejected: the inbox is claim-lifetime state (`inbox-send.sh` refuses an inactive
  recipient), and a standing daemon has no claim. The topic model with an
  out-of-journal cursor is the correct fit for a permanent single reader (§3).
- **Gating ops on a maintainer *login* allowlist (the issue-inbox shape).** Rejected
  as the *primary* gate: the sender is internal fleet infrastructure with an
  unauthenticated `from:`, not an external author, so a login gate defends against
  the wrong threat (§6). The maintainer allowlist is retained only as the *destructive-
  tier attestation*, where "a maintainer deliberately authorized this" is the point.
- **No gate at all, trusting the journal-push boundary alone.** Rejected: the boundary
  admits a confused or compromised agent (§6), and an *accidental* host-op from a
  buggy sender should be inert and visible, not silently obeyed. The issuer-confinement
  gate is cheap defense-in-depth that makes strays refusable and auditable.
