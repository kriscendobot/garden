I opened draft PR **https://github.com/endojs/endo-but-for-bots/pull/1477**. It is ready for the gauntlet to be staged.

- **PR:** `feat/ocapn-np-identity-location-id` at `7f52fa6ee9` into the frozen base `llm-61cd656` (= `llm` at 61cd656cb). The title and body are as specified in the job. I left the head commit unchanged: on the remote it was still at 7f52fa6ee, so it had not drifted.
- **How it was opened:** with `ensure-pr.sh`, passing the predecessor's base, so the PR carries the marker `<!-- garden-job: endo-but-for-bots-ocapn-network-transport-separation-build -->`. `gh pr view` confirms it is a draft, with the expected head SHA and base.
- **Not recorded on the board:** `ensure-pr.sh` logged "no work/endo-but-for-bots-ocapn-network-transport-separation-build record on the board", so PR #1477 is not linked to the predecessor's work record. That job was claimed on another host (oros-studio). Whatever stages the gauntlet should take the PR number from this report.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-network-transport-separation-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (226130 cached reads)
- Output: 2158 tokens
- Cost: $0.432538
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
