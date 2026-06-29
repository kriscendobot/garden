---
created: 2026-06-29
updated: 2026-06-29
author: gardener
---

# RAFT leader election over journal2 (slow-cadence automatic failover)

| Created | 2026-06-29 |
| Author  | gardener |
| Status  | Proposed |

This design closes the failover gap that
[multibot-leader-follower.md](multibot-leader-follower.md) deliberately left
open. That design split the fleet into a leader (runs the singletons) and
followers (run only the gardener pool), gated by the `hosts/main-host` journal
marker and the `is-main-host.sh` predicate, and ended on:

> `set-main-host.sh` CAS-writes `hosts/main-host` … Leadership is changed by
> hand: if the leader dies, the singletons stay down until the marker is
> re-pointed. **Lease-based election (automatic failover) is a separate, harder
> follow-on.**

**This is that follow-on.** It elects the leader automatically with RAFT,
adapted from the reference implementation in
[`kriskowal/cask`](https://github.com/kriskowal/cask) (`go/raft/`), and runs the
election at a deliberately glacial, half-hour cadence. The output stays the
existing `hosts/main-host` marker, so `is-main-host.sh` and every
`ExecCondition=` gate keep working; `set-main-host.sh` degrades to a seed and
break-glass override. No script changes ship in this PR — it is the design for
review.

---

## 0. What we take from cask, and what we change

cask's `go/raft/` (`caskraft`) is an **election-only** RAFT: it implements the
three states (Follower / Candidate / Leader), the three messages (RequestVote
"plea", Vote, Heartbeat "poll"), term monotonicity, and majority quorum — and
**nothing else**. It does *not* replicate an arbitrary command log; its only
state-machine output is "who is leader." That is exactly the garden's need: we
do not want to replicate commands through RAFT (the job board already does that),
we only want to agree on which host runs the singletons. So we adopt cask's
structure directly and adapt three things:

| cask (`go/raft/`) | this design (journal2) |
|---|---|
| In-memory `Election` event loop, millisecond timers | A stateless **every-host systemd tick** over durable journal2 state, minute timers |
| `Network.Send(Message)` over UDP | **Commit a record to journal2** (a `git push` — the CAS) |
| `Election.Handle(message)` from a UDP socket | **Read the relevant journal2 records** on the next tick |
| `currentTerm`, `votedFor`, leadership held **in RAM** (cask must persist them to survive a crash) | The same state as **durable journal2 files** — crash-safe by construction |
| `quorum = (len(members)+3)/2` over `members` (the *other* peers) | identical: `quorum = floor(N/2)+1` over the journal voter roster |
| RequestVote granted `if state.Leader == ""` (a simplification) | **stricter canonical rule**: one vote per term, enforced by a per-voter ledger file |

The one place we are deliberately *stricter* than cask: cask grants a vote
whenever it knows of no leader, which can let a node vote twice in a term under
adversarial timing. At millisecond cadence in a trusted LAN that is harmless; at
half-hour cadence a sloppy vote rule could elect two leaders, so we enforce
canonical RAFT's "at most one `votedFor` per term" using the durable ledger
(§3). cask gets this nearly for free because of its tight timing; we get it
literally for free because journal2 already persists every vote.

---

## 1. Mapping RAFT onto journal2

### 1.1 journal2 *is* the replicated log

The job board already establishes the substrate: **the `git push` to
`origin/journal2`, accepted only as a fast-forward, is the fleet's
compare-and-swap** ([job-board.md](job-board.md) §2). Claims, `set-gardeners.sh`,
and every producer ride that CAS. RAFT rides the same rail. We add one new tree
to journal2:

```
raft/term                     currentTerm — the monotone global term floor (one integer)
raft/votes/<term>/<voter>     votedFor: the candidate <voter> granted its vote to in <term>
raft/log/<term>               a committed leadership grant {term, leader} — the RAFT log entry
raft/heartbeat/<leader>       the live lease assertion {term, seq} — seq monotone per leader
raft/members/<host>           the voter roster (who counts toward quorum) — §4
hosts/main-host               the APPLIED output: the committed leader's identity (UNCHANGED path)
hosts/main-host-term          the term that won hosts/main-host (NEW — lets a stale writer lose the CAS)
```

`raft/term` and `raft/votes/<term>/<voter>` are RAFT's two pieces of **persistent
state** (`currentTerm`, `votedFor`). `raft/log/<term>` is the **log**: in an
election-only RAFT each log entry is exactly one leadership grant (term →
leader). `hosts/main-host` is the **applied state-machine output** — the leader
of the highest committed term — and it keeps its stable path so nothing
downstream churns. We deliberately do **not** implement `AppendEntries`
replication of arbitrary commands; that layer is the job board, already
CAS-serialized at a different altitude.

### 1.2 RAFT transitions as journal2 records

cask sends point-to-point messages; we **commit records to a shared log**, which
is strictly more convenient — a candidate need not collect N vote RPCs, it reads
the tally straight from `raft/votes/<term>/`. The three message subjects map to:

- **RequestVote** — a candidate does not "send" anything to ask. It advances the
  term (CAS-writes `raft/term = T`) and votes for itself
  (`raft/votes/<T>/<self> = self`). Its candidacy *is* the presence of its
  self-vote at the new term, visible to all on their next sync.
- **Vote** — a voter, on its tick, sees a higher term with no committed leader,
  and if it has not yet voted in that term (no `raft/votes/<T>/<self>` exists),
  CAS-writes `raft/votes/<T>/<self> = <candidate>`. The push **is** the vote.
- **Heartbeat** — the leader, each heartbeat interval, bumps
  `raft/heartbeat/<self>.seq`. A follower "receives" it by observing that `seq`
  advanced since its last sync (§3.2 explains why we track `seq`, not a
  wall-clock timestamp).

cask's `if message.Term > e.state.Term { become Follower }` maps directly: on
each sync a host reads `raft/term`; if it exceeds the term the host thought it
held, it reverts to Follower at the new term — the same demotion, triggered by a
ledger read instead of an inbound packet.

### 1.3 Reconciling cask's UDP+block-CAS transport with git-CAS

cask is "half a century of networking and databases with just UDP and a CAS of
1KB blocks." The analogy is exact at every layer:

- **cask's CAS of 1KB content-addressed blocks ↔ the garden's git-CAS on
  journal2.** Both accept a write only against an expected prior state; both make
  the accepted write the single serialization point.
- **cask's UDP datagram (unreliable, may be dropped) ↔ a `git push` that may be
  rejected** for losing the fast-forward race. A rejected push is the analogue of
  a dropped/again-tried RPC: the writer re-syncs (`fetch` + `reset --hard
  origin/journal2`) and retries. Backoff is the garden's
  `backoff()` — exponential with full jitter (`common.sh`, per kriskowal#10) —
  the direct counterpart of cask's **RFC 6298 retransmission timeout with Karn's
  algorithm** ([[casknet-rtt-and-retransmission-timeout]]). A stale-term writer
  that keeps losing the CAS is the analogue of a partitioned peer whose packets
  never land; it makes no progress and, on its next successful sync, discovers a
  higher term and steps down.
- **cask's UDP heartbeats ↔ periodic journal2 heartbeat records.** cask re-sends
  a heartbeat every 100 ms; the garden bumps `raft/heartbeat/<leader>.seq` every
  ~10 minutes. Same role (assert liveness), 6000× slower (§2).

The structural upgrade journal2 buys us: cask's RAFT state lives in RAM and must
be explicitly persisted to survive a process restart (canonical RAFT requires
`currentTerm`/`votedFor` on stable storage before responding). In the garden
those facts are *already* durable journal2 files, so a host that crashes and
restarts simply re-reads the ledger and resumes in the correct term with its
prior vote intact — no separate write-ahead step.

---

## 2. The half-hour cadence, justified

cask's timers are LAN-scale: `minElectionTimeout = 150ms`,
`maxElectionTimeout = 300ms` (a 2× randomized spread), `heartbeatTimeout =
100ms` (≈⅔ of the minimum election timeout, so a couple of heartbeats land per
election window). We preserve those **ratios** and scale them up ~6000–12000×.

| Symbol | Knob | Default | cask analogue | Meaning |
|---|---|---|---|---|
| `Tt` | `GARDEN_RAFT_TICK` | **5 min** | (the event loop) | every-host timer period: fetch journal2 + evaluate. Reads are cheap and do **not** push. |
| `Th` | `GARDEN_RAFT_HEARTBEAT` | **10 min** | `heartbeatTimeout` 100ms | leader bumps `raft/heartbeat.seq` this often — the **only** steady-state write. |
| `Te` | `GARDEN_RAFT_ELECTION_MIN`..`_MAX` | **[30, 50] min** | `min/maxElectionTimeout` 150–300ms | a follower seeing no heartbeat advance for its own randomized `Te` becomes a candidate. |
| `L` | `GARDEN_RAFT_LEASE` | **20 min** | (implicit in the election window) | leader lease: a leader that has not refreshed its heartbeat within `L` **steps down locally** (§3.3). |

Constraints honored by the defaults (each in the holder's *own* monotonic clock):

- `Te_min (30) ≥ 3·Th (30)` — tolerates two missed heartbeats before a follower
  even considers an election, so transient journal blips never trigger one.
- `L (20) = 2·Th` — a leader tolerates one fully-missed heartbeat cycle before
  self-demoting.
- **`L (20) < Te_min − Tt (30 − 5 = 25)`** — the safety inequality (§3.3): a
  leader self-demotes strictly before any follower's election timer can fire.
  5-minute margin absorbs clock-rate skew and replication lag.

**Why glacial is correct, even desirable, here:**

1. **Leadership gates only singleton scheduling, never data safety.** A
   leaderless gap does not lose work: followers keep race-claiming jobs off the
   board the entire time ([multibot](multibot-leader-follower.md) — gardeners run
   everywhere). Only the singletons pause — scheduler, foreman, bulletin,
   deadmail, reaper, follow-up, proxy, mentor, mirror-closer, the comment/mention/
   triager/issue-inbox watchers, the watchman broadcast, and the leader-only
   maintainer-inbox Monitor. Each is a periodic or best-effort task; a
   half-hour-to-an-hour stall in any of them is invisible to the work the fleet
   is actually doing.
2. **It minimizes journal2 contention.** The board is busy; RAFT must not add
   churn. At steady state the cost is **one tiny commit per `Th` = one heartbeat
   bump every 10 minutes** from the single leader. Followers only *read* (a
   `git fetch`, no CAS, no contention). Compared to the gardener pool's constant
   claim/complete traffic this is rounding error — a slow cadence is what makes
   RAFT-on-the-busy-board affordable at all.
3. **Worst-case failover latency is acceptable.** From a leader's death to a new
   leader committing `hosts/main-host`: a follower's election timer (≤ `Te_max` =
   50 min) + vote collection across a few ticks (~2–3·`Tt` ≈ 10–15 min) ≈ **up to
   ~65 min worst case, typically ~`Te` (30–50 min)**. For tasks whose own natural
   periods are minutes-to-hours and whose pause loses nothing, that is fine. The
   manual break-glass (§5) remains for the rare case an operator wants failover
   *now*.

---

## 3. Safety: never two leaders running the singletons

The singletons are duplication-intolerant — two bulletins double-post, two
schedulers double-dispatch. The whole design earns its keep only if it
guarantees **at most one host both (a) is named leader and (b) is actually
running the singletons** at any instant. Three mechanisms combine.

### 3.1 Election safety — at most one leader *per term*

Identical to canonical RAFT, enforced by the ledger:

- **One vote per term.** A voter writes `raft/votes/<T>/<self>` at most once: on
  its tick it first reads its own vote file for term `T`; if present it does not
  re-vote, if absent it CAS-writes its grant. Because each voter touches only its
  own path, the push is a pure fast-forward of one file and cannot race another
  voter — but the voter's *self-read-before-write* is what enforces single
  voting. With at most one vote per voter per term, at most one candidate can
  reach `quorum = floor(N/2)+1`, so **at most one leader per term**.
- **Term monotonicity via the CAS.** `raft/term` only increases. A candidate
  advancing to `T` must win the push that writes `raft/term = T`; if another host
  already advanced to `T` (or beyond), the candidate loses the fast-forward,
  re-syncs, sees the higher term, and reverts to Follower — exactly cask's
  `message.Term > state.Term` demotion.
- **Commit guarded by term.** A candidate that reaches quorum commits by writing
  `raft/log/<T>`, then CAS-updating `hosts/main-host = self` **and**
  `hosts/main-host-term = T` — but only if the current `hosts/main-host-term <
  T`. A stale ex-leader trying to re-pin the marker at an old term loses this CAS.

### 3.2 Liveness detection without synchronized clocks

RAFT assumes **no synchronized clocks** — every timer is local and monotonic. We
honor that: a follower must not compare a leader's wall-clock heartbeat timestamp
against its own clock (cross-host skew would be unsafe). Instead the heartbeat
record carries a **monotone `seq`** the leader bumps on every emission. Each host
keeps, under `$GARDEN_STATE` (outside any reset-prone worktree, like the
triager/watchman cursors), the last `(term, seq)` it observed for the current
leader **and the local monotonic time it observed that advance**. On each tick:

- if `seq` advanced since last sync → the leader is alive; reset the local
  election deadline to `now + rand(Te_min, Te_max)`.
- if `seq` is unchanged and the local election deadline has passed → time out and
  stand for election.

Staleness is thus measured entirely in the follower's own clock, against the
*event* of last seeing the heartbeat move — robust to any clock skew, exactly as
cask's `resetElectionTimer()` is driven by local `time` events.

### 3.3 The lease — the rule that actually prevents split-brain

Election safety (§3.1) guarantees one leader per *term*, but the dangerous case
is a **partitioned ex-leader**: host `A` won term `T`, `hosts/main-host = A`, then
`A` loses connectivity to `origin`. `A`'s `is_main_host` still reads the cached
marker naming itself, so without a further rule `A` keeps running the singletons
while a fresh majority elects `B` at term `T+1` — two live leaders. This is the
exact hazard the multibot design flagged ("so the `is-main-host` in-process
re-check in the bulletin/watchman goes quiet in time").

The fix is a **leader lease** that makes leadership a *time-bounded* claim, not a
marker lookup:

- **Leader side — self-demotion.** The leader records locally (under
  `$GARDEN_STATE`) the monotonic time of each *successful* heartbeat push (a push
  that actually landed on `origin/journal2`). On every tick it checks: have I
  pushed a heartbeat within `L`? If not — because I am partitioned, my pushes are
  failing — I **step down locally**: set my role to Follower and stop asserting
  leadership. A partition is indistinguishable to `A` from "I have lost the
  election I cannot see," and it treats it that way.
- **Predicate side — lease-aware `is_main_host`.** This is the one extension to
  the existing gating contract. `is_main_host` becomes:

  > leader **iff** `hosts/main-host` names me **and** my locally-recorded
  > last-confirmed-leadership time is within `L`.

  The "confirmed leadership" timestamp is refreshed only by a successful sync that
  re-reads the marker still naming me with no higher term present. A partitioned
  leader cannot refresh it, so after `L` the predicate returns **false even though
  the marker still names self** — and the in-process re-checks in the bulletin and
  watchman broadcast (which already call `is_main_host` every loop, per multibot
  §Gating) go quiet. `is-main-host.sh` keeps its exit-0/1 contract; only the body
  of `is_main_host` in `common.sh` gains the freshness clause. For a follower the
  predicate is unchanged (marker names someone else → false). The single-host
  fail-open (`GARDEN_MAIN_HOST_DEFAULT=leader`) is preserved (§5).

- **Why no overlap.** Both timers start from the **same physical event** — the
  leader's last successful heartbeat push, which is also the latest heartbeat any
  follower could have observed (the follower sees it no earlier than the leader
  pushed it, and in practice up to a tick later). The leader's lease expires at
  that event `+ L`; the earliest a follower's election timer can fire is that
  event `+ Te_min`, and a new leader cannot commit until after collecting a
  quorum (later still). With **`L < Te_min − Tt`** the old leader's singletons go
  quiet *strictly before* any new leader can start running its own — so the two
  leadership intervals never overlap. The 5-minute default margin (20 < 25)
  absorbs clock-rate skew and replication lag.

### 3.4 Lost-CAS races and stale terms

Every RAFT write is a `git push` that may be rejected (§1.3). The rule is the job
board's, unchanged: **a write that touches contended state re-syncs and retries
with `backoff()`; a stale term simply loses.** Concretely — two candidates both
try to advance `raft/term` to `T`: the first push wins, the second is rejected,
re-syncs, finds `raft/term = T` already held by a rival's self-vote, and (having
not yet voted in `T`) becomes a follower and may vote for the rival rather than
re-contesting. A leader's heartbeat push that loses a race (someone else wrote a
neighboring `raft/` file) retries — it only fast-forwards its own
`raft/heartbeat/<self>`, so like a completion it is always safe to retry. The
backoff is the retransmission timeout; the rejection is the dropped packet.

---

## 4. Membership — the voter set

Quorum is `floor(N/2)+1` over **N = the number of voters**, so the voter set must
be explicit and carefully changed. Today host presence is implied by
`hosts/<host>` (a gardener *count*, which may legitimately be 0), so we do **not**
overload it. The voter roster is a dedicated tree:

```
raft/members/<host>      one file per voting host (content: admitted-at, by-whom)
```

The raft tick reads `raft/members/` to compute `N` and hence `quorum`.

- **Admission.** A new host is added by an operator action
  (`raft-add-member.sh <host>`, a sibling of `set-main-host.sh`) — a deliberate,
  CAS-raced journal write. This mirrors cask's trust root:
  [[cask-cluster-provisioning]] keeps **manual `cask invite`/`cask accept` key
  exchange as the deliberate trust root**; joining a quorum is likewise a
  deliberate admission, not an automatic gossip. Changing `N` changes quorum, so
  admit (and remove) **one host at a time during a quiescent period** — a
  pragmatic substitute for RAFT's joint-consensus membership change, acceptable
  because changes here are rare, operator-driven, and the cadence is glacial. (A
  full joint-consensus protocol is noted as a future refinement.)
- **Removal of a permanently-dead host.** A dead voter still counts toward
  quorum, which can wedge it (3 members, 1 dead → quorum 2, the 2 live still
  elect; **2 members, 1 dead → quorum 2, wedged**). An operator removes
  `raft/members/<host>` (`raft-rm-member.sh <host>`) once the host is *confirmed*
  dead, shrinking `N` so the survivors regain a quorum. A dead host cannot vote
  to evict itself, so removal is necessarily operator-driven — the unwedge of
  last resort, alongside the §5 break-glass.
- **The 2-host reality today.** The fleet is currently exactly two voters,
  `endolinbot` (leader) and `endolinbot2` (follower). Quorum is `2/2`: **losing
  either host wedges automatic election** until the operator either evicts the
  dead host or uses the break-glass override. This is the classic two-node
  quorum problem and is called out honestly: this design is still strictly safer
  than today (it cannot elect two leaders), but **real single-fault-tolerant
  failover needs a third voter** (quorum `2/3` survives one death). The migration
  (§5) recommends adding a third before relying on hands-off failover.

---

## 5. Integration and migration

### 5.1 The gating contract is preserved

- `hosts/main-host` stays the committed applied output; `is-main-host.sh` keeps
  its exit-0/1 `ExecCondition=` contract. The **only** code change to the
  predicate is the lease-freshness clause in `is_main_host` (§3.3); every gated
  unit (foreman, scheduler, deadmail, reaper, follow-up, proxy, mentor,
  mirror-closer, comment-watcher@, mention-watcher, triager@, issue-inbox,
  library-source-drift-scan) and the two in-process gates (bulletin, watchman
  broadcast) keep working unchanged.
- `hosts/main-host-term` is added so a stale writer loses the CAS (§3.1).

### 5.2 `set-main-host.sh` degrades to seed + break-glass

`set-main-host.sh` is no longer the *only* way leadership changes — it becomes:

1. **Seed / bootstrap.** Before any election has run (cold start), it writes the
   initial `hosts/main-host` + `hosts/main-host-term = 0` so a freshly-stood-up
   fleet has a definite incumbent and does not all-time-out into a thundering
   first election.
2. **Break-glass override.** When quorum is unreachable (the 2-of-2 wedge, or an
   operator wanting *immediate* failover rather than waiting out `Te`), it forces
   a leader. To dominate the running election machinery it must write
   `hosts/main-host-term = currentTerm + 1` (and bump `raft/term`), so the forced
   leader's term beats any in-flight candidacy; otherwise the elected machinery
   would fight the manual marker. (This term-bumping behavior is the one change
   `set-main-host.sh` needs when RAFT is live — specified here, implemented later.)

### 5.3 The tick is an every-host timer, not a leader-only singleton

The election tick **must run on every host** — leader-only would be a
contradiction (a dead leader could never be detected or replaced). It joins the
per-host local-infra units (alongside `clone-keeper`,
`journal-worktree-keeper`, `repo-watcher`, `unblock`, the watchman's
ff/maintenance half): an every-host `garden-raft-tick.{service,timer}`,
`Type=oneshot` + `.timer` at period `Tt`, with **no** `is-main-host`
`ExecCondition` (every host evaluates the election; the *role* it then plays —
emit a heartbeat vs. watch for one — is decided inside the tick from the ledger).
The tick is deterministic shell, **no LLM** — like `is-main-host.sh` and
`unblock`, it is plain-code fleet plumbing.

### 5.4 Rollout, no flap

1. **Phase 0 (today).** Manual marker, no tick. `endolinbot` is leader; behavior
   unchanged.
2. **Phase 1 — shadow.** Deploy `garden-raft-tick` on both hosts in
   **observe-only** mode (`GARDEN_RAFT_COMMIT=0`): it computes the election and
   logs what it *would* do but does not write `hosts/main-host`. Seed the roster
   (`raft/members/endolinbot`, `raft/members/endolinbot2`) and seed the incumbent
   via `set-main-host.sh endolinbot`. Verify the tick re-elects the incumbent,
   emits heartbeats, and never proposes a flap while `endolinbot` stays alive.
3. **Phase 2 — commit.** Flip `GARDEN_RAFT_COMMIT=1`. Because `hosts/main-host`
   already names the incumbent and the incumbent keeps its lease fresh, the tick
   merely continues emitting heartbeats and re-affirming the same leader at the
   seeded term — **no flap**. A follower stands for election only if the
   incumbent's heartbeat goes stale, which is precisely the failover we want.
4. **Phase 3 — fault tolerance.** Admit a **third voter** (or accept the 2-of-2
   no-failover posture with the §5.2 break-glass as the documented stopgap)
   before depending on hands-off failover. The liaison's stand-up/stand-down
   vocabulary (multibot §Liaison) gains "seed leader" / "evict dead host" verbs
   mapping to the seed and removal scripts.

---

## 6. Open questions / future refinements

- **Joint-consensus membership change.** §4 admits/evicts one voter at a time
  during quiescence rather than running RAFT's two-phase joint consensus.
  Adequate for a tiny, slow, operator-driven fleet; revisit if membership churns.
- **Pre-vote / disruption avoidance.** A partitioned-then-rejoined ex-leader can
  bump the term and force a needless re-election. RAFT's pre-vote extension
  avoids it; at this cadence the cost is one extra slow election, so pre-vote is
  deferred.
- **Lease vs. clock-rate skew.** The `L < Te_min − Tt` margin (5 min default)
  assumes bounded clock-rate skew between hosts. On hosts with wildly drifting
  clocks, widen the margin (raise `Te_min` or lower `L`). Monotonic-clock
  comparison already removes absolute-offset skew; only rate skew remains.
- **Heartbeat-record GC.** `raft/votes/<term>/` and `raft/log/<term>` accumulate
  one term-keyed subtree per election. A trivial pruner (keep the last K terms)
  can run as part of the every-host tick or the reaper; out of scope here.

---

## References

- [`kriskowal/cask`](https://github.com/kriskowal/cask) `go/raft/`
  (`raft.go`, `machine.go`, `doc.go`) — the reference election-only RAFT this
  design adapts: Follower/Candidate/Leader, RequestVote/Vote/Heartbeat, term
  monotonicity, `quorum = (len(members)+3)/2`. cask's premise — "half a century
  of networking and databases with just UDP and a CAS of 1KB blocks" — is the
  transport we reconcile with journal2's git-CAS (§1.3).
- [[casknet-rtt-and-retransmission-timeout]] — cask's RFC 6298 retransmission
  timeout with Karn's algorithm, the analogue of the garden's `backoff()` over a
  rejected push.
- [[cask-cluster-provisioning]] — cask's deferred multi-node membership design;
  its manual `invite`/`accept` trust root is the model for operator-driven voter
  admission (§4).
- [multibot-leader-follower.md](multibot-leader-follower.md) — the
  leader/follower split, the `hosts/main-host` marker, `is-main-host.sh`, the
  gated-unit list, and the explicit "manual; no failover" gap this design closes.
- [job-board.md](job-board.md) and `skills/job-board/SKILL.md` — the journal2
  push-CAS that already serializes fleet state; the rail RAFT rides.
- `scripts/jobs/is-main-host.sh`, `set-main-host.sh`, `common.sh`
  (`main_host` / `is_main_host` resolution order, the `GARDEN`/`GARDEN_HOST`
  identity knob, `backoff`) — the integration surface (§5).
