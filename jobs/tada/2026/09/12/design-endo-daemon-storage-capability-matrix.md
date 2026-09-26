Inbox empty. The job is complete.

## Completion report

**Job:** `design-endo-daemon-storage-capability-matrix` (designer role)

**What I did.** Grounded the design in the actual `endojs/endo-but-for-bots@llm` code before writing: read the source review comment (`endojs/endo-but-for-bots#1125` discussion `r3996792043`, `packages/daemon/src/manager.js:6804`), the daemon formula-type set, `mount.js` (`readOnly()`/`snapshot()` producers), `interfaces.js`, `formula-record.js` persistence, and `@endo/platform/fs` `interfaces.js`.

**Key findings that shaped the design:**
- The `@endo/platform/fs` **type layer already models the matrix correctly** (`ReadableBlob`/`SnapshotBlob`/`File`; `ReadableTree`/`SnapshotTree`/`Directory`). The confusion lives only in the **daemon formula-type names**.
- `readable-blob` / `readable-tree` are in fact **SnapshotBlob / SnapshotTree** — content-addressed, `sha256`-carrying, produced by `snapshot()`. Their name claims the generic "readable" word for the specifically-immutable form, which is exactly the `readOnly` != `snapshot` collision the maintainer flagged.
- **`readable-directory` never existed** as a formula (repo-wide grep confirms). The live read-only directory view is the *transient* `ReadableTree` returned by `readOnly()`, deliberately not persisted. I flagged this prompt discrepancy in the design.
- The distinguishing witness of snapshot-vs-view is the **content-address accessor** (`getInfo()`/`sha256()`), present on snapshots, absent on live views, behind the same shared read surface — I made that the type-level basis for the guarantee.

**Deliverable.** `designs/daemon-storage-capability-matrix.md` (matrix table naming all six cells + guarantees; reconciliation; a 3-phase backward-compatible `readable-* -> snapshot-*` rename with a read-time alias over persisted records, no bulk rewrite, content unaffected because identity is content-keyed; design decisions; open questions; captured prompt). Updated `designs/README.md` (recently-added note + summary-table row). No mermaid fence (the matrix is a data table, per the diagram carve-out).

**PR.** Draft **endojs/endo-but-for-bots#1264** against `llm`, head `design/daemon-storage-capability-matrix`, diff = the design file + README rows, body citing the source comment. Left **draft** per designer norms; naming it here arms the automatic design-panel gauntlet staging (I did not un-draft or hand-post a gauntlet).

**Follow-ups.** Implementation is a separate future `build` job (the rename touches `formula-type.js`, the `manager.js` maker table, `formula-record.js`, and exo tags). Four maintainer open questions are enumerated in the doc for panel/review resolution.

**Self-improvement:** nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-daemon-storage-capability-matrix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3940476 cached reads)
- Output: 28609 tokens
- Cost: $3.8777120000000003
- Wall-clock: 457s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
