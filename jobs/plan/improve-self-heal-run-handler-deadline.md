---
gate: deferred
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-19T07:23:05Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-19T07:23:05Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/self-heal-run.sh
Wrap the handler invocation at line 104 (`"$@" > >(tee -a "$capture") 2>&1 &`) in a `timeout --signal=TERM --kill-after=<grace> <bound>` the same way the responder already is at line 247-250, so a wedged handler is bounded well inside each unit's `TimeoutStartSec` instead of relying on systemd's blunt job-timeout + SIGKILL backstop. Add a new tunable (e.g. `SELF_HEAL_HANDLER_TIMEOUT`, defaulting comfortably below the tightest caller's `TimeoutStartSec`, e.g. 600s) and classify a resulting rc=124/137 the same way `is_nonattributable_rc`/the offline-signature grep already do, so a timed-out handler exits clean (no responder burn, no Failed unit) rather than looking like a crash. This directly explains today's incident: `garden-comment-watcher@endojs-endo-but-for-bots` and two `garden-receipt-watcher@*` instances each ran past the full 900s `TimeoutStartSec` during a ~30min degraded-connectivity episode and required forceful termination (one needed a cgroup SIGKILL after the 20s `TimeoutStopSec` grace expired), while every other watcher on the same host failed open within seconds via its own internal cursor/fetch bounds. Since self-heal-run.sh is the shared wrapper for the whole fleet, this single change protects every service that rides it, not just these two.
