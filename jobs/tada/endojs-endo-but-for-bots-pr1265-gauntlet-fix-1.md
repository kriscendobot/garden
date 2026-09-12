CI is GREEN (rc 0). The fix is pushed and CI passed. Writing my report.

---

**FIX round 1 complete — endojs/endo-but-for-bots PR #1265** (design: mutable blob / block-storage)

**What I did:** Read the panel-1 verdict (single-round design panel, verdict: must-fix; request-changes from critic, ergonomist, novice, pedant; should-fix notes from skeptic, copyeditor, orthographer). Applied the must-fix and high-consensus should-fix items to `designs/daemon-mutable-blob-block-storage.md` in one follow-up commit, pushed to the PR head, and watched CI to green.

**Changes applied (commit `a52fdd165`):**
- **Size side-channel (critic/skeptic/ergonomist consensus):** added a paragraph stating the write-only cap is content-opaque but *not* size-opaque (its admission rule branches on current `size`, so a write-only holder can probe offsets to binary-search the size); framed as an intentional coarse leak, not a content leak.
- **Concurrent-writer race (critic/skeptic):** specified that the `EndoBlockStorage` exo **serializes writes per store** so the overwrite-or-append invariant is maintained across the read-then-write `await`, not merely checked (closes the lost-update / wrong-offset-append race).
- **`getInfo()` identity reuse (critic/ergonomist/copyeditor/others):** renamed the field `hash` → `digest`, documented it as a recomputed per-call snapshot (not a stable identity), and added a cheap `size()` accessor so callers avoid an O(n) hash before every write (addresses the O(n²) cost).
- **Naming (ergonomist):** renamed read method `readAt` → `rangeRead` to match the established `platform-range-and-tree-reads` spelling; named the maker `storeBlockStorage` (parallel to `storeBlob`).
- **Error convention (ergonomist):** replaced `EINVAL` with the daemon's descriptive-`Error` exo convention.
- **CASK/citations (pedant/novice/copyeditor):** glossed CASK on first use, converted the four unresolved `[[cask-*]]` wiki-links into explicit forward references, defined CDC and CAT at first use, linked all PR #1125 citations, added a forward pointer from the Problem statement, and spelled out the classification-matrix axes.
- **Style:** removed all em-dashes and non-ASCII code points (U+2014, U+00D7 ×, U+00A7 §, superscript ²); doc is now pure ASCII.
- Added write-serialization, size-opacity, and test-catalog entries to Open Questions.

Staged only the design file (an unrelated `packages/floot/package.json` install artifact was left uncommitted).

**CI:** `GARDEN_CI_DEADLINE_SECS=3600 ci-wait-merge.sh … --no-merge` → **rc 0, CI GREEN** (29 checks, 0 failed; design-only diff so all code jobs path-skipped, `lint`/`zizmor`/`changes` passed). Stopped here per stage instructions — did not re-run the panel (driver re-posts panel-2).

**Follow-ups:** none required for this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1265-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (4153479 cached reads)
- Output: 29663 tokens
- Cost: $3.7028225
- Wall-clock: 859s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
