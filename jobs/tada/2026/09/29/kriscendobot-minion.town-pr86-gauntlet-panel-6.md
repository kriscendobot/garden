Panel round 6 on kriscendobot/minion.town PR #86 came back **must-fix**, and I posted the verdict to the PR.

**How it ran:** I ran the panel once, in single-round mode, against an isolated checkout of the PR head (`099e9b3`), with base `b32291d` (the PR's actual base commit). It ran the 33-seat code panel with `GARDEN_YARN=npm` and exited 0 with `panel #86: code-panel single-round — must-fix`. 9 seats requested changes: archivist, locksmith, breaker, purist, spec-keeper, wire-watcher, engine-realist, pruner and fast-checker. The panel's durable run record was written as normal.

**What's on the PR:**
- **Review** `5346160390`: a summary of the must-fix items plus the blocks from the 9 request-changes seats. It went up as a COMMENTED review because GitHub won't let the bot request changes on its own PR, and its header reads `disposition: must-fix`. That's the same format rounds 1–5 used.
- **Two follow-up comments** with the 24 approve and comment-only seats. They were split because of GitHub's length limit.

**Must-fix items for the next fixer:**
1. **Revocation takes the raw token.** `revoke(token)` needs a secret that is shown once and never stored, so an operator who didn't keep it can't revoke a leaked token. It should take the token hash instead (`revoke(tokenHash)` or a `revokeByHash`), and the runbook needs updating to match.
2. **A revoke can be missed.** The token index is reused whenever the directory's modification time hasn't changed. A revoke that lands in the same clock tick as a rebuild leaves the revoked token working. Five seats flagged this. Fix it by not trusting a timestamp that is too close to the rebuild time (git's "racy index" rule) or with a generation counter, and add a test that forces equal timestamps with `fs.utimes`.
3. **Five public exports have no JSDoc.**
4. **The TLS-floor test only checks nine hand-picked strings.** It should use a property test over every string other than `"0"`.

**Should-fix items, also listed in the review:**
- A sidecar file that parses but has the wrong shape crashes the whole service.
- The `id` inside a sidecar is trusted over its filename.
- `authorize` hands out shared index entries that callers could modify.
- The serving router is given the full store, including mint and revoke.
- The `x-forwarded-proto` header is cast rather than checked, and the `Basic` auth match is case-sensitive.
- A client disconnect after a push skips updating the published content, and nothing retries it.
- Projection starts one `git cat-file` process per file.
- The round-5 fix push had no summary comment.
- Two pieces of doc padding.

Round 5's two must-fix items are confirmed fixed by `099e9b3`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1138729 cached reads)
- Output: 7536 tokens
- Cost: $0.9890098
- Wall-clock: 491s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
