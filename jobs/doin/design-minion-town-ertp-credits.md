---
role: designer
---

# Design: reflect minion.town credits with ERTP for attenuated third-party redemption

**Project:** `kriscendobot/minion.town` (the bot's MCP-server deployment; project
context `journal/projects/minion-town/README.md`).

## Delivery constraints (read the project README first — these are firm)

- **Land as a design PR against `main`**, NOT a direct commit (maintainer directive
  kriskowal 2026-07-10: minion.town design docs are now delivered as pull requests;
  the fork is watched, so the PR draws review). A design-only commit subject says
  **"spec only, no live change."**
- **Use the repo's own design-doc shape, NOT garden frontmatter:** `# Design:
  <title>` then a bold header block (`**Status:** / **Mandate:** / **Grounded
  against:** / **Companion:**`), numbered sections, **mermaid** diagrams.
- **Ground against the existing corpus** before writing: `designs/stripe-credits.md`
  (the current credits model — Stripe TEST-mode balance), `designs/mcp-endo-guest.md`
  (the per-user Endo-guest chain), `designs/mcp-oauth.md` (identity is keyed
  `iss`+`sub` everywhere). minion.town is a **deployment + configuration layer, not a
  code home** — server code that grows is shaped for later transplant, and the Endo
  direction grows `@endo/gateway` + `@endo/mcp`; say where each piece of this design
  lives (minion.town billing vs the Endo/OCapN/ERTP mechanics).

## The design

Reflect minion.town **credits** with **ERTP** (Agoric's Electronic Rights Transfer
Protocol) so that an **attenuated charge account** can be passed down through
**particular ocap message invocations**, letting a **third party redeem credits**
without holding a full account or host capability. Cover, at minimum:

1. **Credits as an ERTP asset.** Model credits with ERTP's issuer / mint / brand /
   purse / payment and `AmountMath`. Decide and justify the relationship between the
   existing **Stripe test-mode balance** and the ERTP-modeled credits: is ERTP the
   internal ledger of record, a mirror of the Stripe balance, or the settlement layer
   between parties? Who **holds the mint** (minion.town as issuer), how credits are
   minted/burned against Stripe top-ups and redemptions, and how ERTP's conservation
   / no-counterfeit guarantees are preserved across the fiat boundary.

2. **The attenuated charge account.** This is the crux. Define a **charge-account
   facet** — an ocap that lets its holder **draw credits** against an account **up to
   a limit / for a scoped purpose**, WITHOUT conferring the underlying purse, the
   account, or a host capability. Specify the attenuation dimensions (amount cap,
   purpose/brand scope, expiry, revocability, single-use vs standing) and how they
   **compose**. Show how the facet is **passed through OCapN message invocations** to
   a counterparty, and how the counterparty **redeems** (deposits a drawn payment /
   draws against the facet). Address the ocap hazards explicitly: revocation,
   double-spend, rights amplification, and confinement (a redeemer must not be able
   to escalate the attenuated facet into fuller authority).

3. **Detailed use cases (the maintainer asked for these explicitly — make them
   concrete, with mermaid sequence diagrams of the capability flow):**
   - **Peering arrangement.** A pair of peers exchange credits for a "peering
     arrangement" so each can use the other's **storage, network, or compute
     WITHOUT a full host capability**. Walk it end to end: what each peer grants
     (an attenuated, credit-metered facet over a specific resource), how usage
     **meters against credits**, how settlement works, and how either side
     **revokes** or lets the arrangement lapse.
   - **Third-party file transfer.** Arrange for **two third parties to transfer
     files between them using credits they have issued.** Walk the flow: who issues
     the credits, who runs the transfer capability, how the transfer is **gated on
     credit** (the attenuated charge account handed down through the invocation that
     performs the transfer), and how the parties settle without either holding the
     other's full host/account authority.
   - **Surface at least one or two further use cases** the pattern enables (e.g.
     metered relay/network egress, storage rental, delegated compute), so the design
     shows the general shape, not two special cases.

4. **Identity, trust, and composition.** How this composes with minion.town's OAuth
   identity spine (`iss`+`sub`) and the per-user **Endo guests** (`mcp-endo-guest.md`)
   — e.g. is a charge-account facet held by a user's guest? How OCapN sturdyrefs /
   the gateway carry the facet between peers. What each party must trust, and what the
   ocap + ERTP guarantees remove from the trust surface.

5. **Where it lives + phasing.** minion.town-side (billing/redemption endpoints,
   shaped for transplant) vs Endo-side (`@endo/gateway`, `@endo/mcp`, OCapN, and an
   ERTP dependency — `@agoric/ertp` or an ERTP-shaped local module; state which and
   why). Note any Endo-side companion design that should follow on
   `endojs/endo-but-for-bots` @ `llm`. Name the open questions rather than hiding
   them (the designer's job).

## Skills

- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [design-dependency-walk](../../skills/design-dependency-walk/SKILL.md),
  [library-lookup](../../skills/library-lookup/SKILL.md) — look up ERTP / OCapN /
  attenuation terms so the design uses the corpus's identifiers and mechanisms,
  [oauth-use-case-patterns](../../skills/oauth-use-case-patterns/SKILL.md),
  [em-dash-style](../../skills/em-dash-style/SKILL.md),
  [no-latin-shorthand](../../skills/no-latin-shorthand/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done

A design PR against `main` on `kriscendobot/minion.town`, in the repo's design-doc
shape, that: models credits as an ERTP asset over the Stripe balance; defines the
attenuated charge-account facet and its pass-through-invocation redemption with the
ocap hazards addressed; gives **detailed, diagrammed** peering-arrangement and
third-party-file-transfer use cases plus a couple more; situates the pieces across
minion.town and Endo; and names the open questions. The `tada` report links the PR
and lists the use cases covered and the key open questions.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 17
  claimed_at: 2026-07-10T22:17:51Z
