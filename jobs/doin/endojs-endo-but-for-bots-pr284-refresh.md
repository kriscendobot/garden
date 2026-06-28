# Refresh endo-but-for-bots PR #284 per kriskowal's review directive

Map: **weave/refresh** (rebase) on endojs/endo-but-for-bots PR #284 (OPEN, by kriscendobot,
"feat(daemon,cli): retention-paths Phase 1"). Bot fork; standing comment authorization.

Directive: kriskowal's COMMENTED review on #284 (review 4587189118, 2026-06-28T07:20:42Z):
**"Please refresh."** Per the standing convention, "refresh" on an endo-but-for-bots PR is the
compound: sync bot-master to current endo-upstream/master, rebase the PR branch on the refreshed
master, resolve conflicts, and retcon if needed (see the rebase-on-master norm). Then push the
refreshed branch.

COMMUNICATE ON THE PR (comms directive): after refreshing, post a top-level summary comment on
#284 stating what was synced/rebased and the new head SHA — do NOT use the maintainer inbox.

NB: this review was missed by the comment-watcher (the source only polls reviews on the 30
most-recent open PRs; #284 is older) — that source bug is being fixed separately; this job
handles the directive itself.

Deliverable: #284 rebased/refreshed on current master, conflicts resolved, pushed, with a
summary comment on the PR.

---
claim:
  host: endolinbot
  gardener: 40
  claimed_at: 2026-06-28T15:52:00Z
