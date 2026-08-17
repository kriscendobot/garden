The `GARDEN_TAG` "unused" warning is a false positive — `common.sh` reads it as an environment variable (used at lines 114, 119, 390, etc.). Both shellcheck notes are pre-existing and benign.

The job was already completed by prior claimants and is fully merged to `main2` (HEAD == origin/main2). No changes are needed from me.

## Completion report

**Finding: the job was already done and merged before I claimed it.**

The requested ISSUES-DISABLED degrade is fully present in `scripts/jobs/handlers/comment-source-gh.sh` on `main2`, landed by commit `cb00b99e20` ("recover pr-comment on Issues-disabled forks (404)") ~48 min ago plus three follow-up refinements (`544355d714`, `d7cfcc6875`, `414954d25e`, `745fa90891`). My worktree's HEAD already equals `origin/main2` (`745fa90891`), so all the work is in the deployed lineage.

**Verified every spec requirement is met:**
1. ✅ Definitive surface-1 failure → authoritative `repo_has_issues` probe (cached `repos/<repo>` read, only on the already-404'd path); transient stderr falls through to freeze-and-retry (`repo_issues_disabled`, lines 127–163).
2. ✅ `has_issues == false` → no `note_fetch_failure`; recovers `pr-comment` per open PR via `issues/<n>/comments?since=…` in the section-3 walk, reusing `emit_pr_conversation_comments` for byte-identical `/pull/` classification and `since=`/`!= $bot` filters (lines 240–260, 365–384).
3. ✅ Ordering handled by deferring the fallback into section 3's open-PR loop (no extra PR-list call).
4. ✅ Comment at the degrade documents that `issue-comment` is legitimately empty in this mode (lines 89–108).
5. ✅ `has_issues == true` + 404 still freezes and exits 1 (line 161, `else` at 250–259).

**Regression coverage present and passing** in `comment-watcher-test.sh`: ID1–ID4 (source-level degrade cases) plus IDIS (disabled → exit 0, `pr-comment` recovered, cursor advances) and IDEN (enabled + 404 → still freezes nonzero).

**Verification I ran:**
- `scripts/jobs/test/comment-watcher-test.sh` → **334 passed, 0 failed**, including IDIS/IDEN/ID1–4.
- `shellcheck` on the handler → only pre-existing SC1091 (sourced-file info) and SC2034 (`GARDEN_TAG` false positive — it's an env var consumed by `common.sh`). No new findings.

**Changed by me:** nothing — no commit needed; the deliverable is already on `main2`. No arming records or journal state touched, and no `watch-optout` tombstone added (correct, per the job's explicit prohibition).

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-agoric-3-proposals-issues-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (6 unmetered)
- Input: 11 tokens (297549 cached reads)
- Output: 3388 tokens
- Cost: $0.7122485000000001 (6 engagement(s) unpriced)
- Wall-clock: 137s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
