Investigated production read-only and notified the maintainer urgently.

- dckc’s identifier is `g-e5fadeb49af110171de798cecfad7d5f`: formula type `handle`; its paired `-agent` formula type is verbatim `guest`, not host.
- The direct public WSS endpoints serve `EndoOcapnBootstrap`, not EndoHost. Live method list: `getAgentBinding`, `getGreeter`, `getNodeId`, `help` (plus CapTP introspection). They require a nonce locator for a Noise session.
- The explanation is the formerly armed weblet powers plane: it resolved publisher-supplied formulas through the daemon host; `@agent` could yield host powers. dckc’s publications predate the 22:45 UTC containment. It is currently disabled/fail-closed by the containment drop-in.
- Reconstructed dckc’s MCP tools from the live guest role and deployed artifact; no dckc credentials were used for a literal `tools/list`.
- No production or repository changes made.

Follow-up: retain containment and replace/remove the unsafe powers-resolution design before re-enabling it; assess any exposure during the pre-containment window.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-host-exposure-forensics.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 1111s

<!-- garden-usage-end -->
