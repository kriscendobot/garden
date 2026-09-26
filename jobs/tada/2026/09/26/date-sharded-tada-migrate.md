## date-sharded-tada stage 3: flat tada backlog migrated to date shards

All 8,356 flat `jobs/tada/<base>.md` entries were moved into `jobs/tada/<yyyy>/<mm>/<dd>/` in a single commit, **`52cb4e14d1a`** on `origin/journal2`. It is renames only, with no content changes. None landed in `undated/`, and the flat level is now empty. A second pass found nothing left to move.

**Deploy check (done before starting).** Stage 2 (`6de4bf5a57`) is an ancestor of the `deployed_sha` on all three hosts in `fleet/health/*`:
- leader `endolin-garden`: `47b41af5a14`
- `endolin-garden2`: `4ab1c8b0be6`
- `oros-studio`: `917115c9b77`

oros-studio's health record is 7 days old (2026-09-19), but its deployed sha already includes stage 2, so it can only write sharded entries.

**Seen-marker check (done before any file moved).** Stage 1 (`a9adf2ea427`, deployed on all three hosts) already keys `follow-up.sh`'s seen-marker on the basename. Each tick also rewrites any old rel-path lines down to basenames. A moved report keeps its basename, so the migration cannot cause a burst of follow-up notifications. Nothing needed fixing.

**Date recovery differed from the spec.** On 2026-09-23 the journal's history was cut down to a fresh root commit (`154a16cea1`). Running the spec's `--diff-filter=A | tail -1` command as written would have dated all 8,356 entries 2026/09/23, which is the truncation date, not the completion date. The full old history is kept on `journal2-archive-20260923`, and its tip has the same tree as the new root. So when an entry's oldest add commit was that root, I looked up its oldest add commit in the archive instead. I also used `--no-renames` so a report that arrived by a move from `doin/` still counts as an add. All 8,356 resolved, spread from 2026-06 to 2026-09 (739 / 3,295 / 2,496 / 1,826 by month), and random spot checks matched the spec's command run against the archive. That is why `undated/` is empty.

**Script.** `scripts/jobs/migrate-tada-shards.sh`, landed on main2 as `959febf3bb3`. It takes `--archive <ref>` and `--dry-run`, and runs one commit per pass under a rebase-and-retry push loop until nothing flat remains. It never touches entries that are already sharded, so re-running it is safe. I ran it in a throwaway journal2 clone under `scratch/`, since deleted; I never ran git in the deployed root or its journal worktree.

**Side effects to know about:**
- **Two copies of one report.** `build-minion-town-invitation-onboarding` now exists under both `2026/09/02` (moved from flat) and `2026/09/21` (a later completion). `tada_find` returns the 09/02 copy, which is also what the old flat-first lookup returned, so behavior is unchanged. Other bases already existed in more than one shard before this job.
- **One oversized bulletin digest.** `bulletin.sh`'s next digest of board changes will list about 8,356 renames, or about 16k delete-plus-add lines once git gives up on rename detection. If that is too large for the journalist, `bulletin.sh` falls back to the deterministic bulletin, so this is a one-off.
- **Existing bug in `reputation.sh`, not caused by this job.** Its claim-to-completion timing only matches flat `jobs/tada/<base>.md` paths. Completions written sharded since stage 2 therefore fall back to `duration_secs`. The migration's sharded adds are ignored, so they don't distort the numbers.

**Follow-ups:**
- Stage 4 (out of scope here, as instructed): remove the flat-path fallback from the tada helpers and the seen-marker's extra old-path normalization.
- Fix `reputation.sh` so its timing match also recognizes `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/date-sharded-tada-migrate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 64 tokens (1939750 cached reads)
- Output: 14566 tokens
- Cost: $1.2193739999999997 (2 engagement(s) unpriced)
- Wall-clock: 348s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
