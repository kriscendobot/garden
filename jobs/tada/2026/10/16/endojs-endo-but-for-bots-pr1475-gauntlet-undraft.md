**Undraft complete: endojs/endo-but-for-bots#1475** ("docs(designs): OCapN-Noise cryptographic review of the as-built IK handshake") is now ready for review.

- **Pre-mutation check:** the PR was open and still a draft, and its head was exactly `453413b83d88582849f42046ff12def478d37995`, the commit the passing panel covered.
- **Action:** I ran `gh pr ready` on the PR.
- **Post-mutation check:** the PR is no longer a draft, and the head is unchanged at `453413b83d88582849f42046ff12def478d37995`.

**Advisory appellate pass** (one `claude -p` run with Sonnet over the diff only; it did not check the code or the Noise spec, and it did not gate the undraft). These points may deserve a follow-up review:
- **Identity-hiding table:** the Noise §7.8 levels look wrong. It says "XX hides the responder (level 1)", which contradicts itself, and the responder-hiding level of 3 for XK and IK is doubtful. The XK-vs-IK initiator-hiding argument for Q1 depends on these numbers. Responder hiding is moot anyway, because the responder key is sent in the clear in the SYN prefix.
- **R2 vs R3:** these may contradict each other. R3 drops Resume, which undercuts R2's objection about the stability of `resumeSession`.
- **`sessionId` replay finding (§5):** this is stated without a code reference or exploit. It is the only finding that would change the wire format.
- **`-A` sign-bit alias:** this gives one key holder two identities, which affects the per-identity in-flight cap and tie-breaking. Canonicalizing the sign bit may be better than only documenting it.
- **Replay as an availability problem:** the review treats replay as only a cost issue. Replayed SYNs could fill the per-local-key in-flight cap and lock out legitimate initiators.
- **Smaller points:**
  - The Thormarker citation (ePrint 2021/509) is narrower than the static-static DH use it is cited for.
  - "Rekey" clashes with Noise's own `Rekey()`.
  - `ocapn-noise-network.md` may still contain XX/ACK wording.
  - One line in Security Considerations is not wrapped.

No follow-up job was posted.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1475-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168576 cached reads)
- Output: 1375 tokens
- Cost: $0.39120720000000003
- Wall-clock: 77s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
