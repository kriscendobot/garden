# Incorporate mhofman's repro-setup clarification into the ymax0 #9 investigation, then reply

**Repo:** `kriskowal/garden`, issue #9 — ymax0 v320 XS value-stack overflow. Active
reproduction is underway through `inquisitor`; kriskowal said "Continue" (22:11Z).

**New guidance — mhofman** (trusted contributor; comment 4848426883, 2026-06-30T22:28Z),
correcting the repro setup ("There is some confusion here"):
> The issue initially occurred on **devnet** upgrading **ymax0** (believed **v320**).
> No devnet snapshot is easily available, but **mainnet is believed to reproduce just
> as well**. On **mainnet** we can try to upgrade either **ymax0 (v290)** or
> **ymax1 (v288)**. The test should be an **upgrade of the existing deployment**
> (potentially as a **contract control upgrade message**).

**Task:** pivot the #9 reproduction to mhofman's corrected setup and reconcile the
version/network mapping (devnet ymax0 = v320; mainnet ymax0 = v290, ymax1 = v288).
Concretely:
1. Reconcile the current `inquisitor` repro against this: since **no devnet snapshot**
   is readily available, target a **mainnet** repro — an **upgrade of the existing
   mainnet ymax0 (v290) or ymax1 (v288) deployment**, exercised as a **contract
   control upgrade message** (not a fresh deploy), which is the path mhofman says
   should reproduce the devnet v320 failure.
2. Run it through the existing XS / chain-state repro tooling (mainnet chain state;
   the value-stack-overflow instrumentation, exit-12 signal) and report whether the
   overflow reproduces on the mainnet control-upgrade path.
3. **Reply to mhofman on #9** confirming the corrected plan, the version mapping you
   used, and the result — read his comment as trusted guidance and answer technically.

**Scope:** investigation only, on the bot's own infra / chain-state repro harness.
Do **NOT** touch upstream `agoric/agoric-sdk` (no upstream PRs or comments); keep all
artifacts on bot infrastructure. Bot identity; #9 is the garden's own issue.

---
claim:
  host: endolinbot2
  gardener: 42
  claimed_at: 2026-06-30T22:35:51Z
