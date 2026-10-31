Opened draft PR endojs/endo-but-for-bots#1586: https://github.com/endojs/endo-but-for-bots/pull/1586

Completed M3 filesystem-interface reconciliation for `@endo/platform` and `@endo/daemon`: added portable `subView`/`makeFile`, live file returns and readable-blob initialization for mounts, and immutable snapshot subtree/change-reader behavior. Updated guards, types, tests, and design status.

Verification: 108 focused tests passed, affected-package type checks passed, and all pre-push gates passed. CI remains in progress; both coverage lanes currently fail in unrelated `@endo/sandbox#test:c8` after its 475 tests pass.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-fs-interface-reconciliation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5321s

<!-- garden-usage-end -->
