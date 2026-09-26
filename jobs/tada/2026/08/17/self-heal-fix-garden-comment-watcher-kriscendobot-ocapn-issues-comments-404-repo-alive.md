This job was already completed and pushed by a prior attempt before the reaper requeue. Re-deriving from committed history confirms everything is in place — nothing needed redoing.

## Completion report

**Status:** Already landed on `origin/main2` (HEAD `48e25d3d33` == `origin/main2`; working tree clean). No new work required.

**What was already done** (commits `544355d714` then refinement `cb00b99e20`, both pushed):

The `has_issues:false` crash-loop in `scripts/jobs/handlers/comment-source-gh.sh` is fixed exactly per spec:

1. **ISSUES-DISABLED classification** added as a sibling to REPO-GONE — `repo_issues_disabled()` fires only on the already-failed path, on a *definitive* section-1 404 **and** an authoritative `repos/<repo>.has_issues == false` probe (cached once per tick). `fetch_failed` is not set for this case.
2. **No blanking of the surface** — instead a per-PR fallback walks `repos/<repo>/issues/<n>/comments` for each open PR from the section-3 enumeration, emitting the same `pr-comment` rows (bot filter, `created_at >= $since`), preserving the LOST-FETCH invariant against silent PR-conversation drops.
3. **Deferred after section 3** so it reuses the open-PR list, mirroring the review-comments deferral.
4. **Failed per-PR walk → `fetch_failed`** so the cursor still freezes; only the repo-level list 404 is forgiven.
5. **Logged once per tick at INFO**, no `alert_maintainer` — normal steady state for a fork.
6. **Not gated on a `has_issues` precheck** — keyed strictly on the observed definitive 404 plus the live repo probe (correctly handles `test262`/`agoric-3-proposals` which report `has_issues:false` yet serve `/issues/comments`).

The companion `comment-watcher.sh` blindness self-test probe was repointed to a surface that survives Issues-off, and `issue-source-gh.sh` got a note on the latent shape.

**Tests:** `scripts/jobs/test/comment-watcher-test.sh` — **332 passed, 0 failed**. New coverage:
- **IDIS** — repo-level 404 + live repo → exit 0, `pr-comment` recovered per open PR, degrade logged, no FETCH-INCOMPLETE freeze.
- **ID4** — per-PR fallback fetch fails → cursor frozen (exit nonzero), fetch-failure logged.
- **IDEN** — 404 while Issues *enabled* → still freezes (no blind 404 match).
- Existing REPO-GONE gone-live/FETCH-INCOMPLETE fixtures unchanged.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-ocapn-issues-comments-404-repo-alive.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 13 tokens (303440 cached reads)
- Output: 3982 tokens
- Cost: $0.627244 (3 engagement(s) unpriced)
- Wall-clock: 215s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
