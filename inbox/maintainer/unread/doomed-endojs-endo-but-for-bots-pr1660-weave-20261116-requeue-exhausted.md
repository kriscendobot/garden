from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-16T12:43:21Z
doom_base: endojs-endo-but-for-bots-pr1660-weave-20261116
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-16T12:43:21Z
last_seen: 2026-11-16T12:43:21Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr1660-weave-20261116; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr1660-weave-20261116) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr1660-weave-20261116

--- original job body ---
---
posted_at: 2026-11-16T09:54:14Z
role: weaver
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Weave endojs/endo-but-for-bots PR #1660 after its base moved

PR: https://github.com/endojs/endo-but-for-bots/pull/1660

The shepherd verified all 38 checks green on head `0aacf9a1653ec370566c4cc83a8f41934a4577c6`, but the frozen/live base moved afterward and GitHub now reports `mergeable: CONFLICTING` / `mergeStateStatus: DIRTY`. Rebase the PR head safely onto the current intended base, resolve conflicts, force-push with lease, and verify the resulting head.

Source shepherd job: `endojs-endo-but-for-bots-pr1660-shepherd`.
