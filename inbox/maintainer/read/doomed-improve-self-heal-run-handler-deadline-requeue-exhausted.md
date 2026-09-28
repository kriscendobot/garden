from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-09-19T07:23:47Z
doom_base: improve-self-heal-run-handler-deadline
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-09-19T07:23:47Z
last_seen: 2026-09-19T07:23:47Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-self-heal-run-handler-deadline; it stays HELD until a human promotes it
(promote-plan.sh improve-self-heal-run-handler-deadline) or removes it, so nothing is lost.
Original job base: improve-self-heal-run-handler-deadline

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/self-heal-run.sh
Wrap the handler invocation at line 104 (`"$@" > >(tee -a "$capture") 2>&1 &`) in a `timeout --signal=TERM --kill-after=<grace> <bound>` the same way the responder already is at line 247-250, so a wedged handler is bounded well inside each unit's `TimeoutStartSec` instead of relying on systemd's blunt job-timeout + SIGKILL backstop. Add a new tunable (e.g. `SELF_HEAL_HANDLER_TIMEOUT`, defaulting comfortably below the tightest caller's `TimeoutStartSec`, e.g. 600s) and classify a resulting rc=124/137 the same way `is_nonattributable_rc`/the offline-signature grep already do, so a timed-out handler exits clean (no responder burn, no Failed unit) rather than looking like a crash. This directly explains today's incident: `garden-comment-watcher@endojs-endo-but-for-bots` and two `garden-receipt-watcher@*` instances each ran past the full 900s `TimeoutStartSec` during a ~30min degraded-connectivity episode and required forceful termination (one needed a cgroup SIGKILL after the 20s `TimeoutStopSec` grace expired), while every other watcher on the same host failed open within seconds via its own internal cursor/fetch bounds. Since self-heal-run.sh is the shared wrapper for the whole fleet, this single change protects every service that rides it, not just these two.
