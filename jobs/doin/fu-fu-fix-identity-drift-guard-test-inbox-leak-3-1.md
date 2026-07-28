In the garden's own repo (kriscendobot/garden, branch `main2`), the maintainer-inbox gate currently reports 14 real `LEAK` entries in `roles/` and `skills/` markdown, and two test suites are red on `main2`. Triage those LEAK entries (fixing genuine drift, not sandbox noise) and report on the two pre-existing failing suites, including whether `test_run_all` is a sandbox artifact.

<!-- garden-reaped: 1 -->

---
claim:
  host: ps23-garden-f65473ae
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-28T16:43:40Z
