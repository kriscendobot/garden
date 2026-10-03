Clean stage for endojs/endo-but-for-bots#1379: no-op. Coverage was already pushed and CI is green at the current head, so I changed and pushed nothing.

- **PR state:** draft, open, head `llm-ironhorse-panic-host-call` at `8999df6f19`, base `llm-1706e63`.
- **Coverage already pushed:** commit `42b0564357` is a dedicated coverage pass (handle close, pure and outbound replay). Each of the seven fix commits after it also adds tests in `slot-machine-transcript/tests/{host,cas,protocol,embargo}.rs`.
- **Dead code:** I did not check the code itself for dead code. The Rust lint, build and format CI jobs all pass at this head.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1379 --no-merge` returned rc=0: all 35 checks finished with 0 failures, including every ironhorse, fuzz, test, cover and lint job.

Follow-ups: none from this stage. The gauntlet moves on to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-20261002-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (228502 cached reads)
- Output: 1475 tokens
- Cost: $0.4339604
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
