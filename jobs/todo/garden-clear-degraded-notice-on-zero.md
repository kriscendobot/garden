---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Clear the backend-degraded notice when a worker class is throttled to zero

Repository: https://github.com/kriscendobot/garden — land on `main2`, no PR.
Do **NOT** run git in `$GARDEN_ROOT`; use your per-job worktree.

**Maintainer directive (2026-08-04):** mute the fireworker backend-degraded
notice when fireworkers are throttled down to zero.

## The bug

`scripts/jobs/common.sh` (~lines 1196-1232), in the worker auto-tune path:

```sh
# Degraded = capped below the declared target while the owner declares > 0.
if [ "$declared" -gt 0 ] && [ "$eff" -lt "$declared" ]; then
  degraded=$((degraded + 1))
else
  degraded=0
fi
...
local akey="backend-degraded-${GARDEN}-${kind}"
if [ "$degraded" -ge "$degraded_ticks" ] && [ "$degraded_ticks" -gt 0 ]; then
  alert_maintainer "$akey" "host $GARDEN declares $count_key=$declared but its $kind backend probe has failed ..."
elif [ "$declared" -gt 0 ] && [ "$eff" -ge "$declared" ]; then
  alert_maintainer_clear "$akey" "..."
fi
```

Trace `declared` dropping to 0 while an alert is **outstanding**:

1. `degraded` resets to 0 (the `else` branch) — correct.
2. The alert branch no longer fires — correct.
3. **The clear branch is guarded by `declared > 0`, so it never runs.**

So the notice **goes silent but is never cleared**: it sits outstanding in the
maintainer inbox forever, and no future recovery can retire it either, because
recovery requires `eff >= declared` with `declared > 0`.

Throttling a class to zero is a **legitimate resolution** of "this host cannot
run its declared workers" — you resolved it by not declaring any. It should
CLEAR, not merely fall silent.

## Why it is worth fixing now

`watchdog-backend-degraded-endolin-garden2-5bcdff64-fireworker` produced **24 of
the 126 journal commits in the last 24 hours — 19% of all journal traffic** —
from a single deduped alert being re-amended. Every amendment is a commit every
host then fetches. It is the only such notice outstanding fleet-wide.

Fireworks is also plausibly *finished* rather than broken: the maintainer's
authoritative total for all Fireworks work is $57, i.e. consumed credits. A host
declaring 4 fireworkers against an exhausted account will never recover, so the
alert can never clear on its own.

## What to change

Make `declared == 0` a clearing condition, with a message that says the class
was stood down rather than that the backend recovered — those are different
facts and the inbox should not conflate them.

**This is a general fix, not a fireworker one.** The same code path serves
`gardener`, `cleric`, `hermit`, `mystic`, and `fireworker`; write it for the
worker-kind abstraction and let fireworker be the instance that motivated it.

## The hazard — do not over-suppress

The alert is **correct and wanted** whenever `declared > 0` and the backend is
down; that is a host that cannot do the work it advertises. Do not silence that
case, do not raise `GARDEN_BACKEND_DEGRADED_TICKS` as a workaround, and do not
add a per-kind mute list. Only the `declared == 0` case changes, and it should
*clear* rather than *suppress* — a suppressed alert is invisible; a cleared one
is a recorded resolution.

Check that `alert_maintainer_clear` is idempotent / safe when nothing is
outstanding (throttling an already-quiet class to zero must not manufacture a
spurious clear). If it is not, guard it.

## Regression coverage

Add tests under `scripts/jobs/test/`. At minimum pin:

1. `declared > 0`, backend failing, ticks exceeded -> alert fires (unchanged).
2. `declared > 0`, backend recovers -> clear fires (unchanged).
3. **`declared` drops to 0 with an alert outstanding -> clear fires.** This is
   the bug; it must go red without the fix.
4. `declared == 0` with nothing outstanding -> no alert, no spurious clear.

Follow the fleet's established stub pattern for `alert_maintainer` /
`alert_maintainer_clear` rather than writing to the real journal.

## Out of scope

**Do not change any host's declared worker counts.** This job fixes the
notification logic only. `endolin-garden2-5bcdff64` currently declares
`fireworkers: 4`; whether that becomes 0 is the maintainer's call and a separate
`set-workers` operation, so **this fix alone will not silence the current
notice** — say so plainly in your `tada/` report so nobody mistakes a landed fix
for a quiet inbox.

Also out of scope: the `retro_eligible` over-broad gate in
`comment-watcher.sh:1602`, and anything about the fireworker backend itself.

## Definition of done

The clear-on-zero fix landed on `main2`, the four regression cases green, the
existing suites still green, and a `tada/` report stating what changed, that the
notice remains outstanding until garden2's fireworker count is actually changed,
and whether `alert_maintainer_clear` needed a guard.
