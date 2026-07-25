from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-07-25T17:53:09Z
poison_base: finbot-pr4-panel-rerun-20260725
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-25T17:53:09Z
last_seen: 2026-07-25T17:53:09Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/finbot-pr4-panel-rerun-20260725; it stays HELD until a human promotes it
(promote-plan.sh finbot-pr4-panel-rerun-20260725) or removes it, so nothing is lost.
Original job base: finbot-pr4-panel-rerun-20260725

--- original job body ---
role: builder

Re-run the required full code panel for https://github.com/kriscendobot/finbot/pull/4 at head 63df8109aba818eb3fcbe9fb480f27205494b85c (base 895ae4822d3c0f36c4026c9bcbddcbcc59f81c62). The prior panel requested changes and the fixer commit is green. PR was returned to draft correctly. Run the scripted panel with non-empty, formal verdict evidence; do not treat empty seat output as pass. If the panel passes, dispatch finbot-pr4-fable-signoff with role orchestrator and model claude-fable-5, including the panel outcome. Do not merge.
