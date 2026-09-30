Layer 6 is up as draft PR endojs/endo-but-for-bots#1396, and the captp, ocapn and thixotrope test suites pass locally. CI results were not checked.

**The PR**
- Title: "feat(captp,ocapn): layer 6 — construct a SturdyRef from its data".
- Branch `build/sturdyref-captp-construct` at `ef45f1dc0a`. It is one feature commit that includes the changeset.
- Its base is layer 5's head (#1394, `dc0027bf5f`), which I froze and pushed as the new branch `build/sturdyref-captp-wire-dc0027b`.
- The body links #695 and garden#47 and has the "## Stack index": layers 1–5 are #774 (design #1389), #1391, #1392, #1393 and #1394; this PR is layer 6; layers 7–9 are not yet opened.
- It was opened through `ensure-pr.sh` and carries this job's marker. I also posted a stack-index update on garden#47.

**What it adds**
- **`@endo/captp`:** `makeCapTP` now also returns `makeSturdyRefFromData({peerId, objectId, designator?, hints?})` and `getSturdyRefData(ref)`.
  - The data is checked when the ref is built: the key set, the value types, and, when the new `peerId` option is set, that the data names that peer.
  - Enlivening one of these refs asks the peer to `locate(objectId)` over the connection, through a new `l-0` target. The peer answers only through a new `locateSturdyRef` option, and rejects when that option is absent. Enlivening also rejects after the connection is aborted.
- **`@endo/ocapn`:** the client gains the same two methods. They translate the fields into OCapN's `(location, secret)`: `peerId` becomes the designator, `objectId` the swiss number (string or bytes), `designator` the transport, and `hints` the hints. The result is an ordinary OCapN SturdyRef, so the wire codec writes it and it enlivens through the client. Enlivening through the OCapN bootstrap is left to layer 7.
- Both capabilities belong only to whoever created the CapTP or client. Neither is reachable from a peer, from a SturdyRef, or through a global.
- **Tests:** new cases in both packages' `test/sturdyref.test.js`. I updated the ocapn `api-surface` snapshot `.md` by hand, as layer 5 did.

**Local results**
- **Tests:** captp 44 passed, ocapn 564 passed, thixotrope 103 passed.
- **Checks:** `lint:types` is clean for captp and ocapn, eslint reports 0 errors on the touched files, and prettier is clean.
- **Flaky gc test:** captp's `gc › test loopback gc` failed once in a full-suite run. It passed on its own and in the next full run.
- **Root type-check not run:** I did not run the repo-root `tsc -p tsconfig.json` check, which CI runs and the per-package check can miss.

**For review**
- **Wire change:** the new `l` target is a CapTP wire change. A peer running older code should fail the request, so the enliven rejects.
- **Data shape:** layer 8 (the daemon) will store refs in this four-field shape, so it is worth settling now.
- **Secret exposure:** `getSturdyRefData` on the OCapN client returns the secret.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer6-captp-construct-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2290439 cached reads)
- Output: 24654 tokens
- Cost: $1.7141598000000002
- Wall-clock: 364s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
