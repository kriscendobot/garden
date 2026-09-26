Done. Here is my completion report.

---

**Job: design-endo-daemon-mutable-blob-block-storage**

Designed the mutable counterpart to the daemon's `readable-blob` capability for `endojs/endo-but-for-bots`, responding to PR #1125 review comment `r3996786768` on `packages/daemon/src/formula-type.js` line 37.

**What I did**
- Researched the existing surface: `readable-blob` (immutable, content-addressed, `ReadableBlobRangeInterface`), the mount-scoped `EndoMountFile` (live but whole-value writes only, no ranged write, no standalone formula type), the `FilePowers` surface (`readFileRange` exists, no `writeFileRange`), and the sibling `readableblob-range-attenuation.md` design.
- Studied CASK's content-delimited block mechanism from the journal library (`cask-blob-cat`, `rabin-chunking`, `cask-entry-type-capability`, `cask-named-typed-pointer`) so the design could answer the maintainer's reminder request accurately.
- Wrote `designs/daemon-mutable-blob-block-storage.md` (Proposed) and added its `designs/README.md` summary row.
- Validated the one mermaid diagram parses (parse-only, `mermaid.parse` OK).
- Committed on branch `design/daemon-mutable-block-storage`, opened **draft PR endojs/endo-but-for-bots#1265** against `llm` via `ensure-pr.sh` (carries the `garden-job` marker; diff is exactly the two design files; confirmed `isDraft: true`).
- Posted an inline follow-up on PR #1125 comment `r3996786768` (`#discussion_r3996842211`) linking #1265 and answering the CASK reminder — commenting is standing-authorized on this repo.

**Key design content**
- **Name recommendation: `block-storage`** for the in-place mutable capability; rejects bare `blob` (content-hash-identity connotation) and reserves `file`/`blob` for a future splice-capable CASK-backed variant. Final pick left as an open question.
- **Separate least-authority powers** for ranged reads (`getInfo`/`readAt`) and ranged writes (`writeAt`/`append`/shrink-only `truncate`), argued from the point that in-place reads and writes are *independent* authorities (a write-only cap is honest here, deliberately unlike CASK's `write-implies-read` cell lattice).
- **Write admission rule**: bounded overwrite within the extent, or append at the exact end; rejects middle-anchored extension and holes past the end; no splice primitive.
- **Daemon plumbing**: a new `writeFileRange` FilePowers primitive with the exo enforcing the rule above the raw seek-write.
- **CASK mechanism** explained: Rabin/buzhash rolling hash, no-reset-at-boundary re-locking, internal-level anchor tree, and why the splice-capable successor is best modeled as a CAS cell over immutable CDC blobs.

**Follow-ups**
- PR left draft intentionally; the design-panel gauntlet is staged automatically by the completion machinery (I did not un-draft or hand-post a gauntlet).
- The design flags reconciliation with the broader readable/snapshot/mutable × blob/file/tree/directory matrix job posted from the sibling comment `r3996792043` on the same review.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-daemon-mutable-blob-block-storage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (4235140 cached reads)
- Output: 31724 tokens
- Cost: $4.269049000000001
- Wall-clock: 528s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
