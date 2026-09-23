---
gate: orchestrated
orchestrated_by: comment-latency-watch
priority: normal
posted_by: producer
posted_at: 2026-09-23T16:28:53Z
---

---
role: builder
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: comment latency watch

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR, per
CLAUDE.md § Conventions). Build exactly what `designs/comment-latency-watch.md` specifies.
That design is the output of the preceding orchestrated job `design-comment-latency-watch`.
Read it first, and read its tada report for any notes.

The maintainer requirement (kriskowal, 2026-09-23): **the reactji acknowledgment's GitHub
timestamp is the source of truth for liveness.**

- If the design landed as an open-questions PR, build everything that does NOT depend on an
  unanswered question. Take the design's stated default where it gives one, and list what
  remains contingent in your report. Do NOT build an outward-facing synthetic canary unless the
  maintainer has approved it.
- Deterministic, no `claude -p`. Use a leader-only systemd timer/service pair in
  `scripts/systemd/`, wired through `install-units.sh`, following the existing watcher
  units' shape. Alerts go through `watchdog-notice.sh`. No per-tick journal commits.
- Tests under `scripts/jobs/test/` with stubbed `gh` responses covering: acked on time,
  acked late, never acked, the bot's own comment (ignored), an untrusted sender (ignored),
  a drained fleet (not paged as dead), and recovery (the notice closes).
- Update CLAUDE.md § Monitoring safety constraint and README or context docs only as far as
  the design says; add the new unit to the leader-only singleton inventory in
  `context/operations/leader-follower.md`.
- Run the new tests plus the comment-watcher test suite, then push to `main2`. The rollout
  goes through the normal rolling deploy, so do NOT run deploy-garden.sh.

Report: commit sha(s), the thresholds as built, and a one-shot run against the live
armed repos showing current per-repo ack latencies (read-only).
