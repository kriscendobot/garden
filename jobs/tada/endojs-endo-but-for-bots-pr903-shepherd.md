No messages. The hand-off is complete.

## Shepherd report — endojs/endo-but-for-bots PR #903

**Live state re-fetched at claim time.** PR #903 (`feat(sha256): platform-neutral SHA-256, unblocking the XS daemon bundle`; head branch `pr824-endo-sha256`, base `llm`) is **APPROVED** by kriskowal on its current head `f6cd2b4f` (2026-08-11T21:46Z — the approval the reconciler caught). But it is **not shepherd-actionable**:

- `gh api .../pulls/903` → `mergeable: false`, `mergeable_state: dirty` (CONFLICTING), `merge_commit_sha: null`.
- `gh pr checks 903` → "no checks reported on the branch."

This is the textbook **"Conflicting PRs block CI dispatch"** case (shepherd/AGENT.md §): `pull_request` workflows run on the synthetic merge ref, which GitHub does not create while `mergeable_state == dirty`, so no CI dispatches on the head and there is nothing for a shepherd to drive green. The correct action per the role is to **hand off to a weaver and stop** — not to push nudge commits against a branch whose CI cannot run.

**What I did:**
- Confirmed the conflict is authoritative (not transient/UNKNOWN mergeability) and that no weaver job for #903 already existed on the board.
- Posted **`weave-endo-but-for-bots-pr903-onto-llm`** to the job board, directing a weaver to rebase the PR onto current `origin/llm`, resolve conflicts reading both sides, preserve net diff (`git range-diff`), and `--force-with-lease` push to `pr824-endo-sha256`.
- Drained my inbox (empty).

**Escalation classification:** `next: weaver` — `mergeable_state == CONFLICTING`, workflows not dispatching on the head; diagnosed via `gh api .../pulls/903 --jq '{mergeable, mergeable_state, merge_commit_sha}'` → `{false, dirty, null}`.

**Follow-ups:** Once the weaver clears the conflict and CI dispatches on the rebased head, a shepherd (if red) then a conductor follows — the approval reconciler will re-dispatch on the approved-and-ready state, or a green run trips the event watcher. No garden-repo (`main2`) commits were needed; this job only diagnosed and handed off.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr903-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 17 tokens (396709 cached reads)
- Output: 5451 tokens
- Cost: $0.7078804999999999
- Wall-clock: 92s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
