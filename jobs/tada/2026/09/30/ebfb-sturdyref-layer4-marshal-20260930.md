## Layer 4 (marshal representation): done, draft PR endojs/endo-but-for-bots#1393

Every marshal encoding can now carry a SturdyRef and decode it back. It passes all local checks; CI was not watched, and the PR stays a draft.

**Where it sits in the stack:** the new branch `build/sturdyref-marshal-representation` is stacked on layer 3 (#1392). Its PR base is a frozen snapshot of layer 3's head, `build/sturdyref-pass-style-recognition-fa2edee`, the same way layer 3 froze layer 2. There are two commits: the feature, and a separate `chore: Update yarn.lock`. The PR body links the arc (kriscendobot/garden#47) and #695, and has the "## Stack index" section.

**What changed:** following the layer-1 design's forward sketch, a SturdyRef takes up a slot just as a remotable or promise does. The difference is that its encoding says what kind of slot it is, so the decoder can check it really got a SturdyRef back.

| Encoding | SturdyRef representation |
| --- | --- |
| capdata | `{"@qclass":"sturdyRef","index":N}` (an `iface` field is rejected) |
| smallcaps | `"'N"`: `'` was a reserved prefix, and the cheatsheet and doc comment are updated |
| encodePassable | prefix `t`, via new `encodeSturdyRef` / `decodeSturdyRef` options |
| rank order | its own category after strings and before `null`; all SturdyRefs rank equal |
| marshal-justin | `sturdyRef(N)`, or `sturdyRefToVal(slot)` when slots are given |
| dot-membrane | the far side gets a new SturdyRef that enlivens the original across the membrane, and it stops working once the membrane is revoked |

- The byte codecs (`@endo/cbor`, `@endo/syrup-frame`) have no notion of passables or slots, so they needed nothing.
- `@endo/ocapn`'s existing sturdyref and its consumers are untouched; its 559 tests pass.
- **Type decision layer 3 left to this layer:** `Passable` now includes `SturdyRef`, but `PassableCap` does not. The slot-converter types widen to `PassableCap | SturdyRef`.
- There is a changeset with minor bumps for `@endo/marshal` and `@endo/pass-style`.

**Tests:** the new `packages/marshal/test/sturdyref.test.js` has 13 tests. They use the real shim and a test handler to check:
- round trips in capdata and smallcaps, ending with `SturdyRef.enliven` on the decoded ref;
- sharing the slot table with remotables and promises;
- rejection of forged or mismatched slots;
- Justin output;
- encodePassable in both formats;
- rank placement;
- the membrane, including revocation.

**Local verification:**
- Test suites under all ses-ava configs: marshal 109 passed (1 skip that was already there), pass-style passed, patterns 699 passed, ocapn 559 passed.
- Type check clean for pass-style, marshal, patterns, captp, ocapn, far, exo and daemon.
- eslint: 0 errors; prettier clean.

**One test snapshot changed:** adding the new category changes the patterns `rankCover` "static ranks" snapshot. Re-recording it normally writes a `.snap` file that can't be read back, because of the known snapshot bug fixed by the still-open ebfb#1334. I recorded it with that fix patched temporarily into the local ava install, then restored the original. The new snapshot passes under unpatched ava.

**Follow-ups:**
- Because all SturdyRefs rank equal, they can't be told apart in a full order. Whether they should get full-order handling like remotables is a patterns question, left open in the PR.
- #1392's stack index still says layer 4 is "not yet opened", and the arc's stack-index comment hasn't been updated to list #1393.
- Layer 3's changeset still says marshal "cannot yet encode a SturdyRef", which this layer makes out of date.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (5441482 cached reads)
- Output: 36126 tokens
- Cost: $2.789632400000001
- Wall-clock: 558s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
