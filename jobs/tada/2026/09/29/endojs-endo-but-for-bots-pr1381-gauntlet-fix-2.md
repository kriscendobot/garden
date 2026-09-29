## PR #1381, gauntlet fix round 2: completion report

The doc fixes are pushed and CI is green. The PR body rewrite, the panel's one hard must-fix, is **not applied yet**. This host's bot token gets a 403 on PR writes to endojs, so I handed that edit to a successor job pinned to another host.

**What I did**
- Read the round-2 panel review. The must-fix items came from the integrator. The PR body doesn't follow the template, and it says "17 sites" where the doc now says 16. The doc-level should-fix items came from the critic, skeptic, copyeditor, novice and integrator.
- Pushed commit `6e3fa01ae7` to `design/hardened-text-codecs-shim-status-reconciliation` with `safe-push-pr-head.sh`, a clean fast-forward from `5ff580e372`. It changes three files:
  - **`designs/hardened-text-codecs-shim.md`:**
    - Test plan item 6 now agrees with the XS finding from #1349.
    - The permits table now lists the `@@toStringTag` entries and the denied `inspect.custom` entries.
    - § Status no longer claims the table is "exact" and no longer mentions M2. I split its parentheticals into shorter sentences, explained what `llm` is, shortened the commit hashes, and dropped the "Before that change" sentence.
    - Phase 3 is now marked optional, so "Implemented" is accurate.
    - "1–2" ranges now use an ASCII hyphen.
  - **`designs/README.md`:** a new current-totals block dated 2026-09-29 (77 Implemented, 18 Not Started), plus the ASCII ranges.
  - **`designs/ARCHIVE.md`:** a groom note for this change, and the previous 2026-09-27 totals block moved into Superseded totals, following the process the README describes.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with 28 of 28 checks passing on the new head.

**Handed off**
- **PR body and merge-note comment:** both `gh pr edit` and the REST PATCH returned 403. I posted `endojs-endo-but-for-bots-pr1381-body-template`, pinned with `requires: host=endolin-garden-ece02cb4`. Its only task is to replace the body with a template-conforming text (included in the job, with the count corrected to 16) and post the #1355 merge note as a PR comment. If panel-3 runs before that job does, it will flag the body again.

**Not done**
- I did not squash the two earlier commits (integrator should-fix 6). This stage uses follow-up commits, and squashing would rewrite the branch history.
- I left two comment-only notes alone: whether the cbor-codec bucket is labeled consistently with this one, and moving the status to a single source of truth.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1381-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1433871 cached reads)
- Output: 11376 tokens
- Cost: $1.0882622
- Wall-clock: 1388s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
