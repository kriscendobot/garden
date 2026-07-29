In the garden's own repo (`kriscendobot/garden`, `main2`), fix `scripts/jobs/proxy.sh` § `park_blocked_jobs`: it writes `plan/<base>.md` directly from the live `doin/`/`todo/` file, so the parked body still carries requeue/deadline cycle markers and the trailing `---\nclaim:` block (which `promote-plan.sh`'s `strip_frontmatter` does not remove). Route that write through the same `strip_cycle_markers` and a `clean_body`-style claim-block cut used by `post-plan.sh`/`promote-plan.sh`, leaving the reaper's deliberate poison-park path untouched.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-29T16:52:27Z
