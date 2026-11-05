Pinned base `7a0bcc903026382582afd97fcc3c2a18a0e85e05` and head `bcd20df6576295121add975cb096419143e1400c`; verified the isolated checkout matched the retained head. The deterministic style pre-pass failed, so no jurors were dispatched and no PR review was posted.

<!-- gauntlet-style-prepass-output-begin -->
probe typist-friendly-code-points fail (exit 1)
  fail: designs/api-key-agent-directory-authorization.md:100 U+201C LEFT DOUBLE QUOTATION MARK: type `"` (auto-fixable: run with --fix)
  fail: designs/api-key-agent-directory-authorization.md:100 U+201D RIGHT DOUBLE QUOTATION MARK: type `"` (auto-fixable: run with --fix)
result: 1 failing stage(s); address and re-run.
<!-- gauntlet-style-prepass-output-end -->

<!-- gauntlet-stage-result: panel=prepass-failed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 55s

<!-- garden-usage-end -->
