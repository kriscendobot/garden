---
role: designer
---

# Design + plan: open self-signup account creation for minion.town (dynamic authorization store)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws`, region us-west-1. **Secrets only in Secrets Manager.**

## Mandate

The maintainer chose **open self-signup**: any authenticated user (GitHub / Google / SIWE) is admitted with a **default baseline role**, no approval step. **Design + spec** the account-creation loop and the **dynamic authorization store** that replaces the static allowlist, plus the styled surfaces. Deliver a design doc + a phased plan with parked `--go-ahead` build follow-ons. **Security-sensitive — the baseline role is the crux.** Do NOT flip the live gate in this job; opening minion.town to everyone is consequential and goes live via reviewed follow-ons.

## The shift (current → target)

- **Current:** oauth2-proxy gates on a static email **allowlist** (`/etc/oauth2-proxy/allowed-emails.txt`, generated from `config/policy.json`); first-party authz is a static file (admins only); an unknown authenticated user gets **403** (the defect the maintainer hit).
- **Target:** oauth2-proxy admits **all authenticated users** (drop the email-allowlist gate; still require a *verified* identity — verification enforced at the thunks/Google, see DEPLOYMENT.md). Authorization becomes a **dynamic store**: a new identity is **auto-provisioned** with a baseline role on first sign-in; specific identities (admins) get elevated roles. The 403 disappears for authenticated users; an "insufficient privilege" surface remains only for actions above one's role.

## Design these

1. **Datastore = DynamoDB** (serverless — keeps the box light, it shares the garden fleet; AWS-native; already used for SIWE nonce state; access behind a small interface so a future CloudFlare/Netlify deploy can swap the backend per the portability directive). Define: table + key (`iss`+`sub`), attributes (email, provider, created_at, role, status), access patterns, and the reader interface the policy layer uses. Reconcile with `config/policy.json` (admins): seed admins into the store, or keep policy.json as a static override layered over the dynamic store — recommend one.
2. **The baseline role — least privilege (the crux).** Define exactly what scopes/tools a self-signed-up arbitrary user gets. Arbitrary GitHub/Google/wallet users must NOT get sensitive/mutating tools by default (e.g. NOT `summon_minion` / `mcp/minions:write`). Propose a conservative baseline (e.g. read-only `minion_status` only) and the elevation path (an admin grants more). Justify against the actual MCP tool/scope set (`src/auth/scopes.ts`).
3. **The account-creation loop.** First authenticated request from an unknown verified identity → auto-create the DynamoDB record with the baseline role → proceed. Decide where it runs (the MCP server / app policy layer at request time vs. the pre-token-gen Lambda — the Lambda can't cleanly do DB writes; trade-off table). Idempotent; handle the first-request race.
4. **The oauth2-proxy gate change.** Exact config to drop `authenticated_emails_file` (admit all authenticated) while preserving: verified-identity enforcement, the break-glass path, and the ungated MCP Bearer surface. Spell out the security implications (anyone with a GitHub/Google account or a wallet can now reach the app shell at baseline).
5. **Styled surfaces (subsumes the earlier "403 not consistently styled" item).** One minimal aesthetic (matching the login + SIWE wallet pages) for the authenticated landing (exists) and any remaining **insufficient-privilege** page — styled, states the user's role and how to request elevation. No bare oauth2-proxy 403/500.
6. **SIWE / on-chain tie-in (forward path, not v1).** How Tier-2 on-chain gating (`designs/siwe-onchain-authz.md`) composes with self-signup — e.g. hold asset X → elevated role auto-granted.

## Deliverables

- `designs/account-creation-open-signup.md` — the above with recommendations + a **threat model** (open-signup abuse, baseline-role blast radius, DynamoDB cost/DoS, admin bootstrap/lockout).
- A phased build plan; parked `--go-ahead` follow-on build jobs (DynamoDB table + policy-layer store + auto-provision; the gate change; the styled insufficient-privilege surface), each naming any maintainer decision it needs.
- Optionally a runnable local toy of the auto-provision + baseline-intersection logic (mirroring the mcp-oauth toy), with tests.

Keep coupling loose; secrets only in Secrets Manager. **Spec only — no live gate change in this job.**
