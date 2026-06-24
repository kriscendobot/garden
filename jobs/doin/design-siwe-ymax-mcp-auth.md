# Design: integrate SIWE with ymax for an MCP that authenticates the caller per tool call

Follow-up to the SIWE research (`research-siwe-oauth-providers`; report at journal
`entries/2026/06/24/222655Z-result-gardener-siwe-oauth.md`, commit `96011938`).
Design **how to integrate SIWE (Sign-In with Ethereum) with ymax** so that an **MCP
(Model Context Protocol) server** can **authenticate the caller** — prove their
Ethereum account address — **for some tool calls** (per-tool auth gating). This is a
design/research investigation; ground it in the actual systems, not memory. Deliver a
design proposal for maintainer review.

## Build on the SIWE research (do not re-derive the landscape)

The research recommended, for "sign in with your Ethereum address":
- **Default:** the `siwe` library + your own session (self-hosted, mature, lowest
  dependency; you own nonce store + verification + token). No OIDC endpoint.
- **If a standard OIDC IdP is needed** (to federate the Ethereum identity to other
  relying parties): Spruce **`siwe-oidc`** — but vendor/fork it; confirm 2026
  maintenance (it showed staleness signals).
- SIWE = ERC-4361: wallet (MetaMask) signs a domain+nonce-bound message; the relying
  party recovers the signer (or EIP-1271 `0x1626ba7e` for contract wallets) and binds
  the session to the immutable address.

## Investigate / design

1. **Locate and characterize ymax** — find what `ymax` is and its MCP surface (search
   the repos/context; likely an Agoric/Endo project). Which of its MCP **tools need
   the caller authenticated**, what the current auth (if any) is, and how its MCP
   server is structured.
2. **MCP authorization model** — the MCP spec's authorization framework (OAuth 2.1 /
   bearer tokens / resource indicators): how an MCP client/host authenticates to a
   server and how a server gates individual tools. Cite the current MCP auth spec.
3. **Two SIWE integration shapes — evaluate both and recommend one:**
   - **(a) SIWE-OIDC as the IdP for MCP's OAuth flow**: the MCP server's OAuth
     authorization server federates to a `siwe-oidc` provider; the Ethereum address is
     the `sub`; MCP access tokens carry the verified address. Cleanest fit for MCP's
     OAuth model, but inherits the `siwe-oidc` staleness/vendoring caveat.
   - **(b) Custom SIWE verifier in the MCP server**: the server issues a SIWE
     challenge (nonce + domain), verifies the signature (and EIP-1271), mints its own
     session/token, and gates tools on it. Lower dependency, no OIDC, but you build the
     token issuance MCP expects.
   Cover the **MetaMask credential path** (how the caller obtains and presents the
   signature) for whichever the caller is (a human via wallet, or an agent/MCP host
   holding a key).
4. **Per-tool-call authentication enforcement** — how to declare that specific tools
   require an Ethereum-identity-proven caller and enforce it on each invocation: the
   authorization check per tool call, token/session lifetime, **nonce/replay
   protection**, and what identity the tool handler sees (the verified address as the
   caller principal).
5. **Endo/ocap fit (if ymax is Endo/Exo-based)** — how the verified address threads
   through hardened modules / capability discipline (the address as an attenuating
   identity claim rather than ambient authority).

## Deliverable

A design proposal: where SIWE plugs into ymax's MCP, the recommended approach (a vs b)
with rationale, the per-tool-auth enforcement mechanism, replay/lifetime handling, and
the tradeoffs — for maintainer review. Ground every claim about ymax, MCP auth, and
SIWE in the actual source/spec; cite what you read. Report where the design lives. If
you cannot determine what ymax is from the available context, say so and request the
pointer rather than guessing.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 86
  claimed_at: 2026-06-24T23:03:56Z
