Pushed to `main2` as `11a482d343`.

## Report

**What I found on arrival.** The provisioner change this job asks for had already landed in earlier (reaped) runs of this same job — `bb971c9a39` (armed-fork liveness recheck) and `014d2838a5` (retirement hardening). I verified it against the spec rather than redoing it:

- **Armed-set liveness pass** — the discovery loop no longer skips slugs present in both sets; a fully armed own fork is re-probed with the unchanged `upstream_exists`, and a confirmed 404 takes the existing `write_dead_tombstone` + arming-record-removal path in § 1b, inside the same `sync_clone`/`commit_and_push` CAS/retry loop (peers collapse onto one tombstone).
- **Throttle** — `liveness_probe_due` / `mark_liveness_probe` gate armed re-probes to once per slug per `GARDEN_FORKWATCH_LIVENESS_INTERVAL` (default 14400s) via untracked per-host stamps, so no per-tick API call per watched repo. An inconclusive probe (rc=2) writes no stamp, defers, and never tombstones.
- Two guards on the armed path only: a confirm re-check before retiring, and a mass-404 breaker that treats an all-armed-404 tick as a read-side failure and alerts instead.

**What I did.** The job's second half — "confirm the disarm is complete end to end" — was unpinned. `repo-watcher.sh`'s `reconcile_set` *is* a two-way reconcile over all four prefixes, but the only disarm regression test (in `run-test.sh`) covered `garden-triager@` alone, and nothing ran the provisioner and the reconcile together. I added case **K** to `scripts/jobs/test/fork-watch-provisioner-test.sh`: one real `repo-watcher.sh` tick against a mocked `systemctl` arms all four families for a live own fork; its upstream then 404s; the same tick tombstones it, drops both arming records, and issues `disable --now` for `garden-{triager,comment-watcher,ci-watcher,dependabot-watcher}@<slug>`, while a live fork's units stay armed. **55 pass, 0 fail**; with `reconcile_set`'s disarm loop neutered the new assertions fail **8-for-8** (verified, then reverted). Design doc records the teardown contract next to the tombstone section it completes. `shellcheck -S warning` clean. `tests/checks/run.sh` has two failing suites (`test_run_all`, `test_maintainer_inbox_information_hiding`) — pre-existing, identical on a stashed clean tree, unrelated.

**Verification against live state.** `gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro` → 404 confirmed; the journal now holds its tombstone and neither arming record, and no `*chrome-native*` units exist on this host — the class this change automates.

**Follow-up for the maintainer/liaison (not acted on — removing a tombstone is a human call).** `kriscendobot/garden` now **exists** again (transferred from `kriskowal/garden` on 2026-07-28, `gh api` confirms, public), but carries a stale `journal/watch-optout/kriscendobot-garden` tombstone from when it was deleted. State is split: `comment-repos/kriscendobot-garden` is armed (comment/CI/dependabot watchers running) while `repos/kriscendobot-garden` is absent, and the tombstone permanently blocks the provisioner from re-arming commit triage. Deleting that tombstone would let the reconciler restore it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-fork-watch-provisioner-armed-recheck.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2779452 cached reads)
- Output: 19202 tokens
- Cost: $2.7799030000000005
- Wall-clock: 310s

<!-- garden-usage-end -->
