---
withdrawn: true
withdrawn_reason: design LANDED: designs/comment-latency-watch.md on main2 (becaf0ffc52) + open-questions PR kriscendobot/garden#110; the session exited without complete-job twice so the reaper doomed a finished job. Build promoted by liaison per maintainer's 'design ... and build it'.
withdrawn_by: liaison
withdrawn_at: 2026-09-23T17:12:46Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: designer
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-23T17:03:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-23T17:03:06Z
---

---
role: designer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-23T16:31:04Z cleared=none -->

---
role: designer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: comment latency watch (reactji-anchored liveness)

Repo: the garden itself (`kriscendobot/garden`, `main2`). Output: `designs/comment-latency-watch.md`.
The builder job `build-comment-latency-watch` follows in the same orchestration
(`comment-latency-watch`) and builds exactly what this design lands.

## Why
Nothing watches comment→job latency today. Existing defenses:
- the comment-watcher's blindness self-test (`scripts/jobs/comment-watcher.sh` ~1683) only fires when a
  tick RUNS and sees zero comments;
- failed-unit checks don't fire either, because the watcher's quiet skip paths (drain, the
  journal-outage cooldown, a stale is-main-host read) all exit 0.
Incident 2026-09-22/23: every comment directive was silently dropped for ~4.5h
while systemd recorded success (a bloated cursors clone latched the shared
journal-outage cooldown). Also, the journal cursor's `last_polled_at` is written ONLY when
a new comment moves the cursor forward (`comment-watcher.sh:2188`), so the journal cannot tell a
QUIET repo from a DEAD watcher. That confusion produced a false "7 repos unpolled for
weeks" alarm on 2026-09-23. Those repos were just quiet; every later comment was
the bot's own.

## Maintainer requirement (kriskowal, 2026-09-23)
**The timing of the acknowledging reactji is the SOURCE OF TRUTH for liveness, if at all
possible.** The watcher posts 👀 (`eyes`) as it ingests a directive
(`skills/reactji-acknowledgment/SKILL.md`), and GitHub timestamps it independently of the
garden's own bookkeeping. Reference point: a kriskowal directive on kriscendobot/garden#108 was created at
16:24:14Z, its `eyes` landed at 16:25:56Z (102s), and the job was posted at 16:25:48Z. So:
latency = reaction.created_at − comment.created_at, read from the GitHub API, not from
self-reported state. A comment that SHOULD have been acknowledged but has no bot
reaction after a threshold is the anomaly.

## Design must settle
1. **Which comments are "should-ack"?** Derive this deterministically, with no LLM, from the SAME
   gates the watchers use (armed repo set, `comment-repos/`; sender trust:
   `trusted-senders/allowlist`, `maintainers/allowlist`, org membership when
   `sender-gate: required`; directive recognition, i.e. @-mention or imperative verb; exclude
   the bot's own comments). Ideally reuse the watcher's own classifier, not a copy, so the two
   cannot drift. Cover issue comments, review bodies, and inline review comments, plus the issue
   inbox (`issue-inbox-watcher.sh`) and the GitHub-wide mention watcher if it is armed.
2. **Thresholds.** Base them on each watcher's timer cadence (e.g. alert when an ack is later
   than k× cadence plus a slack), and state the numbers.
3. **Distinguishing states:** acked-on-time / acked-late (latency anomaly) / never-acked
   (liveness failure) / the watcher intentionally not acking (drained fleet, or a directive
   intentionally ignored). A drained fleet must not page as dead, but it should be VISIBLE:
   say how.
4. **Quiet-repo liveness.** Reactji only prove liveness when a comment arrives. Decide
   whether that suffices, or whether a supplementary per-tick heartbeat (HOST-LOCAL state,
   NOT journal commits: journal churn was just cut from ~10k/day, see
   74461976fd and 3c696ea6c8) is needed to catch a dead watcher before the next
   human comment. If you propose a synthetic canary (the bot posting a probe comment
   somewhere), that is outward-facing: treat it as an OPEN QUESTION for the maintainer,
   not a default.
5. **Where it runs.** Leader-only singleton (like the other watchers) gated by
   `is-main-host.sh`, and it must still run while the fleet is drained. Also: what watches
   the watcher? Say what happens if this checker itself stops running.
6. **API budget.** Reading reactions per comment costs API calls, so bound it (only
   should-ack comments inside a lookback window, cached once a comment is resolved).
7. **Alerting.** Use `scripts/jobs/watchdog-notice.sh` (one coalesced notice per open
   condition, amended as it continues, closed with `--recovered`), keyed per repo+class. Never a new
   message per tick.
8. **Observability.** A small latency record (p50/p95 per repo) for the bulletin or
   a read-only probe script, if cheap and churn-free.

Follow `roles/designer/AGENT.md` for the open-questions carve-out (land bare if
there are none; review PR if there are). Keep open questions to genuine maintainer
decisions. Everything else should be decided in the design so the build can proceed.
