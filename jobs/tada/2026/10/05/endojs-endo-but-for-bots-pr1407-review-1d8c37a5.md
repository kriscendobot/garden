I didn't change the code myself. Following the directive, I posted the rework as a fixer job, `fix-endo-pr1407-single-socket-guest-lookup`, and it is now in `jobs/todo/` on `origin/journal2`.

**The review.** kriskowal's review 5410056994 on endojs/endo-but-for-bots#1407 is CHANGES_REQUESTED. It has a body but no inline comments. The preflight check found no earlier fix by another worker (exit 0).

The review rejects the per-guest Unix socket design. kriskowal's reasons:
- Managing the lifecycle and collection of more than one domain socket is fraught for little gain.
- Safety comes from object-capability discipline, not system isolation: the harness already confines the stdio MCP, and the MCP is the agent's only view of the world.

What they want instead: the stdio MCP connects to the Endo root, looks up the guest by its formula ID, and uses that guest for every tool call. The guest must never be able to reach the root or the root host agent.

**The fixer job asks for:**
1. Remove the per-guest socket code (`guestBootstrapPath`, `serve-guest-path.js`, `connectToGuestBootstrap`, `issueGuestBootstrapPath`, `--guest-socket`, `makeGuestConnect` and its fallback to the root connection), along with its tests, help text, changesets, design doc and README sections.
2. Have the broker connect to the root and look up the guest by formula ID once. Every tool call then goes through that guest only, with tests showing no tool exposes root or host authority.
3. Update the PR title and body (keeping `Refs: #1371`) and the design doc. If the change shrinks to almost nothing beyond what `llm` already does, say so on the PR and propose closing it.
4. Reply to the review with commit SHAs, and run the package tests locally before pushing.

**Follow-up:** the fixer may conclude the PR is redundant. The description says the code before this PR already looked up the guest through the root host's `lookupById`, which sounds close to what kriskowal is asking for. If so, the PR will need a close decision from the maintainer.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a62e91aca69f41da51c81bab904a1cb902e79609`; this job presented `a49568bb92f8e9f8776e22d73380cc66097ff58e`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1407-review-1d8c37a5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (284199 cached reads)
- Output: 2941 tokens
- Cost: $0.4774598
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
