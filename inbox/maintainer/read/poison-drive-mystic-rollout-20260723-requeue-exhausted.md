from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-24T02:23:06Z
poison_base: drive-mystic-rollout-20260723
poison_signature: requeue-exhausted
notice_count: 2
first_seen: 2026-07-23T22:23:07Z
last_seen: 2026-07-24T02:23:06Z
---
POISON notice — occurrence #2 (first seen 2026-07-23T22:23:07Z, latest 2026-07-24T02:23:06Z).
This job has been poison-parked 2 times for the same condition (requeue-exhausted);
this is an AMENDED notice, not a new one. Latest detail:

POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/drive-mystic-rollout-20260723; it stays HELD until a human promotes it
(promote-plan.sh drive-mystic-rollout-20260723) or removes it, so nothing is lost.
Original job base: drive-mystic-rollout-20260723

--- original job body ---
---
role: orchestrator
model: gpt-5.6-terra
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-24T00:44:51Z -->

model: gpt-5.6-terra
role: orchestrator
handler-timeout: 10800
Drive the Mystic (Moonshot Kimi K3 via official Kimi Code CLI) rollout to verified completion.

Own and recover the existing serial orchestration kimi-k3-harness-rollout-20260723 and its children kimi-k3-harness-implement-20260723 and kimi-k3-harness-validate-20260723. The implementation child is stranded in doin after a Claude quota failure; all Claude monk workers are intentionally disabled and must remain unable to claim jobs. Use the normal board/reaper/requeue mechanisms or create a clearly linked replacement child if recovery cannot safely reassign it. Ensure implementation work is performed by a non-Anthropic backend, preferably the Codex cleric path.

Completion means all of the following: (1) land a dedicated worker kind named mystic, provider moonshot, model kimi-k3, using the official Kimi Code CLI rather than Codex Responses; (2) preserve explicit-model-only routing, isolated per-job worktree and KIMI_CODE_HOME, secret hygiene, bounded process cleanup, output/report capture, completion sentinel, resume/requeue behavior, and reputation metadata; (3) add and pass focused offline and worker-spine regression tests; (4) independently validate the landed implementation; (5) coordinate with the leader liaison for deliberate deployment of main2 rather than editing the deployed root; (6) ensure MOONSHOT_API_KEY reaches user systemd without printing it and install the supported Kimi Code CLI; (7) enable exactly one Mystic only for a reversible tool-using canary, prove correct worker/provider/model reputation scope plus interruption/resume behavior, then return Mystic capacity to zero unless the maintainer explicitly authorizes otherwise; and (8) leave monk capacity at zero.

Do not make Kimi a default, do not enable high-stakes design/build routing, do not delete failed diagnostic evidence, and do not bypass the journal claim/completion contracts. Monitor every stage instead of merely posting follow-ups. Send concise progress only for a real blocker and send the final evidence-backed result to the maintainer inbox.
