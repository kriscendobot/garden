Working tree is clean, HEAD is at `origin/main2`, all tests pass (0 failures). The work is complete.

## Completion report

**Problem:** `comment-source-gh.sh` fetched the repo-level `issues/comments` list, which GitHub answers with a permanent HTTP 404 on any repo whose Issues feature is disabled (the fork default). `gh_api_retry` classifies 404 as definitive → `note_fetch_failure` fired → the handler exited nonzero → `comment-watcher.sh` died FATAL every tick, crash-looping the 11 `kriscendobot/*` own forks and never enumerating `surface=pr-comment`.

**What I changed (all four items in the spec):**

1. **Recovered the surface with no coverage loss** (`comment-source-gh.sh`): when the repo-level list 404s because Issues are off, enumerate PR-conversation comments per open PR via `issues/<n>/comments?since=…`, reusing the existing activity-bounded open-PR walk in section 3 (no extra PR-list call). Emitted as `surface=pr-comment` via a shared `emit_pr_conversation_comments` helper — byte-identical to the repo-level branch. `issue-comment` is genuinely impossible on such a repo, so nothing is lost.

2. **Authoritative detection, not a blind 404 match**: new `repo_has_issues` (cached `repos/<repo>.has_issues` read, one per tick, only on the already-404'd path) and `repo_issues_disabled` gate the degraded mode. A 404 while Issues are enabled (deleted/renamed repo, lost scope), a transient blip, or a primary-quota refusal all keep the freeze-the-cursor behavior; a gone repo still reaches the tail REPO-GONE deactivation. Logs `issues disabled on <repo>; enumerating pr-comment per open PR` once per tick.

3. **Self-test probe** (`comment-watcher.sh`): repointed the jq-blindness probe so it falls back from `issues/comments` to `pulls/comments` (which returns 200 with Issues off), inside one shared `timeout 10s --kill-after=5s` budget (< 20s `TimeoutStopSec`, 5s margin). PR-number extraction avoids jq so the probe still detects an absent jq as BLIND. Prevents the guard from being silently disabled forever on the own-fork cohort.

4. **Latent shape noted** (`issue-source-gh.sh:117`): added a comment documenting the identical repo-level endpoint and how to gate it on `has_issues` if the inbox is ever pointed at a fork (no fix required now).

**Tests** (`comment-watcher-test.sh`): added **IDIS** (`has_issues=false` + repo-level 404 → exit 0, `pr-comment` recovered per open PR, degraded mode logged, no freeze) and **IDEN** (`has_issues=true` 404 → still exits 1, `FETCH INCOMPLETE` logged, does not enter disabled mode). Full suite: 332 passed, 0 failed; `issue-inbox-watcher-test.sh`: 40/0.

**Deploy note / follow-up:** the fix is on `main2` (commit `cb00b99e20`). The already-crash-looping units on the affected forks will recover on the next deploy of the garden root + a `reset-failed`; no code follow-up required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-endo-but-for-bots-issues-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (3812672 cached reads)
- Output: 38454 tokens
- Cost: $4.367472000000001
- Wall-clock: 714s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
