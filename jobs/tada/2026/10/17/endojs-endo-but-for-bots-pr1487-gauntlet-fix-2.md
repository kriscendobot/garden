Fix round 2 on endojs/endo-but-for-bots#1487 is done. I pushed the fixes and CI is green: `ci-wait-merge.sh` returned rc 0, with 35 checks and none failing.

**What I fixed.** Three follow-up commits are on `build/ocapn-noise-cryptographic-review` (8e71116a37 → 58443878ae), pushed with `safe-push-pr-head.sh`:
- **`d205d9f9dd`, package README:**
  - The wire-contract rationale link now points at the review proposed in #1475. Before, it pointed at the older copy of `designs/ocapn-noise-cryptographic-review.md` on this branch, which doesn't contain that rationale (archivist must-fix, integrator).
  - The key-confirmation rule now matches the SYN paragraph and `network.js`: an unproven handshake may hold a crossed-hello settlement slot, but it can't win settlement or displace a session.
  - Both Noise §7.7 citations now use the same wording.
  - I applied the pruner's cuts: the 213-byte total, the long explanation of the forged-SYN (key-compromise impersonation) attack, and the paragraph on the dropped Montgomery sign.
- **`adc34e3b38`, test:** the comment on the key-compromise-impersonation test is down to four lines and uses the same §7.7 citation.
- **`58443878ae`, session-reconnect design:**
  - R3 now "proposes to settle" open question C1 instead of settling it.
  - I removed the sentences about this branch's copy of the review and about the #252 history.
  - Decision 3 no longer repeats C1's status.
  - `last_acked_recv_nonce` no longer claims to equal the CipherState recv-nonce.
  - I rewrapped the C1 bullet.

**PR body (integrator must-fix, pruner).** It now has a Phase and evidence ledger that marks the PR as one slice of a larger plan, names `endo-but-for-bots-ocapn-noise-session-id-r2-build` (parked on the plan queue) as the owner of R2, and records C1 confirmation and #1475 landing as open gates. The phase-evidence gate accepts it with rc 30, which means the ledger is well-formed but un-drafting is withheld. I also shortened the body.

**Summary comment.** I posted one on the PR (https://github.com/endojs/endo-but-for-bots/pull/1487#issuecomment-6230893274). It lists what I addressed and what I declined, and tells @kriskowal that C1 is waiting on him. What I declined:
- **Splitting the design commits out of the PR:** the PR stays draft behind #1475 instead, and splitting is left to the maintainer.
- **The "resume" sweep:** the remaining hits are the ordinary verb or the C1 note that is meant to stay.
- **Renaming `last_acked_recv_nonce`:** it's a wire field, so renaming it is a design change.
- **A changeset:** none is needed, because `@endo/ocapn-noise` is private and already has changesets.

**Follow-ups:**
- The PR has to stay draft until @kriskowal confirms C1 and #1475 lands.
- The panel-3 stage is next; I did not re-run the panel.
- My first CI wait was moved to the background and stopped after 10 minutes. I killed it and restarted the wait with a longer time limit, and the restarted wait is the one that came back green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1487-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2301814 cached reads)
- Output: 13766 tokens
- Cost: $1.4205788
- Wall-clock: 1956s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
