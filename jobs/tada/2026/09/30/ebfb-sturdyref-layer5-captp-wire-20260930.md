Layer 5 is open as draft PR endojs/endo-but-for-bots#1394 (https://github.com/endojs/endo-but-for-bots/pull/1394). Both CapTP layers now mint `SturdyRef`s and carry them over the wire, and `@endo/ocapn`'s existing sturdyref now runs on the `SturdyRef` global. All local tests pass.

**Branch and base**
- Head is `build/sturdyref-captp-wire` (`dc0027bf5f`).
- Base is `build/sturdyref-marshal-representation-f404dbc`, a frozen snapshot of layer 4's head (#1393). I pushed it for this PR.
- There are two commits: the feature, then a separate `chore: Update yarn.lock`.
- I kept it as one PR rather than two. The CapTP change is about 40 lines, so a split didn't seem worth a tenth stack entry.

**@endo/captp**
- A `SturdyRef` is exported under a new `s+N` slot kind.
- The importer mints its own `SturdyRef`. Calling `SturdyRef.enliven` on it asks the exporter, which enlivens its original ref and returns the live result. The exporter answers only `enliven` on that slot.
- Passing the imported ref back yields the original, and repeated imports give the same ref.
- These refs only work while the connection is up: enlivening fails after an abort. Refs that survive the connection are layer 6's job.
- New tests are in `test/sturdyref.test.js`.

**@endo/ocapn (replaces the version already on `llm`)**
- `makeSturdyRef` now returns a real `SturdyRef` instead of a `makeTagged('ocapn-sturdyref')` record.
- The `sturdyRefDetails` WeakMap stays as a private table of each ref's location and secret, because the wire codec has to read them back.
- Each ref is tied to the client that minted it, so `SturdyRef.enliven(ref)` and `client.enlivenSturdyRef(ref)` give the same result.
- `ocapnPassStyleOf` maps pass-style's `'sturdyRef'` to OCapN's `'sturdyref'`.
- The wire format (`codecs/descriptors.js`) is unchanged. The codec now refuses to write a `SturdyRef` that OCapN didn't mint; that case belongs to layers 6 and 7.

**Other packages**
- `thixotrope` `test/hub.test.js` now checks for `[object SturdyRef]`.
- `goblin-chat` needed no change because it only uses client APIs that didn't change. Its tests pass.

**Visible behaviour change:** `passStyleOf` on an OCapN sturdyref now returns `'sturdyRef'` instead of `'tagged'`. The PR flags this, along with the new `s` slot as a CapTP wire format, as the main things to review.

**Checks run locally**
- captp: 41 passed
- ocapn: 562 passed
- thixotrope: 103 passed, 3 skipped because the XS builds aren't present
- goblin-chat: 4 passed
- `lint:types` is clean for captp, ocapn and thixotrope. eslint reports 0 errors on the touched files, and prettier is clean.
- I edited the ocapn `api-surface` snapshot `.md` by hand. Updating it through ava writes an unreadable `.snap` because of the known bug fixed in #1334.

**Housekeeping**
- A changeset is included (minor bumps for `@endo/captp` and `@endo/ocapn`, which now depend on `@endo/sturdyref`).
- I posted a stack-index update on the arc: https://github.com/kriscendobot/garden/issues/47#issuecomment-5906544413
- GitHub API rate limiting delayed opening the PR by about 15 minutes.

**For layer 6:** stack on `build/sturdyref-captp-wire`. It needs to add `SturdyRef`s built from data that survive a dropped connection, and let OCapN write refs it didn't mint.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (6069630 cached reads)
- Output: 40253 tokens
- Cost: $3.0472420000000002
- Wall-clock: 1430s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
