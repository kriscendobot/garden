## Completion report: `endojs-endo-but-for-bots-pr1097-stream-bytes-20260929`

I did the migration from kriskowal's review 5348027197 (ask 2: move `streamBase64` usage to `stream()` with passable byte arrays) and pushed it to the head of https://github.com/endojs/endo-but-for-bots/pull/1097. The head moved from `273765a08e` to `99b69ceed7` on base `llm-1706e63`. All 25 CI checks pass; the 8 skipped ones are skipped by design. I did not merge.

**Commits on `fix/readableblob-byte-array-cleanup`:**
1. **`ef1c3ab9d6` feat(exo-stream):** bytes readers made by `bytesReaderFromIterator` now offer `stream()`, which yields each chunk as a passable byte array. `streamBase64()` stays for compatibility.
   - Every responder on the cached-fs path already builds its reader with this function, so all of them get `stream()` with no further edits: LocalBlob, BlobRef, the daemon's mount and manager blobs, and native Git.
   - `stream` is added to `PassableBytesReaderInterface`. In the TS type it is **optional**, because a hand-rolled or older remote reader may only have `streamBase64`.
   - README and DESIGN § Migration Path are updated, the agent-tools code-mode declarations are regenerated, and there are new CapTP loopback tests.
   - Changeset: `@endo/exo-stream` minor, `@endo/platform` patch.
2. **`49c3731fd7` refactor(platform):** the `withCachedReads` background cache fill now reads through `iterateReader`, and so does the test's caller drain.
   - `canonicalizeStreamEventsRace` and its unit test now expect three `stream` calls: the caller drain, the cache fill, and the watcher's `events` reader.
   - The cache-hit test now requires every `stream` call to be matched by an `events` call. A freshly looked-up File starts its own watcher, so a plain zero count would fail.
   - The ava snapshot is regenerated; only method names changed.
3. **`99b69ceed7` chore: Update yarn.lock**, for the new `@endo/immutable-arraybuffer` dependency.

**Replied on the PR:** https://github.com/endojs/endo-but-for-bots/pull/1097#issuecomment-5892830562. It flags two things:
- **Consumers must copy the chunks first.** Under the immutable-ArrayBuffer shim, `Uint8Array#set` of a frozen byte-array chunk silently copies zeros; I confirmed this on Node 22. Callers must run `thawedBytes()` on each chunk first. Both migrated call sites do this, and the README now says so.
- **Wire size goes up.** CapTP's JSON encoding carries byte arrays as hex, about 2× the payload, versus about 1.33× for base64. That's fine for the background cache fill, but worth weighing before migrating hot paths.

**Verification:**
- Locally: exo-stream (155 tests), platform (363), exo-zip, exo-unzip and daemon mount/conformance tests pass. `tsc` and `eslint` report no errors on the changed packages. `cached-fs` passed 10 runs in a row.
- One local agent-tools test failed: `git-flow`, on a Git repo-identity check during cherry-pick. It has nothing to do with byte streams, and agent-tools passed in CI.
- In CI, one `test (22.x, macos-15)` run failed on a daemon-teardown test (an orphaned daemon's pid recording, a timing issue). A re-run passed.

**Snapshot note:** running ava's snapshot update (`-u`) under `@endo/init` without the fix from ebfb#1334 writes a `.snap` file ava can't read back. I applied that fix to my local `node_modules` only to regenerate it. The committed `.snap` is 2835 bytes and passes on a plain checkout.

**Follow-ups:** the retcon and conduct children of `endojs-endo-but-for-bots-pr1097-orch-20260929` come next. Bytes writers and other `iterateBytesReader` callers (daemon mount, `from-mount-backend`, and others) are still on `streamBase64`, so they're available for a wider migration later.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1097 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `bf54c8f16c70151be62d28461fca83012bc077bf`; this job presented `99b69ceed70601d37f1395192dfbc4065595fe5d`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1097-stream-bytes-20260929.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 192 tokens (11417085 cached reads)
- Output: 45966 tokens
- Cost: $4.438985
- Wall-clock: 5122s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
