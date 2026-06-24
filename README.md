# Garden bulletin

_As of 2026-06-24T22:56:14Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh, with a
journalist's narrative in the Latest section. This page (the journal's README.md)
IS the bulletin; the journal's layout and design narrative lives in [DESIGN.md](DESIGN.md).

## Messages to the maintainer

- `20260624T222907Z-d848e0` — from gardener:research-siwe-oauth-providers, reply_to `research-siwe-oauth-providers` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260624T222907Z-d848e0.md)

> # Research: OAuth/OIDC "Sign in with your Ethereum address" (SIWE landscape)
>
> **TL;DR.** The standard is **SIWE / ERC-4361**: a wallet (MetaMask) signs an
> ERC-191 message bound to your domain + a nonce; the relying party recovers the
> signer to the address (or calls **EIP-1271 `0x1626ba7e`** for smart-contract
> wallets) and binds the session to the immutable address. Raw SIWE is **not**
> OAuth/OIDC — bridging it to standard OIDC is what **Spruce ID's `siwe-oidc`**
> does (the only standards-native bridge found). Most "web3 auth" SaaS (Privy,
> Dynamic, Magic, Web3Auth→MetaMask Embedded Wallets) are a *different shape*:
> social-login embedded wallets that **consume** OIDC, not "sign in with your
> existing address."
>
> | Option | Custody | OIDC posture | Host | OSS / License | Notes |
> |---|---|---|---|---|---|
> | **Spruce `siwe-oidc`** | Non-custodial | **Issues standard OIDC** (`sub`=address) | **Self-host** (Rust+Redis / CF Worker) or hosted | **Apache-2.0/MIT** | Only standards-native bridge; **but v0.1.0, unaudited, ~2yr-stale** — verify upkeep |
> | **`siwe` lib + NextAuth/Auth.js** | Non-custodial | JWT session in your app (no OIDC endpoint) | **Self-host** | **OSS** | Mature, lowest-dependency; you own nonce store |
> | **thirdweb Auth / Reown AppKit** | Non-custodial | SIWE-compliant **SDK** (not an IdP) | SaaS + OSS SDK | **OSS SDKs (Apache-2.0)** | Active; SDK lock-in for full stack |
> | **Auth0 + SIWE** | Non-custodial | **Standard OIDC** (backed by Spruce IdP) | SaaS (Okta) | Integration over OSS IdP | From Apr 2022; **2026 status unconfirmed** |
> | **Privy / Dynamic / Magic / MetaMask Embedded Wallets** | Non-custodial MPC/TSS | **Consumes** OIDC (BYO IdP) | SaaS | Proprietary | Social-login embedded wallets, *not* address-as-identity. Consolidating: **Privy→Stripe**, **Web3Auth→Consensys/MetaMask** (both 2025) |
>
> **No first-party MetaMask "OIDC IdP keyed on your address" exists** — MetaMask SDK
> + SIWE-on-your-backend is the canonical path.
>
> **Recommendation.** For a decentralization-minded project wanting OAuth-style
> "sign in with your Ethereum address":
> - **Default: `siwe` library + NextAuth/Auth.js CredentialsProvider** — fully
>   self-hosted, mature, lowest dependency, you own verification + JWT session. No
>   OIDC discovery endpoint, but you don't need one unless federating to third
>   parties.
> - **If you genuinely need a standard OIDC IdP** to federate the Ethereum identity
>   to other relying parties: **`siwe-oidc`** — but **vendor/fork it** given the
>   staleness, and confirm 2026 maintenance first.
> - **Avoid** the embedded-wallet SaaS (Privy/Dynamic/Magic/Embedded Wallets)
>   unless mainstream non-crypto onboarding is a hard product requirement — they
>   solve custody-UX, not address-sign-in, and reintroduce the SaaS lock-in SIWE
>   was meant to remove.
>
> **Method/confidence:** 6-angle deep-research fan-out (23 sources, 109 claims, top
> 25 adversarially 3-vote-verified, 0 killed) over primary specs + provider docs,
> plus a supplementary pass for providers the fan-out left unverified. §1–§2
> (standards + Spruce/Auth0) are verified to the adversarial bar; embedded-wallet
> rows are vendor-stated. Flagged unknowns: Auth0+SIWE 2026 availability; whether
> `siwe-oidc` is still maintained (staleness signals).
>
> **Full source-cited report** (per-provider detail, every citation, the MetaMask
> credential path, caveats): journal entry
> `entries/2026/06/24/222655Z-result-gardener-siwe-oauth.md` (commit `96011938` on
> `journal2`).

- `20260624T223047Z-ff38ba` — from gardener:harden-fleet-gh-identity, reply_to `harden-fleet-gh-identity` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260624T223047Z-ff38ba.md)

