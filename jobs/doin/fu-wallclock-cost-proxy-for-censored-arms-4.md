In the garden's own repo (kriscendobot/garden, branch `main2`, direct push — no PR), fix the two pre-existing failures in `scripts/jobs/test/hermit-capability-probe-test.sh` (`capable_succeeded not 1`). They were confirmed to fail identically on `origin/main2` independent of the wallclock-cost-proxy change, so diagnose whether the probe or the test's expectation is wrong and repair the correct side.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-29T01:55:46Z
