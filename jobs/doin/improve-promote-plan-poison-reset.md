scripts/jobs/promote-plan.sh
Promoting a poison-parked job re-poisons it immediately. When the reaper poisons a job it parks it in `jobs/plan/` (gate=go-ahead) with the counter markers still in the body — `<!-- garden-reaped: N -->` and, for a deadline overrun, `<!-- garden-deadline-overrun: N -->` (reaper.sh:609, 648, 720; regexes in common.sh:2799 and reaper.sh:114). `promote-plan.sh`'s `strip_frontmatter` only removes the plan frontmatter block and passes the body through verbatim, so the promoted `todo/` file carries N forward. With `GARDEN_REAP_OVERRUN_THRESHOLD=1`, the next reap cycle re-reads the stale count, clears the threshold on its first evaluation, and parks the job straight back in `plan/` without ever granting it a requeue.

This is live today: the sturdyref gauntlet `endo-sturdyref-agent-surface-build-gauntlet` sits in `plan/` behind `go-ahead` carrying poison metadata from the 07-26 overrun, and the press tick's guidance is that "a promoting liaison should clear or requeue past it" — a manual step no promoter is reliably going to perform, on a job that has already waited days for the promotion.

Change: have `promote-plan.sh` strip the reaper's counter markers from the body as part of promotion (matching `REAP_MARKER_RE` and `DEADLINE_OVERRUN_MARKER_RE`, plus any stale `garden-reap-now` / `garden-productive-cycle` markers), and record what it cleared in the existing `<!-- garden-promoted-from-plan: … -->` provenance comment so the reset is auditable rather than silent. Promotion is a deliberate "run this again" act, so a clean counter is the correct semantics; the reaper's protection is unchanged, since a job that still fails deterministically re-accumulates and re-poisons on its own. Reuse the marker regexes from `common.sh` rather than re-spelling them. Related but out of scope: `post-plan.sh` re-parking paths.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-29T01:56:43Z
