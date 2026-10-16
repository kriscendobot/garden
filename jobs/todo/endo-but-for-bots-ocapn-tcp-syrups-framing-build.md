---
arc: minion-town-mcp-ocapn
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step for the M4 Networking milestone in endojs/endo-but-for-bots, following the ocapn-tcp-syrups-framing design (status Not Started, no depends_on). Implement Syrup framing for the OCapN TCP transport as a mergeable feature on the `llm` branch, and open a DRAFT PR. The three other M4 builds (tcp-for-test-extraction, network-transport-separation, daemon-agent-network-identity) are already queued, so keep this change out of their files and rebase on whichever lands first.
