CI is green: 19 SUCCESS, 15 SKIPPED, 0 failing, 0 pending, all on my pushed head `f4566ca9f`. The fix stage is complete.

## Completion report

**Job:** Gauntlet FIX round 3 for endojs/endo-but-for-bots PR #1125 (guest-owned invitation primitive).

**Panel-3 must-fix items applied** (head `cda861b2` → `f4566ca9`, three review-feedback follow-up commits on `kriscendobot:bot/build/endo-guest-invite-primitive`):

1. **accept() atomicity (#1)** — `manager.js`: the single-use consume (guestName rebind + controller cancel) previously ran *before* peer registration and `formulateGuest`, so a post-consume failure stranded a spent, half-configured invitation. Restructured the whole of `accept` into one `invitationJobs` critical section: check first → all fallible work → consume **last**. A mid-flight failure now leaves the invitation redeemable; serialization still blocks concurrent/replayed accepts.
2. **Type honesty + legacy fallback (#4, typist)** — `types.d.ts`: made `invitingAgent`/`invitingHandle` optional with the deprecated `hostAgent`/`hostHandle` documented as the coerced fallback. `manager.js` `extractLabeledDeps` now applies the same fallback so legacy invitations' graph edges don't vanish. Read-sites coerce+cast; U+2192 arrows in the new comments replaced with ASCII `->`.
3. **Rename sweep (#6)** — `makeInvitation`'s `locate` locals `hostHandleNumber/Node` → `invitingHandleNumber/Node`; also corrected the PR description's atomicity bullet (it still said "consumes … before any externally visible side effect").
4. **Docs (#7)** — `MULTIPLAYER.md` Connection Lifecycle reworded from host-issued to inviter/inviting-handle framing.
5. **Test coverage (#2, #3, #5)** — the two #1125 integration tests no longer look the responder up before the post-gap send (which masked the feature); the responder is now retained in the guest's pin directory so delivery auto-reincarnates it. **Verified locally**: both pass with the reincarnation call and *hang* without it (the break-it check). Added a `mail-pins.test.js` failure-tolerance test (a throwing pin must not reject delivery, siblings still re-warmed). Renamed abbreviated identifiers (`nets`→`networks`, `ack`→`acknowledgement`).

**Verification:** daemon `yarn lint` (0 errors), root `tsc -p tsconfig.json` (0 errors), `mail-pins.test.js` (4/4), `invite-retention.test.js` (13/13 — concurrent/superseded/cancel/guest-mint accept paths), `provideGuest` tests (8/8), and both #1125 integration tests all pass locally.

**CI:** terminal green on head `f4566ca9f` — 19 SUCCESS, 15 SKIPPED, 0 failing.

**Notes/follow-ups:** Several panel-3 sub-items under finding #3 (concurrent accept, superseded, all four pins/networks validation paths) were already covered by an earlier commit and left intact. The pre-existing-guest-without-pin-directories fallback at accept() time remains impractical to construct as an integration test (requires a legacy guest formula minted before pin directories existed). The maintainer's separate request (Chat-diagnostics follow-through + a retcon) is outside this fix stage's scope.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 242 tokens (16789367 cached reads)
- Output: 85836 tokens
- Cost: $12.576057500000001
- Wall-clock: 1730s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
