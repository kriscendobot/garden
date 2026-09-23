---
role: designer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: SIWE as guest-identity recovery (supersedes on-chain authz) on minion.town

Repo (PRIVATE): `kriscendobot/minion.town`. Work in an isolated per-job checkout
(`scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`) and follow that
repo's conventions for design changes.

## Maintainer decision (kriskowal, 2026-09-23 muster), verbatim
> We have no interest in publishing an on chain contract now or ever. We only want to use SIWE to
> enable an account with an associated Ethereum address to recover its guest formula identifier,
> which is the only credential we are concerned with on minion.town.

## What this replaces
`designs/siwe-onchain-authz.md` framed SIWE as an **authorization** system: Tier 1 address
allowlists under `iss=https://siwe-idp.minion.town` with scopes and guestFacetGrants, and Tier 2
on-chain assets (a registry contract on Base, safe_signer, erc721, erc20_min_balance). The
maintainer's inbox question (tier choice plus allowlist addresses) is now answered: **none of
that.** No contracts, no chain-held authorization, no address allowlist granting scopes. SIWE's sole
purpose is **proof of control of an Ethereum address, used to RECOVER the guest formula identifier
bound to that address.**

## Design must settle
1. **The binding:** how an account associates an Ethereum address with its guest formula identifier
   (when, with what proof, where it is stored, how it is changed or removed). The formula identifier
   is the only credential that matters, so treat its disclosure as the security-critical event.
2. **The recovery flow:** SIWE sign-in (nonce, domain binding, replay protection, and expiry) leads to
   the formula identifier being disclosed or re-issued to that signer. Decide: return the existing
   formula id, or re-key/rotate? Also cover single use, rate limits, and audit logging. Cover a lost
   address and more than one address per guest. Say what an attacker who compromises the address
   gets, and what they don't.
3. **Fit with the capability-first invitation onboarding** (minion.town design #56; `EndoGuest.invite`/`accept`,
   endojs/endo-but-for-bots#1310; draft kriscendobot/minion.town#81). Recovery must not become an ambient
   authority that bypasses the capability model. Note that a parallel mentat job,
   `mentat-guest-peer-fetch-vs-invitation-20260923`, is evaluating guest peer-fetch against invitation.
   Read its tada report if it has finished.
4. **What survives from the existing SIWE work:** the portable thunk core in `deploy/thunks/siwe/`
   (19/19 tests) and the Cognito OIDC path. Decide whether recovery still needs the Cognito IdP or
   can be a smaller verifier. EIP-1271/ENS are almost certainly out of scope now; say so.
5. **Retire cleanly:** mark `designs/siwe-onchain-authz.md` superseded (keep it for history, with a
   pointer) and remove or annotate the policy-layer SIWE address-keyed allowlist shape if it no longer
   serves recovery. Re-scope the parked garden job `deploy-siwe-thunk-minion-town` (journal
   `jobs/plan/`, gate go-ahead): either rewrite its body to deploy exactly what the new design needs
   (its old precondition, design § 6 decisions 1 and 4, is moot) or withdraw it with
   `scripts/jobs/withdraw-plan.sh --by designer deploy-siwe-thunk-minion-town "<reason>"`. Do not
   promote it yourself.

Use the open-questions carve-out only for genuine maintainer decisions. Complete the job via the
normal completion path when done.
