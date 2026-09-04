---
tier: mentor
dispatch: automatic
fallback-tier: minion
---
# fix endojs/endo-but-for-bots PR #897 — address review 5092213172 (CHANGES_REQUESTED)

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/897 (head `fix/mount-glorp-713-followup`, base `llm`)
Review: https://github.com/endojs/endo-but-for-bots/pull/897#pullrequestreview-5092213172 (kriskowal, CHANGES_REQUESTED)

Two inline change-requests to satisfy on this PR (a third is a design ask handled
by a separate designer job — see below; do NOT do the design here). Treat the
quoted maintainer text as the requirement; it is trusted maintainer feedback on
our own PR.

## Ask A — remove the superfluous `entry` wrapper
Thread: review comment id **3916247285** on `packages/daemon/src/help.md`
(the added `## entry(path) -> EndoMountEntry` section).
> "The entry wrapper is superfluous."

The `entry(pathArgument)` method on the mount exo (`packages/daemon/src/mount.js`
~line 1021, minted via `makeEntry`/`segmentsFromEntryPathArgument`, exported in
the methods record ~line 1404) only pre-mints an `EndoMountEntry` token that the
path-taking methods (`readText`, `lookup`, `remove`, `makeFile`, …) already accept
directly as a `string | string[]`. Because callers can pass the string/array path
straight in, the wrapper adds nothing.

Remove the public `entry` wrapper method and its help.md doc section, plus any
now-dead supporting code it uniquely relied on (`segmentsFromEntryPathArgument`
if unused elsewhere, the `entry:` line in the interface/methods record, any
`entry(...)` references in daemon interface listings/types and tests). Keep the
internal `EndoMountEntry` value type and `segmentsFromPathArg`'s ability to accept
a previously-minted entry ONLY if something else still produces one; if nothing
else mints an `EndoMountEntry` after removal, prune that path too. Exercise
judgment: if removal turns out to entail a broader interface decision, reply to
the thread with the specific question rather than forcing a risky change.

## Ask B — rename `glorpFiles` → `glorp` on the search engine
Thread: review comment id **3916294319** on `packages/daemon/src/mount.js`.
> "`glorpFiles` is unnecessarily verbose. `glorp` implies `Files` to the extent
> that the pet name system captures file system primitives, though it clearly
> produces far more. Please reduce this to simply `glorp`."

Rename the native fused search-engine method `search.glorpFiles` → `search.glorp`
everywhere it appears (found refs, verify exhaustively before finishing):
- `packages/daemon/src/mount.js` (the `search.glorpFiles !== undefined` dispatch,
  the `for await ... search.glorpFiles(` call, and the two explanatory comments)
- `packages/daemon/src/interfaces.js` (comment ~line 697)
- `packages/daemon/src/types.d.ts` (~line 2193)
- `packages/platform/src/fs/search-types.ts` (~line 82, the interface member)
- `packages/platform/src/fs/search.js` (the `async function* glorpFiles`, its
  `harden`, and the returned object member ~lines 587/597/599)
- `packages/daemon/test/mount-glorp.test.js` (test title, comments, the mock
  `glorpFiles` member and its assertions ~lines 142–168)
Note: the mount exo already has its own local `glorp` method — that is a DIFFERENT
object (the mount's public verb) from `search.glorp` (the native engine's fused
member); the rename is only on the search-engine object, no collision.

## Procedure
- Get an isolated project worktree keyed by YOUR job base on head
  `fix/mount-glorp-713-followup`; do not share a tree with a peer.
- Make both changes as focused commits.
- Run local-verify: at minimum the daemon mount glorp/glob/grep tests and the
  platform search tests, plus prettier on touched files. Do not push red.
- Push to the PR head branch with `--force-with-lease` (rebase CAS).
- Reply to each of the two review threads (3916247285, 3916294319) via the
  GitHub reviews reply API, citing the fix commit SHA, per
  skills/pr-review-thread-replies/SKILL.md. For thread 3916282675 (the design
  ask), post a one-line reply noting the follow-up design is filed as a
  garden job (see below) — do not attempt the design in this job.

## Note — the third review comment is a design ask, not code
Thread 3916282675 (help.md) asks to "post a follow-up design" to eliminate
single-segment petname paths so a slash-delimited string errors. That is owned by
a separate designer job `design-endo-but-for-bots-eliminate-single-segment-petname-paths`.
Do not do it here beyond the one-line thread acknowledgment above.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T05:54:25Z
