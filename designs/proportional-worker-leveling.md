| | |
| --- | --- |
| Created | 2026-09-09 |
| Author | mentor (gardener, job `design-proportional-worker-leveling`) |
| Status | Reviewed — approved for build with amendments (mentat review, 2026-09-09) |

# Proportional worker leveling across hosts

## Decision

Replace the identical per-host `monk` ceiling with a bounded apportionment of
one fleet-wide monk ceiling. A host's share is derived from its calibrated
weekly Anthropic cap in `config/budget-pools`. The existing spend-headroom
calculation still selects a target between that host's floor and apportioned
ceiling. The existing dwell, confirmation, and one-step movement then approach
that target.

Do not use Anthropic caps to level `cleric`. Both hosts' clerics draw one shared
Codex account, so there is no truthful per-host budget share. Size the shared
cleric fleet from claimable demand, and split it by the host eligibility of
queued work. The cleric rule redistributes a separately configured shared
concurrency envelope; it neither invents nor estimates a Codex quota.

These decisions are independent of the unimplemented session-quota sensor in
[`session-budget-pace.md`](session-budget-pace.md). Proportional monk ceilings
can land first. When session pacing lands, it supplies an additional, lower
headroom target beneath the same weekly-cap-derived ceiling.

## 1. Monk: allocate one fleet ceiling by calibrated cap

### 1.1 Inputs

For every enabled Anthropic weekly-token pool `h`:

```
C_h = its positive calibrated weekly cap from config/budget-pools
S_h = spend in the current weekly window
q   = GARDEN_TOKEN_BACKOFF_FRACTION
L   = GARDEN_BUDGET_LEVEL_MIN, initially 1
P_h = the host's hard monk capacity, initially 4
F   = GARDEN_MONK_FLEET_CEILING, initially 6
```

`F=6` is the concrete two-host rollout value. It preserves the established
four-worker ceiling for the 143M pool and adds the smaller pool only at its
proportional two-worker ceiling. It is an explicit fleet concurrency policy,
not a quantity inferred from current worker counts. Adding a host therefore
does not silently add fleet-wide concurrency. An operator may later change
`F`, but cap calibration alone must not change it.

Require `F >= N*L`, where `N` is the number of enabled Anthropic pools. If the
declared fleet ceiling is smaller, or if `sum(P_h) < F`, fail closed for
actuation, warn once, and leave every monk count unchanged. Do not silently
relax a floor or discard unallocatable capacity.

### 1.2 Bounded largest-remainder apportionment

Give every host its floor first, then apportion the discretionary slots by cap:

```
R = F - N*L
x_h = R * C_h / sum(C)
U_h = L + floor(x_h)
```

Assign the remaining `F - sum(U_h)` slots in descending fractional remainder
`x_h - floor(x_h)`. Break an exact tie by bytewise pool id. A host at `P_h`
leaves the competition; recompute the quotas for the still-unassigned slots
over uncapped hosts. This bounded Hamilton apportionment continues until all
`F` slots are assigned. The preflight above makes failure to assign impossible
for valid input.

The floor is a deliberate liveness reservation, so only the capacity above the
floor is proportional. This makes the rounding behavior and the small-pool
subsidy explicit instead of hiding either in independent 1-to-4 bands.

For the current calibrated caps:

```
C_ece02cb4 = 143,000,000
C_garden2  =  64,000,000
F = 6, L = 1, P_h = 4

R = 4
x_ece02cb4 = 4 * 143/207 = 2.763...
x_garden2  = 4 *  64/207 = 1.237...

U_ece02cb4 = 1 + floor(2.763) = 3
U_garden2  = 1 + floor(1.237) = 2
```

The leftover slot (`F - sum(U_h) = 6 - 5 = 1`) goes to `ece02cb4`, which has
the larger fractional remainder (0.763 vs 0.237), for final ceilings of 4 and
2. Thus
garden2 cannot climb to four merely because its own fractional headroom is
high. Its calibrated cap gives it a ceiling of two while the present fleet
envelope and caps remain unchanged.

### 1.3 Existing headroom rule under the new ceiling

For each host with a valid spend reading, retain the current controller's
headroom fraction and half-up rounding, substituting `U_h` for the shared
`GARDEN_BUDGET_LEVEL_MAX`:

