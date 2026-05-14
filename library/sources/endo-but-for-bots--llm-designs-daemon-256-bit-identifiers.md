---
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: **Status: Complete** upstream. The migration prerequisite that the locator-terminology rename ([[endo-but-for-bots--llm-designs-daemon-locator-terminology]]) builds on; *NodeNumber/FormulaNumber* brand types established here are what `dlt` later renames to *PeerKey/FormulaAddress*. Introduces the `keypair` formula type — the 26th and (at the time of this design) most recent addition to the daemon's formula-type taxonomy. The `@keypair` special name + the per-agent keypair formula are the mechanism the `LOCAL_NODE` sentinel in `dlt` rests on. Migration is **breaking**: no backward compatibility with 512-bit state; users purge `~/.local/state/endo/`.
---

> Abstract: Migration of the Endo daemon's identifier scheme from **512-bit / 128-char hex to 256-bit / 64-char hex**, aligning with OCapN-Noise's Ed25519 peer-identification. Four concrete shifts: (1) Node ID is now the **Ed25519 public key directly** (not a SHA-512 derivation); (2) formula numbers are 256-bit random via `randomHex256()`; (3) content addressing uses SHA-256 instead of SHA-512; (4) `FormulaNumber` and `NodeNumber` become branded 64-char-hex types in `types.d.ts`. The `CryptoPowers` interface (`{makeSha256, randomHex256, generateEd25519Keypair}`) is the narrow boundary; *key persistence is not a crypto concern*. Per-agent keypairs (formerly only the daemon root keypair) — each host and guest gets its own Ed25519 keypair stored as a `keypair` formula in the formula graph, accessed via the `@keypair` special name. Key material lives in the formula JSON file (same security posture as the existing `nonce` file). Complete 26-formula-type taxonomy enumerated. Security: 256-bit identifiers retain effective 128-bit floor under birthday / Grover attacks — sufficient by any practical measure. **Breaking migration**: state purge required; OCapN-Noise wire protocol unchanged because it already used Ed25519. The structural choice — peer ID *is* the Ed25519 public key, not a separate handle — is what later designs like `dcpg` and `dlt` build on.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-original-state](../sections/endo-but-for-bots--llm-designs-d256--problem-and-original-state.md) | daemon, capability-security | current |
| [identifier-migration-and-crypto-powers](../sections/endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers.md) | daemon, capability-security, patterns | current |
| [per-agent-keypairs](../sections/endo-but-for-bots--llm-designs-d256--per-agent-keypairs.md) | daemon, capability-security, persistence, agent-conventions | current |
| [formula-types-and-security](../sections/endo-but-for-bots--llm-designs-d256--formula-types-and-security.md) | daemon, capability-security | current |

## See also

- `daemon-locator-terminology.md` (`dlt`) — renames the brand types established here (Node Number → Peer Key, Formula Number → Formula Address)
- `daemon-cross-peer-gc.md` (`dcpg`) — uses the per-peer Ed25519 public key as the retention-set's `guest_public_key`
- `daemon-persistence.md` (PR #3121, `dp`) — Formula Persistence model; the formula-type taxonomy enumerated here is what `dp` discusses abstractly
- `daemon-agent-network-identity.md` — referenced as the followup (network registration, per-agent connection hints, locator construction, null local node sentinel); not yet ingested
