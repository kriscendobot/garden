---
child-dependabotany-sweep-approval-held-reap-count: 0
child-dependabot-merge-now-auto-conduct-host: endolin-garden-ece02cb4
child-dependabot-merge-now-auto-conduct-reap-count: 0
order: serial
children: dependabot-merge-now-auto-conduct dependabotany-sweep-approval-held
on-child-failure: halt
state: running
created_by: liaison
created_at: 2026-08-12T05:14:32Z
---

# Rollout: dependabot MERGE-NOW auto-merges to `llm`

Maintainer directive (kriskowal, 2026-08-12): a dependabot PR that achieves a
MERGE-NOW verdict merges automatically; manual review does not economically
increase confidence and uneconomically exposes us to risk.

Serial, halt on child failure:

1. `dependabot-merge-now-auto-conduct` — encode the stance: a narrow, fail-closed
   bypass of the maintainer-approval gate for dependabot-authored PRs on bot-owned
   repos, plus the role/design/watcher docs. Lands on `main2`.
2. `dependabotany-sweep-approval-held` — clear the seven approval-held MERGE-NOW
   PRs on `endojs/endo-but-for-bots` under the new stance.

Child 2 checks a precondition first: the DEPLOYED garden root must carry the new
merge path. `main2` landing is not enough — the root checkout advances only by the
deliberate `deploy-garden.sh`. If the deploy has not happened, child 2 halts the
orchestration rather than merging under the old rules; re-promote it after deploy.
