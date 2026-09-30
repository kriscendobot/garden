I opened layer 7 as draft endojs/endo-but-for-bots#1397. It is stacked on layer 6 (#1396) and now includes a fix for one real bug that the new tests found.

**What was already there.** The enliven path the job describes was mostly in place from layers 5 and 6. Remote refs call `fetch(swissnum)` on the peer's bootstrap and connect on demand using the hints in the ref's location. Refs that name the local client go to its own nonce locator. So this layer is mainly end-to-end tests, plus the fix.

**The bug.** A SturdyRef read off the wire keeps its secret as raw bytes. When such a ref names the local client, the home path handed those raw bytes to the locator. So a ref minted here with a string secret, sent to a peer, and received back failed with "locator has no capability". The new home round-trip test failed on this before the fix.

**The fix.** The home path now looks up the secret the same way the bootstrap `fetch` does: ASCII-decode it if possible, otherwise use the raw bytes. That lookup is a new helper, `lookupSwissnum`, in `packages/ocapn/src/client/sturdyrefs.js`. I left the decoded-secret format as bytes, because the codec tests expect bytes and the thixotrope and goblin-chat packages use that format.

**New tests** (`packages/ocapn/test/sturdyref-enliven.test.js`), two clients over the TCP test netlayer:
- A ref received over the wire enlivens remotely through the peer's bootstrap.
- A ref that goes out and comes back home enlivens from the nonce locator to the original object.
- Non-ASCII secret bytes survive the remote, home and back-again trips.
- A ref built from data (layer 6) opens a session on demand through its hints; a second enliven reuses the session and reaches the same object.
- A peer can enliven a ref it received on the sender's behalf.
- Unknown secrets are rejected, remotely and at home, without the secret appearing in the error.

**Local results:** ocapn 570 passed (564 existing plus 6 new), thixotrope 103 passed with 3 skips that need an XS build, goblin-chat 4 passed. Type checking and prettier are clean, and eslint reports no errors. Its one warning, `safe-await-separator` in `enlivenSturdyRefDetails`, was already there before this change. CI has not been checked.

**Git and the arc:**
- **Commit:** `f212191840` on the new branch `build/sturdyref-ocapn-enliven`, with a patch changeset for `@endo/ocapn`.
- **Base:** I froze layer 6's head as `build/sturdyref-captp-construct-ef45f1d` and used that as the PR base.
- **PR:** opened as a draft through `ensure-pr.sh`, with the garden-job marker, links to kriscendobot/garden#47 and #695, and a stack index.
- **Arc:** posted a stack-index update on kriscendobot/garden#47: https://github.com/kriscendobot/garden/issues/47#issuecomment-5906834955
- **Garden repo:** no changes, so nothing was pushed to main2.
- **Inbox:** empty.

**Follow-up:** layer 8 (daemon formula SturdyRef) should stack on `build/sturdyref-ocapn-enliven`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer7-ocapn-enliven-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2755323 cached reads)
- Output: 25027 tokens
- Cost: $1.9359165999999994
- Wall-clock: 472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
