The work is pushed, verified, and the worktree is torn down. Both sources are now current on `origin/journal2`.

---

## Completion report — `scholar-refresh-marshal-rankorder-encodepassable`

**Outcome:** Both drifted `@endo/marshal` longform-comment sources re-anchored to current `master`; pushed to `origin/journal2` (commits on `7b922ea49`, rebased cleanly over concurrent gardener work). Integrity gate passes.

**Note on the job spec:** the two recorded `source_commit` values in the job body were swapped. Actual recorded anchors (from the source pages) were rankOrder=`2e933309`, encodePassable=`e6192056`. I used the real values; the current file-specific master shas matched the job's named tips.

**encodePassable.js (`e6192056` → `c423ed37`):** Diffed the two anchors — the only change was numeric-literal digit separators (`0x7ff8000000000000n` → `0x7ff8_0000_0000_0000n`). **Zero comment-text change, zero line shift.** Per conventions, a pure `source_commit` bump: source page + all 5 sections (parent + 4 children each). No supersession, no line-range edits.

**rankOrder.js (`2e933309` → `337d16a8`, +34 lines):** The five existing sections' backing comment clusters were **unchanged** (only function signatures gained optional `compare` defaults), so none were superseded. Two changes:
- **Re-pinned shifted line ranges** on the two sections whose material sits after the insertion point: `sort-by-rank-…` → `167, 380-451`; `full-order-…` → `598-642` (incl. URL anchors).
- **One genuinely-new comment cluster** appeared — `compareRankRemotablesTied` / `compareAntiRankRemotablesTied`, the remotables-tied-but-non-short-circuiting comparator that became the **default `compare`** across `isRankSorted`, `assertRankSorted`, `sortByRank`, `rankSearch`, `getIndexCover`, `unionRankCovers`, `intersectRankCovers` (with attendant parameter reordering). Captured as a **new 6th section** (`compare-rank-remotables-tied-default-comparator`, parent + abstract + body + see-also + translation). It supersedes nothing.

Bumped `source_commit` everywhere; updated the rankOrder source page (abstract, notes, section table, `section_count` 5→6, span `19-570`→`19-642`), `sources/README.md` + `sections/README.md` rows, `topics/marshal.md` (count 69→70) + `topics/pass-style.md` (count 55→56), and the `rank-order-preserving-encoding` concept index.

**Incidental fix (standing "proactively fix the garden" directive):** the `--changed` gate surfaced a **pre-existing dangling see-also link** in `inner-comparator-…--see-also.md` — it pointed at `endo--pkg-pass-style-readme.md` with a bare name (resolving inside `sections/`) though that source page lives in `sources/`. Corrected to `../sources/…`. Committed separately.

**Verification:** `library-link-check.sh` passes for both source slugs and `--changed` (exit 0). Inbox empty. Worktree (isolated off `origin/journal2`) torn down.

**Follow-ups:** none. The sibling key-equality sources (`compareKeys.js`, `checkKey.js`) were noted current by the job and not touched.
