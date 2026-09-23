## Completion report — investigate-malingering-foreman

**Root cause (definitive): the foreman is deliberately QUIESCED, not broken.** The systemd unit sets `GARDEN_FOREMAN_ACTIVE_TARGET=0` (`scripts/systemd/garden-foreman.service`, commit `d954683f1f`, 2026-07-14, "maintainer-directed"). With target 0 the capacity check `if [ "$inflight" -ge "$GARDEN_FOREMAN_ACTIVE_TARGET" ]` is **always** true (inflight is a count ≥ 0), so every tick takes the "fully subscribed" branch — `rm -f idle-since`, no handler, exit 0 — pumping nothing.

This reconciles every symptom: `idle-since` absent (deleted on that branch each tick); `last-step`/`noted` frozen at 2026-07-13 (the day *before* the quiesce — the last real promotion); clean rc-0 ticks; 124 deferred jobs untouched. The ambiguous ad-hoc-invocation lead was resolved too: it wasn't the brake guard or an identity mismatch — outside systemd the env var is absent so target defaults to 5, and the first tick hits the equally-silent debounce path (`[ ! -f idle-since ]` → write clock, exit 0); a later systemd tick then deleted that marker.

**Ruled out:** fleet drain and foreman brake (both off); token/budget back-off (host cap 143M weekly-tokens at 0.85 high-water, usage ~53% — nowhere near); `plan_deferred_ranked`/`promote-plan.sh` failures (never reached — exit is upstream at the capacity check); stale foreman clone (not implicated). Live board confirmed the liaison's observation: todo=0, doin=1, 124 `gate: deferred`.

**What changed (pushed to main2, commit `42e141b609`):**
- `foreman.sh`: durable, host-local, self-trimming **per-tick decision log** at `$GARDEN_STATE/foreman/decisions.log` — one line per tick (timestamp, inflight, target, guard/branch that ended it: `subscribed`/`settle-*`/`token-backoff`/`budget-backoff`/`promoted`/`pumped`/`anti-flap`/`maintainer-note`/`handler-failed`/`noop`/`braked`). Host-local, not journal (avoids 5-min churn); trims to last 1000 lines past 1200; best-effort so it never fails a tick. A quiesced foreman now self-documents `guard=subscribed target=0` — this investigation becomes a one-line read.
- New regression test `foreman-decision-log-test.sh`: pins the reproduction (target=0 → no pump, logs `subscribed target=0`) **and** recovery (target=5 → PUMPS, logs `pumped`) — the requested "post-fix tick actually promoting," shown in the harness with the real `foreman.sh` rather than by unilaterally lifting the fleet-wide quiesce. All existing foreman suites (brake/provider-order/dedup/edge-kick) still pass.

**Durable records:** journal result entry `051956Z-result-fixer-8d6528.md`; maintainer inbox message surfacing the one real open question.

**Open question (maintainer's, not mine):** the quiesce dates to the July quota crunch; whether to lift it (raise target to 3/5) now that 124 pre-approved jobs sit parked and usage is ~53% is a spend-policy decision. I did **not** change the target. Sent to the maintainer inbox.

**Deploy: deliberately skipped.** The mechanism is proven in the harness with the real script; since target stays 0, a deploy would restart the live fleet at real cost only to reconfirm `subscribed target=0`. No hypothesis a restart would test. The instrumentation lands on the next regular deliberate deploy.

Memory added so a future investigator checks the unit + decision log before re-live-debugging.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-malingering-foreman.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3551380 cached reads)
- Output: 40553 tokens
- Cost: $3.8062060000000004
- Wall-clock: 552s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
