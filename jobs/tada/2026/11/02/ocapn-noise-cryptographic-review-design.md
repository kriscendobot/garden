I didn't write anything new: this job repeats work the fleet already finished between 2026-10-16 and 2026-10-20. Writing it again would have opened a third PR that conflicts with the two below. I opened no PR and committed or pushed nothing to the project or to garden `main2`.

**What already exists**

- **Handshake and key handling** are covered in endojs/endo-but-for-bots#1475 (`designs/ocapn-noise-cryptographic-review.md`, head `453413b83d`). It reviews the IK handshake (`Noise_IK_25519_ChaChaPoly_BLAKE2s`) as built on `llm` and approves both IK and the X25519 keys derived from the Ed25519 identity. It also covers channel binding, `sessionId` scope and the cipher suite, makes recommendations R1–R5, and leaves questions Q1–Q3 open. It passed one design-panel round. It is open and no longer a draft, and it is waiting for a maintainer review. `ensure-pr.sh` found it and recorded it against this job's base, so nothing was duplicated.
- **Session reconnect** is covered in a draft addendum, endojs/endo-but-for-bots#1514, stacked on a frozen snapshot of #1475's head:
  - §8: transport nonces, replay, and failure handling.
  - §9: the session layer above the encrypted channel (`op:session-hello`, the session token, the epochs, resending lost frames after a reconnect).
  - R8: look up a reconnect by the authenticated peer plus the token, never the token alone.
  - R9: rules for delivering each resent message exactly once.
  - R10: derive the `np` `sessionId` from the session token.

  Its panel jobs have run, per the 2026-10-20 reports in `jobs/tada/`.
- **The follow-on PRs** are all open:
  - #1487 (draft): R1, R3 and R4.
  - #1506 (open, not a draft): R2, binding `sessionId` to the handshake hash.
  - #1512 (draft): the reconnect protocol design. Its rule R12 already requires the epoch-0 handshake hash, which matches R10.
  - #1476, #1478, #1481, #1482 and #1483 (drafts): the reconnect build stack.

**Why this was re-posted:** on `llm`, `designs/README.md` still marks this design "Deprecated", and the plan record says Not Started, because none of these PRs has merged. The roadmap row will keep looking unstarted until #1475 (which sets it to Proposed) merges.

**Follow-ups:** no new build is needed; the builds above already exist.
- **Maintainer:** review #1475 and #1514 together, and answer Q2 there. Q2 asks whether to bind the `np` `sessionId` to the handshake hash or to persist handoff replay state per `sessionId`. It blocks the parked job `endo-but-for-bots-ocapn-noise-session-id-r2-build`, and #1514's R10 proposes an answer.
- **Cryptographer:** a contributor who knows cryptography still has to sign off. The fleet cannot do that.
- **Parked reconnect build:** `build-endo-but-for-bots-ocapn-noise-session-reconnect-open-pr` is on hold for a human decision because the #1512 gauntlet failed. That needs a maintainer call, not another design job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-noise-cryptographic-review-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1288274 cached reads)
- Output: 7368 tokens
- Cost: $1.0555188000000002
- Wall-clock: 142s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
