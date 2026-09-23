Done. All work landed and verified.

---

## Completion report — `comment-watcher-no-overlap-with-issue-inbox`

**Problem:** On a repo the issue-inbox covers (its `config/garden-repo`), both `garden-issue-inbox` and `garden-comment-watcher@<slug>` polled true-issue comments, so a maintainer comment on an issue got a job from *each* watcher → duplicate responses (kriskowal/garden #9, 2026-06-30).

**What I changed (landed on `main2`, commit `1fc9b3cd9`):**

1. **PR-only mode on issue-inbox-covered repos.** `comment-watcher.sh` now derives PR-only deterministically (and logs it) from either signal: journal `config/garden-repo` == this repo, **or** `comment-repos/<slug>` declares `surfaces: pr-only` (overridable via `GARDEN_COMMENT_PR_ONLY`). In PR-only it **skips `surface=issue-comment`** — leaving true-issue comments to the sole issue-inbox handler — while keeping its unique surfaces.

2. **No coverage gap.** `comment-source-gh.sh` splits the `issues/comments` stream by `html_url` into `surface=pr-comment` (a PR's conversation; `.../pull/<n>`) vs `surface=issue-comment` (a true issue; `.../issues/<n>`) — **no extra API call**. PR-only therefore drops only true-issue comments, never a PR conversation comment. `comment-reactji-gh.sh` maps the new `pr-comment` surface to the same `/issues/comments/<id>/reactions` endpoint (a PR conversation comment is an issue comment on the API).

3. **Secondary — cursor advances past a dropped newest comment.** Added boundary dedup (`skip a comment whose created_at <= cursor`) to the main loop, matching the issue-inbox-watcher. A dropped newest comment (whose `created_at` persists as the high-water mark) is no longer re-dropped every tick (the re-dropped `cid=4839300009` loop). Affects all instances, incl. endo-but-for-bots.

4. **Tests (GI1–GI6, SS1; +16, total 115 pass):** PR-only skips a true-issue comment (logged) but processes a PR review *and* a PR conversation comment; auto-derivation from `config/garden-repo`; full coverage retained when no issue-inbox; cursor advances past a dropped newest comment and does not re-drop it; source splits pr-comment vs issue-comment.

**Re-arming (landed on `journal2`):** wrote `comment-repos/kriskowal-garden` with `surfaces: pr-only` (isolated clone + CAS push; the live journal worktree was never touched). `repo-watcher.sh` (leader-only) will arm `garden-comment-watcher@kriskowal-garden.timer` on its next tick; the watcher auto-derives PR-only from both signals, so garden PR reviews (e.g. the #5 "convert to job" review) are caught again with no issue-comment overlap. endo-but-for-bots (no issue-inbox) keeps full comment+review coverage.

**Verification:** existing 99 tests still pass; 16 new pass; issue-inbox test suite (25) unaffected; shellcheck shows only pre-existing infos/warnings, none from the new code.

**Follow-ups:** none blocking. The duplicate-committer-name confusion the maintainer noticed (git committer `endolinbot` vs `GARDEN=endolinbot2`) is out of scope here and already tracked by the queued `leader-marker-journal-leader-and-garden-env-var` refactor.
