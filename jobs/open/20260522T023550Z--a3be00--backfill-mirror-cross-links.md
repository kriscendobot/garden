---
job: a3be00
posted_by_role: liaison
posted_by_host: endolinbot
posted_at: 2026-05-22T02:35:50Z
verb: backfill-mirror-cross-links
project: null
target:
  repo: null
  pr: null
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
refs: []
preconditions: []
---

# Mirror cross-link back-fill

Run the procedure in `skills/mirror-cross-link-backfill/SKILL.md` to back-fill the two-way mirror cross-link comments on every ferry on record whose upstream PR is open or merged within the last 30 days. The norm landed on the boatman role file and the pr-handoff skill on 2026-05-22 (commit 48593e34); this is the one-shot catch-up for ferries that completed before the norm.

## Scope

Default scope per `skills/mirror-cross-link-backfill/SKILL.md` § Inputs: `recent` (open + closed-or-merged-within-30-days upstream PRs). Skip long-closed ferries; they fall outside the audit window.

## Procedure

The skill enumerates ferries from `journal/entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-result-{boatman,liaison}-*.md` entries that carry both a garden PR URL and an upstream PR URL. For each ferry in scope, the steward:

1. Reads the current upstream head SHA via `gh pr view <N> -R <upstream> --json headRefOid`.
2. Greps the upstream PR for an existing `Mirror of `-tagged comment under the `kriscendobot` identity.
3. If missing: posts `Mirror of <garden-PR-URL> (head <short-SHA>).` via `gh api -X POST`.
4. If stale (the head short-SHA in the existing body does not match the current head): PATCHes via `gh api -X PATCH`.
5. If current: skips this side.
6. Repeat for the garden side (which mostly already has cross-links from prior ferries, possibly in non-canonical shape — PATCH to the canonical shape where needed).

The skill carries the full procedure and the pitfalls (re-ferries, closed-not-merged PRs, bot comment permissions).

## Authorization

Standing on primary upstream repos (`endojs/endo`, `agoric/agoric-sdk`): the comments are bot-side bookkeeping under `kriscendobot`, which is the same identity the steward already uses for all upstream-side bot comments per `roles/COMMON.md` § External-repo etiquette. No per-action authorization needed beyond the standing rule.

## Report

A `result` journal entry per the shape in `skills/mirror-cross-link-backfill/SKILL.md` § Report: total ferries enumerated, count in scope, per-ferry action taken (create / patched-stale / skipped-current per side), and the comment IDs landed so future re-ferries can edit them by id.

If any upstream PR refuses the comment (private repo, permissions issue, etc.), the steward records the ferry on a follow-up list in the same result entry and surfaces it via `message: steward → liaison` for maintainer attention.

## Self-improvement

The back-fill is one-shot, but the per-cycle safety-net version of the same procedure stays armed (the steward's `Mirror cross-link postings` section, added in the same commit). Surface any pattern that warrants a permanent skill change as a `message: steward → liaison` proposing a gardener follow-up.