> Heads-up from job harden-fleet-gh-identity (gardener-21): the live tree
> /home/kris/scripts/jobs/common.sh has SUBSTANTIAL UNCOMMITTED work — a flock-based
> "per-clone serialization (shared-clone race fix)" adding clone_lock/clone_unlock
> and rewiring ensure_clone/sync_clone/commit_and_push — that is NOT in origin/main2.
>
> Impact: this dirty file WEDGES garden-watchman (its fast-forward aborts on a dirty
> tree), so NO origin/main2 change is auto-deploying to the live /home/kris tree for
> ANY job, garden-wide — it has been stuck at 51030653 while origin advanced.
>
> I did NOT touch/clobber that WIP. I deployed my own fix non-destructively (added
> scripts/jobs/bin/gh; applied my PATH hunk to a different region of the live
> common.sh), so the gh-identity fix is live now and the flock WIP is intact.
>
> Needs a human/owner call: is that flock work an in-flight job that should be
> committed to origin/main2, or abandoned? Until it's committed (or reverted) the
> watchman stays wedged and the live tree won't track origin. I left it untouched
> because committing someone else's untested WIP isn't mine to decide.


## Board
### todo (0)
(none)

### doin (7)
- `apply-503-feedback` — Apply maintainer meeting feedback to endo-but-for-bots #503
- `bulletin-message-links-or-body` — Bulletin: link each maintainer message, or include its full body
- `finish-ebfb-pr96` — Finish endo-but-for-bots #96 implementation as designed
- `fix-comment-watcher-timer-and-classification` — Make the comment-watcher actually fire, and catch plain-language maintainer d...
- `harden-producer-push-path` — Harden the producer push path: confirm the push landed; fix the shared-clone ...
- `scholar-ingest-cask-4` — Scholar: continue the library ingest of kriskowal/cask (cycle 5)
- `scholar-ingest-cask` — Scholar: deepen the library ingest of kriskowal/cask

### tada (83)
- `research-frb-endo-exo-collections` — Done. The deliverable is live on origin/journal2 and the temp worktree, stale...
- `scholar-ingest-cask-3` — Completion report — scholar-ingest-cask-3 (cask library ingest, cycle 4)
- `reliable-pause-resume` — Awaiting the clean test run's completion.
- `build-github-mention-watcher` — Completion report
- `scholar-ingest-collections-operators` — The work is complete. Here is my report.
- … and 78 more

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners

## Recent progress
- 223157Z-progress-gardener-2638ba.md: gardener-6 on endolinbot completed job bulletin-show-job-descriptions
- 223205Z-progress-gardener-e14fc4.md: gardener-28 on endolinbot completed job improve-mentor-journalctl-timeout
- 223209Z-progress-gardener-bc45df.md: gardener-52 on endolinbot completed job scholar-ingest-cask-2
- 223400Z-progress-gardener-f09815.md: gardener-70 on endolinbot completed job scholar-ingest-collections-operators
- 223601Z-message-mentor-269acb.md: ## Maintainer authorization — GitHub-wide @kriscendobot mention watch (sender-gated)
- 223644Z-progress-gardener-51697d.md: gardener-69 on endolinbot completed job build-github-mention-watcher
- 224044Z-progress-gardener-c928a9.md: gardener-44 on endolinbot completed job reliable-pause-resume
- 224501Z-progress-gardener-9f65c3.md: gardener-30 on endolinbot claimed job apply-503-feedback
- 224645Z-result-scholar-3840b7.md: # Result: cask library ingest cycle 4 — the GC family, dbstore, and cryptography.md
- 224647Z-progress-gardener-b6b4c0.md: gardener-29 on endolinbot claimed job fix-comment-watcher-timer-and-classification
- 224655Z-progress-gardener-bb7521.md: gardener-67 on endolinbot claimed job research-frb-endo-exo-collections
- 224707Z-progress-gardener-f6906b.md: gardener-17 on endolinbot claimed job bulletin-message-links-or-body
- 224955Z-progress-gardener-23a5b3.md: gardener-15 on endolinbot claimed job scholar-ingest-cask-4
- 225100Z-progress-gardener-032196.md: gardener-62 on endolinbot completed job scholar-ingest-cask-3
- 225605Z-progress-gardener-4688a1.md: gardener-67 on endolinbot completed job research-frb-endo-exo-collections
## Latest

The Endo exo-collections FRB research job completed (gardener-67), the only board move this tick, leaving seven jobs in flight and the todo queue empty. Two maintainer messages need a human eye. The louder one: gardener-21 reports the live `/home/kris/scripts/jobs/common.sh` carries substantial uncommitted flock-based "per-clone serialization" WIP that is *not* on origin/main2 — and that dirty tree has **wedged garden-watchman**, so no origin/main2 change has auto-deployed garden-wide since 51030653. The gh-identity fix was landed non-destructively around it, but someone needs to decide whether that flock work gets committed or reverted before deploys resume. Separately, the SIWE/OAuth research deliverable landed: the recommendation is the self-hosted `siwe` library + NextAuth path, with `siwe-oidc` only if a standard OIDC IdP is genuinely needed (and only after vendoring, given staleness). Background: scholar's cask ingest reached cycle 4 and the GitHub mention-watcher build completed.
