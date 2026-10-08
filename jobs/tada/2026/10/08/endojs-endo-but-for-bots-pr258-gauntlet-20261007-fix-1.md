I applied the panel's round-1 must-fix items to endojs/endo-but-for-bots PR #258 and pushed three follow-up commits. CI is green on the new head `59327bd058` (16/16), and a re-run proved the cache restore actually works.

**What changed** (head `ace90ab0af` → `59327bd058`, pushed with `safe-push-pr-head.sh`):
- **`3f1decac4b`** — fixes to `.github/workflows/ocapn-guile-interop.yml`:
  - **Restore never ran:** I split the cache into `actions/cache/restore` and `actions/cache/save` (v5.0.5, the same pin the tarball cache uses). The extract now checks `cache-hit`, an output `cache/restore` actually declares; the old `cache-matched-key` check was always false.
  - **Cache key:** the key now hashes `endo/.github/workflows/...`, the path under the checkout, so it changes when the workflow changes. I removed `restore-keys` so the snapshot can't keep growing across workflow edits.
  - **Read-only `/gnu/store`:** the extract stops both `guix-daemon` and the read-only `gnu-store.mount`, and a trap restarts them even if the extract fails.
  - **Snapshot too early:** before snapshotting, the job now builds the exact `guix shell --pure --no-grafts` profile the Guile host step uses.
  - **Live database copy:** the daemon is stopped while `tar` runs, so its database isn't copied mid-write.
  - **Visibility:** restore and snapshot sizes appear as `::notice::` lines. A key hit with no tarball now fails the step instead of silently passing.
- **`04c37431f6`** — the first CI run failed with exit 127 because `--pure` leaves `true` off the PATH. The step now runs `guile -c '(exit 0)'` instead.
- **`59327bd058`** — zizmor also went red, but not because of this PR. The upstream `dorny/paths-filter` `v3` tag moved to v3.0.4, so the `# v3` comment in `ci.yml` no longer matches the pin. I changed the comment to `# v3.0.3`, which is what the pinned commit `d1c1ffe` is; the pin itself is unchanged.
- **PR body:** cut from 642 to 354 words. It no longer claims a two-server outage day won't block the workflow.

**Evidence:** the first run took the cache-miss path: it wrote a 243M compressed snapshot and saved it (job 113238156036, 2m42s). I re-ran the job and it took the hit path: it restored 1.1G into `/gnu/store`, skipped the snapshot and save, and the interop test passed (job 113240738996, 1m19s). I posted both job links and a summary on the PR: https://github.com/endojs/endo-but-for-bots/pull/258#issuecomment-6056794482

**Follow-ups:**
- Other branches whose `ci.yml` still has the `# v3` comment will hit the same zizmor failure once they rebase or their base moves.
- I didn't add the panel's should-fix integrity check after restore (`guix gc --verify`).
- Panel round 2 is left to the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr258-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2754485 cached reads)
- Output: 18300 tokens
- Cost: $1.6128490000000004
- Wall-clock: 1222s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
