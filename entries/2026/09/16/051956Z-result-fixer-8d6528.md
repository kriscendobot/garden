---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-09-16T05:19:58Z
---
# Root cause: the "malingering foreman" is deliberately QUIESCED, not broken

Job: investigate-malingering-foreman (host endolin-garden-ece02cb4, the leader).

## Finding (definitive, with evidence)

The foreman is NOT malfunctioning. It is intentionally quiesced fleet-wide by
`GARDEN_FOREMAN_ACTIVE_TARGET=0`, set in `scripts/systemd/garden-foreman.service`
(commit `d954683f1f`, 2026-07-14, "foreman: quiesce fleet-wide —
GARDEN_FOREMAN_ACTIVE_TARGET 3 -> 0 (maintainer-directed)"). The rendered unit on
this host carries it verbatim: `Environment=GARDEN_FOREMAN_ACTIVE_TARGET=0`, with
the in-unit comment "the fleet foreman is intentionally QUIESCED ... so the board
is never 'under target' and the foreman NEVER pumps -- fleet-wide, on every host
that becomes leader."

Mechanism: `foreman.sh` capacity check is `if [ "$inflight" -ge
"$GARDEN_FOREMAN_ACTIVE_TARGET" ]` → "fully subscribed, clear settle clock, exit
0". With target=0, `inflight >= 0` is ALWAYS true (inflight is a count), so EVERY
tick takes that branch, removes `idle-since`, and exits 0 having pumped nothing.

This reconciles every reported symptom:
- `idle-since` absent → `rm -f "$IDLE_SINCE"` runs on the subscribed branch every tick.
- `last-step`/`noted` stamped 2026-07-13 → the last real promotion, the day BEFORE
  the 07-14 quiesce; nothing has promoted since because target=0.
- garden-foreman.service completes rc 0 each tick, no crash → the subscribed branch
  is a clean early exit.
- The ad-hoc `bash scripts/jobs/foreman.sh` producing silent exit 0 was NOT the
  brake guard (brake is unset) and NOT an env/identity mismatch. Outside systemd
  the env var is absent, so target defaults to 5; with inflight low the FIRST tick
  hits the debounce path (`[ ! -f "$IDLE_SINCE" ]` → write clock, exit 0) — also
  silent. A subsequent systemd tick (target=0) then deleted that `idle-since`. The
  job's "only consistent with the brake guard" hypothesis was wrong; the
  first-observation debounce path is equally silent.

## Ruled out

- Fleet drain / foreman brake: both off (confirmed).
- Token/budget back-off: `config/budget-pools` gives this host a 143M weekly-token
  ceiling at the default 0.85 high-water; manually-verified usage ~53% — nowhere
  near back-off. Not the cause.
- `plan_deferred_ranked` empty / `promote-plan.sh` failing: never reached — the
  tick exits at the capacity check before any promotion logic.
- Stale/corrupt foreman journal clone: not implicated; the exit is upstream of the
  clone read for promotion.

## Live board (2026-09-16, confirming the liaison's observation)

todo=0, doin=1, 124 `gate: deferred` plan jobs parked (363 plan total). The
reservoir is full and untouched precisely because target=0.

## The real open question (maintainer decision — NOT mine to make)

The quiesce dates to 2026-07-14, the Claude-quota-constrained era. It is still in
force while 124 pre-approved deferred jobs sit unpromoted and this host's usage is
~53%. Whether to LIFT it (raise GARDEN_FOREMAN_ACTIVE_TARGET back to 3/5 in the
unit, or via a per-host drop-in) is a maintainer decision about autonomous spend.
Surfaced to the maintainer via the liaison inbox. I did NOT change the target.

## Fix delivered: durable per-tick decision record (instrumentation)

The reason this needed live-debugging at all: a successful-but-did-nothing tick
(exit 0, pumped nothing) left NO durable trace — `self-heal-run.sh` only captures
on rc!=0. Added a host-local, self-trimming `decisions.log` under
`$GARDEN_STATE/foreman/`: one line per tick — timestamp, inflight, target, and the
guard/branch that ended the tick (`subscribed`, `settle-start`, `settle-wait`,
`token-backoff`, `budget-backoff`, `promoted`, `pumped`, `anti-flap`,
`maintainer-note`, `handler-failed`, `noop`, `braked`). Host-local, not journal
(a line every 5 min would churn journal2); trims to the last 1000 lines past 1200.
Now a quiesced foreman self-documents `guard=subscribed target=0` every tick, and
this exact investigation would be a one-line read from the leader host.

New regression test `scripts/jobs/test/foreman-decision-log-test.sh` pins both the
reproduction (target=0 → no pump, logs `subscribed target=0`) and recovery
(target=5 → PUMPS, logs `pumped`) — the demonstrated "post-fix tick actually
promoting from the reservoir," shown in the harness rather than by unilaterally
lifting the fleet-wide quiesce. All existing foreman suites (brake, provider-order,
maintainer-notice-dedup, edge-kick) still pass.
