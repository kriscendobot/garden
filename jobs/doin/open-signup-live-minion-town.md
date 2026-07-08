---
role: builder
---

# minion.town: open self-signup — build the account store AND open the gate, live (no feature flag)

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`. AWS CLI `~/.local/bin/aws` (install via `bash scripts/aws/install-aws-cli.sh` if absent), region us-west-1. Box access SSM only (`i-0380cd68b90020fad`). **Secrets only in Secrets Manager.**

Design: `designs/account-creation-open-signup.md` (read it). This job **collapses the design's two staged jobs (`build-account-store-minion-town` + `open-signup-gate-flip-minion-town`) into ONE live rollout** and **supersedes both parked jobs — do not run those.** Per the maintainer: there are **no existing users**, so the `ACCOUNT_AUTOPROVISION=off` dark-launch feature flag is unnecessary complication — build the store enabled and open the gate in one go (but still verify the store works BEFORE dropping the allowlist, within this run).

## Maintainer decisions (2026-07-08)
- **Baseline role = `guest`** — rename the design's `visitor` → `guest` everywhere; same semantics: `mcp/tools` only (town status count). NO roster read, NO write/`summon_minion`, NO admin.
- **All guests are alike** — no elevation/roles beyond `guest` + the existing admin overlay for now. **Omit** the styled "request more access" / elevation surfaces and the elevation contact (design's job #3 `styled-privilege-surfaces` is deferred). A host/admin tier comes later.
- **No feature flag** — autoprovision on; gate opened live.
- **Context (NOT this job): Stripe credits next.** Guests will buy credits to meter usage. Shape the guest account record so a future per-guest **credit balance / metering** field slots in cleanly (the account record is its natural home). Do not build Stripe here.

## Do
1. **Account store (DynamoDB)** per the design: table `minion-town-accounts` keyed `iss`+`sub` (attributes: email, provider/`idp`, created_at, role, status; leave room for a future credit balance). The portable `AccountStore` reader interface; IAM read+provision. Wire it into the app policy layer (`resolveEffectiveScopes` = `(static overlay ∪ dynamic) ∩ token`), auto-provisioning an unknown **verified** user as `guest` at request time (idempotent conditional-put; exclude machine/client-credentials principals via `idp`/`token_use`). Admins stay in the `config/policy.json` overlay.
2. **Open the gate:** oauth2-proxy — drop `authenticated_emails_file`, set `email_domains = ["*"]` (admit all *verified* authenticated users). Preserve: thunk/Google verified-identity enforcement, the break-glass path, the ungated `/mcp` Bearer surface. Commit the config to the repo + deploy via the deploy scripts. The hand-added allowlist entries become moot (that is the point).
3. **Deploy + verify live:**
   - A fresh identity NOT in `policy.json` signs in → auto-provisioned `guest` → reaches the landing; the app grants only `mcp/tools` (status count); `list_minions` / `summon_minion` denied for a guest.
   - Admin identities (maintainer GitHub/Google, break-glass) still get full scopes via the overlay.
   - `/mcp` Bearer still works. No config drift (box matches repo). Update `DEPLOYMENT.md` (open-signup posture, `guest` baseline, allowlist retired).

## Guardrails
- Opening the gate is the consequential act — **verify the store + baseline enforcement work BEFORE dropping the allowlist within this run**; if the store isn't provably working, do NOT drop the allowlist and surface to the maintainer.
- Least privilege: a compromise of the account store must never mint write/admin — the role ladder tops at `guest` (and read, if the design kept `resident`); write + admin only via the git-audited overlay.
- Secrets only in Secrets Manager; keep the store access behind the portable interface (provider-portability).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 18
  claimed_at: 2026-07-08T01:21:11Z
