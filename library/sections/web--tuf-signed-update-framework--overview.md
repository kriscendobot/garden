---
title: "The Update Framework (TUF): signed software update channels for always-online nodes"
source_kind: web
source_url: https://theupdateframework.io/docs/metadata/
source_date: 2026-01-01
ingested: 2026-06-11
ingested_by: scholar
topics: [signed-updates, node-packaging]
status: current
notes: "TUF specification last updated January 2026 per search results. CNCF Graduated project since December 2019."
---

## Abstract

The Update Framework (TUF) is a CNCF-graduated specification and software framework that defends software update systems against a comprehensive threat model including repository compromise, signing-key theft, rollback attacks, and mix-and-match attacks. For an always-online appliance-style node (such as the Endo gateway), TUF provides the signing-key role hierarchy and metadata protocol that lets the node verify that software updates are authentic, current, and not downgraded. TUF uses separate online and offline keys to limit blast radius on key compromise, and short-expiry timestamp metadata to detect staleness quickly.

## Role hierarchy and metadata files

TUF defines four required top-level roles, each with a dedicated metadata file:

| Role | File | Key type | Signs | Typical expiry |
|---|---|---|---|---|
| Root | `root.json` | Offline | Specifies all other top-level role keys and threshold requirements | Long (1 year+) |
| Targets | `targets.json` | Offline | Hashes and sizes of software update artifacts; can delegate to sub-roles | Medium |
| Snapshot | `snapshot.json` | Offline (recommended) | Version numbers and hashes of all targets metadata files | Medium |
| Timestamp | `timestamp.json` | Online | Hash and size of snapshot.json; re-signed frequently | Short (days) |

**Online vs. offline keys**: The Timestamp role uses an online key because it must be re-signed automatically at regular intervals (to prevent clients from treating old metadata as current). The Snapshot role should use an offline key to limit damage if the timestamp key is compromised; separate keys prevent a compromised timestamp key from also signing fake snapshot metadata.

## Security properties

**Rollback attack prevention**: The `snapshot.json` file records version numbers for all metadata files, ensuring clients see a consistent view. An attacker who compromises one piece of infrastructure cannot present clients with a mix of old and new metadata files from different points in time (`snapshot.json` pins the consistent set). The `timestamp.json`'s short expiry means clients quickly detect if they are being fed stale metadata (a "freeze" attack).

**Threshold signatures**: Root metadata requires a threshold of N-of-M key signatures before it is accepted, so compromise of fewer than N keys does not allow an attacker to replace the root trust anchor.

**Delegation**: The Targets role can delegate signing authority for subsets of the target namespace to additional roles, each with their own keys. This allows a large software distributor to give different teams signing authority over different packages without sharing a single root key.

## Threat model

TUF defends against:
- Arbitrary software installation (attacker serves malicious update)
- Rollback attacks (attacker serves old known-vulnerable version)
- Indefinite freeze attacks (attacker prevents clients from seeing any update)
- Extraneous dependencies (attacker serves signed-but-wrong artifact)
- Mix-and-match attacks (combining metadata from different points in time)
- Wrong software mirrors (substituting packages from a different product line)
- Signing-key compromise for individual roles (isolated by key separation; root key compromise is the only total compromise)

## Deployment pattern for always-online appliance nodes

For an always-online node that receives automatic software updates:
1. The vendor maintains a TUF repository (typically a static file server or S3 bucket).
2. The Timestamp role's key is kept on the vendor's build infrastructure (online; re-signed on a schedule, for example daily or on every new release).
3. The Snapshot, Targets, and Root role keys are kept offline in hardware security modules (HSMs) or air-gapped signing ceremonies.
4. The node periodically fetches `timestamp.json`, verifies its expiry and signature, fetches `snapshot.json` if the hash changed, fetches `targets.json` if needed, and verifies the target artifact hash before applying the update.
5. On key rotation, the old root metadata delegates to the new root key; nodes performing a chain-of-trust walk from their shipped root certificate automatically pick up the rotation without manual intervention.

TUF is not designed for air-gapped nodes; it assumes connectivity to the update repository. For air-gapped scenarios, out-of-band metadata transfer is required.

Source: [The Update Framework - Roles and metadata](https://theupdateframework.io/docs/metadata/) and [TUF specification](https://theupdateframework.github.io/specification/latest/) retrieved 2026-06-11.
