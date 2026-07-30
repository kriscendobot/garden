---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-29T23:55:05Z cleared=none -->

---
tier: mentor
role: builder
fallback-tier: minion
dispatch: automatic
---
# Add a periodic approval-to-conductor reconciler

Repository: https://github.com/kriscendobot/garden. Land directly on main2, no PR.

Fix the gap where trusted maintainer approvals can be missed by the event-driven comment/review watcher, leaving approved pull requests without a conductor. The maintainer observed multiple approvals on 2026-07-28 that did not dispatch conductors and has manually requested conductors for those PRs; do not duplicate those manual requests.

Inspect the existing approval-trigger path in scripts/jobs/comment-watcher.sh, pr-maintainer-approval-gh.sh, conductor/shepherd posting logic, directive identity indexes, watch configuration, and the investigation report jobs/tada/investigate-pr721-review-false-peer-resolution.md recommendation for an approval reconciler. Implement a deterministic, no-LLM, leader-only periodic reconciler for the authorized bot-repository watch set. It must:

- Enumerate open bot-authored PRs on authorized watched repositories without ingesting untrusted bodies.
- Require a current trusted-maintainer approval on the exact current head SHA; stale approvals do not count.
- Reuse the event watcher’s existing mergeability, draft, CI, and authorization semantics rather than inventing weaker gates.
- Post a conductor when the approved head is eligible and green, or the established shepherd path when approved but CI requires work, exactly matching current event behavior.
- Deduplicate against existing todo, doin, tada, plan, orchestration, manually posted conductor/shepherd work, and the directive identity index so restart, overlap, and event-plus-sweep races cannot double-dispatch.
- Never interact with or link to upstream https://github.com/Agoric/agoric-sdk. Preserve all watch-set and sender-trust constraints.
- Be leader-only, cadence-bounded, API-thrifty, restart-safe, and observable. A missed tick must self-heal on the next tick.

Audit the approvals from 2026-07-28 as read-only regression evidence: identify which would have been recovered, while proving current manual conductor requests suppress duplicates. Add hermetic tests for missed events, stale approval after head movement, event/sweep race, existing manual job under a different basename, red CI, draft PR, untrusted approver, non-bot PR, and leader/follower gating. Add the systemd unit/timer or integrate with the existing appropriate watcher cadence, update operations documentation, and report the landed revision and rollout requirements.

<!-- garden-reaped: 1 -->
