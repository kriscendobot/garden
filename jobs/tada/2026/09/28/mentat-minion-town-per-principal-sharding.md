# Completion report: mentat-minion-town-per-principal-sharding

**Deliverable.** `designs/per-principal-sharding.md` on `kriscendobot/minion.town`, draft PR **[#124](https://github.com/kriscendobot/minion.town/pull/124)** (head `design/per-principal-sharding` @ 048d889, base frozen snapshot `main-f69bf87`, opened via `ensure-pr.sh` with the durable job marker; `--find-only` first confirmed no prior claimant's PR). Left **draft** per the manual-gauntlet regime; the maintainer promotes it with "run the gauntlet #124".

**What the design says.** A shard per principal (user / guest / agent), keyed by the invitation design's opaque `accountId`, comprising: the principal's own node Ed25519 keypair (grounded in the verified fact that a formula identifier is `<number>:<node>` with `node = toHex(rootKeypair.publicKey)`, so per-principal daemons make per-principal key material fall out of the topology), a per-shard DEK wrapped by an operator KEK (closing the plaintext-keys-in-SQLite gap and superseding the single `GUEST_RECOVERY_KEY`), a per-shard DB partition and independent CAS behind the daemon's real `DaemonicPersistencePowers`/`makeContentStore` seams, and a sleepable formula-manager worker (thixotrope model, snapshot layer per sibling PR #123) plus metered additional workers. It covers rotation-as-shard-succession (reusing `siwe-guest-recovery`'s atomic bond-update contract), a thin no-authority routing layer with the surviving global singletons enumerated, cross-shard OCapN references via invitation-carried introductions and sturdy publications, isolation guarantees with honest limits, per-principal metering with ERTP cross-shard settlement (resolving the `clip-usage-metering` § 3 vs § 10 dedup-pricing tension in favor of per-principal storage), per-platform realization (AWS partition+prefix, Cloudflare DO-per-principal, fly.io Machine-per-principal, Hetzner/DO template units, exe.dev VM-per-principal) with an idle-shard cost column, a six-step reversible migration from the shared daemon (lobby shard for anonymous `web-<uuid>` guests), an ownership map, and clearly marked cross-repo Endo implications (no endo edits proposed).

**Open questions for the maintainer** (design § 13): migration-by-credential-rotation acceptability; agents as principals vs sub-workers; lobby shard vs micro-shards for anonymous guests; per-principal storage pricing (abandoning cross-tenant dedup); routing layer platform-native vs cross-offering; DEK travel across offerings at migration; which offering pilots first.

**Proposed build sequence** (suggested basenames, not posted): `build-minion-town-account-id-spine`, `design-endo-daemon-persistence-key-seams`, `build-minion-town-per-shard-cas`, `probe-minion-town-two-shard-daemons`, `design-endo-node-succession`, `build-minion-town-shard-onboarding`, `design-minion-town-cross-shard-settlement`, `build-minion-town-shard-migration`.

**Verification.** The mermaid fence parses (`mermaid.parse` OK, flowchart-v2). Definite Endo claims spot-verified against `llm` source (`formula-identifier.js` id grammar, `manager.js` node derivation, `manager-database.js` schema, `types.d.ts` persistence powers). Style checked: zero em-dashes (matching the newest sibling design), no Latin shorthand, no typist-unfriendly code points. Not verified: nothing executable was built (design-only job).

**Housekeeping.** Journal `result` entry posted (`entries/2026/09/28/063558Z-result-designer-723ddb.md`). Job inbox empty (the `inbox-read.sh` helper's fresh clone timed out twice, rc=124; verified empty by reading the journal worktree's inbox directory directly — worth noting as a possible slow-clone follow-up, not blocking). Scratch validator dir cleaned. Sibling cross-references: PR #123 landed and is cited; the three backend-plan siblings had not landed and are referenced by their expected filenames.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-minion-town-per-principal-sharding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (5065551 cached reads)
- Output: 44083 tokens
- Cost: $13.1533312
- Wall-clock: 784s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
