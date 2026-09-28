---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
token-budget: 400000
---
# Fix the foreman's maintainer-note dedup: it's flooding the inbox

Repository: `kriscendobot/garden`, branch `main2` (the garden's own repo —
land direct to `main2`, no PR, per CLAUDE.md's own-repo convention). Work in
an isolated project worktree: `ensure-project-worktree.sh <base>
kriscendobot/garden main2`. Never run git against `$GARDEN_ROOT` itself.

## The bug, observed

`scripts/jobs/foreman.sh`'s `note_milestone_once()` / `notice_signature()`
(around line 184) is supposed to post a milestone/bottleneck notice to the
maintainer inbox **once per distinct substance**, per its own doc comment:
"An unchanged state... posts NOTHING; a genuinely new decision... changes the
signature and fires exactly once." In practice, over roughly 20 hours
(2026-09-27T18:18Z through 2026-09-28T03:28Z) it posted **~30 separate
near-duplicate notices** to `inbox/maintainer/unread/`, all describing the
SAME underlying static state: milestone M2 blocked on a maintainer decision to
run the gauntlet on endojs/endo-but-for-bots#1349 and/or #1356 (both green
drafts that sat unpromoted the whole window — nothing about the real state
changed). Find them yourself:
`git -C journal log --oneline origin/journal2 --since="24 hours ago" -F --grep="from: foreman"`
(each is its own `inbox/maintainer/unread/<timestamp>-<hash>.md` file, not a
coalesced/amended single file — contrast with the reaper's `doom-notice`
family, which DOES coalesce correctly via `notice_count`/`amended` and is the
right model to compare against).

## Root cause (confirmed, verify before changing)

`notice_signature()` extracts `\b[Mm][0-9]+\b|#[0-9]+` tokens from the
generated prose and joins them sorted as the signature. The underlying board
state (which PRs are blocking M2) was static, but the foreman's own `claude
-p` generative step reworded its analysis each tick and did not consistently
mention the SAME subset of PR numbers every time — one pass says "blocked at
#1349", another says "blocked at #1349 and #1356", another leads with #1356
alone. Each distinct combination of mentioned numbers produces a distinct
signature, so genuinely unchanged real-world state still looks "new" to the
dedup every time the prose varies which PR(s) it happens to name.

## What to do

Do not just widen the regex — the real issue is that the signature is derived
from the LLM's own free-form prose (which varies) rather than from the
deterministic board state (which didn't). Consider, and pick what actually
fits `foreman.sh`'s existing structure:

- Deriving the signature from the milestone identifier plus the actual,
  independently-computed set of currently-blocking-and-relevant PRs/decisions
  (something the wrapper can determine deterministically, not scrape from
  prose), so it's stable regardless of how the LLM phrases the same analysis.
- A backstop rate limit (e.g., at most one milestone-notice per N hours per
  milestone) in addition to/instead of pure substance-dedup, mirroring how
  other watchdogs in this codebase coalesce via `notice_count`/`amended`
  rather than posting a fresh file every time.
- Whatever combination you find actually stops the flood without suppressing
  a genuinely new decision point (e.g., M2 becoming blocked on a THIRD,
  different PR should still notify).

## Tests

Extend or add a focused test under `scripts/jobs/test/` covering: identical
underlying state with varying prose/PR-mention-order does NOT re-post; a
genuinely new blocking PR or milestone DOES post. Run the full relevant test
suite, not just your new cases, before reporting done — the garden's own CI
was red for 3 days last week from exactly this kind of untested edge (see the
`fix-garden-ci-gauntlet-retry-viability-tests` job, 2026-09-27); don't repeat
that.

## Also, separately: archive/compact the existing flood

The ~30 already-posted near-duplicate notices are still sitting unread in the
maintainer inbox. Once your fix lands, archive them down to the single most
recent/complete one per distinct milestone-blocker (move the rest to `read/`
or otherwise dispose of them per whatever the inbox skill's normal compaction
mechanics are) so the maintainer's next muster isn't scrolling past 30 copies
of the same ask. Do not lose the underlying signal (M2 needs a gauntlet
decision on #1349/#1356) — one clear copy should remain.

## Report

Confirm before/after: what the old signature would have produced across a few
of the real captured notices (showing why they differed), what your new
mechanism produces for the same inputs (showing they now match), and how many
stale duplicates you archived.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T03:49:22Z
