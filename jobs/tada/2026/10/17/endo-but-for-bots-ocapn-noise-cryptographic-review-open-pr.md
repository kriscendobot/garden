I opened the draft PR **endojs/endo-but-for-bots#1487**: https://github.com/endojs/endo-but-for-bots/pull/1487

- **Head:** `build/ocapn-noise-cryptographic-review` at `8e4b72fefb036841fe95aa0b112c3b4db88657a1`. Its three commits are on `llm-a794753`. The head had not moved since the job was posted, and I did not rewrite the branch.
- **Base:** `llm-a794753` (= `a7947533c6`).
- **Title:** `feat(ocapn-noise): key-confirmation test, np/1 wire contract, and Rekey-only reconnect (cryptographic review R1, R3, R4)`
- **Body:** copied word for word from the job spec. It includes `Refs: #1475` and the `<!-- garden-related-design: 1475,1481 -->` marker.
- **How it was opened:** through `ensure-pr.sh`, run from the isolated project checkout. The script reported that it opened a new PR (it did not find an earlier one) and recorded #1487 on `work/endo-but-for-bots-ocapn-noise-cryptographic-review-open-pr`.
- **Garden repo:** nothing changed in the garden repo.

**Follow-up:** the gauntlet needs to be staged for #1487. R2 (the per-connection `sessionId`) is still parked as `endo-but-for-bots-ocapn-noise-session-id-r2-build`, waiting on the maintainer's answer to Q2.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-noise-cryptographic-review-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (118735 cached reads)
- Output: 2727 tokens
- Cost: $0.426623
- Wall-clock: 59s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
