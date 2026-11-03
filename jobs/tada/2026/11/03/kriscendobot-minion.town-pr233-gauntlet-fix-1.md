**FIX round 1, PR #233:** all pre-pass findings are fixed and pushed as `485bf557` (a follow-up on `7f5202ec`, no history rewrite), and CI is green.

**CI visibility:** `ci-wait-merge.sh` returned rc 0 with 1 run and 0 failed. The bot token can't read `statusCheckRollup`, so it fell back to the Actions runs API, which doesn't show commit statuses or non-Actions check runs.

**Findings applied**
- **`prefer-endo-primitives`:** `src/web/local-invitations.ts` now has the `prefer-endo-primitives-exempt` marker on line 1. The justification is the one its sibling `guest-web-socket-service.ts` uses, and I confirmed it: `npm view @endo/sha256` returns 404.
- **`spell-out-identifiers` in `src/endo/guest-tools.ts`:** `ok` and `okJson` are now `success` and `successJson` at every call site in the file. This touches about 30 existing lines because the probe flagged the helper names. I left the `"ok with text"` wording in the `infer` tool description, since it names a tagged result.
- **`spell-out-identifiers` in `test/endo-invite-tools.test.ts`:** `c` is now `clientTransport` in the transport pair and `item` in the `textOf` callback. `s` wasn't flagged, but I renamed it to `serverTransport` so the pair reads consistently.

**Advisory, no change:** the pruner flagged the comment at `src/endo/guest-control.ts:146`. I kept it because it records that the locator is a one-time bearer secret that is never logged, and the adjacent code doesn't show that.

**Verification**
- Both failing probes now pass against `origin/main-c5c3504...HEAD`.
- `tsc --noEmit` reported no errors.
- 24 tests pass across the invite tools, local invitations, clip tools and guest HTTP test files. I ran only those four files locally, not the full suite.

**Follow-ups, left out of this round's scope**
- `src/endo/guest-tools.ts` still has the British spelling `cancelled` in the new `cancelInvite` code, while the same file's `infer` description uses `canceled`. Panel 2 may flag it.
- The comment above `successJson` cites `designs/clip-gateway.md` § 7.1, but that file isn't in this repo. The citation predates this PR, and my rename changed its `ok(...)` to `success(...)`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr233-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (313803 cached reads)
- Output: 5454 tokens
- Cost: $0.6712246
- Wall-clock: 539s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
