## Viability report: endojs/endo-but-for-bots PR #1401

**Verdict: proceed.** The PR is still needed. The last session reached this verdict but put the stage marker after the completion signal, so the job wasn't recorded as done. Nothing on the PR or the base needed re-checking; this report re-issues the same result.

**PR facts:** open, draft, not merged. Title: "fix(daemon): close two teardown flakes (pid-before-ready race; unpulled-iterator rejection)". Base is the frozen `llm-825c598`, head is `fix/daemon-teardown-flakes` @ `9b5029dc94`. Opened 2026-09-30, with no reviews or comments yet.

**Deciding question:** Does current `llm` still have both bugs the PR fixes, with no commit or other PR having fixed either since the PR's base? The two bugs are:
- the daemon tells callers it is "ready" before it writes `endo.pid`, so a prompt `stop()` can miss the pid and leave the daemon running;
- the stream promise `E(readerRef).stream(synHead)` is created early but has no rejection handler until the first pull, so an abandoned iterator reports an unhandled rejection.

**Answer: yes.**

**Evidence:**
- On `origin/llm` @ `80054c3453`, `packages/daemon/src/manager-node.js` still sends "ready" at line 73, before it writes `endo.pid` at line 94.
- On the same commit, `packages/exo-stream/iterate-reader.js:55` still creates `nodePromise = E(readerRef).stream(synHead)` with no handler. Only `terminalPromise` gets a catch handler.
- `git log 825c598..origin/llm` shows no commits touching `manager-node.js`, `bus-manager-node.js`, `packages/exo-stream`, `daemon-teardown.test.js` or `endo.test.js`.
- A PR search for "daemon teardown flake" finds only #1401 open on this flake. The related #1166 (merged) fixed a different race, in git's background packing.
- The PR's premise still holds: daemon flakes keep failing CI on PRs that never touch the daemon, such as #774 and #1391. The PR is one day old.

The GitHub REST API quota ran out partway through the first session, so the base-code checks above were done with `git fetch` in a per-job project checkout instead.

No changes were made; this stage only decides whether the gauntlet starts.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1401-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (231149 cached reads)
- Output: 3079 tokens
- Cost: $0.9562556
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
