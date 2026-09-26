No lingering processes; HEAD == origin/main2 at my commit. Job complete.

---

## Completion report

**Job intent:** kriskowal asked on kriskowal/garden#9 whether the new methodology insights (install-bundle-first + the faithful contract-control upgrade path) require rerunning the ymax0 v320 XS value-stack-overflow experiment to reproduce and validate — and if so, to do it.

**Answer: yes, and it's done.** The rerun was both warranted and, this time, *complete*, because the one input every prior round flagged as the blocker — the over-threshold "devnet v320" `bundle-ymax0.json` — turns out to be a **downloadable `ymax-v0.3.2606-beta3` release asset** (866 KB, 10 `.flatMap(` sites incl. the `hex.js` decodings table). Prior rounds had it wiped or used a stand-in without it.

**What I ran (real-execution evidence):** Rebuilt the inquisitor host in a `kriscendobot/agoric-sdk` worktree (better-sqlite3 native binding via node-direct prebuild-install; built the two worker bundles), then ran the A/B on the cached real mainnet swing-store `agoric-26146641` through a real on-chain XS worker via the `createVat` import vector:
- **control** (stock beta3 bundle, `b1-7b73897d…`) → `Vat Creation Error: Stack meter exceeded` — overflow *during* import.
- **patched** (`hex.js` flatMap→`for`+`.set()` loop, one flatMap removed 10→9, `b1-6648cdf3…`) → `lacks buildRootObject()` — imports/evaluates clean, *past* the overflow.

The single-flatMap delta flips overflow→clean import on real chain state. I also exercised the more-faithful EV-direct contract-control upgrade vector (`upgrade(bundleId)` on the live v1-owned ymax0 `ContractControl`), but its delivery is subject to the documented overlay wallet-bridge caveat, so I reported it as corroborating, not decisive — did not over-claim it.

**What changed (committed + pushed to main2, `5f3222b40`):**
- `skills/agoric-chain-snapshot/SKILL.md` — recorded that missing-input (1) is resolved (bundle is a beta3 release asset) with the verified A/B outcomes.
- `skills/agoric-chain-snapshot/repro/` — committed the durable drivers prior rounds kept losing to redeploys: `repro-createvat-driver.mjs`, `repro-cc-direct-driver.mjs`, `patch-hex-bundle.mjs` (re-verified to reproduce `b1-6648cdf3…` byte-for-byte), and a README.

**Replied on the issue thread:** https://github.com/kriskowal/garden/issues/9#issuecomment-4849474721 (issue left open for the submitter to close).

**Follow-ups:** (1) The fully wallet-envelope-faithful contract-control run still needs the inquisitor overlay's inbound `WALLET` bridge wired (or the control wallet revived) — the EV-direct shortcut is the current stand-in. (2) A built agoric-sdk worktree remains at `/home/kris/scratch/as9repro` as a reusable build cache alongside the `agoric-26146641` snapshot, so the next rerun is minutes, not a full rebuild. Scope throughout: read-only analysis + on-host runs of the open-source XS worker and public release assets on bot forks only; no upstream `agoric/agoric-sdk` interaction.
