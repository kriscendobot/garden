# Job complete: design-siwe-ymax-mcp-auth

Design proposal delivered:
`journal/entries/2026/06/24/230700Z-result-gardener-design-siwe-ymax-mcp-auth.md`
on branch `journal2` (commit a7e347fc; present on origin/journal2).

Recommendation: **shape (b)** — a custom SIWE verifier embedded as ymax's own
MCP OAuth 2.1 authorization+resource server, reusing the EIP-712
recover/verify/bind code that already exists in `portfolio-api`. siwe-oidc
(shape a) held in reserve only if third-party federation is ever required.

Per-tool gate, replay/lifetime handling, EIP-1271 contract-wallet path, and
Endo/ocap fit are all specified in the document. Four open questions flagged
for the maintainer (internal ymax-web details the public surface can't settle).
