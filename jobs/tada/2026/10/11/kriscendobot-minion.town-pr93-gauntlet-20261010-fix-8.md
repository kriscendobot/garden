**Fix round 8 for kriscendobot/minion.town#93: done, CI green on head `9adb2e4`**

I applied the round-8 panel's must-fix items and pushed them to `feat/clip-content-store-gc` as two follow-up commits (fast-forward from `e0cc943`). `ci-wait-merge.sh` returned rc 0, with all three checks passing (test, and the Claude harness on amd64 and arm64).

**`92bfb9b` — fix(gateway): one unreadable record can no longer block GC for everyone** (breaker, saboteur)
- **Unreadable roots:** these are settled records with a missing, malformed or oversized manifest, and live records whose `front` is not a blob id or points at something that isn't a manifest. The audit now lists them one by one under `unreadableRecords` and keeps going. A delete run still refuses, but now names each record and the fix.
- **New `--excise-unreadable <recordId>...` flag:** works only with `--delete`. It re-reads the root and removes the record only if the root really is unreadable. It refuses a readable root, a dead root (that is `--drop-unresolved`'s job), a failed liveness check, and a record it has no powers plane to check.
- **Excision race closed:** both excision flags re-read the record just before renaming it, and refuse if it changed during the liveness check. Excising the same record twice now creates a new tombstone instead of overwriting the first.
- **Overlapping runs:** the inventory skips `.tmp-gc-<pid>-*` quarantine files whose process is still running, so a timer run and a manual run can no longer break each other's sweep. A crashed run's leftovers are still cleaned up.
- **Grace floor:** the 60-second minimum is now documented as a guard against typos only. It does not limit how long a publish can take; the one-hour default is the real safety margin.
- **Tests and docs:** new tests cover each of these. The CLI usage text and output and the design doc are updated to match.

**`9adb2e4` — docs(gc): runbook split** (pruner)
- The audit-validation script and recovery steps moved out of DEPLOYMENT.md into a new `deploy/aws/content-gc-runbook.md`. Recovery now uses `--excise-unreadable` (masking the timer, then running once with `systemd-run` under the unit's user and environment) instead of renaming the record by hand.
- DEPLOYMENT.md keeps the flags, the promotion gate and the wiring. `deploy/aws/README.md` links to the runbook.

**Summary comment** (scribe): I posted https://github.com/kriscendobot/minion.town/pull/93#issuecomment-6113793291, which summarizes fix rounds 2 through 8. It also notes that commits landed after the earlier `review-budget-reached` marker, so that verdict is out of date.

**Verification:** the GC and CLI test suites pass (50 tests) and typecheck is clean. One test in the full local run failed: `test/git-remote/capability.test.ts` "propagates a git failure", in code this PR doesn't touch. I didn't confirm it fails on the old head, but CI's `test` job passed.

**Declined, not done:**
- Saboteur #3: a pet name is left stranded when `unpublish` fails. The panel accepted the logged warning.
- Breaker #5: liveness reads have no timeout of their own; the unit's 30-minute `TimeoutStartSec` bounds them.

No panel re-run from this stage; the driver posts panel-9.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3680956 cached reads)
- Output: 32086 tokens
- Cost: $2.3983592
- Wall-clock: 1052s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
