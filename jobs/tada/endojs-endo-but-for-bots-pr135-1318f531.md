Inbox empty. Work complete.

## Completion report

**Directive** (PR #135, comment 4951756168, @kriskowal): consolidate the genie/lal/fae file-read features into the platform — add `listTree` (recursive list), `rangeRead` (bytes), `rangeReadText` (lines); omit `stat`; and (aside) rename `getInfo` → `contentAddress`.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer resolution) → proceeded.

**What I did.** Since #135 is closed and the ask was "create a pull request that adds these to the platform," I built a fresh PR against base `llm`:

- **`packages/platform/src/fs/interfaces.js`** — new method-guard records `rangeReadConvenienceMethodGuards` (`rangeRead`/`rangeReadText`) and `recursiveListMethodGuards` (`listTree`), plus two pre-assembled interfaces `ReadableBlobRangeReadInterface` / `ReadableTreeRecursiveInterface`. Added as *separate* records (not folded into the shared ones every implementer spreads) to keep the blast radius inside `@endo/platform`.
- **`local-blob.js`** — `rangeRead` (whole-value byte window as `Uint8Array`) and `rangeReadText` (0-based end-exclusive UTF-8 line range); refactored `fetch`'s window logic into a shared `readWindow` helper (EOF clamp, allocation bound, `EINVAL` validation).
- **`local-tree.js`** — `listTree(...path)`: recursive walk returning `{ path, type }` records, sorted, `.git`/symlink-skipping, depth-guarded.
- **`types.d.ts`**, **`fs/index.js`** — types + exports.
- **Tests** — extended `local-blob.test.js`, new `local-tree.test.js`.
- **Design doc** — `designs/platform-range-and-tree-reads.md`, documenting the three methods, the `stat` omission (security-germane leak; size stays via `getInfo().size`), the interface-layering rationale, and the deferred `getInfo` rename.

**Decisions.** `stat` deliberately omitted. The `getInfo` → `contentAddress` rename (framed as a tentative aside, ~30-file cross-cutting change) is **deferred to its own PR** and recorded as a follow-up — bundling it would have bloated and destabilized this change.

**Verification** (in the isolated project worktree): `@endo/platform` full suite **275 passed** (14 new cases), `tsc` clean, eslint **0 errors**.

**Outputs.**
- PR opened: **endojs/endo-but-for-bots#714** (base `llm`).
- Reply comment on #135 linking #714 and citing cid 4951756168.

**Follow-ups.** (1) `getInfo` → `contentAddress` rename PR. (2) Propagate `rangeRead`/`rangeReadText`/`listTree` to the daemon/git/mount blob & tree exos so they're available over CapTP.
