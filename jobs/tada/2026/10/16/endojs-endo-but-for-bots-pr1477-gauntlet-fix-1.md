## Fix round 1 for endojs/endo-but-for-bots#1477: done, CI green (35 checks, 0 failed)

I applied the panel-1 must-fix items, pushed two follow-up commits to `feat/ocapn-np-identity-location-id` with `safe-push-pr-head.sh` (7f52fa6ee9 → 0c45074754 → 295c136e65), and trimmed the PR body.

**Panel items:**
- **coverage-auditor:** added the test `websocket netlayer rejects a peer on another network` to `packages/ocapn/test/netlayer-websocket.test.js`. It hits the new `Unsupported network` throw in `connect` twice: once with `network: 'np'`, and once with the legacy `transport: 'tcp-testing-only'` and no `network`.
- **typist:** no code change needed. In the `OcapnLocation` typedef (`src/codecs/components.js:30`), `transport` is a required `string`, `network` is an optional `string`, and `hints` is `false | Record`. So `Pick<…>` with `@returns {string}` is correct, and the test helper's literal fits the type. The package's `tsc` passes clean.
- **pruner:**
  - Removed the duplicate paragraph from the `locationToLocationId` JSDoc.
  - Cut the migration story from the `locationNetworkId` JSDoc, keeping the `network ?? transport` rule and the "not a byte carrier" line.
  - Deleted the comment that restated the template literal.
  - Trimmed the PR body: removed the bullets that walk through the diff, the test counts, and the Scaling/Docs/Upgrade sections. The Security section stays.
- **changeset-auditor:** the changeset now has one sentence per line. It keeps the bump at `minor` and gives the reason: only `np` location IDs change, and they are in-memory session keys that are never saved. It also says `locationNetworkId` is public, since it's exported through `@endo/ocapn/client/util`. I dropped the internal WebSocket-netlayer sentence.

**Local checks** (run in `packages/ocapn` using tool shims): `ses-ava` passed `location-id` and `netlayer-websocket` under all three configs, `tsc` reported no errors, eslint found no errors in the touched files, and prettier is clean.

**CI:** a single 3600s wait was cut off by my 10-minute background limit, so I ran `ci-wait-merge.sh --no-merge` again as three shorter foreground waits. The first two timed out with jobs still pending (rc 4); the third ended green (rc 0).

**Follow-ups:** none. The driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1477-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1986927 cached reads)
- Output: 10991 tokens
- Cost: $1.2115334
- Wall-clock: 2139s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
