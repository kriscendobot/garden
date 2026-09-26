The fix is fully landed on `origin/main2` (HEAD == `cb00b99e20`), with all tests green. The 13 still-failed units are running the *old* code from the deployed root checkout — they clear only once the deliberate deploy advances the root (the `garden-upgrade-monitor` → `deploy-garden.sh` path), which is a separate step outside this job's scope, not a per-tick reconcile of the current deploy.

## Completion report

**Job status: already complete — re-derived from committed history, nothing left to redo.**

Two prior-attempt commits landed the Issues-disabled comment-watcher degrade and are pushed to `origin/main2` (HEAD is at them, working tree clean):

- `544355d714` — `fix(comment-source): degrade Issues-disabled repos to a per-PR walk, not a crash-loop`
- `cb00b99e20` — `fix(comment-watcher): recover pr-comment on Issues-disabled forks (404)`

**What the landed fix does (verified against the spec):**
- `scripts/jobs/handlers/comment-source-gh.sh` — on a **definitive** (non-transient) 404 from the section-1 repo-wide `issues/comments` fetch, it probes `repos/<repo>` for `.has_issues` once (cached). Only an authoritative `false` arms `issues_disabled`; a transient probe failure or `has_issues:true` falls through to the unchanged freeze-and-retry (`repo_issues_disabled`/`repo_has_issues`, lines ~127–275).
- In issues-disabled mode, the existing section-3 open-PR walk enumerates `repos/<repo>/issues/<n>/comments?since=$since&per_page=100` (paginated) per open PR, emitting `pr-comment` rows with identical `$bot`-login and `created_at >= $since` filters. A per-PR fetch failure calls `note_fetch_failure` so the cursor still freezes (LOST-FETCH invariant preserved).
- Logs the degrade once per tick: `"issues disabled on $repo; enumerating pr-comment per open PR"`.
- Section-1 comment block documents the new degrade alongside LOST-FETCH and REPO-GONE, including the verified per-PR `200` vs repo-wide `404` fact.
- `comment-watcher.sh` and `issue-source-gh.sh` carry companion adjustments/notes.

**Tests:** `scripts/jobs/test/comment-watcher-test.sh` → **332 passed, 0 failed**, including IDIS (disabled → exit 0, `pr-comment` recovered, no FETCH INCOMPLETE) and IDEN (enabled + 404 → still freezes, exit 1). The spec's two required cases are present and green.

**Follow-up (not this job):** the 13 currently-failed `garden-comment-watcher@*` units still run the pre-fix code from the deployed root `/home/kris/garden2`; they clear only after the deliberate deploy advances the root checkout to this main2 head — the standing `garden-upgrade-monitor`/`deploy-garden.sh` path handles that, no action needed here.

Note: the implementation classifies the surface via the `html_url` `/pull/` test rather than hardcoding `pr-comment` as the spec suggested — a strictly safer choice that yields `pr-comment` for all PR conversation comments (which is all that can exist with Issues off), and the tests assert exactly that surface.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-ymax-stdio-mcp-issues-comments-404-issues-disabled.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 14 tokens (287350 cached reads)
- Output: 3888 tokens
- Cost: $0.5877879999999999 (2 engagement(s) unpriced)
- Wall-clock: 125s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
