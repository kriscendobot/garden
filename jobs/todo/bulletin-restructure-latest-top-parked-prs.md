# Restructure the bulletin: lead with "Latest" (claude summary + PR links), drop "Recent progress", track PRs parked for maintainer feedback

Wear the **mentor** role. Three maintainer-requested changes to the bulletin
(`scripts/jobs/bulletin.sh` + the journalist handler `scripts/jobs/handlers/bulletin-claude.sh`),
on `main2` (bot identity; isolated worktree off `origin/main2`; the bulletin is the live
`garden-bulletin.service` loop — redeploy/restart at the end).

## 1. Remove the "Recent progress" section

Delete the `## Recent progress` section (the last-N progress-entries list) from
`compute_dashboard` — the maintainer finds it not useful.

## 2. Lead with "## Latest" — a claude-generated summary of recent work, WITH PR links

- Move the journalist's **`## Latest`** narrative to the **TOP** of the bulletin (right
  after the title / `_As of` freshness line, before everything else) — it is the lead.
- The journalist (`bulletin-claude.sh`, `claude -p`) should produce a **concise summary of
  recent work** that **links the relevant pull requests**. Give the handler the PR context
  it needs: the since-cursor board transitions already name jobs like
  `…-pr513-…`/`address-review-ebfb-pr474`; pass the handler enough to resolve those to real
  PR URLs (and the parked-PR set from §3), and instruct it to **hyperlink each PR it
  mentions** (e.g. `[endo-but-for-bots#513](https://github.com/endojs/endo-but-for-bots/pull/513)`).
- Keep the existing **cost gate + idempotent change-compare**: the compare must still
  EXCLUDE the volatile `_As of` line AND the non-deterministic `## Latest` narrative
  (so prose churn never commits on its own), even though `## Latest` is now at the top.
  Preserve graceful degradation (deterministic bulletin still ships if claude is absent).

## 3. New section: PRs parked for maintainer feedback

Add a deterministic section listing **open, non-draft PRs awaiting the maintainer's
review/feedback** in the watched repos — the "parked for kriskowal" queue (this is the
high-value board for a human). 
- Source it deterministically via `gh` (reuse the v1 `review-queue-poll` idea): e.g.
  `gh search prs --owner endojs --review-requested kriskowal --state open` and/or per
  watched repo `gh pr list --search "review-requested:kriskowal draft:false state:open"`.
  Render each as `- [<repo>#<N>](url) — <title> (waiting <age>)`.
- **Throttle the GitHub query** — the bulletin loop runs continuously; do NOT hit the API
  every tick. Cache the parked-PR set in `GARDEN_STATE` and refresh it at most every ~N
  minutes (e.g. 5m), reusing the cache between refreshes. Use gh's built-in `--jq` (not
  external jq) and `require_tools`-guard per the recent hardening.
- If the query fails, degrade gracefully (show the last cached set or "(unavailable)"),
  never wedge the loop.

## Resulting bulletin order

`_As of` freshness → **## Latest** (journalist + PR links) → **## Parked for maintainer
feedback** → Messages to the maintainer → Board → Watch set → Hosts. (No "Recent progress".)

## Redeploy & tests

- Restart `garden-bulletin.service` (non-blocking) so the loop picks up the new layout;
  confirm a tick renders `journal/README.md` with Latest on top, the parked-PR section, and
  no Recent-progress. If you can't restart from a dispatch worktree, flag the restart.
- Stub the journalist + the parked-PR `gh` query; assert: Latest renders at top with PR
  links; the parked section lists review-requested PRs; the change-compare still excludes
  the `_As of` line and the `## Latest` body (no commit on prose-only churn); the GitHub
  query is throttled (not per-tick). `shellcheck`/`bash -n` clean.

## Definition of done

Bulletin restructured (Latest on top with PR links, Recent-progress removed, parked-for-
maintainer-feedback section added with throttled gh query + graceful degradation), idempotency
preserved, redeployed, tests added — committed and pushed to `origin/main2`. Report the SHA,
the parked-PR query used + throttle interval, and a sample rendering. If blocked, report the
diagnosis and ready-to-apply content rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
