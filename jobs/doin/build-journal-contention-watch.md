---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-23T17:31:03Z cleared=none -->

---
role: builder
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: journal contention watch

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR). Build exactly what
`designs/journal-contention-watch.md` specifies (the output of the preceding orchestrated job
`design-journal-contention-watch`). Maintainer requirement (kriskowal, 2026-09-23): anomaly detection
for journal transaction **latency and retries**.

- If the design landed as an open-questions PR, build everything that does not depend on an
  unanswered question, take the design's stated defaults, and list what stays contingent.
- Deterministic, with no `claude -p`. Instrumentation goes in `scripts/jobs/common.sh` (and wherever
  else the design names) at negligible overhead. Stats are host-local, with NO per-event journal
  commits. The checker runs as a per-host timer and service pair in `scripts/systemd/`, wired through
  `install-units.sh`. Alerts go through `watchdog-notice.sh`.
- Tests under `scripts/jobs/test/`: a lock wait above baseline, a lock give-up, push retries above
  baseline, a fetch approaching the cap, a slow drift toward the cap, sustained outage-latch skipping,
  an oversized clone (including the automatic remedy if the design adopts one), recovery closing the
  notice, and a quiet baseline NOT paging. Also rerun the existing common.sh, cursor, and clone
  suites to prove the instrumentation changed no behavior.
- Update `context/operations/` docs as the design says. Push to `main2`. Rollout goes through the
  normal rolling deploy; do NOT run deploy-garden.sh.
- **You MUST complete the job via the normal completion path when done.** Two jobs today did
  their work but exited without completing, and the reaper doomed them.

Report: commit sha(s), the thresholds as built, and a one-shot run of the probe on your host
showing current per-clone stats.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T18:13:18Z
