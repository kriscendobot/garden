Inbox empty. The fix stage is complete.

## Completion report

**Job:** FIX round 4 of the gauntlet for endojs/endo-but-for-bots PR #1264 (design-only: `designs/daemon-storage-capability-matrix.md`).

**What I did:** Read the round-4 panel verdict (disposition: must-fix; blocking seats critic, skeptic, ergonomist, pedant) and applied every blocking item plus the copyeditor should-fixes, in one pass, to the design doc on the PR head.

**Changes applied (1 file, +129/−34):**
- **critic** — Reconciled the contradiction between § "Target Naming" (advertising the `readable-blob`/`readable-tree` names as "freed") and Phase 3 / Design decision 4 (recommending a *permanent* read-time alias). Stated explicitly that literal reuse of those strings and a permanent alias are **mutually exclusive**, and picked option (a): keep the permanent alias and give any future live-view blob/tree formula a new distinct name. Aligned the Open Questions bullet to match.
- **skeptic** — (1) Named the overlooked **third** `formula.type`-keyed dispatch site: `makeFormulaRecord`'s internal `case 'readable-blob':` (verified at `formula-record.js:215`) that populates `properties.content`. Revised Phase 1 step 2 to alias `formula.type` at function entry (covering both the computed `FormulaRecord.type` and the switch) and Phase 2 step 3 to rekey the case, so newly written `snapshot-blob` records don't silently drop `content`. (2) Added a test catalog pinning the four external literal-string consumer rekeys.
- **ergonomist** — Surfaced the three-way spelling of the Readable-view/Collection cell (`ReadableTree` interface + transient view vs. `ReadableNameHub` persisted formula); added an Open Question on a mount-backed persisted live-read-only-view formula and on aligning the `ReadableNameHub` tag.
- **pedant** — Title-cased all headings (`Open Questions`, `Migration Path`, `The Matrix`, `Reconciliation with the Existing Names`, `Target Naming`, `Why the Read Surface Is Shared…`) and their in-prose section references.
- **copyeditor** (should-fix) — Split the ambiguous cross-semicolon pronoun in Phase 2 step 4; recast Phase 2 step 3 into imperative voice. Kept the doc em-dash-free (rewrote the 5 em-dashes I'd introduced) and free of typist-hostile code points.

**Push & CI:** Committed and pushed as a follow-up commit (`1f9c305c2`) to the endojs/endo-but-for-bots head branch `design/daemon-storage-capability-matrix` via `safe-push-pr-head.sh` (rc 0, advanced `9e4fcce51..1f9c305c2`). Watched CI bounded: **GREEN** — 29/29 checks, 0 failed (rc 0).

**Follow-ups:** None. Per the stage contract, I did not re-run the panel; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1264-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2669932 cached reads)
- Output: 29049 tokens
- Cost: $2.9811940000000003
- Wall-clock: 966s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
