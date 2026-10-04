Opened draft PR [#154](https://github.com/kriscendobot/minion.town/pull/154) against frozen base `chore/javascript-only-scripts-part-2b-2ca6c15`.

Converted all remaining scoped deploy/host scripts to Node ESM, updated callers and documentation, deleted `common.sh` and shell counterparts, and emptied the shell allowlist. Preserved remote SSM payload behavior, Claude production checks, and daemon port-reaper recovery semantics.

Validation: pre-push gates and typecheck passed; full Vitest passed with 837 tests; all three GitHub checks passed. No live AWS or production deployment was performed; per-script exercise evidence is recorded in the PR.

Affected areas: `deploy/aws`, workflows, systemd, Docker, deployment documentation, tooling, and tests.

Follow-up: PR remains draft for the automated review gauntlet.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2079s

<!-- garden-usage-end -->
