Fix round 4 on kriscendobot/minion.town#135 is done. I pushed four commits on top of `dd72592` (head is now `d6048ea`), and CI is green: all 3 checks passed (`ci-wait-merge` exited 0).

What changed, by panel finding:
- **assessor (must-fix):** `68e395d` runs the deploy script on the box under `set -eo pipefail`. A truncated `base64 -d` payload now stops the deploy instead of quietly installing a partial preflight script or systemd unit. The `systemctl status | head` line only prints diagnostics, so it is marked `|| true` and can't fail the deploy.
- **corner-prober (must-fix), `backup` had no test:** `4ef4afc` adds a `backup` suite. It checks the database copy, the CAS copy (skipping in-flight `.tmp-` uploads), the exact MANIFEST, and that `restore` accepts the result.
  - It also covers a failed database copy (service restarted, scratch directory removed) and a restart that fails or never becomes ready.
  - A new `NPM_REGISTRY_NODE` variable lets the tests replace the release's node binary with a stub.
- **Other fixes in the same commit:**
  - **breaker:** the EXIT trap is now cleared before the post-backup restart, so a failed `systemctl start` still reports "backup itself is complete".
  - **assessor (round 3):** the scratch directory is removed when the backup fails, not only when it succeeds.
  - **saboteur:** restore refuses a CAS entry that is a symlink or not a regular file.
  - **wire-watcher:** a CAS object that is listed but absent gets its own "missing" message. There are new tests for a tampered database, a tampered inventory, a corrupt object and a missing object.
  - **corner-prober:** restore refuses duplicate inventory entries. There are new tests for an empty CAS and for an existing pre-restore generation.
- **Preflight (`36533be`):** the free-space floor is limited to 18 digits, so an overflowing value gets the one refusal message instead of a bash error first. Zero is documented as turning the check off. Tests cover zero, 18, 19 and 26 digits.
- **pruner / typist (`d6048ea`):** the README's design pointer and status are cut to one statement each, the sentence repeating the heading is gone, and the `→` arrows are replaced with words in the README and DEPLOYMENT.md.

Verification:
- The 27 tests in the two npm-registry suites pass locally.
- `tsc` and prettier are clean.
- I removed each new guard in turn and confirmed its test fails.

I posted the dispositions as a PR comment (issuecomment-5882572017).

Not done, since the panel marked these as optional:
- fast-check property tests (the repo has no fast-check dependency).
- One shared SQLite backup helper for the two scripts that each carry a copy (purist).
- Setting Node's heap limit (`--max-old-space-size`) below the service's `MemoryMax` (engine-realist).
- Automatically revoking the old grant when the publisher secret is rotated (locksmith).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr135-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3368474 cached reads)
- Output: 25296 tokens
- Cost: $2.1523587999999996
- Wall-clock: 549s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
