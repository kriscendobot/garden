---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/fork-watch-provisioner.sh
`scripts/jobs/fork-watch-provisioner.sh:222-230` drops the production probe exit status, reducing silent failures to `unclassified (… no output)`; this recurred at 19:55:40 through 20:15:50. Preserve the rc in `UPSTREAM_FAIL_DETAIL` and give no-output inconclusive probes a bounded escalating cooldown that resets after a successful probe. Keep the existing fail-open rule: do not arm, tombstone, or retire forks while the upstream result is unknown. Add coverage to `scripts/jobs/test/fork-watch-provisioner-test.sh` for silent rc=2 probes and cooldown escalation/reset.
