CI is GREEN (rc 0, 29 checks, 0 failed). The fix stage is complete.

## Completion report — FIX round 1, endojs/endo-but-for-bots PR #1264

**PR:** Design: daemon storage capability matrix (draft). Head `design/daemon-storage-capability-matrix`, a docs-only change adding `designs/daemon-storage-capability-matrix.md`.

**Panel verdict applied** (reconstructed panel-1 disposition, 16 items across critic/decomplector/ergonomist/pedant/skeptic). I verified each claim against the actual code in an isolated worktree before fixing, and applied:

1. **Central factual correction (critic/skeptic/ergonomist).** The design claimed the snapshot-vs-live-view distinguisher was the "content address accessor" `getInfo()`/`sha256()`, absent from live views. That is wrong: `interfaces.js` documents `getInfo()` as the *uniform* accessor, and `mount.js`'s `makeReadableBlobView` (the `file.readOnly()` live view, on `ReadableBlobRangeInterface`) **does** implement `getInfo()` over current bytes. Rewrote the "Why the read surface is shared" section, the Readable-view bullet, and Design decision #1 to make the true distinguisher the **`sha256()` method** (present only on `SnapshotBlobInterface`/`SnapshotTreeInterface`), backed by the semantic difference (permanent identity vs. current-state fingerprint).
2. **Migration-path anchors (critic/skeptic).** The doc named non-existent `serializeFormula`/`deserializeFormula` and a mis-named `formulaMakerTable`. Corrected to the real anchors: `makeFormulaRecord`'s `switch (formula.type)` in `formula-record.js`, and the `makers` table (typed `FormulaMakerTable`) plus direct `formula.type === …` branches in `manager.js`.
3. **Phase 1 redundancy (decomplector).** Collapsed the two-mechanism compat plan (read-boundary alias **and** dual key-registration) to the single read-boundary alias carrying backward compatibility.
4. **Open question 3 (decomplector).** Reframed to flag the state/identity conflation hazard of a content fingerprint over mutable backing, noting live blob views already expose `getInfo()`.
5. **Em-dashes (pedant must-fix).** Removed all 12 em-dashes (→ colons/periods/parentheses) per the no-em-dash rule; file is now em-dash-free.
6. **Heading case (pedant should-fix).** Normalized "Design Decisions"→"Design decisions", "Open Questions"→"Open questions" to match sibling designs.
7. **Exo-tag rename (ergonomist/critic).** Added a Phase 2 cross-reference to the Open questions deferral on external tag-string consumers.

**Incidental hygiene:** reverted an unrelated `packages/floot/package.json` churn (a yarn-install JSON re-escape) so the commit is design-doc-only.

**Push & CI:** committed `6b5a390e5`, pushed as an advance follow-up via `safe-push-pr-head.sh` (91029124a → 6b5a390e5). Bounded `ci-wait-merge.sh --no-merge` returned **rc 0 / CI GREEN** (29 checks, 0 failed; `lint` + `zizmor` pass, the rest skip on a docs-only diff).

Stopped here as instructed — did not re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1264-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (5383034 cached reads)
- Output: 37548 tokens
- Cost: $4.660145
- Wall-clock: 1260s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
