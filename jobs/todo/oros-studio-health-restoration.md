---
tier: mentat
dispatch: manual
---
---
role: gardener
handler-timeout: 28800
token-budget: 2000000
requires: host=oros-studio-garden-ce242c49
---
# Restore oros-studio's job-handler health: analyze, hypothesize, fix, validate

You are running THIS job ON oros-studio-garden-ce242c49 itself (pinned via
`requires: host=`) specifically so you have direct diagnostic access to its
own systemd journal, resource state, and running processes — access the
liaison did not have when it first found this problem. Use that access; do
not limit yourself to journal2 evidence the way a remote investigation would
have to.

## The problem, as observed so far (liaison, 2026-09-27, do not re-derive — verify and extend instead)

Over a 6-hour window this host claimed 52 jobs, completed 2, and had 49 killed
by the fleet's own "transient handler kill" detection (a `reap-now` hint posted
by this host's own self-heal, then classified `failure_classification:
transient`, `doom_signature: requeue-exhausted`). This happened both on stale
pre-deploy code AND on fully current code (a rolling-deploy canary that was
stuck since 2026-09-25T03:17Z was force-deployed on 2026-09-27 ~06:55Z;
handler-kills continued identically afterward), so it is not simply a
stale-deploy artifact — something about THIS HOST specifically is killing
`claude -p` handler processes mid-run, most of the time.

Four PR-gauntlet stage jobs doomed by this (endo-but-for-bots PR675/664/450
panel rounds, PR356 fix) have been unpinned and returned to the general job
pool so the underlying PR review work actually gets done on a healthy host —
do not touch those live basenames or treat their re-completion as validating
anything about this host; they are out of scope for you now, already moving
elsewhere.

## Your mandate

1. **Analyze.** Find the actual mechanism killing handler processes: check
   `dmesg` for OOM kills, `journalctl --user -u 'garden-worker@monk-*'` and the
   gardener-scaler/reaper logs around several recent kill timestamps (the
   journal's `reap-now` and `transient-elapsed` commit history for this host,
   `git -C journal log --oneline -F --grep="by oros-studio-garden-ce242c49"`,
   gives you exact times to correlate), disk/inode pressure (`df -h`, `df -i`),
   memory pressure and cgroup limits on the worker units, and anything else
   that distinguishes this host from endolin-garden/endolin-garden2 (both
   healthy). Look for a resource ceiling, a systemd unit config difference, a
   container/host memory or CPU allocation difference, network/DNS flakiness
   causing a `gh`/git call to hang past some external timeout, or anything
   else concrete — do not settle for "it's just flaky" without a mechanism.
2. **Form a hypothesis** — specific and falsifiable, not "it's probably
   resources."
3. **Propose and implement a solution.** This may be a garden code/config
   change (land it on `main2` the ordinary way, in an isolated project
   worktree, direct push per the garden's own-repo convention — no PR unless
   it surfaces real open questions), a host-level fix you can apply directly
   (you're running here), or both.
4. **Validate on this host specifically, deliberately.** Do NOT just declare
   victory from the analysis. Construct your OWN reproducer test jobs (do not
   reuse the four live PR-gauntlet basenames above — they belong to the
   general pool now) that resemble the killed jobs closely enough to exercise
   whatever you believe is the failure mechanism (a similar handler-budget-role,
   similar token/time footprint, similar `ensure-project-worktree.sh` usage if
   that's implicated), pin each with `requires: host=oros-studio-garden-ce242c49`,
   and watch them run to completion or failure. Several consecutive successes
   under conditions that used to fail (and, ideally, a demonstrated failure
   BEFORE your fix on the same reproducer, if you can safely get one) is the
   bar — one lucky pass is not.

## Standing constraint: keep this host OUT of ordinary rotation

`config/worker-leveling`'s `host oros-studio-garden-ce242c49` row is
deliberately capped to `1 0` (monk-cap 1, cleric-cap 0) right now — down from
its normal 4 — specifically so this host stops absorbing and killing ordinary
board work while you investigate. **Keep it there.** Your own reproducer/
validation jobs use the single available monk slot when you dispatch them
(pin them with `requires: host=` as above so they can only land here, and post
them when you're actually ready to watch one run — don't leave several queued
at once fighting your single slot with ordinary work that might also be
pinned-or-not sitting in the shared pool). If you need more concurrency to test
a hypothesis about load (e.g. "does it only fail under 4-way concurrency"), you
may temporarily raise the cap in `config/worker-leveling` AND
`hosts/oros-studio-garden-ce242c49`'s `monks:` line (via
`scripts/jobs/set-workers.sh monk <n>` run ON this host) for that specific
experiment, but restore both to `1`/`1` immediately after — never leave this
host at an elevated count between your own deliberate tests. Once you are
confident the problem is actually fixed (multiple clean validation runs, not
one), raise `config/worker-leveling`'s cap back to `4` as part of your
completion — that is the signal the rest of the fleet needs to resume routing
ordinary work here.

## If you don't fully resolve it within this job's budget

Post a direct follow-up job to `jobs/todo/` named
`oros-studio-health-restoration-round2` (increment the round number for any
further rounds) with the SAME structure as this one, but replace this job's
"problem, as observed so far" section with your own findings: what you ruled
out, your current best hypothesis, what you tried, and exactly what's left to
check — so the next round does not repeat your work. Do not leave the host
silently half-fixed with no record of what's still wrong.

## Report

State plainly: root cause found or not: yes/no. If yes, the mechanism, the fix,
and the validation evidence (job basenames + outcomes). If no, your ruled-out
list and current best hypothesis for the next round. Either way, confirm the
current state of `config/worker-leveling`'s oros-studio row and explain why
you left it there.