```
H_h = clamp(1 - S_h / (q*C_h), 0, 1)
T_weekly_h = L + floor(H_h * (U_h - L) + 0.5)
```

At zero measured spend, the two hosts target 4 and 2. At or above the
high-water mark, each targets the existing floor of 1. The floor intentionally
dominates proportionality near exhaustion: it is the fleet's minimum liveness
policy, not spare budget.

The target is not the actuator command. Feed `T_weekly_h` into the existing
per-host movement path unchanged:

1. Compare the target with the declared current count.
2. Maintain the existing direction streak in the per-host dwell record.
3. Require `GARDEN_BUDGET_LEVEL_UP_CONFIRM` confirmations before an increase
   and `GARDEN_BUDGET_LEVEL_DOWN_CONFIRM` confirmations before a decrease.
4. Move by at most `GARDEN_BUDGET_LEVEL_STEP` and never past the target.
5. Use the existing local `set-workers.sh` or remote sysop operation.

This design changes the target ceiling only. It does not replace the controller
that cautiously approaches the target.

### 1.4 Fleet-wide provenance gate

The present provenance check is per row. Proportional allocation adds a
denominator, so its validity is fleet-wide: one missing or uncalibrated pool
would give every other pool too large a share.

Before computing any `U_h`, require every enabled Anthropic weekly-token row to
have:

- a positive integer cap;
- provenance accepted by the existing `budget_level_uncalibrated` rule; and
- a corresponding host and hard-cap input.

If any row fails, actuate no monk host during that tick and issue one
deduplicated diagnostic naming the bad pool. Continue to reject placeholder,
empty, `seed`, and other self-disclaiming provenance exactly as today. A pool
must be deliberately disabled or removed from the enabled fleet set before it
may be excluded from the denominator. Mere sensor failure is not removal.

One denominator-independent exception keeps the throttle direction prompt
during a frozen tick. At or above a host's own high-water mark, `H_h = 0`
makes `T_weekly_h = L` for **every** possible ceiling — the target does not
depend on `U_h` or on any other pool's cap. A host whose own row is calibrated
and whose own spend reading is valid may therefore still be leveled
**downward toward `L`** while the fleet gate is failing, through the same
dwell, confirmation, and one-step path. This is not a partial apportionment:
no share is computed and no count is ever raised on a frozen tick. Without
this carve-out, one uncalibrated pool would freeze every *other* host at its
current count even while that host burns past its own high-water mark — a
regression from today's per-row isolation, and not hypothetical: the garden2
pool sat uncalibrated for roughly a day across 2026-09-04/05.

After ceilings are valid, a missing or invalid spend reading remains isolated
to that host and leaves its count unchanged, matching the current fail-open
sensor posture. It must never be reinterpreted as zero spend.

## 2. Cleric: shared-account demand allocation

### 2.1 Why the monk rule does not apply

The `openai-codex-shared` checkpoints describe one Codex subscription used by
both hosts. A ratio between host-local Anthropic caps says nothing about how
many clerics either host should run. Fabricating two Codex sub-budgets would
double-count one account and make a host label look like a spending boundary.

Use a separate configured `GARDEN_CLERIC_FLEET_CEILING=K_max`. At rollout,
initialize it to the sum of the two currently declared cleric counts, making
the first tick redistribution-only. Changing that value is an operator policy
decision based on the shared account and host capacity. It is not derived from
`config/budget-pools`.

`K_max` (with the fleet drain) is also the operator's throttle lever. Once
this allocator exists it is the designated writer for cleric count lines and
will restore a raw `set-workers.sh` edit on its next tick, exactly as the monk
leveler already does for monk counts (cybernetics-audit.md § 4.1). The
2026-09-02 codex quota shutdown, performed then by zeroing counts directly,
would under this design be expressed as `K_max = 0` (active claims grandfather
and drain off as they complete, per § 2.2).

### 2.2 Demand and total count

On each leader tick, let:

```
E = cleric-capable, reachable hosts
N = |E|
A_h = live doin jobs currently owned by a cleric on host h
A = sum(A_h)
J = claimable todo jobs for which at least one cleric host is eligible
Q = |J|
K_idle = min(N, K_max)
K_demand = min(K_max, A + Q)
K = max(K_idle, K_demand, A)
```

