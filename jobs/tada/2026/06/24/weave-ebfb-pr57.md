Weave job `weave-ebfb-pr57` (rebase endo-but-for-bots #57 onto #475): **not completed — premise conflict surfaced and escalated, no push made.**

**What I did**
- Confirmed PR states: #57 (`kriskowal-marshal-binary` @ `2c8c2bfb`, base `master`, CONFLICTING) and #475 (`feat/narrow-bytearray-to-uint8` @ `b2e71216`, OPEN, MERGEABLE — still in-flight). #57 is 4 commits ahead of an old merge-base and 158 behind master; #475 is built on a much newer master.
- Created a detached bot-identity worktree at #57's head and ran `git rebase b2e712164…` (onto #475's current head).
- Got conflicts in `packages/pass-style/src/byteArray.js`, `packages/pass-style/package.json`, and `yarn.lock`.

**Why I stopped (weaver→fixer escalation, per the role's no-redesign norm)**
The conflict is a superseded-premise conflict, not a mechanical one:
- #57 models a `byteArray` as an **immutable ArrayBuffer** and adds `byteArrayToHex`/`hexToByteArray`/`byteArrayToUint8Array`/`uint8ArrayToByteArray` to `@endo/pass-style`, wiring the marshal capdata/smallcaps/encode-passable/justin codecs to that ArrayBuffer model.
- #475 **deliberately removes that representation**: `byteArray` is now a plain frozen `Uint8Array`, raw immutable ArrayBuffers are *rejected* as `byteArray`, and `toBytes`/`fromBytes` were renamed to `frozenBytes`/`thawnBytes`. #475 does **not** define #57's helpers.
- `confirmCanBeValid` collides head-on (`candidate instanceof ArrayBuffer && candidate.immutable` vs #475's `confirmCanBeByteArray` Uint8Array check); package.json collides (`@endo/immutable-arraybuffer`+`@endo/utf8` vs `@endo/hex`). #57's marshal codecs import helpers that exist only in #57's obsolete-model `byteArray.js`.

Forcing a textual resolution would re-introduce exactly the representation #475 just removed. Re-expressing #57's codec admission against the Uint8Array model is a redesign, which the weaver does not do on the fly. I aborted the rebase (`git rebase --abort`), removed the worktree, and left #57 untouched at `2c8c2bfb`. **No force-push, no PR comment** (I won't post a "confirming reply" for a rebase I didn't land, and the job didn't authorize a blocker comment).

**Follow-ups (escalated to the maintainer inbox via the liaison, reply_to `weave-ebfb-pr57`)**
- Dispatch a **fixer/builder** to port #57's codec-admission core onto #475's Uint8Array `byteArray` model (drop the now-superseded helpers, retarget validation and the `byteArray.test.js` fixtures), **or** get a maintainer call on whether #57's core should fold into #475's line instead.
- #57 remains stacked-but-unrebased on #475; #475 is itself still unmerged, so even a clean port stays stacked until #475 lands.

Self-improvement: the weaver "rebase #N on #M" job shape should note up front that when #N and #M are competing representations of the same pass-style (not a true parent/child stack), the correct outcome is a fixer escalation, not a force-push — worth a one-line hint in the weaver role or the conflict-resolution skill. Nothing landed this run (subagent can't commit role/skill changes).
