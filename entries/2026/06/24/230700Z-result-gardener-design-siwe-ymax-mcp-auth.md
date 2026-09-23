---
ts: 2026-06-24T23:07:00Z
kind: result
role: gardener
job: design-siwe-ymax-mcp-auth
host: endolinbot
refs:
  - entries/2026/06/24/222655Z-result-gardener-siwe-oauth.md
  - library/sources/agoric-labs--agoric-to-axelar-local-agoric-docs-ymax-evm-remote-accounts.md
  - library/sections/mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum--authorization-hardening-six-se.md
---

# Design — Integrating SIWE with ymax so an MCP server authenticates the caller per tool call

A design proposal for maintainer review. Builds on the SIWE research
(`entries/2026/06/24/222655Z-result-gardener-siwe-oauth.md`, commit `96011938`);
that report establishes the landscape and is **not** re-derived here. Grounded in
public sources only, per the maintainer's clarification (the internal `ymax-web`
repo is inaccessible to kriscendobot, like `capsule-sdk`). Where an internal
ymax-web detail would refine a choice, it is flagged as an **open question**, not
guessed.

## 0. Sources this design is grounded in

- **ymax product surface (public):** Ymax is a *non-custodial, cross-chain
  stablecoin yield orchestrator* — "moves, allocates, and rebalances your
  stablecoin portfolio with one signature," across Ethereum L1 + Arbitrum / Base /
  Optimism / Avalanche and IBC chains. Private beta signs with **Keplr** (Cosmos);
  **MetaMask and other EVM wallets are planned**. MetaMask co-founder Dan Finlay
  noted Ymax "encode[s] readable signature challenges into a MetaMask **ERC-712**
  signature." Sources: <https://agoric.com/ymax>,
  <https://agoric.com/blog/orchestration/ymax-private-beta-the-cross-chain-command-center-for-defi-users-has-landed/>,
  <https://messari.io/report/ymax-orchestrated-onchain-capital>.
- **ymax on-chain + planner side (public, in `Agoric/agoric-sdk`):**
  `packages/portfolio-contract` (the Agoric orchestration Exo), `packages/portfolio-api`
  (EVM-wallet typed-data layer), `services/ymax-planner` (off-chain planner). Read
  from the `Agoric/agoric-sdk` monorepo worktree at
  `packages/portfolio-api/src/evm-wallet/{eip712-messages,message-handler-helpers}.ts`.
- **MCP authorization spec (current):** `modelcontextprotocol.io` Authorization,
  rev **2025-06-18** (OAuth 2.1 + RFC 9728 + RFC 8707 + PKCE), plus the **six
  authorization-hardening SEPs** landing in **2025-11-25 / 2026-07-28**
  (library section above; blog 2026-05-21).
- **SIWE / ERC-4361, EIP-1271, CAIP-122/74:** from the prior research report's §1–§2.

## 1. What ymax is, and where an MCP would sit

Ymax turns **one user signature** into a coordinated multi-chain sequence
(deposit → allocate → rebalance → withdraw) over the user's stablecoins. The
public architecture has three tiers:

1. **The orchestration contract** (`portfolio-contract`, Agoric Exo) — holds the
   per-user *portfolio* and drives cross-chain execution. Sibling design: the
   `agoric-to-axelar-local` "EVM Remote Accounts" doc — assets live in boring
   durable per-portfolio contracts; routers are *authenticated instruction
   delivery* with explicit **confused-deputy-defense**
   (`library/sources/agoric-labs--…ymax-evm-remote-accounts.md`).
2. **The EVM-wallet authorization layer** (`portfolio-api/src/evm-wallet/`) — this
   is the load-bearing find. Ymax **already** authenticates EVM callers
   cryptographically: portfolio operations (`OpenPortfolio`, `Rebalance`,
   `SetTargetAllocation`, `Deposit`, `Withdraw`) are **EIP-712 typed-data**
   messages, either standalone or wrapped in a **Permit2** witness
   (`eip712-messages.ts`). The handler **recovers the signer**
   (`recoverTypedDataAddress`, `message-handler-helpers.ts`), validates the
   **domain** (`name:'Ymax'`, `version:'1'`, `chainId`, `verifyingContract`),
   carries a **`nonce`** and **`deadline`** per operation, and binds the operation
   to the portfolio's **source EVM account** ("The signer of the message must match
   the portfolio's source EVM account"; cf. `sameEvmAddress`). That is the SIWE
   verification primitive — domain-bound, nonce-bound, address-recovering — already
   in ymax's codebase, used today for *operation authorization*.