The `A` term grandfathers already-running work if an operator lowers `K_max`:
leveling never preempts a claim to enforce the new envelope. The count falls
under `K_max` as those claims complete. `K_idle` keeps one ready cleric per host
when the shared queue is empty, where the envelope permits it. An unreachable
or deterministically ineligible host is not in `E` and gets no newly allocated
slot.

`J` uses the same static provider, model, role, explicit-host, and capability
constraints used by claim eligibility. It excludes jobs already blocked by
drain or a provider throttle. It does not call a provider or use a transient
backend probe while counting. If the board snapshot or eligibility data is
unreadable, leave all cleric counts unchanged for the tick.

### 2.3 Split across hosts

Reserve `A_h` slots on every host so the allocation cannot revoke active work.
For each queued job `j`, compute its eligible host set `E_j` and add fractional
demand to each eligible host:

```
D_h = sum(j in J, h in E_j) 1 / |E_j|
```

An explicitly host-pinned job contributes 1 to that host. A job runnable on
both current hosts contributes 1/2 to each. This is need-based without
pretending the shared queue is two independent queues.

Of the `K-A` free slots, distribute up to `min(Q, K-A)` demand slots by bounded
largest remainder over `D_h`, subject to each host's physical cleric cap. Then
distribute any remaining idle-reserve slots one at a time to the host with the
lowest target count, breaking ties by bytewise host id. This keeps idle capacity
spread across reachable hosts instead of piling all warm spares behind one
pinned job. If a host reaches its physical cap, leave it out and re-apportion
among the remaining eligible hosts. If every eligible host is at its physical
cap before all slots are placed (a `K_max` larger than the fleet's physical
cleric capacity), allocate to the caps, warn once, and stop — mirroring the
monk preflight, unallocatable envelope is a configuration error to surface,
not capacity to invent. The resulting integer target `T_cleric_h` satisfies:

```
T_cleric_h >= A_h
sum(T_cleric_h) = min(K, sum over E of physical cleric caps)
```

Before a downward command, the implementation must also map active claims to
unit identities and defer a shrink that would stop an active unit. A count
lower bound alone is insufficient if the active workers have sparse instance
numbers.

Apply the existing confirm-before-move dwell and one-step clamp to each cleric
host target too. Queue depth changes faster than weekly spend, so this reuse is
important: an arriving or completing job changes demand, but does not justify
oscillating systemd units in the same tick. Key the cleric dwell record by
host **and worker kind**: the existing record (`budget-level.sh`'s
`_dwell_file`) is keyed by host alone, and sharing one streak file would let a
monk direction change reset a cleric confirmation count, and vice versa.

This first rule deliberately does not weight hosts by historical completion
speed. The current queue has mixed job classes, making raw completions per hour
a confounded signal that would reward hosts receiving shorter work. Eligibility
fractions and explicit pins are observable need. A later throughput weight
requires a normalized, reviewed service-rate metric and can replace the equal
`1/|E_j|` fraction without changing the envelope or safety gates.

## 3. Composition with session pacing

This work should not wait for [`session-budget-pace.md`](session-budget-pace.md):

- Monk ceiling allocation uses the calibrated weekly caps because they express
  the durable relative size of the two independent Anthropic accounts.
- The session design regulates short-window pace. It does not change ownership
  or the relative weekly account sizes.
- Cleric demand allocation is unrelated to either Anthropic window.

When session pacing is implemented, do not put session caps into the monk
apportionment denominator and do not define an `effective cap` by comparing raw
weekly and five-hour token totals. The windows have different durations. Keep
`U_h` based on weekly `C_h`, compute the session-limited worker target described
by the session design, and select:

```
T_h = min(T_weekly_h, T_session_h)
```

If the observed tokens-per-worker-second implementation from that design is
available, both paces may instead map through that common rate and the lower
pace still wins. Until it exists, `T_session_h` is the session headroom-band
target over the same `[L, U_h]` range. Missing or stale session telemetry stays
transparent to the weekly target and warns once, exactly as
`session-budget-pace.md` specifies.

Thus the implementation order is:

