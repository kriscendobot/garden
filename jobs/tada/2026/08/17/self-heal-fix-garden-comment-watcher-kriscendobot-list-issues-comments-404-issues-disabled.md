All parts verified and the defect I found is fixed and pushed. Here is the completion report.

## Completion report

**Re-derived state:** The job's three specified changes were already committed and pushed to `main2` by prior (reaped) attempts:
- **(a)** Issues-disabled probe in `comment-source-gh.sh` — commits `544355d`, `cb00b99e`
- **(b)** per-open-PR `issues/<n>/comments` re-route emitting `pr-comment` rows — same commits
- **common.sh** `unexpected end of JSON input` added to `GARDEN_TRANSIENT_GH_API_SIGNATURES` with the block comment extended — commit `cd75de2`; end-to-end ci-watcher regression — commit `48e25d3`

**Defect I found and fixed:** The two `comment-source-gh.sh` commits *each* independently added a per-PR conversation-comment walk inside section 3's loop, and the reconciliation kept **both** — an inline-jq block writing to stdout **and** a helper block writing to `$s3out`. On any `has_issues=false` fork (the exact target repos), **every recovered `pr-comment` row was emitted twice**. I reproduced it against a `GARDEN_GH` stub: comment `770001` appeared 2×. The existing ID1/IDIS tests used `grep -q`, which cannot detect a duplicate, so 332 tests passed over the live defect.

**Changes (commit `d7cfcc6875`):**
- Removed the redundant inline-jq per-PR block; kept the single DRY helper-based block (`emit_pr_conversation_comments`, byte-identical classification to surface 1), and enriched its comment to mark it the sole per-PR enumeration.
- Added exact-count (`-eq 1`) regression assertions to both the ID1 and IDIS test families so a re-introduced second block fails loud.

**Verification:** direct stub repro now yields exactly one row; `comment-watcher-test.sh` 334/0, `gh-api-retry-test.sh` 47/0, `ci-watcher-test.sh` 52/0; `bash -n` clean. Pushed to `main2` (CAS, first attempt).

**Follow-ups:** none. The two redundant `issues_disabled=""` declarations (lines ~108 and ~218) remain — harmless idempotent artifacts of the double-commit merge, left in place to keep the fix minimal.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-list-issues-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 53 tokens (2306076 cached reads)
- Output: 24321 tokens
- Cost: $2.664094999999999 (3 engagement(s) unpriced)
- Wall-clock: 572s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
