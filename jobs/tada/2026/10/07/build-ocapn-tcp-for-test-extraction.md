Stopped because the design has been overtaken by current `llm` (`f1e3065`):

- OCapN-Noise already bypasses the core handshake through `provideSession`/`inboundSessions`, but deliberately performs an encrypted `op:start-session` identity exchange for location signatures and three-party handoffs.
- `@endo/ocapn-iroh` deliberately relies on the core `op:start-session` handshake plus `verifyPeerLocation`; moving it only into tcp-for-test would break Iroh.
- Merged #1071 established the newer multi-transport hint model. Draft #684 remains changes-requested and deferred behind that model.

No code, commits, or PR were created. Follow-up: revise the design to account for network-owned identity exchange and migrate Iroh before removing the core fallback.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-tcp-for-test-extraction.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 273s

<!-- garden-usage-end -->
