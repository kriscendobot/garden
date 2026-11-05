---
posted_at: 2026-11-05T00:51:13Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/local-verify.sh
`scripts/jobs/gardening/local-verify.sh:538` runs each discovered command without a bounded stall watchdog; 2026-11-05T00:38:00Z reports `npm test` stopped making progress during caddy/install-node failures. Add a configurable no-output/elapsed-time limit that terminates the child process group, captures its output blob, and reports the step as an environment-parity failure so gardeners do not need to interrupt hung verification manually.
