I've landed the fix on `main2` as 43cdacb443d, directly with no PR, and compacted the maintainer inbox. The foreman on this host is still running the old code, though, so it will keep posting a few duplicate M2 notices until the rolling deploy picks up the fix.

**Root cause (confirmed).** `notice_signature()` used the exact set of `M…`/`#…` tokens in each notice as its key, and only remembered the last one. The model's wording named different subsets of the same two blockers from tick to tick, and every subset change counted as new, including flips back and forth (A→B→A). `decisions.log` shows about 80 consecutive "maintainer-note" ticks with the board unchanged, and 33 foreman notices landed.

**Fix (`scripts/jobs/foreman.sh`):**
- **Key by milestone:** each notice is keyed by its milestone ids (`M2`, or `M2-M3`); a notice naming no milestone uses `general`.
- **Deliver only new blockers:** each key keeps a list of the PR/issue refs already reported, stored per host under `$GARDEN_STATE/foreman/notice-seen/<key>`. A notice goes out only if it names a ref not on that list. It also goes out if the list is older than `GARDEN_FOREMAN_NOTICE_TTL` (default 24h), so a stalled milestone gets at most one reminder a day.
- **One entry per milestone:** delivery now uses `inbox-send.sh`'s existing update-in-place mode, keyed `foreman-milestone-<key>`. Each milestone has one unread entry that is updated in place, with a count of how many times it was sent, instead of a new file each time.
- **Pumps no longer reset the dedup:** posting a fixer job for a blocking PR isn't progress on the milestone. Promotions and pumps no longer clear it.

I did not derive the key from board state as the spec suggested. The foreman wrapper never sees which PRs block a milestone; only the handler's prose names them. So the fix makes the key stable against that prose varying rather than trying to compute the blockers.

**Before and after, on the real captured notices:**

| Notice | Old signature | New: key / new refs |
|---|---|---|
| 20:43Z | `#1349,M2` | M2 / `#1349` → delivered |
| 00:08Z | `#1349,#1356,#3332,M2` | M2 / `#1356` → delivered (amends the entry) |
| 02:08Z | `#1356,M2` | M2 / none → quiet |
| 02:13Z | `#1349,#1356,M2` | M2 / none → quiet |
| 03:28Z | `#1349,M2` | M2 / none → quiet |

Replaying all 33 foreman notices gives **7 deliveries into 2 entries (M2, M3)**, against 33 separate files before. Nothing would have gone out after 00:08Z. Of the 7, 4 were for distinct older asks (#756, #3322/#3332, #1355, #1102).

**Tests:**
- I rewrote `scripts/jobs/test/foreman-maintainer-notice-dedup-test.sh` around the captured notices. It checks that reworded or subset M2 notices stay quiet, and that a new PR (#1400) amends the same entry. It also checks that a new milestone (M3) gets its own entry, that the TTL reminder fires, and where the state file lives. It passes 10/10 on the fix and fails 7/10 against the old `foreman.sh`.
- Shellcheck is clean on both changed files.
- These pass: the other foreman tests (brake, decision-log, deferred-sigpipe, provider-order), `inbox-coalesce-test`, `awaiting-maintainer-gate-test`, and the CI "Run focused tests" suites apart from the checks runner.
- Pre-existing failures, also present without this change:
  - `foreman-edge-kick-test` has 1 failure; I reproduced it on the old code.
  - `live-budget-admission-test` has 3 failures; I reproduced them on unmodified `origin/main2`.
  - The CI checks runner (`tests/checks/run.sh`) didn't complete here: `test_gauntlet_stage_retry_budget` ran past 900s, and `test_gauntlet_viability_gate` and `test_state_clone_keeper` ran past 120s. I reproduced the `test_state_clone_keeper` timeout on unmodified `origin/main2`; I didn't re-run the other two on the old code. None of them touches the foreman or `inbox-send`. The other suites in that runner pass.

**Inbox compaction.** I archived 33 duplicate M2 notices with `maintainer-archive.sh`: 30 in the first pass and 3 more the undeployed foreman posted during this job. The complete #1349+#1356 ask (`20260928T034317Z`) was archived along the way, and my attempt to move it back to unread lost the journal push race five times. Instead I re-sent its text once as the new `foreman-milestone-M2` entry, noting that it consolidates the ~33 duplicates, so the fix will update that entry from now on.

Foreman notices left unread:
- `foreman-milestone-M2`: the gauntlet decision on #1349 and #1356.
- The #1355 ask.
- The #756 merge ask (that PR is still open and not a draft).
- The two original M3 notices, which weren't part of the flood.

**Follow-ups:**
- Once the deploy lands, the first M2 notice will update the `foreman-milestone-M2` entry instead of adding a file. Any timestamped M2 notices posted before then can be archived at the next muster.
- The old `.garden-state/foreman/notice-sig` file is no longer read and is harmless.
- The `live-budget-admission` failures and the three slow or hanging check suites are separate existing issues.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-foreman-milestone-notice-dedup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (4565316 cached reads)
- Output: 30980 tokens
- Cost: $2.5513192
- Wall-clock: 4510s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
