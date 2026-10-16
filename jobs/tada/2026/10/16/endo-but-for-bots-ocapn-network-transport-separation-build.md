---
handed-off: endo-but-for-bots-ocapn-network-transport-separation-open-pr
deliverable-complete: false
---
I built the increment, tested it, and pushed it, but the draft PR isn't open yet. This host's bot token is refused PR creation on endojs (403 on `createPullRequest`), so I handed that one step to a successor job.

**Where the job stood:** no prior PR existed, and no earlier attempt had left commits. In `packages/ocapn`, `OcapnLocation` already had the optional `network` field. The missing piece was step 4 of the design's migration plan: the `.np` session key should be `(network, designator)`, but `locationToLocationId` still used `transport` and folded the hints into the ID.

**What changed** (branch `feat/ocapn-np-identity-location-id`, commit `7f52fa6ee`, based on the frozen `llm-61cd656`, which is the current `llm` tip):
- **New helper:** `locationNetworkId(location)`, meaning `network ?? transport`, in `packages/ocapn/src/client/util.js`. `locationToLocationId` and the network checks in both older netlayers (`tcp-test-only.js`, `websocket.js`) now use it.
- **`.np` IDs ignore hints:** a `.np` location ID is now `ocapn://<designator>.np`. One authenticated Noise peer keeps one location ID, and so one session, even as its listeners bind, rebind or close. The older netlayers keep their current IDs with sorted hints.
- **WebSocket netlayer:** its location now declares `network: 'websocket'` next to the old `transport` field.
- **Tests and changeset:** a new `packages/ocapn/test/location-id.test.js` with 5 tests, plus a `minor` changeset.

**Tests:** `packages/ocapn` `yarn test` passed 564 tests, including the API-surface snapshot; the 5 new tests passed in a separate run. `yarn lint` reported 0 errors; its warnings are not in lines this change adds. `packages/ocapn-noise` `yarn test` passed 78 tests.

**Handoff:** I posted `endo-but-for-bots-ocapn-network-transport-separation-open-pr`, pinned to `endolin-garden-ece02cb4`. Its only task is to run `ensure-pr.sh` under this job's base, with the PR body included, so the PR is tagged with this job's marker.

**Follow-ups:** the `@endo/ocapn-noise` steps come next: splitting `addTransport` from `listen`, `<transport>+<codec>` hint keys, a `tcp+cbor` transport, and listener handles. The end-to-end test that reuses a session after rebinding belongs with that work.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-network-transport-separation-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 70 tokens (2415421 cached reads)
- Output: 17501 tokens
- Cost: $1.7953042
- Wall-clock: 732s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
