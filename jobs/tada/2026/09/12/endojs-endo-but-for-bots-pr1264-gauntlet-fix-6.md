## Completion report

**Job:** FIX round 6 — gauntlet stage for endojs/endo-but-for-bots PR #1264 (design doc: `designs/daemon-storage-capability-matrix.md`).

**What I did:** Read the round-6 panel verdict (posted as a comment-review because the panel bot authors the PR; three seats voted request-changes: critic, skeptic, decomplector). Applied all must-fix items plus the actionable should-fix items in a single review-feedback commit, verifying each panel claim against the live `manager.js` before editing.

**Changes (one commit `d775baf27`, pushed to `endojs/design/daemon-storage-capability-matrix`):**
- **critic (request-changes):** Corrected the grep-exhaustiveness claim from "two groups" to three (read/dispatch sites, external consumers, **literal write sites**). Named the three write sites explicitly in Phase 2 steps 3 & 5 — `formulateReadableBlob` (`manager.js:4532`), `checkinTree` (`:4939`), and the easy-to-miss duplicate `loadContent` content-locator tree-formulate call (`:6346`) — all verified in source.
- **skeptic (request-changes):** Added a GC-survivor regression test to the Phase-3 catalog (a legacy aliased `readable-*` record must still count as a `collectFormulaHashes` survivor — the design's own named data-loss risk). Dropped the stale `4743e382b` #1125 commit-SHA citation (verified unreachable from #1125's current head `326d8990b`) in favor of the PR's live open/DRAFT state.
- **decomplector (request-changes):** Scoped the `formulaForId` invariant to the deserialization path, carving out freshly-minted Phase-1 records (resolving the design's internal contradiction). Added Design Decision 5 recommending a single `isSnapshotFormulaType` predicate.
- **should-fix (copyeditor/pedant/novice/ergonomist):** Folded the inline `[proposed-rule, from the panel…]` annotation into authorial prose; fixed the stray imperative fragment in Phase 2 step 4; capitalized the Author field to `Kris Kowal (prompted)`; named the third abstraction-layer axis and the shape-axis root-name asymmetry up front in the Matrix; fixed the self-defeating forward reference in the Readable-view bullet; added Recommendation lines to the two Open Questions lacking them. Also rekeyed the two dead `provide(…, 'readable-blob')` grep hits for hygiene.

Kept the diff em-dash-free per the doc's convention, and reverted an incidental `yarn install` normalization of `packages/floot/package.json` so only the design file was committed.

**CI:** `ci-wait-merge.sh` → **CI GREEN** (29 checks, 0 failed; `lint`/`zizmor`/`changes` pass, rest correctly skipped for a docs-only PR). Did not re-run the panel (driver posts panel-7) and did not merge (PR stays draft).

**Follow-ups:** none for this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1264-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 100 tokens (4219778 cached reads)
- Output: 27563 tokens
- Cost: $3.783967
- Wall-clock: 1034s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
