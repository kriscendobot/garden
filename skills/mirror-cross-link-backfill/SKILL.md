---
created: 2026-05-22
updated: 2026-05-22
author: gardener
---

# Skill: mirror-cross-link-backfill

Walk every ferried PR pair on record, identify the ones missing the two-way tagged cross-link comment (per `roles/boatman/AGENT.md` § Operating norms and `skills/pr-handoff/SKILL.md` § Done), and post or PATCH the missing side. The norm landed 2026-05-22; this skill is the one-off back-fill for ferries that completed before that date plus an ongoing safety net for any ferry whose cross-link did not land for procedural reasons.

The back-fill is a steward-claimable job by default; the same procedure also serves as the standing safety net the steward applies during its per-cycle survey if a ferry's `message: boatman → steward` was dropped or never written.

## When to use

- **One-shot back-fill** after the 2026-05-22 norm change. The liaison posts a `backfill-mirror-cross-links` job to the board; the steward claims and runs the procedure once.
- **Standing safety net**. The steward applies the same procedure during its per-cycle survey when it notices a recent boatman `result` entry whose paired `message: boatman → steward` is missing or whose upstream comment id was never recorded. Surfaces as a sub-step of the inbox drain.
- **Audit invocation** when the maintainer wants to confirm coverage on a specific repository pair (e.g., "audit `endojs/endo` mirror links from the past month").

## Inputs

- `<scope>`: `recent` (default; open + merged-within-the-last-30-days upstream PRs), `all` (every ferry on record), or a specific list of garden-side PR numbers.
- `<dry-run>`: when set, the skill walks and reports findings but does not post or PATCH anything. Useful for measuring coverage before committing to a full back-fill.

## State

- The journal's ferry history at `journal/entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-result-boatman-*.md` and `*-result-liaison-*.md` (when the liaison ferries). Each carries the garden PR URL, the upstream PR URL, and the head SHA at ferry time.
- GitHub comment state on each garden-side and upstream-side PR (read via `gh api repos/<owner>/<name>/issues/<N>/comments`).

The skill is otherwise stateless; the journal is the source of truth.

## Procedure

### 1. Enumerate ferries

```sh
# Find every boatman / liaison result entry that mentions a ferry.
# A ferry result entry names both the garden PR and the upstream PR.
grep -rlE 'role: (boatman|liaison)' "$JRN/entries/" \
  | xargs grep -lE 'kind: result' \
  | xargs grep -lE 'github\.com/(endojs|agoric|kriskowal)/' \
  > /tmp/ferry-results.list
```

Parse each result entry for the (`garden_pr_url`, `upstream_pr_url`, `head_sha`) triple. The boatman's `result` entries carry these as structured fields; the liaison's older ferry entries may need a regex pass on the body.

Each ferry record is `(garden_repo, garden_pr_number, upstream_repo, upstream_pr_number, head_sha, ferry_date)`. Dedupe by `(upstream_repo, upstream_pr_number)` keeping the newest record (re-ferries supersede the original; the current head SHA is the one to post).

### 2. Apply scope filter

For each ferry record:

- `recent` (default): keep if the upstream PR is OPEN, or if it merged within the last 30 days, or if it closed within the last 30 days. Drop otherwise.
- `all`: keep all.
- explicit list: keep only those whose `garden_pr_number` matches.

```sh
# Per ferry record:
state=$(gh pr view "$upstream_pr_number" -R "$upstream_repo" --json state,mergedAt,closedAt 2>/dev/null)
# Decide keep/drop per the rules above.
```

### 3. Check existing cross-links

For each kept ferry, check both sides for an existing tagged cross-link comment under the bot identity:

```sh
garden_link=$(gh api "repos/$garden_repo/issues/$garden_pr_number/comments" \
              --jq '.[] | select(.user.login == "kriscendobot" and (.body | startswith("Mirror of "))) | {id, body}')
upstream_link=$(gh api "repos/$upstream_repo/issues/$upstream_pr_number/comments" \
                --jq '.[] | select(.user.login == "kriscendobot" and (.body | startswith("Mirror of "))) | {id, body}')
```

Each side is in one of three states:

- **Missing**: no tagged comment exists. The back-fill creates one.
- **Stale**: tagged comment exists but its `(head <short-SHA>)` does not match the current head. The back-fill PATCHes it.
- **Current**: tagged comment exists and matches. The back-fill skips this side.

