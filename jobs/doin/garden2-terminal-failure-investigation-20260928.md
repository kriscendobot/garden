---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 21600
token-budget: 1200000
requires: host=endolin-garden2-5bcdff64
---
# Investigate endolin-garden2's terminal-failure rate

You are running this job ON endolin-garden2-5bcdff64 itself (pinned via
`requires: host=`) specifically so you have direct diagnostic access to its
own systemd journal, resource state, and local journal clones — this mirrors
the successful `oros-studio-health-restoration` job (2026-09-27), which found
a stale-CLI root cause only reachable by running directly on the affected
host. Read that job's tada report first
(`git -C journal log --oneline -F --grep="oros-studio-health-restoration"`,
then read the referenced completion report) for the methodology and the kind
of finding to expect — but do not assume the same root cause; this host's
failures are classified differently (see below).

## The problem, as observed so far (liaison, 2026-09-28, do not re-derive — verify and extend)

Over the 24h window ending ~2026-09-28T03:20Z, this host claimed 178 jobs,
completed 65, and had **109 marked `terminal-failure` (non-transient handler
failure)** — a completion rate of roughly 37%. This is a DIFFERENT failure
classification than the oros-studio epidemic (which was `reap-now` / transient
handler kill): `terminal-failure` means the fleet's own classifier judged
these deaths NOT retriable, so they went straight to doom without the
transient-requeue cycle. Sample failing basenames (from
`git -C journal log --oneline --since="24 hours ago" | grep "terminal-failure: hint" | grep endolin-garden2`,
re-run this yourself for the current window): `dependabotany-recheck-endo-but-for-bots-*`,
`claude-on-minion-town-completion-press-*`, `fix-endojs-endo-but-for-bots-pr1356-zizmor*`,
`design-hardened-ses-shims-plan-reconciliation`, `endojs-endo-but-for-bots-pr1354-dependabot`
— a mix of job kinds, not one narrow category, which argues for a host/environment
cause over a content bug in any single job type.

There are open, UNREAD maintainer-inbox watchdogs specifically naming this
host that you should read in full and treat as primary leads, not background
noise:
- `watchdog-journal-lock-contention-_home_kris_garden2__garden_state_leader_journal`
- `watchdog-journal-push-contention-_home_kris_garden2__garden_state_producer_journal`
- `watchdog-journal-fetch-slow-_home_kris_garden2__garden_state_maintainer_approval_verify`
- `watchdog-rolling-deploy-canary-stuck-endolin-garden2-5bcdff64` (this one
  shows RECOVERED as of 2026-09-27T09:59Z — confirm it has stayed clear and
  isn't a recurring flap)

Context: this host's declared worker count was raised from 1 monk/1 cleric
toward whatever `budget-level.sh`'s apportionment currently gives it once the
fleet-wide `GARDEN_FOREMAN_ACTIVE_TARGET` was raised 2 -> 10 on 2026-09-27 to
saturate the worker pool — this host may simply be running more concurrent
`claude -p` handlers, journal-clone syncs, and git operations than its
resources or its local journal-clone locking can cleanly sustain. That is a
hypothesis to TEST, not an assumed conclusion.

## Your mandate

1. **Analyze.** Read the three watchdog notices above in full. Check
   `journalctl --user` for the worker units and the clone-lock/contention
   guard logs around several of the terminal-failure timestamps (exact times
   from `git -C journal log --oneline --grep="by endolin-garden2-5bcdff64" | grep terminal-failure`).
   Check disk/inode pressure, memory pressure, and current concurrent worker
   count (`hosts/endolin-garden2-5bcdff64`, `config/worker-leveling`) against
   physical resources. Check whether the "non-transient" classification itself
   is correct — a mis-classified transient condition (lock contention that
   COULD be retried) wrongly landing as terminal would itself be a bug worth
   fixing even if the underlying resource pressure is real and separate.
2. **Form a specific, falsifiable hypothesis.**
3. **Propose and implement a fix** — host-level (resource/config tuning),
   garden-level (a code fix, e.g. to clone-lock handling or contention
   classification, landed on `main2` the ordinary way — isolated project
   worktree, direct push, no PR unless it surfaces real open questions), or
   both.
4. **Validate on this host.** Construct your own reproducer or simply watch
   several consecutive claims of the previously-failing shape complete cleanly
   after your fix — don't declare victory from analysis alone.

## Report

State plainly whether you found the root cause, the mechanism, the fix, and
validation evidence. If you don't fully resolve it within this job's budget,
post a direct follow-up job `garden2-terminal-failure-investigation-round2`
with your findings so far (ruled-out causes, current best hypothesis, what's
left to check) rather than leaving it silently unresolved.

<!-- garden-transient-elapsed: kind=signature through=0 values=14 -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T03:46:59Z
