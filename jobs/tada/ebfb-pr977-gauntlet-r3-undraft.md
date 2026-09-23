PR #977 successfully un-drafted.

## Completion report

**Job:** `ebfb-pr977-gauntlet-r3-undraft` — final (undraft) stage of gauntlet `ebfb-pr977-gauntlet-r3` for endojs/endo-but-for-bots PR #977.

**What I did:**
1. **Idempotence check:** `gh pr view` reported `isDraft=true, state=OPEN` — the PR was still draft, so the stage proceeded (not a no-op).
2. **Advisory appellate pass:** Reviewed the full 116-line diff (test-only, entirely in `packages/daemon/test/endo.test.js`). The change adds one regression test, `host-only capabilities are not reachable through an EndoGuest`, that pins the Host/Guest CapTP authority boundary: it asserts the complete 40-method Host-only surface is absent from a live `EndoGuest` (both by method-name list and by behavioral rejection at the CapTP receiver), and confirms the guest's reserved `@host` parent handle is not a second path to that surface. The test is well-structured, thoroughly commented (including the prefix-collision guard on the `no method "<name>"` error shape), and matches its PR description. No blocking concerns; advisory only, so it does not gate.
3. **Un-draft:** `gh pr ready` succeeded. Confirmed `isDraft=false, state=OPEN`.

**What changed:** PR #977 transitioned from draft to ready-for-review.

**Follow-ups:** None from this stage. The PR body notes a separately-tracked private remediation for a minion.town gateway exposure, which is out of scope for this daemon-facet test PR.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr977-gauntlet-r3-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (176134 cached reads)
- Output: 1712 tokens
- Cost: $0.405624
- Wall-clock: 43s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
