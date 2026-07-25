from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-07-25T14:13:08Z
poison_base: kimi-k3-canary-20260723-c
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-25T14:13:08Z
last_seen: 2026-07-25T14:13:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/kimi-k3-canary-20260723-c; it stays HELD until a human promotes it
(promote-plan.sh kimi-k3-canary-20260723-c) or removes it, so nothing is lost.
Original job base: kimi-k3-canary-20260723-c

--- original job body ---
model: kimi-k3
role: gardener
Kimi K3 compatibility canary attempt 3. In the isolated per-job worktree only, use shell tools to create .kimi-k3-canary with a short marker, read it back, then remove it. Do not modify or push repository content and do not perform external side effects. Complete normally and report tool creation, readback, removal, and completion.
