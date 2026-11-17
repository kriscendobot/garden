# Gauntlet fix round 1: endojs/endo-but-for-bots#1670

I applied every pre-pass finding and pushed the fix to the PR head, and CI is green: 36 checks, 0 failed. The first CI run went red on a flaky test outside this change, and a rerun of the failed jobs passed.

**Changes** (two commits on `build/endopi-jsonl-transcript-lal`, 051dfe7bdd → 780bc28057, pushed with `safe-push-pr-head.sh`):
- `37e9fb5a3f refactor(lal): use @endo/utf8 and @endo/hex; spell out identifiers`
  - **prefer-endo-primitives:** in `transcript.js`, `TextEncoder`/`TextDecoder` are replaced with `encodeUtf8`/`decodeUtf8` from `@endo/utf8`, and the byte-to-hex loop is replaced with `encodeHex` from `@endo/hex`. The probe suggested `@endo/bytes`, but that package has no UTF-8 codec, so I used `@endo/utf8`. Both packages are now dependencies in `packages/lal/package.json`, and the composite tsconfig was regenerated with `generate-composite-tsconfigs.mjs`.
  - **spell-out-identifiers:** local names renamed:
    - `ms` → `milliseconds`, `i` → `index`
    - `makeId`, `guestId`, `lastId`, `sessionId`, `parentId`, `id` → the `…Identifier` forms
    - in `agent.js`: `msg` → `inboundMessage`, `formMessageId` → `formMessageIdentifier`, `workerP` → `workerPromise`
    - the internal mail shape's `messageId` → `messageIdentifier` (in `agent.js`, `inbox-loop.js` and the test)
  - **Left unchanged on purpose:** names that are on-disk or external API keys:
    - the Pi JSONL format's `id`, `parentId` and `sessionId`
    - `sessionFileName` and `writeHeader` options from `@endo/jsonl-transcript`
    - the header field `endo:guestId` and the `messageId` key in `endo:mail` entries
    - the daemon message fields `inboundMessage.messageId`, `.replyTo` and `.valueId`

    The spelling probe will likely still flag these in panel-2. The test's `n` hit is the `'\n'` escape, which is a false positive.
  - **Pruner advisory** (`agent.js:229`): I kept the comment. It says that worker sub-guests are never given the writable transcripts mount, which you can't tell from the code next to it.
- `780bc28057 chore: Update yarn.lock`: the two new workspace dependencies only.

**Verification:**
- Local: the full lal suite passed (203 tests). eslint on the changed files gave 0 errors, and prettier has been applied.
- CI: the first run had 3 red checks (`test (22.x, ubuntu-latest)`, `cover (22.x, ubuntu-latest)`, `sandbox-drivers`). All three failed on the same timing test in `packages/sandbox`, `bwrap timeout and repeated cancellation reap process groups`, which this diff doesn't touch; the previous head was green. I reran only the failed jobs, they passed, and `ci-wait-merge.sh` returned rc 0.

**Follow-ups:**
- The `bwrap` reap test in `packages/sandbox` is flaky on CI. It isn't caused by this PR.
- Panel-2 may need to accept the Pi-format and daemon keys listed above as exempt from the spelling rule.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1670-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (3953807 cached reads)
- Output: 15068 tokens
- Cost: $1.8493054000000002
- Wall-clock: 7303s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
