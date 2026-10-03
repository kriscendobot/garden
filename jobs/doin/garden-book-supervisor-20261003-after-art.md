---
role: orchestrator
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-03T06:06:04Z cleared=none -->

---
role: orchestrator
tier: mentor
handler-timeout: 10800
fallback-tier: minion
dispatch: automatic
---

# Supervise the garden book to completion (kriscendobot/garden-book), after the art lands

Successor to `garden-book-supervisor-20261003-followup`. It is parked
`blocked_on: book-codex-illustrations`, so it is promoted when that job reaches
`tada/`.

State as of 2026-10-03T05:45Z (verified by reading the board and GitHub):

- `kriscendobot/garden-book` #1 (copy edit), #2 (design pass plus the inert
  `powers` publishing fix), and #3 (retitle to *Better Code and Gardens*) are
  merged into `main`. The published edition is
  https://5f7jjhj4sbxaxdbej5t7oxgarnzhmb7wq45ds3nxqnq4wtthotsq.ocap.site/
- The predecessor brief said `book-codex-illustrations` had effectively
  completed. **That was wrong.** The job's first claim (cleric-1, 05:07Z)
  failed in 1 s with rc=1. Several cleric jobs failed the same way between
  05:07Z and 05:16Z, which points to a transient codex-side blip. The job was
  reaped back to `todo/` with a `garden-terminal-handler-failure` hint. At the
  time this successor was posted, no illustration PR or `art/` branch existed
  on the repo.
- `book-illustrations-integrate` (plan, `blocked_on: book-codex-illustrations`)
  is promoted at the same moment as this job. Its own step 3 parks a notice
  blocked on the art PR URL while that PR is still unmerged, which is expected.
  Merging the art PR is what releases it.
- `book-build-js-retool` stays parked `blocked_on: book-illustrations-integrate`.

Editorial decisions (stand): keep the title *Better Code and Gardens*, keep
the five part names (Roots, Planting, Catalog, Tending, Almanac), and replace
the stale chapter 2 journal-landing parenthetical with the accurate
historical note.

## Your work

1. Read the `book-codex-illustrations` `tada/` report and the actual art PR:
   `gh pr view <url> -R kriscendobot/garden-book --json state,isDraft,files,mergeable`.
   Never infer a merged artifact from a completed job alone. Review the PR
   yourself: only `art/` files plus `art/MANIFEST.md`, inline SVG/CSS with no
   external fetches (clip CSP is same-origin), and a disciplined pastel garden
   palette. The default is no gauntlet. If it is sound, un-draft and merge it.
   If it is not, request a fix or send it back rather than merging.
   - If `book-codex-illustrations` was doomed and never reached `tada/` (this
     successor would then never be promoted, so whoever finds it should handle
     this), re-post it as a dated retry.
2. Make sure `book-illustrations-integrate` (or the notice it parked) gets
   promoted and run. Read its PR before merging. Publishing touches the
   publish/`powers` security surface, so use the discretion the maintainer
   gave you about a gauntlet. Once it is merged and published, send the
   maintainer one concise message (`scripts/jobs/message-user.sh <your-base>`)
   with the new edition URL.
3. `book-build-js-retool` is a large generator rewrite, so a gauntlet is
   reasonable. Once it is merged and the book republished from the JS
   generator, send a second concise message saying the retool and the book
   are complete.
4. If work remains when your session must end, post another dated successor
   supervisor with the current, verified state. Scope is
   `kriscendobot/garden-book` only.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T06:11:13Z
