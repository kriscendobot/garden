---
id: per-agent-keypair
aliases: ["@keypair", "per-agent keypair", "KeypairFormula", "agent identity formula", "agent Ed25519 keypair", "keypair formula"]
topics: [daemon, capability-security, persistence, agent-conventions]
---

# per-agent-keypair

Each host and guest agent on the Endo Daemon has its own Ed25519
keypair, stored as a `keypair` formula in the formula graph. The
keypair is generated when the agent is formulated and is reachable to
the agent itself via the `@keypair` special name — through the same
name-resolution machinery any other capability is reached through, so
cryptographic identity is addressable in the ordinary way (not via a
privileged side channel). Private key material lives in the formula
JSON, with the same security posture as the existing `nonce` file:
plaintext on disk, protected by filesystem permissions.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [d256/per-agent-keypairs](../sections/endo-but-for-bots--llm-designs-d256--per-agent-keypairs.md) | The `KeypairFormula` type; agent-formula integration (host and guest gain `keypair` fields); `formulateKeypair()` flow; `@keypair` special name. |
| [d256/identifier-migration-and-crypto-powers](../sections/endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers.md) | The narrow `CryptoPowers` interface (`makeSha256`, `randomHex256`, `generateEd25519Keypair`); separated-power discipline. |
| [dani/per-agent-networks-and-nets](../sections/endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets.md) | The `NETS` companion: per-agent network identity (who-can-reach-me) pairs with per-agent keypair (cryptographic identity). |
| [dani/network-registration](../sections/endo-but-for-bots--llm-designs-dani--network-registration.md) | `EndoNetwork.registerAgentKey(publicKey, agentId)` — installed networks must know agent public keys to route inbound connections. |
| [dcp/handle-agent-foundation-and-the-gap](../sections/endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap.md) | The `handle` formula type links back to its owning agent (`{type: 'handle', agent: agentId}`); the Handle / Agent / keypair triangle is the prerequisite for the delegate model. |
| [dcp/verification-and-handle-extensions](../sections/endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions.md) | Cross-OCapN verification requires the verifier to reach the principal's Handle — explicitly interacts with the per-agent keypair work as a follow-on. |

## See also

- [[local-node-sentinel]] — internal storage uses `LOCAL_NODE` instead of any specific agent's key; externalization stamps the agent key on outbound locators.
- [[formula-graph]] — keypair formulas are just one of the 26 formula types in the graph.
- [[revocation-by-withdrawal]] — revoking an agent's identity is revoking its keypair formula.
- [[delegates-and-epithets]] — the principal/delegate identity model builds on per-agent keypairs as the cryptographic substrate.
