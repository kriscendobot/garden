The job's deliverable is already complete on `origin/main2` and verified green. This was a reaper requeue: a prior claimant of this same job base had already landed the fix (two commits) before my attempt. I independently implemented the same fix, discovered the collision at the push CAS, confirmed the landed version fully satisfies every requirement, and discarded my redundant commit rather than duplicate the work.

## Completion report

**Outcome:** The requested fix — teaching the LOST-FETCH invariant in `scripts/jobs/handlers/comment-source-gh.sh` to distinguish a surface-disabled 404 from a lost fetch — is already on `main2` and passing tests. No new commit from me was needed.

**Landed on `origin/main2`** (by a prior claimant of this job base):
- `544355d714` — `fix(comment-source): degrade Issues-disabled repos to a per-PR walk, not a crash-loop`
- `cb00b99e20` — `fix(comment-watcher): recover pr-comment on Issues-disabled forks (404)`

**Verified the landed version covers all four requested changes:**
1. Authoritative disabled-surface detection (`repo_issues_disabled` / `repo_has_issues`): a definitive 404 on `issues/comments` + `repos/<repo>.has_issues == false` skips the surface (logged once) without setting `fetch_failed`, so the cursor advances. Reuses the transient guard so "could not ask" never reads as "disabled".
2. PR-conversation comments recovered via the per-PR `issues/<n>/comments` endpoint inside section 3's existing open-PR walk, emitted as `pr-comment`; a failure there still sets `fetch_failed` (real lost fetch).
3. The `has_issues` probe is cached per tick (`_REPO_HAS_ISSUES`), one API call at most, only on the 404 path.
4. Regression test present as case **ID** in `scripts/jobs/test/comment-watcher-test.sh`.

**Test result:** `332 passed, 0 failed`, with case ID asserting exactly the required behaviors — issues-disabled fork exits 0 (no crash-loop), PR conversation comment still emitted via the per-PR walk, no FETCH-INCOMPLETE log, and `has_issues:true` still freezes and exits nonzero.

**Follow-ups:** None. `kriscendobot/test262` (and the other issues-disabled own-forks) will stop failing every tick once this main2 state is deployed to the root checkout via the normal deliberate-deploy path. I did not unwatch test262 or add any tombstone, per the job's instruction.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-test262-issues-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 51 tokens (2444414 cached reads)
- Output: 23811 tokens
- Cost: $2.860998 (1 engagement(s) unpriced)
- Wall-clock: 517s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
