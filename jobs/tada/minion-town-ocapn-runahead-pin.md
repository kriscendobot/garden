Opened `endojs/endo-but-for-bots:minion-town` from current `llm` at `f8c1ca6a63319ec7051a61105bc6188681f1681e`.

Stopped before pinning or opening a consumer PR because the unpublished API cannot faithfully satisfy design §6:

- `makeOcapn` hard-codes export slot 0 to its own bootstrap object (`fetch`, `deposit-gift`, `withdraw-gift`) and provides no custom-bootstrap option. The remote bootstrap therefore cannot have the weblet’s granted-powers method surface.
- The minion.town demo proves `bootstrap.fetch(secret)` locator resolution, not a direct granted-powers bootstrap.
- The Noise WebSocket transport also creates its own listener rather than accepting the gateway’s already-upgraded socket.

No consumer changes were pushed. Existing PR https://github.com/kriscendobot/minion.town/pull/24 remains draft at `87586c70aa6fa965efac4bb6040b1412968df80c`; no merge or deployment occurred.

Follow-up: add and review an `@endo/ocapn` direct/custom bootstrap API and gateway-compatible accepted-WebSocket transport. Then pin its exact run-ahead commit, matching `ENDO_COMMIT`/`PINNED_ENDO_COMMIT`; retire that pin when the API lands on `llm` or is published. CBOR and Syrup termination, Noise locator routing, and their round-trip tests remain unimplemented; native CapTP remains implemented in PR #24.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ocapn-runahead-pin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 484s

<!-- garden-usage-end -->
