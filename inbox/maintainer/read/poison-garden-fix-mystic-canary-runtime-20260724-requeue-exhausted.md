from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-24T22:03:06Z
poison_base: garden-fix-mystic-canary-runtime-20260724
poison_signature: requeue-exhausted
notice_count: 2
first_seen: 2026-07-24T08:03:08Z
last_seen: 2026-07-24T22:03:06Z
---
POISON notice — occurrence #2 (first seen 2026-07-24T08:03:08Z, latest 2026-07-24T22:03:06Z).
This job has been poison-parked 2 times for the same condition (requeue-exhausted);
this is an AMENDED notice, not a new one. Latest detail:

POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/garden-fix-mystic-canary-runtime-20260724; it stays HELD until a human promotes it
(promote-plan.sh garden-fix-mystic-canary-runtime-20260724) or removes it, so nothing is lost.
Original job base: garden-fix-mystic-canary-runtime-20260724

--- original job body ---
---
role: fixer
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-24T21:18:31Z -->

model: gpt-5.6-terra
role: fixer
Fix and revalidate the Kimi K3 Mystic canary runtime in kriskowal/garden.

Observed live failure on both kimi-k3-canary-20260723-c and -d: scripts/jobs/gardener.sh line 481 calls reap_process_group, but the function is absent at runtime, so mystic/1 exits rc=1 immediately after the handler. Restore the helper in the shared worker spine/common library with its documented safety guards and add a regression that runs the real deployed call path, not only a sourced fixture. Re-run handler-orphan-reap, mystic-kimi-harness, worker-spine, completion, and routing tests.

Also audit and harden secret-safe Moonshot propagation against the established Anthropic path: garden passes ANTHROPIC_API_KEY via Docker -e at container creation; PID 1 -> systemd --user -> worker unit inheritance supplies it without embedding secrets in unit files. MOONSHOT_API_KEY should follow the same path, with deterministic presence-only diagnostics and documentation that existing containers require secret-safe recreation. Do not print, inspect, persist, or commit credential values.

After landing and deliberate deployment coordination, requeue exactly one reversible kimi-k3 canary, validate completion plus mystic/moonshot/kimi-k3 reputation scope, and return mystics to 0. Keep monks at 0 throughout. Preserve the failed canary evidence and use normal board/reaper contracts.
