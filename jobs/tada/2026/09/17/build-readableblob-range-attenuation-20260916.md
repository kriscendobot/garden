---
handed-off: build-rbra-cleanbreak-20260916
deliverable-complete: false
---
Everything is in place. Writing my completion report.

---

## Completion report: `build-readableblob-range-attenuation-20260916`

**Outcome: honest handoff.** ReadableBlob range attenuation is a large, atomic, multi-package clean break. Per the job spec's explicit guidance ("if it does not fit one handler even at 10800s, SPLIT it along the design's own three steps and say so"), I landed a verified, self-contained foundation and posted a durable orchestration owning the entire remainder.

### What I built and verified (draft PR endojs/endo-but-for-bots#1301, base `llm-387ea66`)

Step 1 of the design for the **in-process platform blobs**, adopting `range(start,end)` / `textRange(startLine,endLine)` capability attenuation:

- **Shared attenuation logic** — new `packages/platform/src/fs/range-attenuation.js` (exported from `@endo/platform/fs/lite`): `assertByteRange` / `assertLineRange` (EINVAL on negative/non-safe/inverted), `composeByteInterval` (a range of a range **intersects** — can never regain authority outside its parent), and `lineRangeToByteSlice` (LF boundary math kept byte-for-byte consistent with `rangeReadText`; CRLF and terminal-LF preserved).
- **`LocalBlob`** (`fs-node/local-blob.js`) — interval-aware over the host file; live face observes the source per-op subject to the fixed interval.
- **`BlobRef`** (`fs/extended/shared/blob-ref.js`) — O(1) `subarray` view over the immutable snapshot; a range of a snapshot is stable; derived ranges compute their own SHA-256.
- Guards require the returned `ReadableBlob` (`M.remotable('ReadableBlob')`, not `M.any()`); `range` resolves synchronously (no bytes read), `textRange` asynchronously. Types layered additively on `ReadableBlobRangeRead` / `BlobRef` so the daemon/mount/git blobs still satisfy the unchanged shared base.

**Verification (real runs):** `packages/platform` — `lint` (0 errors), `lint:types`, `test:types`, and full `ava` all green: **363 tests pass**, including a new attenuation matrix (`test/range-attenuation.test.js`, plus additions to `local-blob.test.js` / `blobref.test.js`) covering nested byte ranges, byte-after-text / text-after-byte, terminal-LF, CRLF, invalid args, `start === end`, EOF clamping, immutable snapshot stability, and live-file changes. Downstream `daemon`, `git`, `exo-git` `lint:types` all clean — confirming the change is non-breaking for the not-yet-adopted producers.

### Handoff — remaining work is owned by a durable serial orchestration

`build-rbra-cleanbreak-20260916` (recorded at `jobs/orch/`, serial, on-child-failure=halt), three parked children stacking on branch `build/readableblob-range-attenuation` / PR #1301:

1. `build-rbra-daemon-mount-git-20260916` — adopt range/textRange in daemon (`manager.js`), mount (`mount.js`), git (`native-git-backend.js`) + their guards + daemon tests (live mount, revocation), still additive.
2. `build-rbra-clean-break-20260916` — remove `fetch`/`rangeRead`/`rangeReadText` from every producer/guard; rewrite consumers `cas.js`/`cached-fs.js`/daemon to the new cap shape.
3. `build-rbra-rename-conformance-20260916` — collapse to the single `ReadableBlob` surface, drop `ReadableBlobRange*` names, regen declarations, help text/`help.md`, method-set conformance assertions, design/API prose.

When the orchestration completes, #1301 is ready for a **run the gauntlet**.

**Follow-up note:** each child's body carries the resume recipe (`ensure-project-worktree.sh` → `git reset --hard kriscendobot/build/...` → re-adopt #1301 via `ensure-pr.sh` marker). The daemon/mount/git child flags the one hazard to watch: adding to the shared `ReadableBlobRangeInterface` forces every exo using it to implement the two methods, so that child must enumerate implementors first.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-readableblob-range-attenuation-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (11546991 cached reads)
- Output: 106109 tokens
- Cost: $10.454414500000004
- Wall-clock: 1566s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
