Fix round 5 on endojs/endo-but-for-bots#1482 is pushed and CI is green: 35/35 checks passed on head `a46821cc0`. One piece is still pending: the PR-body edit has been handed to a successor job and had not landed when I last checked.

**What I changed** (one commit, `a46821cc0`, pushed with `safe-push-pr-head.sh`; it changes only docs and comments, no code):
- **Design doc `## Status`:** cut back to the phase list plus two short deviation bullets. One covers the Rekey `op:session-hello` and the relaxed epoch check; the other notes the tiebreaker is implemented (pointer to `prefersOwnDial`) and P3 stays open. I removed the mechanism narrative and the redundant "Either side redials" bullet. The § 4 parenthetical is now its own note under the list, under 80 columns.
- **`designs/README.md`:** the index row now reads "In Progress (Phase 4 open)".
- **`packages/ocapn-noise/README.md`:** dropped the `sessionTimeoutMs` deference and stale-epoch sentences. The lead paragraph, the "greater ephemeral" rule and the `hardTimeoutMs` abort sentence stay.
- **Tests:** deleted two comments that restated the next line in `reconnect.test.js`, and cut the `getStreams` JSDoc in `_loss-injector.js` to the one sentence on why the first write is kept.
- **`src/network.js`:** dropped the "A reconnect." label from the branch comment.

**What I declined:**
- **Decomplector #1 (remove either-side redial and go back to initiator-only):** not done. Design § 3 says side B "does the symmetric thing", and the maintainer's original prompt asks for reconnect "by either side (crossed hellos being accounted for)". Removing it would contradict the governing design. The finding itself allows keeping it if the PR body explains why, so I wrote that explanation into the new body. A loser that never dials cannot recover a one-way partition where only it can reach the winner, and the `sessionTimeoutMs` bound covers a winner whose own dial hangs.
- **`harden` on `initiatesOnCrossedHellos`:** left as is. The package's existing exports, such as `compareUint8Arrays`, have no top-level `harden` either, and lint passed.
- **Should-fix items** (a bounded epoch accept window, and recording the deviation as a design decision): deferred.

**Handed off:** this host's bot token can't edit PRs on endojs (`gh pr edit` failed with 403 on `updatePullRequest`). I posted job `endojs-endo-but-for-bots-pr1482-gauntlet-fix-5-pr-body`, pinned to `endolin-garden-ece02cb4`, to apply the new body. That body:
- removes the phase-history clause, the test-helpers sentence and the Documentation Considerations paragraph;
- cuts Testing Considerations to "See CI.";
- adds the either-side-redial reason above.

The body is about 326 words with the ledger included; panel-6 may flag it against the ~300-word check again.

**Follow-ups:**
- Panel-6 should see the body change only after that job runs; if it re-runs first, it will review the old body.
- The phase/evidence pre-pass misread `designs/README.md` as the governing design. The PR body already names `designs/ocapn-noise-session-reconnect.md`, so this looks like a fault in the check, not the PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1482-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1861314 cached reads)
- Output: 10744 tokens
- Cost: $1.1319268
- Wall-clock: 2148s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
