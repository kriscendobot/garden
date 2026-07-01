# GitHub watchers: make observe→post-job FULLY deterministic (no claude -p)
Maintainer directive (2026-07-01): **no `claude -p` anywhere between observing a message/comment and
posting a job.** The LLM must only run when a gardener CLAIMS and works the job.
**Diagnosis (confirmed):** `comment-watcher.sh:829-830` calls the `claude -p` fallback triager
`handlers/comment-claude.sh:70` for the "ambiguous" case (`classify()` rc=2 — a trusted @-mention with
no recognized verb, or a trusted sender's comment with no verb/@-mention). That call is
`... 2>/dev/null || echo skip`, so on API error / rate limit / quota / blank / unparseable output it
defaults to `skip` and the comment is DROPPED with only a 👀 (comment-watcher.sh:837). That is why
ambiguous maintainer directives (and anything during a rate-limit window) were lost.
**Task:**
1. **Remove the `claude -p` fallback triager from the observe→post-job path** in `comment-watcher.sh`
   (and audit `issue-inbox-watcher.sh` + `mention-watcher.sh` for any LLM in their observe→post-job
   paths; remove those too). No GitHub watcher may invoke an LLM between observing and posting.
2. **For the ambiguous case, post a deterministic job anyway** — a generic **triage/attention** job
   carrying the comment context (repo, pr/issue, surface, author, url, comment-id, body reference),
   **idempotent by comment-id**. The verb/triage decision moves INTO the worked job: a gardener claims
   it, reads the comment, and decides/dispatches. So EVERY trusted comment deterministically becomes a
   job — never dropped by an LLM skip/failure.
3. Keep the existing deterministic verb table (explicit shepherd/conduct/rebase/etc. still post their
   specific jobs directly) and the trust/dedup gates. Only the LLM step is removed; the ambiguous
   branch now posts a triage job instead of asking the LLM for a verb.
**Verify:** a test where the LLM is unavailable (or a trusted ambiguous comment) STILL results in a
posted job (the triage job), not a drop. Land on `main2` via an isolated worktree off origin/main2.

---
claim:
  host: endolinbot2
  gardener: 69
  claimed_at: 2026-07-01T04:09:22Z
