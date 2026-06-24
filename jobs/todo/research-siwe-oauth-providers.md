# Research: OAuth/OIDC sign-in based on an Ethereum account address (Sign-In with Ethereum)

Research the landscape of **identity providers and solutions that let a user sign in
via OAuth/OIDC using their Ethereum account address**, where a wallet such as
**MetaMask** produces the credential (a signed message). Report the findings
**through the bulletin** (see Reporting below) so the maintainer reads the summary on
the dashboard.

This is a web-research task — use `WebSearch`/`WebFetch` and read primary sources
(specs, provider docs), not training-data recall. Verify claims against current docs;
note recency and licensing.

## What to cover

- **The standard:** Sign-In with Ethereum (**SIWE, EIP-4361**) and related (ERC-4361,
  CAIP-122, EIP-1271 for contract wallets). How a wallet signature becomes an
  authenticated session, and how that bridges to **OAuth 2.0 / OIDC** (e.g. SIWE as an
  OIDC provider / "Sign-In with Ethereum" OIDC).
- **Providers / solutions**, hosted and self-hostable — survey the real options and
  what each is, e.g.: Spruce ID (SIWE, kepler, the SIWE OIDC provider), Web3Auth,
  Magic, Privy, Dynamic, thirdweb, WalletConnect / Reown Auth, Auth0 + SIWE,
  NextAuth/Auth.js SIWE, and any first-party MetaMask offering. For each note:
  - what it does (wallet-only, or wallet + social/email; custodial vs non-custodial),
  - whether it exposes a standard **OAuth/OIDC** endpoint or a proprietary SDK,
  - **self-hostable vs SaaS**, open-source vs proprietary, **license**,
  - maturity / adoption / maintenance status, and notable limitations.
- **The MetaMask credential path** specifically: how MetaMask (`personal_sign` /
  EIP-712) yields the credential, and what a relying party verifies.
- **Tradeoffs & recommendation:** for a project that wants OAuth-style "sign in with
  your Ethereum address," which approaches fit which needs (pure decentralization vs
  convenience; self-host vs SaaS; standard OIDC vs SDK lock-in). Give a concise
  comparison table and a short recommendation with the reasoning.

## Reporting — through the bulletin

Deliver the report so it surfaces on the **bulletin** (the journal dashboard), not
buried in a tada file:
- Write a **`message` to the maintainer** (`scripts/jobs/message-user.sh <your-base>`)
  carrying a tight executive summary + the comparison table + recommendation — the
  bulletin's "Messages to the maintainer" section aggregates this.
- Keep the **full report** (sources, per-provider detail) in your job report / a
  journal entry, and reference it from the message so the bulletin summary links to
  the depth.

## Definition of done

A researched, source-cited survey of Ethereum-address OAuth/OIDC sign-in providers
(SIWE landscape) with a comparison table and recommendation, surfaced through the
bulletin via a maintainer message, with the full detail in the journal. Cite every
provider/claim with a current source. If a key fact can't be verified, say so rather
than guessing.

Posted by the liaison on behalf of the maintainer.
