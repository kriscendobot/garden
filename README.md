# Garden bulletin

_As of 2026-07-06T12:19:24Z_

## Latest

A fable review of the garden's own scripts turned up a data-corruption-class bug in the reaper requeue path (`reaper-requeue-kills-or-waits-for-live-handler`): a job was requeued about every 18 min against a 40-min handler wall without killing the prior handler, twice leaving two live writers in one worktree. It's a main2 infrastructure fix with no bot-repo PR, surfaced to the maintainer for a deliberate fix-and-deploy rather than posted to the board. On the board itself, little moved — the `xs2rust-endor-stage4-generators` child was claimed (stage-4 `classes` child already completed), continuing the XS→Rust (Endor) port. Separately, the `onboarding-p1-launcher` job closed as already-landed: streamlined-onboarding phase 1 shipped 2026-07-04, and its ".garden-file-first identity" design point was deliberately superseded by the newer location-derived identity (`<hostname>-<basename>-<hash8>`) in commits 6d543582e/367a7543c — so that paragraph of the design is now stale and worth annotating as such.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 3d)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 6d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 7d)
- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 10d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 20d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 45d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 45d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 47d)
- [endojs/endo-but-for-bots#329](https://github.com/endojs/endo-but-for-bots/pull/329) — docs: introduce spackle, the polyfill+ponyfill race pattern (waiting 46d)
- [endojs/endo#3073](https://github.com/endojs/endo/pull/3073) — feat(patterns): Add `M.choose` (waiting 54d)

_Showing top 10 of 26 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260706T114016Z-d133d3` — from liaison:follow-up, reply_to `?` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T114016Z-d133d3.md)

> From the fable review of the garden's own scripts (report `fable-review-fix-garden-scripts`): a data-corruption-class bug was found in the reaper requeue path — `reaper-requeue-kills-or-waits-for-live-handler`. The job was requeued roughly every 18 min against a 40-min handler wall while the prior handler was left alive, twice producing two live writers in one worktree (pids/timestamps in the job body). This is a garden-infrastructure fix (main2, no bot-repo PR), so I'm surfacing it rather than posting a board job — it warrants a deliberate fix + deploy. Two lesser items rode along and need no decision: the accepted-but-deferred `watchers-port-fail-floor-to-mention-issue-inbox` fix, and `ci-watcher-test-preexisting-failures` (6/29 failures on a pristine main2 tree, unrelated to that job's changes).

- `20260706T115432Z-634cb5` — from gardener:onboarding-p1-launcher, reply_to `onboarding-p1-launcher` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260706T115432Z-634cb5.md)

> Job onboarding-p1-launcher (streamlined-onboarding phase 1): no changes made — the work is already landed, and the one remaining design point was deliberately superseded. Detail:
>
> Phase 1 landed 2026-07-04 in commit 8fdbd11e0 ("direct-exec launcher, auto-build, guard-hook seed"). Present in current origin/main2:
>   - garden: auto-build (ensure_container), .claude/settings.json seeding with the SessionStart guard hook (seed_claude_settings), `exec claude --dangerously-skip-permissions` on bare enter (cmd_enter), and the `./garden sh` debug-shell subcommand (cmd_sh).
>   - Dockerfile: claude CLI install + `command -v claude` build assertion + /etc/profile.d/garden.sh PATH wiring.
>   - CLAUDE.md § Container guard: the launcher-seeded-hook sentence.
>
> The ONLY job item not present is the design's ".garden-file-first identity". It is absent on purpose: commits 6d543582e and 367a7543c (both 2026-07-06, ~8h before this job was promoted) deleted the .garden file and GARDEN env knob from the launcher, replacing them with LOCATION-derived identity (<hostname>-<basename>-<hash8>), citing two concrete bugs the .garden model caused (the "lost container" strand and journal-worktree corruption) and verifying with two concurrent instances. That newer decision achieves the same user-facing goal the design wanted — bare `./garden` needs zero required env vars — via a different, better mechanism.
>
> Re-adding .garden-first identity per design §1.1 would revert 6d543582e/367a7543c, so I did not. If you DO want .garden naming back (e.g. as sugar layered on top of location-derivation), please re-post with that reconciliation spelled out; otherwise design §1.1's identity paragraph is stale and could be annotated as superseded. Completing the job as already-satisfied.


## Board
### todo (0)
(none)

### doin (4)
- [`garden-pages-0fe25c6e9af6-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/garden-pages-0fe25c6e9af6-shepherd.md) — pages-shepherd (auto: red Pages deploy) on kriskowal/garden
- [`pr-ebfb-286-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/pr-ebfb-286-shepherd.md) — Repo endojs/endo-but-for-bots — shepherd PR #286 (https://github.com/endojs/e...
- [`scholar-ingest-gutentag-remainder`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/scholar-ingest-gutentag-remainder.md) — role: scholar
- [`xs2rust-endor-stage4-generators`](https://github.com/kriskowal/garden/blob/journal2/jobs/doin/xs2rust-endor-stage4-generators.md) — Stage-4 child: generator functions and the iteration protocol closure

### tada (1284)
- [`deadmail-20260706T121417Z-81d784`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/deadmail-20260706T121417Z-81d784.md) — Completion report
- [`endojs-endo-but-for-bots-pr605-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr605-shepherd.md) — Completion report — shepherd on endojs/endo-but-for-bots PR #605
- [`xs2rust-endor-stage4-classes`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/xs2rust-endor-stage4-classes.md) — Completion report — xs2rust-endor-stage4-classes (stage-4 child 2/8)
- [`endojs-endo-but-for-bots-pr442-shepherd`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/endojs-endo-but-for-bots-pr442-shepherd.md) — Completion report
- [`scholar-ingest-gutentag-packages`](https://github.com/kriskowal/garden/blob/journal2/jobs/tada/scholar-ingest-gutentag-packages.md) — Completion report — scholar-ingest-gutentag-packages
- … and 1279 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- [`endojs-endo-but-for-bots-pr132-report-render-mode`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr132-report-render-mode.md) — _normal_ · re-port render-mode toggle onto @endo/space-chat InboxRoot (endojs/endo-but-f...
- [`foreman-budget-cross-host-weekly-token-aggregation`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/foreman-budget-cross-host-weekly-token-aggregation.md) — _normal_ · PLAN: deterministic cross-host weekly token-spend aggregation for the foreman...
- [`synth-and-deploy-minion-town-aws`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/synth-and-deploy-minion-town-aws.md) — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS
- [`verify-ymax0-hex-fix-inquisitor`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/verify-ymax0-hex-fix-inquisitor.md) — _normal_ · PLAN (go-ahead): verify the ymax0 hex fix and stackCount snapshot-compatibili...

### deferred (top by priority; foreman auto-promotes when idle)
- [`scholar-ingest-dialog-db`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-dialog-db.md) — _normal_ · ---
- [`endojs-endo-but-for-bots-pr486-review-69dc0d7a-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr486-review-69dc0d7a-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #486 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr486-review-7da05a5b-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr486-review-7da05a5b-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #486 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr486-review-d14e72bb-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr486-review-d14e72bb-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #486 (primary: endojs-endo-but-f...
- [`endojs-endo-but-for-bots-pr96-review-b474e0ee-retro`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/endojs-endo-but-for-bots-pr96-review-b474e0ee-retro.md) — _low_ · Retrospective on endojs/endo-but-for-bots PR #96 (primary: endojs-endo-but-fo...
- [`scholar-ingest-against-sql`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/scholar-ingest-against-sql.md) — _low_ · ---

### blocked (awaiting an artifact; unblock watcher auto-promotes on completion)
- [`build-daemon-rename-to-manager-phase2`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase2.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/598` · Build: daemon→manager rename Phase 2 (identifier renames)
- [`build-daemon-rename-to-manager-phase3`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/build-daemon-rename-to-manager-phase3.md) — awaiting `build-daemon-rename-to-manager-phase2` · Build: daemon→manager rename Phase 3 (consumer sweep + CHANGELOG + docs)
- [`port-xs-to-rust-memory-safe-engine-s9`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/port-xs-to-rust-memory-safe-engine-s9.md) — awaiting `xs2rust-endor-build-stage4` · Fable supervisor: drive the XS→Rust (Endor) port from design to maintainer-re...
- [`resume-lint-ceiling-shepherds`](https://github.com/kriskowal/garden/blob/journal2/jobs/plan/resume-lint-ceiling-shepherds.md) — awaiting `https://github.com/endojs/endo-but-for-bots/pull/594` · Resume shepherds for PRs blocked by the endo-but-for-bots lint projectService...

## Watch set
(none)

## Hosts
- [endolin-garden-ece02cb4](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden-ece02cb4): 20 gardeners
- [endolin-garden2-5bcdff64](https://github.com/kriskowal/garden/blob/journal2/hosts/endolin-garden2-5bcdff64): 20 gardeners
