All work complete. Final summary:

## Completion report — PR #910 panel response, child 08/10: should-fix, git-and-docs slice

Worked all **5 should-fix findings** in the `git-and-docs` slice from the authoritative checklist (`journal/artifacts/pr910-panel-findings.md`), in checklist order. Each carries a disposition; code changes pushed as one non-force follow-up commit `931e8c16b` on `feat-readableblob-range-attenuation` (still DRAFT), and the checklist was landed to `journal2` via the producer-clone helper.

**Fixed (code/docs):**
- **GD-06** — git `readWindow` now returns `bytes.slice(from, to)` (a copy over a fresh `ArrayBuffer`) instead of `bytes.subarray(from, to)` (a view onto the whole materialized object), so a narrowed git range can't leak the full object's backing buffer past the attenuation — matching the other four producers. Comment updated too.
- **GD-09** — `designs/readableblob-range-attenuation.md`: retitled the stale "Current surface" section → "Prior surface" with a `> Retired` callout (the doc is now *Accepted — implemented*); fixed both `shared/blobref.js` → `shared/blob-ref.js` path citations; added `streamBase64` (+`text`/`json`) to the `blob-ref.js` file-header surface list.

**Fixed (PR body):**
- **GD-10** — added a "Regression-test note" to the PR Verification section documenting a real break/observe/revert experiment: breaking `lineByteSpan`'s line-end to `to = i + 1` failed 5 tests (incl. the `textRange` equivalence corpus); reverting restored 18/18 green.

**Reasoned declines (no code change, replied in checklist):**
- **GD-07** (commit hygiene) — retroactively splitting a commit ~10 deep in pushed history requires a **force-push the run explicitly forbids** (would strand the sibling children stacked on this branch). Recorded as a forward lesson; the panel-response commits are kept single-concern.
- **GD-08** (arrow/typography churn, DISPUTED) — re-measured against the **true** merge-base (`a3064e1a2`, not the stale `3ec55851d` the panel diffed); em-dashes are net-added, arrow deltas are dominated by substantive `fetch → range` rewrites, and where notation did shift to ASCII it moves toward the garden's own `typist-friendly-code-points`/`no-latin-shorthand` preference. Sided with archivist (documentation seat): style, not accuracy.

**Verification:** `lint:types` clean on `@endo/git` and `@endo/platform`; `eslint` on `native-git-backend.js` shows only pre-existing warnings (0 errors, none in the edited region); `blob-range.test.js` 18/18 pass.

**Follow-ups:** none owed by this slice. GD-07's per-immutable hygiene lesson is noted for `skills/pr-formation` but not actionable without a history rewrite.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr910-panel-response-08-shouldfix-git-docs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 103 tokens (4520678 cached reads)
- Output: 25937 tokens
- Cost: $3.9239849999999996
- Wall-clock: 472s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
