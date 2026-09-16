---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Investigate and fix the malingering foreman

## Symptom (observed by the liaison, 2026-09-16 ~04:30-05:00 UTC, on endolin-garden-ece02cb4, the leader)

The board (`jobs/todo/` + `jobs/doin/`) sat well under the foreman's active-job
target (default 5 — todo=0, doin=0-1) for an extended period, despite:

- **124** `gate: deferred` plan jobs available (exactly what
  `plan_deferred_ranked` draws from for auto-promotion) — not depleted.
- Neither the fleet drain nor the foreman-only brake active
  (`brake-foreman.sh status` → not braked; no `config/foreman-brake` in the
  foreman's synced clone; `fleet_draining` false).
- Quota well under the back-off threshold: `GARDEN_TOKEN_BACKOFF_FRACTION`
  defaults to 0.85 (85%), and this host's manually-verified weekly usage is
  53% — nowhere near the high-water mark that would legitimately suppress
  pumping.
- `garden-foreman.timer` firing on schedule every 5 minutes, `garden-foreman.
  service` completing (rc 0) each time — no crash, no failed unit.

Yet the foreman's own state markers under `.garden-state/foreman/` tell a
different story: `idle-since` does not exist (it should, given sustained
under-target inflight — created the moment inflight < target and persisted
until either a promotion fills the target or inflight recovers on its own),
and `last-step` / `noted` are both stamped **2026-07-13** — over two months
stale, meaning the deferred-promotion branch has apparently not executed
since then, despite an enormous available reservoir the whole time.

One direct manual invocation (`GARDEN_TAG=diag bash scripts/jobs/foreman.sh`,
run ad hoc outside systemd) produced **zero output and exit 0** — silence is
only consistent with the very first guard (`foreman_braked "$DIR" && exit 0`)
firing, which contradicts the brake-file check above; this could equally be
an environment/identity mismatch in that ad hoc invocation (GARDEN/
GARDEN_STATE resolving differently outside the systemd unit's environment)
rather than a real finding — treat it as a lead, not a conclusion.

## What to investigate

1. Reproduce cleanly: invoke `foreman.sh` the SAME way `garden-foreman.
   service` does (`self-heal-run.sh garden-foreman -- foreman.sh`, with the
   real unit environment — check `systemctl --user show garden-foreman.
   service` for its actual `Environment=`/`WorkingDirectory=` rather than
   assuming your shell matches it) and determine EXACTLY which guard/branch
   is exiting the tick without promoting: `foreman_braked`, the settle
   window, `meter_quota_status`/`budget_fleet_status` returning something
   unexpected, `plan_deferred_ranked` silently returning empty inside the
   real invocation despite returning 124 rows when you call it by hand, or
   `promote-plan.sh` failing silently for every candidate (check its exit
   code and stderr, not just whether `jobs/todo/` grew).
2. Check whether `.garden-state/foreman/journal` (the foreman's OWN synced
   clone, distinct from the deployed `journal/` worktree) is itself stale,
   corrupted, or diverged — `sync_clone` is supposed to keep it current every
   tick; confirm it actually is, and that the foreman reads inflight counts
   from a clone that matches reality.
3. Check `config/budget-pools` for a per-host override that might set a
   LOWER `GARDEN_TOKEN_BACKOFF_FRACTION` or a tighter cap than the 0.85
   default — don't assume the default applies without checking the actual
   configured value for this host.
4. `self-heal-run.sh` only persists a capture on FAILURE (rc != 0); a
   successful-but-wrong-decision tick (the actual failure mode here — the
   foreman exits 0 every time, just doing nothing useful) leaves NO durable
   trace. This is itself the reason this took live debugging to even notice.

## Instrumentation to add

The foreman needs a durable, lightweight per-tick DECISION record so a
future stall like this is diagnosable from the journal alone, without a
human live-debugging it. Concretely: on each tick, write (not necessarily to
the journal every 5 minutes forever — that's needless churn; consider a
host-local rolling log under `.garden-state/foreman/` PLUS a journal-backed
record only on a decision CHANGE or a periodic heartbeat, e.g. hourly) a
one-line summary of: inflight count, target, which guard (if any) caused an
early exit, and (when it promotes) what was promoted. Design this proportionate
to the actual gap found — don't over-build if the root cause turns out to be
a one-line bug that makes the whole question moot.

## Authorization: deploys within the rolling-deploy/canary system

**Maintainer-authorized (kriskowal, this session, 2026-09-16):** you may
initiate and monitor `main2` deploys via the sysop channel —
`scripts/jobs/send-host-op.sh <host> op=deploy authorized_by=kriskowal` —
on any fleet host (the leader, garden2, or oros-studio) if doing so is
useful to reproduce the issue, observe the foreman across a fresh restart
(a `deploy` op restarts the target host's entire fleet including the
foreman service), or validate that your fix actually resolves the stall
post-deploy. This authorization is SCOPED to the `deploy` op for this
investigation only — it does NOT extend to `unit`/`local-model`/`maintain`
or any other sysop op, and does not authorize a ferry/identity-switch. Use
it purposefully, not repeatedly/speculatively — each deploy restarts a
host's live fleet and has real cost; prefer read-only reproduction first,
and reach for a deploy only when you have a specific hypothesis a restart
would test.

## Report

Produce a durable journal record of what you find — a `result` entry
(`scripts/jobs/journal-entry.sh result`) at minimum; if the root cause is a
real, non-obvious bug worth remembering, consider whether it warrants a
short design note. State the root cause with evidence (not "seems fixed" —
show the mechanism, and show a post-fix tick actually promoting from the
reservoir). If you cannot fully root-cause it, report what you ruled out and
what remains open, rather than guessing.