1. Land proportional weekly ceilings and the cleric demand splitter.
2. Later add session sensing and compute a second monk target.
3. Take the lower monk target before the unchanged dwell and step logic.

Neither stage requires rewriting the other.

## 4. Safety invariants

Every implementation and test must preserve these invariants:

1. **Leader only.** There is one allocator and no competing cross-host writers.
2. **Drain means no actuation.** If `fleet_draining` is true, skip monk and
   cleric leveling for the entire tick.
3. **Calibrated authority only.** Any invalid or uncalibrated enabled Anthropic
   cap freezes the fleet-wide monk allocation. Never compute around it. Raising
   is frozen absolutely; the sole permitted motion is the denominator-free
   § 1.4 exhaustion-floor move downward toward `L`.
4. **No signal is not zero.** An unreadable spend or board sensor leaves the
   affected controller unchanged; it never maximizes a target.
5. **Bounded targets.** Monk targets stay in `[L, U_h]`, cleric targets stay
   within physical caps, and fleet totals stay within their configured
   envelopes except for temporary grandfathering of active cleric claims.
6. **No revocation.** Neither controller terminates in-flight work. Monk keeps
   the existing admission boundary, and a cleric shrink waits until the units
   it would remove are idle.
7. **Confirm before move.** Ceiling or demand changes only alter the target.
   Per-host direction dwell, confirmation counts, and the one-step clamp remain
   between every target and actuator.
8. **Existing actuator path.** Counts still flow through `set-workers.sh` on
   the local host or an authenticated host-scoped sysop operation remotely.
9. **Failure isolation.** A failed host operation is reported and does not
   prevent safe evaluation of other already-validated targets. A failed fleet
   preflight causes no partial allocation (the § 1.4 exhaustion-floor down-move
   is not an allocation: it uses no denominator and never raises a count).

## 5. Implementation boundary and acceptance cases

This document changes no runtime behavior. The follow-on build should keep
apportionment in deterministic plain code, expose the two fleet envelopes and
per-host physical caps as validated configuration, and extend the existing
`budget-level.sh` tests with at least the cases below.

**Configuration surface (settled by the mentat review).** The fleet envelopes
(`F`, `K_max`) and the per-host physical caps are **journal-backed
configuration** (a `config/` file on `journal2`, alongside
`config/budget-pools`), with the environment variables above serving as test
and operator overrides only. The allocator is a leader-only singleton, and the
foreman brake already established the precedent for exactly this shape:
journal state follows the `leader` marker across a handoff and is auditable in
git, where a per-host environment default would be left behind on the old
leader. Validate the file on read and fail closed (freeze, warn once) on a
malformed row, the same posture as an uncalibrated cap.

- 143M and 64M caps with `F=6` produce monk ceilings 4 and 2;
- swapping row order produces identical allocations;
- equal remainders use pool-id ordering;
- a physical cap causes bounded re-apportionment without losing a slot;
- an invalid or uncalibrated Anthropic row causes zero monk operations across
  the fleet, EXCEPT that a calibrated host at or above its own high-water mark
  is still stepped downward toward the floor (and never upward);
- valid caps plus one missing spend reading do not treat that host as zero;
- headroom targets use each apportioned ceiling, then require the existing
  upward dwell and step clamp;
- drain causes zero monk and cleric operations;
- a host-pinned cleric job assigns its demand only to that host;
- a two-host-eligible cleric job contributes half to each;
- shared cleric demand never changes the configured fleet envelope;
- active cleric claims are grandfathered and sparse active unit ids are not
  stopped by a shrink;
- monk and cleric dwell streaks on the same host are independent;
- a `K_max` above the fleet's physical cleric capacity allocates to the caps
  and warns instead of looping or inventing capacity; and
- adding a session target can only hold or lower the weekly monk target, never
  raise it or alter the proportional ceilings.

No script, unit, host count, or journal configuration is changed by this design
job. The mentat review (job `review-proportional-worker-leveling-mentat`,
2026-09-09) adversarially checked the apportionment and shrink rules, settled
the configuration surface (journal-backed, above), and amended the design in
place: the § 1.4 exhaustion-floor carve-out, the cleric physical-capacity
clamp, the dwell-record keying, the `K_max`-as-throttle-lever note, and the
worked-example arithmetic. Approved for build as amended.