3. **The planner / web tier** (`services/ymax-planner`, and the internal
   `ymax-web` front-end) — off-chain. **An MCP server for ymax would live here**,
   beside or inside the planner tier: an agent-facing surface exposing ymax
   capabilities as MCP *tools* ("open a portfolio," "rebalance to target," "quote a
   deposit," "show balances"). No such MCP server is public today; this design is
   for the one to be built.

**Which tools need an authenticated caller.** Split the tool surface by authority:

| Tool class | Examples | Caller auth requirement |
|---|---|---|
| **Read-only / public** | `quoteYield`, `listSupportedChains`, `previewPlan` | None, or session-only |
| **Read, principal-scoped** | `getPortfolio`, `queryBalances(portfolioId)` | Must prove the address that **owns** that portfolio |
| **Write, principal-scoped** | `openPortfolio`, `rebalance`, `setTargetAllocation`, `deposit`, `withdraw` | Must prove the Ethereum address **and** match it to the portfolio's source EVM account |

The write tools are exactly the operations already EIP-712-gated on-chain. The MCP
layer is **not** a place to relax that — it is an additional gate in front of it.

**Open question (internal):** does `ymax-web` already mint a session after the
"one signature," and if so is it an EIP-712 operation signature or a separate
sign-in? If a session already exists, the MCP server should consume it rather than
introduce a parallel auth. Flagging for the maintainer; the design below assumes
the MCP server owns its own sign-in unless told otherwise.

## 2. The MCP authorization model (what the spec actually requires)

MCP authorization (rev 2025-06-18) is **transport-level OAuth 2.1**, and it is
specific about roles:

- The **MCP server is an OAuth 2.1 *resource server*** (RS). The **MCP client/host**
  (Claude Desktop, Cline, an agent) is the OAuth client. The **authorization
  server** (AS) is a separate role that may be co-hosted with the RS.
- **Discovery:** the MCP server **MUST** implement **RFC 9728 Protected Resource
  Metadata** (`/.well-known/oauth-protected-resource`) advertising its
  `authorization_servers`; on an unauthenticated call it **MUST** return **401**
  with a **`WWW-Authenticate`** header pointing at that metadata. The AS **MUST**
  publish **RFC 8414** metadata. Clients **SHOULD** support **RFC 7591 Dynamic
  Client Registration**.
- **Tokens:** **bearer** in the `Authorization` header on **every** request, never
  in the query string; **PKCE MUST** be used. The RS **MUST validate the token's
  audience** — it **MUST** reject tokens not issued specifically for it
  (**RFC 8707 Resource Indicators**: the client **MUST** send `resource=<canonical
  MCP server URI>`). **Token passthrough is explicitly forbidden** (confused-deputy
  defense — which rhymes with ymax's own router confused-deputy posture).
- **Errors:** **401** = unauthenticated / invalid token; **403** = valid token but
  **insufficient scope/permission**; 400 = malformed.
- **Per-tool authorization is *not* in the spec.** MCP defines how a *server* is
  protected as a whole; **gating individual tools is left to the server** — done
  with **scopes** (insufficient → 403) and server-side checks in tool dispatch.
  This is the hook our per-tool SIWE gate plugs into (§4).
- **STDIO transport SHOULD NOT use this flow** — it takes credentials from the
  environment. So a *local* ymax MCP (stdio) authenticates differently from a
  *remote* (HTTP) one; see §4 note.
- **Hardening (2025-11-25 / 2026-07-28):** six SEPs tighten OAuth/OIDC alignment —
  notably **SEP-2468** `iss` validation (RFC 9207, mix-up defense) and
  **SEP-2350** scope accumulation on step-up. A ymax AS should emit `iss` now and
  model **step-up** (read scope first, elevate to write scope at the moment a write
  tool is called) — a natural fit for "browsing is free, moving money needs a fresh
  proof."

Source: `modelcontextprotocol.io/specification/2025-06-18/basic/authorization`;
hardening per the library section above.

## 3. Two SIWE integration shapes

The question is **what sits in the AS role** and how the Ethereum address becomes
the token subject.

### (a) `siwe-oidc` as the IdP behind MCP's OAuth flow

The MCP server's AS federates to a **Spruce `siwe-oidc`** provider. The wallet
signs ERC-4361; `siwe-oidc` issues a standard OIDC token with **`sub` = Ethereum
address**; the MCP AS exchanges that for an MCP access token carrying the address.

- **Pro:** cleanest *standards* fit — MCP wants an OAuth AS, OIDC *is* one,
  drop-in; the address-as-`sub` mapping is exactly OIDC's shape; zero bespoke
  token code.
- **Con:** inherits the research report's **`siwe-oidc` caveat** — **v0.1.0,
  unaudited, ~2-yr staleness signals**; would have to be **vendored/forked** and
  its 2026 maintenance confirmed. It adds a **Rust + Redis** service to a
  TypeScript/Agoric stack. And it is **only worth it if ymax must federate** the
  Ethereum identity to *third-party* relying parties — which the public product
  (one app, one portfolio surface) does not suggest.

### (b) Custom SIWE verifier embedded as ymax's MCP authorization server  ← recommended

The ymax MCP server (or the planner tier beside it) **is** the OAuth 2.1 AS+RS. It
issues a SIWE challenge, verifies the signature with **the verification code ymax
already owns**, and mints its own short-lived bearer token whose subject is the
verified address.

- **Pro:** **ymax already has the entire verifier.** `portfolio-api`'s
  `recoverTypedDataAddress` + domain/nonce/deadline validation + source-EVM-account
  binding is precisely ERC-4361 verification minus the sign-in message template.
  Adding a SIWE *sign-in* endpoint reuses that path; no new audited dependency, no
  Rust/Redis, no OIDC server to keep alive. The token's `sub` is the **same
  address principal** the contract layer already enforces — one identity model end
  to end. Lowest dependency, matching the research report's default recommendation
  ("`siwe` library + your own session … lowest dependency; you own nonce store +
  verification + token").
- **Con:** ymax must **mint the OAuth token MCP expects** (RFC 9728 metadata, 8707
  audience, PKCE, short-lived JWT + refresh rotation). This is well-trodden
  (`siwe` lib + a JWT session, per the research report's NextAuth recipe) but it is
  code ymax writes and owns. No OIDC discovery endpoint — fine, because nothing
  here federates to a foreign RP.

### Recommendation: **(b)**, with (a) held in reserve

Choose **(b) the custom SIWE verifier as ymax's own MCP AS/RS.** Decisive reasons:

1. **The verifier already exists in ymax** and uses the **identical address-as-
   principal** model the contracts enforce; (a) would bolt a stale external IdP onto
   an identity ymax proves natively.
2. **No federation requirement** is visible in the public product; OIDC's one real
   advantage (third-party RPs) is unused.
3. (a)'s dependency is **unaudited and possibly unmaintained** — a poor base under
   a system that **moves user funds**.

Reserve **(a)** for one concrete trigger: *if* ymax must let **external relying
parties** consume the ymax Ethereum identity as an OIDC IdP. Then stand up
`siwe-oidc` (vendored, audited) as the AS while keeping (b)'s verifier as its
backing check. Until then, (b).

### The MetaMask credential path (for shape b)

Two caller kinds, one verifier:

- **Human via wallet.** The MCP host opens the OAuth authorize URL → a
  ymax-hosted **sign-in page** → wallet prompts **`personal_sign`** (ERC-191) or a
  typed **`eth_signTypedData_v4`** over the ERC-4361 message (ymax already favours
  the *readable* ERC-712 challenge per Dan Finlay's note) → ymax verifies and the
  OAuth flow returns the MCP token. EOA wallets verify by **ecrecover**;
  **smart-contract wallets verify by EIP-1271 `isValidSignature` == `0x1626ba7e`**
  — and this branch **matters for ymax specifically**, because ymax "EVM Remote
  Accounts" are **contract** accounts; a portfolio's controlling account may itself
  be a Safe/smart wallet. (EIP-6492 covers the counterfactual/not-yet-deployed
  case.)
- **Agent / headless MCP host holding a key.** No browser. The host signs the
  ERC-4361 message directly (viem `signTypedData`/`signMessage`) and exchanges it at
  a **direct SIWE→token grant** (an OAuth extension grant, e.g. a
  `urn:…:siwe`/JWT-bearer-style grant, or client-credentials-with-proof). Same
  verifier, same token. **Note (Keplr/Cosmos):** today's beta signs with Keplr;
  CAIP-122 (SIWx) generalizes ERC-4361 across chains, so the same challenge model
  extends to a Cosmos signature if the MCP must also serve Keplr-custodied callers.
  Flag: which signer the *MCP* caller uses (EVM vs Keplr) is an **open question**
  pending the EVM-wallet GA the public posts promise.

## 4. Per-tool-call authentication enforcement

The bearer token authenticates the *connection*; each tool call must still be
**authorized against the verified address**. Mechanism:

1. **Declare the requirement on the tool.** Each tool's manifest carries an
   auth descriptor — e.g. `auth: { ethIdentity: 'required', scope:
   'ymax:portfolio:write', portfolioBinding: 'owner' }`. Read-only tools declare
   `ethIdentity: 'none'`. This makes "which tools need a proven Ethereum caller" a
   **data** property of the tool, reviewable in one place.
2. **Enforce in a tool-dispatch middleware**, before the handler runs:
   - **(token validity)** validate the bearer JWT — signature, expiry, **audience ==
     this MCP server's canonical URI** (RFC 8707), `iss` (SEP-2468). Fail → **401**.
   - **(scope)** the token's scopes must include the tool's required scope. Missing →
     **403**. Write scopes are obtained by **step-up** (SEP-2350): browsing tools
     work with a read token; the first write tool triggers a fresh authorize round
     that may require a **fresh signature** ("re-sign to move funds").
   - **(principal binding)** for `portfolioBinding:'owner'` tools, check the token's
     **verified address == the portfolio's source EVM account** — reusing the
     contract layer's existing `sameEvmAddress` invariant. Mismatch → **403**. This
     stops a holder of *a* valid ymax token from touching *another* user's
     portfolio.
3. **What the handler sees.** The handler receives the **verified, checksummed
   Ethereum address as the caller principal** — never ambient authority, never a
   raw token to forward. The handler uses it to select the caller's portfolio
   capability and nothing else.

**Local (stdio) vs remote (HTTP).** Per the spec, a stdio ymax MCP **SHOULD NOT**
run the OAuth flow — it takes the signer/credential from the environment (the
user's local wallet/keystore) and still applies steps 1.3 (principal binding) and
the nonce/replay discipline below. The OAuth/RFC-9728 machinery is for the
**remote HTTP** MCP.

### Replay protection, token lifetime, nonce discipline

- **SIWE nonce (sign-in replay).** The server **issues** the ERC-4361 `nonce`
  (≥8 alphanumeric), stores it single-use with a short TTL, and **rejects reuse** —
  exactly the discipline ymax already runs for per-operation `nonce`/`deadline`.
  Bind the challenge's **`domain`/`uri`** to ymax's own origin (anti-phishing) and
  check `issued-at`/`expiration-time`.
- **Token lifetime.** Short-lived access token (**5–15 min**), **refresh-token
  rotation** for public clients (OAuth 2.1 §4.3.1, mandatory). The signed-in
  *session* can be longer-lived than any single access token; **money-moving
  step-up** can demand a *fresh wallet signature* regardless of session age — a
  policy ymax can set per-scope.
- **Audience binding (cross-resource replay).** RFC 8707 `resource` parameter binds
  each token to the ymax MCP URI; the RS rejects tokens minted for any other
  resource. No token passthrough to upstream (planner/contract) services — the MCP
  server acts as its own OAuth client to those if needed, with separate tokens.
- **On-chain operation nonces are unchanged.** The MCP per-call gate is an
  *additional* off-chain check; the EIP-712 operation the handler ultimately
  submits still carries its own `nonce`/`deadline` and is re-verified on-chain. Two
  independent replay defenses, not one.

## 5. Endo / ocap fit

ymax's contract tier is Agoric **Exo/orchestration** (hardened, capability-
disciplined), and the resonance is exact: the verified Ethereum address must be an
**attenuating identity claim, never ambient authority** — the same posture as the
Endo ACP/MCP adapter design, where "the adapter holds **the user's authority**, not
the [client]'s … each new session is a new guest with capabilities the *user*
authorized" (`journal/projects/endo/drafts/endopen-acp-server.md`).

Mapped onto ymax:

- The **MCP server holds no portfolio authority of its own.** It holds the right to
  *verify a signature* and *mint a token*; it does **not** hold any user's portfolio
  capability.
- The **verified address is a selector/attenuator**, not a key to a vault: the tool
  handler uses it to look up *the caller's own* portfolio capability (the Exo facet
  scoped to that source EVM account) and can act only within it. A token for
  address A can reach only A's portfolio facet — capability confinement at the tool
  boundary, mirroring the contract's source-account binding.
- This is the **same confused-deputy discipline** ymax's routers already encode
  on-chain (the `ymax-evm-remote-accounts` design's "routers as authenticated
  instruction delivery … confused-deputy-defense") and that MCP's own spec names as
  a top auth hazard. The address-bound token is the off-chain analogue of the
  router's authenticated-source-address calldata rewrite: **out-of-band
  authentication converted into an in-band, checkable argument** (the caller
  principal) at every tool call.

## 6. Summary of the recommendation

- **Shape:** **(b) custom SIWE verifier**, embedded as ymax's own MCP OAuth 2.1
  AS+RS, reusing `portfolio-api`'s existing EIP-712 recover/verify/bind code as the
  SIWE check. Reserve **(a) siwe-oidc** strictly for a future third-party-federation
  requirement (vendored + audited if ever adopted).
- **MCP conformance:** RFC 9728 PRM + `WWW-Authenticate`/401, RFC 8707 audience,
  PKCE, short-lived JWT + refresh rotation, `iss` (SEP-2468), scope step-up
  (SEP-2350).
- **Per-tool gate:** declarative `auth` descriptor per tool + dispatch middleware
  enforcing **token validity (401) → scope (403) → address-to-portfolio-owner
  binding (403)**; handler sees the **verified checksummed address** as principal.
- **Replay/lifetime:** server-issued single-use SIWE nonce (TTL), domain/uri
  binding, 5–15 min tokens, refresh rotation, audience binding; on-chain operation
  nonces remain an independent second defense.
- **ocap:** the verified address is an **attenuating claim**; the MCP server holds
  the user's authority, not its own; tokens confine to the caller's own portfolio
  facet.
- **EIP-1271** smart-contract-wallet verification is **first-class**, not optional,
  because ymax accounts can be contract wallets.

## 7. Open questions for the maintainer (need internal `ymax-web` / GA detail)

1. Does `ymax-web` already mint a sign-in session post-"one signature"? If so the
   MCP server should consume it, not introduce a parallel SIWE sign-in.
2. EVM-wallet GA timing: beta is Keplr-signed. Which signer do *MCP callers* use at
   launch — MetaMask (ERC-4361/EIP-1271) or Keplr (CAIP-122 SIWx)? The §4 gate
   handles both; the challenge template differs.
3. Is the intended MCP transport **remote HTTP** (full OAuth flow) or **local
   stdio** (environment credential), or both? It changes which half of §4 applies.
4. Any requirement to **federate** the ymax Ethereum identity to third-party
   relying parties? That is the sole trigger that would flip the recommendation to
   shape (a).

## Where this design lives

This file:
`journal/entries/2026/06/24/230700Z-result-gardener-design-siwe-ymax-mcp-auth.md`
on the `journal2` branch. It is the deliverable for maintainer review.
