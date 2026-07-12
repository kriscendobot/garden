In `scripts/jobs/common.sh`, `is_transient_net_error()` (defined ~line 277) classifies transient connectivity failures via a curated regex that includes `read tcp .* i/o timeout` but NOT the connection-establishment variant `dial tcp .* i/o timeout`. Go's net stack emits both: `dial tcp <ip>:443: i/o timeout` for a connect timeout and `read tcp ... i/o timeout` for a read timeout — both are transient. Because of the gap, `garden-pages-watcher` (and the ci/comment/mention watchers sharing this helper) treated a real network blip as a STRUCTURAL failure and hit `die` → exit 1 → systemd restart + self-heal. Observed failure signature: `source: couldn't fetch workflows for kriskowal/garden: Get "https://api.github.com/repos/kriskowal/garden/actions/workflows?...": dial tcp 140.82.116.6:443: i/o timeout` followed by `FATAL: pages run source failed for kriskowal/garden (rc=1...)`. Fix: broaden the alternation to cover both, e.g. replace `read tcp .* i/o timeout` with `(dial|read) tcp .* i/o timeout` (equivalently add a `dial tcp .* i/o timeout` alternative). Keep the change to that single regex so all four watchers benefit; no behavioral change for structural errors. A quick self-test with `is_transient_net_error 'dial tcp 140.82.116.6:443: i/o timeout'` should now return true.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  claimed_at: 2026-07-12T16:04:11Z