### 4. Compose the canonical body for each side

Garden side: `Mirror of <upstream-PR-URL> (head <short-SHA>).`
Upstream side: `Mirror of <garden-PR-URL> (head <short-SHA>).`

The `<short-SHA>` is the 9-character short hash of the upstream PR's current head (read from `gh pr view <N> -R <upstream> --json headRefOid`). The same short hash appears on both sides; using the upstream head is the canonical choice because the upstream PR is the published artifact.

### 5. Post or PATCH

For each side that is **missing**:

```sh
gh api -X POST "repos/$repo/issues/$pr_number/comments" -f body="$canonical_body"
```

For each side that is **stale**:

```sh
gh api -X PATCH "repos/$repo/issues/comments/$comment_id" -f body="$canonical_body"
```

For each side that is **current**: no action.

The skill batches reads (one `gh api` call per PR-side, two per ferry) and writes (one per missing or stale side); for ~30 ferries this is roughly 60 reads + up to 60 writes (most writes will be missing-upstream comments since the prior norm was asymmetric).

### 6. Report

Write a `result` journal entry containing:

- Total ferries enumerated; the count kept after the scope filter.
- Per-side coverage before the back-fill (how many missing, how many stale, how many current).
- Per-ferry action taken (create or PATCH on each side, or skipped because current).
- Comment IDs landed for the freshly-posted cross-links so future re-ferries can edit them by id rather than re-greping.

```yaml
ferries_enumerated: <int>
ferries_in_scope: <int>
backfill_actions:
  - upstream_repo: endojs/endo
    upstream_pr: 3232
    garden_repo: endojs/endo-but-for-bots
    garden_pr: 75
    upstream_side: created  # or `patched-stale` or `skipped-current`
    upstream_comment_id: 4567890
    garden_side: skipped-current  # or `patched-stale` or `created`
    garden_comment_id: 1234567
```

## Composition

- **With the boatman**: the boatman writes the steady-state `message: boatman → steward` after every ferry; the back-fill is the catch-up for pre-norm ferries plus the safety net when a steady-state message falls through.
- **With the steward's per-cycle survey**: the standing safety-net check is a small sub-step the steward runs once per cycle (or once per day, depending on the volume) — list the ten most-recent boatman results, confirm each has a paired upstream cross-link comment, post the missing ones. This catches dropped messages without re-running the full back-fill every cycle.
- **With the followup ledger**: orthogonal. The followup ledger captures panel-deferred items; the mirror cross-link captures the ferry relationship. Both compose with the merged-PR feedback watch.

## Pitfalls

- **Re-ferries change the upstream head.** A re-ferry that force-pushes changes the upstream head SHA; the cross-link comment becomes stale. The back-fill detects stale comments by comparing the `(head <short-SHA>)` substring in the existing body against the current `headRefOid`. Stale detection is exact-match on the 9-character short hash; longer or shorter hashes in the body count as stale.
- **The bot user must have comment access on the upstream repo.** Most public upstream repos allow comments from any authenticated GitHub user, including `kriscendobot`. If a private repo refuses, the back-fill skips that ferry and reports it for maintainer attention.
- **Closed-not-merged PRs.** The `recent` scope filter keeps PRs that closed within the last 30 days even if they did not merge. The cross-link there is mostly for the audit trail; if the back-fill operator wants to skip closed-not-merged, the scope filter can be tightened in the calling job.
- **Multiple ferries producing the same upstream PR.** When a chain of re-ferries hit the same upstream PR (force-pushing each time), the deduplication in step 1 keeps the newest head SHA; the back-fill posts a single cross-link reflecting the current state, not a history of ferries.

## Notes from the field

(Append; terse and dated.)

- _2026-05-22_: skill landed alongside the two-way cross-link norm on `roles/boatman/AGENT.md` and `skills/pr-handoff/SKILL.md`. The first back-fill is staged via a job-board post (`backfill-mirror-cross-links`, eligible_roles: steward); the steward claims and runs the procedure once. The journal's ferry-result inventory at that date covers ~30 ferries across `endojs/endo` and the bot's `endojs/endo-but-for-bots` mirrors, most of which lack the upstream-side cross-link entirely (the prior norm was asymmetric). Recent (within 30-day window) is the canonical scope.
