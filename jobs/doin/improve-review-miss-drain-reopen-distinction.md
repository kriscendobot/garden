scripts/jobs/review-miss-record.sh
Move the "genuine recurrence vs. backlog-drain artifact" judgment out of the prosecutor's head and into the store writer, so it runs deterministically and identically on every host. Today `cmd_record` blanket-sets `recurrence=1` whenever a new miss joins a `closed` cluster (the `if [ "$oldstatus" = closed ]; then status=open; recurrence=1; fi` at ~line 184). That fires on pre-improvement cascade reviews that merely drained after the cluster closed mid-drain, producing a false "the improvement failed" maintainer escalation — observed twice on agoric-sdk PR #15, handled two different ways by two prosecutors (one suppressed, one escalated-then-caveated).

Change: have the record file carry the reopening miss's review/comment timestamp (add a frontmatter field, e.g. `review_at:`, parsed with the existing `fm` helper), and compare it against the cluster's improvement time — derivable from the stored `improved_by` commit (its committer date via `git -C "$DIR" show -s --format=%cI <sha>`) or the `improvement_job` dispatch time. When the reopening miss's timestamp is *before* the improvement landed, emit a distinct `drain_reopen=1` (keep `status=closed`, do not set `recurrence=1`) so the prosecutor records-and-re-closes without escalating. When the miss postdates the improvement, keep today's `recurrence=1` reopen so a genuine post-fix recurrence still escalates. Surface the new flag in both the `log` line and the `recorded=... recurrence=...` stdout contract (add `drain_reopen=<0|1>`), and add a case to `scripts/jobs/test/review-miss-record-test.sh` covering a pre-improvement reopen (expects `drain_reopen=1`, no reopen) and a post-improvement reopen (expects `recurrence=1`). This makes `skills/review-retrospective/SKILL.md` § 6's escalation gate mechanical rather than a per-prosecutor timestamp eyeball.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-20T17:21:13Z
