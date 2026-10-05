Fixed: `ci-wait-merge.sh` now refuses to merge a PR whose base is a frozen snapshot of a live feature branch (not trunk), so it can no longer strand the content off the trunk. Pushed to main2 as `5058262e17e`. The new tests pass. One older test, T8, still fails, but it fails the same way on main2 without my change (details below).

**The fix** (`scripts/jobs/gardening/ci-wait-merge.sh`)
- A new check, `refuse_nontrunk_snapshot_base`, runs inside `unfreeze_base_if_frozen` when the base isn't an `llm|main|master` snapshot. It treats a base `<name>-<hex>` as a snapshot only when both hold:
  - `<name>` exists as a live branch on the repo.
  - The `<hex>` suffix is the base branch's tip commit, or an ancestor of it. The ancestor case covers a sibling that has already merged onto the snapshot and moved its tip.
- When it is a snapshot, the script alerts the maintainer and prints `unfreeze-blocked … reason=nontrunk-frozen-base live=<name> → alerted maintainer, NOT merging`. It exits 1 without merging and without touching the PR's base. The maintainer then decides: retarget to trunk, retarget to the live feature branch, or land the parent PR first.
- If any GitHub read fails, it refuses the merge rather than guessing. A branch whose name only happens to end in hex characters (e.g. `release-2024`) still merges normally, because the suffix isn't a commit.
- **Exit code:** I kept exit 1 and made the printed reason the distinct signal, rather than adding a new exit code. Exit 1 already means "stall for maintainer" (the dependent-stack refusal uses it too), and a new code could be mishandled by callers that only know the existing ones. The header comment documenting the exit codes is updated.

**Tests** (`scripts/jobs/test/ci-wait-merge-test.sh`)
- The fake `gh` now answers branch-tip and compare lookups.
- T36: the #1343 shape, `feat/daemon-provisioning-grants-5feadae` → refused, no merge, no base edit, distinct reason printed.
- T37: snapshot whose tip has moved past the suffix commit → still refused.
- T38: `release-2024` → merges.
- T39: `<name>-<hex>` with no live `<name>` branch → merges.
- T40: branch read fails → refused, no merge.

**Docs:** `roles/conductor/AGENT.md` step 2 now has a paragraph saying never to merge onto a non-trunk snapshot, and listing the maintainer's three options.

**Test results:** 94 pass, 2 fail. Both failures are T8. Inside a running worker, the real fleet `gh` wrapper is already on PATH and gets used instead of T8's test stub, so its first PR read fails. That's a problem with how the test sets itself up, not with this change.

**Follow-up:** T8's setup could be made independent of the PATH it inherits so it passes inside a worker. I haven't posted a job for that.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-ci-wait-merge-nontrunk-frozen-base.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1210867 cached reads)
- Output: 14663 tokens
- Cost: $1.1841694
- Wall-clock: 143s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
