## Gauntlet fix round 4: endojs/endo-but-for-bots#1388 (OCapN over Cloudflare RPC and Cap'n Web)

The panel-4 must-fix items are fixed and pushed, and CI is green: `ci-wait-merge.sh` returned rc 0, with all 28 checks passing and none failing.

**Commit:** `d93e36ebeb`, "design(ocapn): address cloudflare netlayer panel round 4". It was pushed as a follow-up commit with `safe-push-pr-head.sh`, moving the head from `b027ff77e9` to `d93e36ebeb`. The only file changed is `designs/ocapn-cloudflare-netlayer.md`.

**The pedant's must-fix items (the request-changes verdict):**
- Every source-file reference now uses its full path from the repository root. That covers `packages/ocapn/src/client/{handshake,sturdyrefs,index,ocapn}.js`, `netlayers/websocket.js`, `cryptography.js`, `codecs/operations.js` and the `packages/ocapn/test/` suites.
- Code from other packages now names its package: `init:peer-auth` is in the Goblins-compatible WebSocket netlayer in `@endo/ocapn`, and `exchangeIdentity` is in `packages/ocapn-noise/src/network.js`.
- The bare "ebfb#806" is now a full link to the pull request.

**Should-fix items from the other seats, also applied:**
- **Ergonomist:**
  - `CloudflareNetworkOptions` is now a discriminated union, so a caller must pass exactly one of `port` or `bindings`.
  - `CarrierBindings` now has a defined shape.
  - `idleProbe` is renamed to `idleProbeInterval` throughout.
- **Critic:**
  - The document now says `maxPendingOpens` limits cost but does not prevent starvation. An internet-reachable Durable Object with no supervisor must sit behind a Worker that rate-limits each source. This is added to Known Gaps.
  - The ordering claim is now limited to Durable Object stubs, where it was verified.
- **Skeptic:**
  - Verification item 1 is downgraded to a hypothesis for the types the platform docs don't list.
  - Each `ping` now has its own timeout, because it is unverified whether a call to a vanished peer rejects or hangs. This is added to Known Gaps.
  - The test plan now includes "an idle session sends no `ping`" and "a `ping` that never settles times out".
  - Refusing `dial` is now stated to affect only new sessions, with a note on how the supervisor cuts off sessions that are already open.
- **Copyeditor:** reworded the definition of a DO facet and the sentence about the initiator not trusting the reply.
- **Novice:** added forward pointers to the Cloudflare vocabulary section, to the codec-generalization subsection and to `OcapnPort`.

**Left as is:**
- Two em-dashes remain: one inside a quotation from source code, the other in the prompt attribution.
- These comment-only suggestions were not applied: the copyeditor's "On E-ordering" wording (the paragraph was rewritten anyway), and the novice's point that the sketch's "(verify)" markers aren't reproduced in the document.

**Next step:** the gauntlet driver posts the panel-5 round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1150552 cached reads)
- Output: 9198 tokens
- Cost: $1.0677584000000002
- Wall-clock: 1029s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
