# Fix round 3 for kriscendobot/minion.town PR #165

I fixed the two must-fix code findings from the round-3 panel, pushed them to the PR head, and CI is green (3 of 3 checks passed). The integrator's phase-gate blocker cannot be fixed in code, so the PR is still blocked from leaving draft.

Pushed to `feat/claude-pinned-responder` (`a0be086` → `d136726`) with `safe-push-pr-head.sh`:

- **`37fd1d7` — the responder misidentified its own messages (wire-watcher must-fix).** It compared the guest's own address string with each message's sender string. On a daemon that advertises network addresses, `locate("@self")` adds connection hints that the sender field never carries. So the strings never matched, and the responder treated the child's own outgoing copies as incoming mail. It now compares the node and formula number taken from each address. The responder caplet test now uses a self address with hints against a sender address without them.
- **`32180b2` — new `test/claude-agent-proxy-caplet.test.ts` (prover and corner-prober must-fix).** The test calls `infer` against a stubbed `fetch` and runs in a plain `npm test`, with no `ENDO_CHECKOUT` needed. It covers:
  - every result type and each of its allowed values, plus invalid field values;
  - the `usage-exhausted` result with and without `resetAt`;
  - bodies that are null, an array, a string, a number, or have an unknown or missing `type`;
  - non-2xx statuses, a failed fetch, and invalid JSON;
  - that results are hardened.
- **`d136726` — the endpoint's rate-limit ledger now drops entries for revoked and re-keyed bearers** once their time window has passed (assessor; engine-realist comment).

Checks: the four responder and proxy test files pass (47 tests) and `tsc --noEmit` is clean. A full `vitest run` showed three failures, none in these files: two in `tools/claude-harness`, which `npm test` excludes, and one in `test/git-remote/capability.test.ts`, which was already failing on this host. I posted a summary comment on the PR (issuecomment-6024133915).

Still open:
- **Integrator phase gate.** The panel's phase check is blocked: the governing design's Phase 1 is blocked and Phases 3–6 and acceptance are still open. The integrator says the PR should stay draft behind Phase 1 and the #150 canary hand-off. I left the ledger's `deliverable` disposition as it was, so panel-4 will likely still return must-fix on this gate alone.
- **Should-fix items I didn't take this round:**
  - a failure to reach the app is recorded as a final `unavailable` answer and the message is dismissed;
  - `infer`'s fetch has no timeout;
  - the per-message effect records are never cleaned up;
  - the "responder" vs "inbox-watch" naming split;
  - restored child records are built in `wiring.ts` instead of `agents.ts`;
  - the sliding-window rate limiter is duplicated;
  - gaps in the endpoint's failure-mode tests;
  - the PR body is too long (560 words).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1754299 cached reads)
- Output: 12874 tokens
- Cost: $1.2993557999999998
- Wall-clock: 398s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
