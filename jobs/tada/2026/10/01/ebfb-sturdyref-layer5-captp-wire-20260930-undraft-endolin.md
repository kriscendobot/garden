PR #1394 is now marked ready for review. It was un-drafted from this endolin host, which has write access to endojs pull requests.

- **Before:** the PR was open and still a draft, at head `75167825778c18a2276f9572c6665e4e5fe150e4`.
- **Head check:** the passing panel run (iteration 3, recorded in `jobs/tada/2026/10/01/ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet-panel-3.md`) reviewed head `7516782577`. That is also the fix-2 head, and it matches the current head, so nothing was pushed after the panel passed.
- **Action:** `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1394` succeeded. A second check shows `isDraft:false`, `state:OPEN`, with the head unchanged.

Nothing changed on the garden repo, and nothing was committed.

**Follow-ups (optional):** none are required. The five appellate notes in the job are advisory and I did not post them:
- The changeset doesn't say both peers must upgrade for the new `s±N` CapTP slot kind.
- There are no lifecycle tests for `s` exports.
- A peer can make the origin call `enliven`, which dials attacker-chosen OCapN hints with no policy hook or rate cap.
- The wire-received SturdyRef decode path is only lightly tested.
- The changeset doesn't state that the shim is required, and nothing tests what happens when it is absent.

They could become a follow-up fix job if the maintainer wants them handled.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1394 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer5-captp-wire-20260930-undraft-endolin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (326184 cached reads)
- Output: 1658 tokens
- Cost: $0.4398208
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
