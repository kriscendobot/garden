The rebase is clean — PR #398 is now **MERGEABLE** against the frozen base, with CI running (`UNSTABLE` = checks pending). All review asks are resolved. Here is the completion report.

---

## Completion report — review directive on endojs/endo-but-for-bots #398

**Reviewer:** @kriskowal (review 4945548154, "Looking good, albeit stale"). Preflight returned PROCEED (no peer resolution); I did the work.

The PR was badly stale: its merge base (`6cf4e2b8`) trailed `llm` by ~1493 commits, and in that window `packages/endo-fs` was reorganized into `packages/platform/src/fs/extended`. So the rebase was a re-home, not a fast-forward.

### Asks addressed (both inline comments + the body)
1. **"Pin the merge base to an `llm-xxxx` hash with the current hash and rebase; that makes `@endo/bytes`/`@endo/utf8` available"** — Created frozen base `llm-6ea8640` on `endojs/endo-but-for-bots` (snapshot of the current `llm` tip), rebased the head onto it, and moved the PR base from the moving `llm` to `llm-6ea8640`. Note there is no `@endo/utf8` package on `llm`; its UTF-8 helpers live in `@endo/bytes` (already a `@endo/platform` dependency), which is what I used. Replied on thread `3791092947` → reply `3791140058`.
2. **"Byte utilities should be in `@endo/bytes`"** — Replaced the hand-rolled `TextEncoder`/`TextDecoder` (`utf8`/`fromUtf8`) with `bytesFromText`/`bytesToText` from `@endo/bytes`, and dropped the local reader-drain-and-concat `collectBytes` in favor of the canonical `collectBytes` porcelain helper from `@endo/platform/fs/extended`. Replied on thread `3791093390` → reply `3791140100`.

### What changed (commit `41b225c36`, pushed to `claude/endo-streaming-clone`)
- `packages/platform/src/fs/extended/clone.js` — re-homed `cloneTree`/`streamTree`/`writeTreeStream`/`CloneFrameShape` (source verbatim; only the module-doc package reference updated to `@endo/platform`). I verified every Directory/File/OpenFile cap it uses (`list().toArray()`, `lookup`, `open`, `read(0n)`→EOF, `create({truncate})`, `write(0n)`, `close`, `materialise`) exists with a compatible signature on the new platform fs.
- `packages/platform/src/fs/extended/index.js` — exported the four clone symbols (reachable at `@endo/platform/fs/extended`).
- `packages/platform/test/clone.test.js` — re-homed with corrected import paths and the `@endo/bytes` swap.
- `designs/endo-app-sharing.md` — re-added the "Outstanding from the streaming-clone implementation" section (its only PR-unique content; the rest had already merged on `llm`).
- `.changeset/endo-platform-streaming-clone.md` — added a `minor` changeset for the new public feature (the original PR had none).

### Verification
- `node --check` passes on all three JS files; every import target (`@endo/bytes/from-string.js`, `/to-string.js`, `helpers.js#collectBytes`, `in-memory.js#makeInMemoryFilesystem`, the exo-stream/base64 subpaths) resolves to an existing file with the expected export.
- PR is now `mergeable: MERGEABLE` against `llm-6ea8640` (no conflicts).
- **Could not run the test suite locally:** `yarn install` fails host-wide with `EMLINK: too many links` on the shared `.yarn/berry/index` cache (hardlink-count exhaustion — an infra constraint, not a dep/code problem). CI on the PR will exercise the tests; it is currently running (`UNSTABLE`).

### Follow-up
- CI is in flight; if a check goes red, the standard ci-watcher/shepherd path owns it. The host-level yarn-cache hardlink exhaustion is a sysop/infra concern, not PR-attributable.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr398-review-262cd801.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 113 tokens (4992068 cached reads)
- Output: 40756 tokens
- Cost: $4.524469000000001 (2 engagement(s) unpriced)
- Wall-clock: 710s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
