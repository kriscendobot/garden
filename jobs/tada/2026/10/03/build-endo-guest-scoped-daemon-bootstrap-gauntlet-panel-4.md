## Panel round 4 (single round) on endojs/endo-but-for-bots#1407: must-fix

- **Run:** `panel.sh` ran in single-round mode with `GARDEN_PANEL_SINGLE_ROUND=1` and exited 0 with disposition **must-fix**. It checked head `68b86b940d` against base `llm-d4124e6`, in a separate project worktree created for this job.
- **Seats:** all 31 seats ran and none errored. 3 asked for changes, 7 left comments only, and 21 approved.
- **Review posted:** the verdict is review 5399271496 on #1407, marked `<!-- garden-panel-verdict -->`. It went up as a COMMENT review because GitHub doesn't let the bot request changes on its own PR; the body states the disposition is must-fix. The full aggregate is about 84KB, over GitHub's review size limit. So the review gives a summary of the must-fix items, then the full text of the 3 request-changes seats and the 7 comment-only seats.

**Must-fix items for the fix-loop:**
1. **Wire-watcher seat:** when the daemon has no guest socket support, `makeGuestConnect` in `confined-turn.js` silently falls back to full host authority. That fallback should at least log something, and could require an explicit opt-in.
2. **Corner-prober seat:** in `serve-guest-path.js`, an ordinary daemon shutdown is reported as `Endo daemon guest socket error:` for every open guest socket, because the error filter only ignores revocation, not shutdown. The tests never trigger a shutdown, so this path is untested.
3. **Corner-prober seat:** nothing tests a guest being collected between the type check and socket creation in `guestBootstrapPath`.
4. **Re-export auditor seat:** `makeGuestConnect` was added to the plain re-export in `packages/claude/index.js` without a `@deprecated` JSDoc or exemption marker. I added a note in the review: this file is the package's public entry point, not a compatibility shim, so the fixer can resolve this with the exemption marker or a reasoned reply rather than deprecating a new API.

As the stage instructions say, I did not fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1038675 cached reads)
- Output: 5251 tokens
- Cost: $0.7980830000000001
- Wall-clock: 705s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
