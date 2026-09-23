from_host: endolin-garden2-5bcdff64
from: gardener:diagnose-hourly-graphql-quota-exhaustion-20260923
reply_to: diagnose-hourly-graphql-quota-exhaustion-20260923
msg_key: msg-diagnose-hourly-graphql-quota-exhaustion-20260923-da2cfcbbcac9
notice_count: 1
first_seen: 2026-09-23T22:52:57Z
last_seen: 2026-09-23T22:53:08Z
sent_at: 2026-09-23T22:53:08Z
---
GraphQL quota diagnosis (job diagnose-hourly-graphql-quota-exhaustion-20260923): here is what I measured.

At the 22:44:06Z reset, the bot's GraphQL `used` rose at a steady ~2.3 points/s: 26 → 886 in 6.5 minutes, which is about 8,400/hr of demand. That drains the 5,000 bucket about 36 minutes into each hour. Each `gh pr view --json statusCheckRollup` costs 1 point.

This does NOT come from endolin-garden2. Across several 30–100s windows I sampled every `gh` process at 0.1–0.2s intervals and saw zero GraphQL-issuing processes there. Nor can it be the ci-watcher or its sibling watchers: they sit behind the 3600s latch almost all hour, because the latch is armed about 2 min BEFORE each reset and so blinds them for the whole fresh window. Every scripted consumer in the repo is either latched or low-rate (ci-watcher ≈1.2k/hr at most when unlatched, approval-reconciler ≈250/hr, ci-wait-merge 60/hr per conductor, mirror-closer ≈150/hr).

The consumer is therefore on the leader, endolin-garden-ece02cb4 (or outside the garden, anywhere else the kriscendobot token lives). It does not honor the latch, which suggests an agent- or Monitor-driven poll loop, e.g. a liaison Monitor running `until gh pr view …; do sleep 1; done`.

Could you run this on the leader?
    ps -eo pid,ppid,etimes,args | grep -E '[/ ]gh (pr|api|issue|repo)' ; ps -eo pid,etimes,args | grep -iE '[M]onitor|until .*gh|while .*gh'

I'm landing a per-caller GraphQL ledger in the gh wrapper so this becomes one command once deployed, plus a resetAt-sized latch. No reply is needed for the job to finish; this message is for the operator to act on.
