Deployed tier-native routing to both reachable Endolin hosts: leader `d0ba6ee2…`, follower `532584e0…`; both include `tier:` / `fallback-tier:` routing. Fixed and landed the candidate-gate noexec regression and sysop ack loop.

Verified leader: not draining, no failed garden units, `gardeners: 0`, active mystic worker. Follower reported the same health with active cleric and mystic workers. `ps23` and `ps23-garden-f65473ae` never acknowledged authorized sysop requests and remain unreachable.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-tier-native-routing-deploy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (4 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (4 engagement(s) unpriced)
- Wall-clock: 1350s

<!-- garden-usage-end -->
