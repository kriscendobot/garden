Everything is verified. The core deliverable was completed and pushed by a prior attempt (my fresh worktree is clean at the main2 tip containing it), and I've re-run the tests to confirm.

## Completion report

**Job state re-derived from committed history + journal — the fix was already landed by a prior attempt; I verified and closed out.**

**Steps 1–3 (code fix + regression tests): DONE.** Committed as `cb00b99e20` (with precursor `544355d714`) and pushed to `origin/main2`; my fresh worktree is clean at that tip.
- `scripts/jobs/handlers/comment-source-gh.sh`: on the repo-level `issues/comments` 404, authoritatively detects `has_issues=false` via a cached `repos/<repo>` read (only on the already-404'd path) and classifies the surface as structurally ABSENT — no `fetch_failed`, WARN once per tick. A 404 while Issues are ENABLED (deleted/renamed repo, lost scope) still hits `note_fetch_failure` and freezes — no blind 404 swallow. The open-PR walk (section 3) recovers `pr-comment` coverage per open PR via `issues/<n>/comments` (still 200 with Issues off), with `note_fetch_failure` preserved for genuine per-PR enumeration gaps.
- Companion touch-ups: `comment-watcher.sh` blindness self-test probe repointed to a surface that exists with Issues off; `issue-source-gh.sh` noted the same latent shape.
- Tests: **IDIS** (disabled → exit 0 + `pr-comment` recovered) and **IDEN** (enabled 404 → still freezes). Full suite: **332 passed, 0 failed**.

**Step 4 (post-deploy cleanup): not actionable yet, and nothing to reset right now.**
- The deployed garden root (`/home/kris/garden`, HEAD `55d2c6411b`) still lags `main2` (`cb00b99e20`) — the fix has **not** deployed. Advancing the root is the deliberate, drained `deploy-garden.sh` operation supervised by the liaison, not a gardener action, so I did not run it.
- No `garden-comment-watcher@*` units are currently in `failed` state (`is-failed` → `inactive`; all `inactive dead` with timers `active waiting`) — the acute `activating (start)` crash-loop has already settled on this host, so there is nothing for `reset-failed` to clear at this moment. The `reset-failed` sweep belongs to the deliberate deploy that ships this fix.

**Siblings (same bug, shared-handler fix):** 6 already in `jobs/tada/` (cosgov, endo-but-for-bots, endo, moddable, test262, +2 garden-repo-crashloop); 5 in `jobs/doin/` actively claimed by peers (agoric-3-proposals, list, ocapn[-repo-alive variant], ymax-stdio-mcp, + this agoric-sdk one); 1 in `jobs/todo/` (vattr97). The fix is idempotent in the shared handler, so each sibling resolves without further code change. I did **not** forcibly move peers' actively-claimed `doin/` jobs.

**Follow-up for the maintainer/liaison:** deploy `main2` to the root (deliberate `deploy-garden.sh`), then run `systemctl --user reset-failed 'garden-comment-watcher@*'` and confirm the fork units settle — the two remaining acts of step 4 that are gated on that deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-agoric-sdk-issues-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 17 tokens (402107 cached reads)
- Output: 6512 tokens
- Cost: $0.7456174999999999 (2 engagement(s) unpriced)
- Wall-clock: 169s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
