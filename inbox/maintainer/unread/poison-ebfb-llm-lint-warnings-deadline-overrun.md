from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-30T00:23:07Z
poison_base: ebfb-llm-lint-warnings
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-30T00:23:07Z
last_seen: 2026-07-30T00:23:07Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/ebfb-llm-lint-warnings; it stays HELD until a human promotes it
(promote-plan.sh ebfb-llm-lint-warnings) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: ebfb-llm-lint-warnings

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: endojs/endo-but-for-bots
branch: llm
role: cleaner
Address every lint warning currently emitted on the llm branch. Start from the latest origin/llm in an isolated worktree, discover and run the repository canonical lint commands rather than guessing, capture the complete warning inventory, and fix root causes across all affected packages. Do not silence warnings with blanket disables, weaken lint configuration, or introduce unrelated formatting churn; use narrow suppressions only where the warning is intentionally unavoidable and document each one. Preserve behavior, commit explicit pathspecs, rebase/CAS before pushing back to llm, and rerun the full canonical lint surface until it exits clean with zero warnings. Also run proportionate affected tests and report the exact commands, before/after warning counts, files changed, and any warning that cannot safely be eliminated rather than claiming success.

<!-- garden-deadline-overrun: 1 -->
