from_host: endolin-garden-ece02cb4
from: gardener:design-gateway-authenticated-peer-identity
reply_to: design-gateway-authenticated-peer-identity
msg_key: msg-design-gateway-authenticated-peer-identity-5de70553bb78
notice_count: 1
first_seen: 2026-09-13T14:20:55Z
last_seen: 2026-09-13T14:20:56Z
sent_at: 2026-09-13T14:20:56Z
---
Design complete: authenticated peer identity for host gateway() across all transports (job design-gateway-authenticated-peer-identity, the residual requirement from the retention-set disclosure hold).

WHERE IT LANDED (embargo-respecting): the design is committed as designs/gateway-authenticated-peer-identity.md on branch design/gateway-authenticated-peer-identity, pushed to the bot fork kriscendobot/endo-but-for-bots (commit 1bcfb1b2e). I did NOT open a PR and did NOT touch designs/README.md, per this job's directive not to open a public PR or publish without further authorization. So the normal design review surface (a draft PR against llm + README plan sync) is DELIBERATELY WITHHELD, pending your disclosure decision.

NEEDS YOUR DECISION:
1. When disclosure clears, where do you want the review PR opened (draft against llm, as usual)? I left the branch on the bot fork so it is minimally visible until then.
2. The design assumes the two draft fix PRs land FIRST - https://github.com/endojs/endo-but-for-bots/pull/978 (inbound followRetentionSet binding) and https://github.com/endojs/endo-but-for-bots/pull/979 (outbound gateway binding). They make the gateway node-bound, which is the precondition for authenticating that node. Confirm that ordering.

KEY FINDINGS (all file:line grounded in the design):
- greeter.hello(remoteNodeId, ...) takes the peer's NodeNumber as a self-asserted argument on EVERY transport; only its shape is checked. The two fix PRs bind the gateway to that node, but the node itself is still unauthenticated inbound, so the binding is only as good as the unverified claim.
- The only real peer crypto (OCapN agent-binding) is one-directional: the dialer authenticates the responder, but hello runs on the responder and nothing authenticates the dialer. iroh's authentication is void for identity because its secret key is derived from the PUBLIC NodeNumber (deriveIrohSecretKey) - anyone knowing a target's node number can impersonate it on iroh.
- Proposed fix: a reciprocal agent-binding proof (generalizing OCapN's) so the transport vouches for the peer's NodeNumber before hello scopes a gateway; followRetentionSet takes no argument. Non-uniform where it must be: tcp-netstring (no crypto) and iroh-until-fixed get a degraded gateway with no cross-peer retention surface rather than a spoofable identity.

Five open questions in the design (channel-binding shape, tcp-netstring disposition, iroh EndpointId rotation, deprecation window, whether to drop the self-asserted hello arg). None block your disclosure decision; they are for the eventual review PR.
