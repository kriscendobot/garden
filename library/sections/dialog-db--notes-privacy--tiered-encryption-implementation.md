---
title: Tiered (nested-layer) encryption implementation
source: notes/privacy.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: The four access levels are realized as **nested encryption layers** on each node, so decrypting an outer layer reveals only the next layer's metadata, never the layers within. **L1 (outer)** encrypts child references — decrypt to traverse blob connectivity. **L2 (middle)** encrypts key-range information and wraps the L3 content — decrypt to validate tree structure. **L3 (inner)** encrypts the actual fact values, with different keys for different fact groups. Keys are **hierarchical**, derived from a root key into per-level access keys and, within L3, per-group keys; the scheme supports key rotation without rebuilding the entire tree. This onion structure is what makes the L0–L3 tiers a cryptographic guarantee rather than a policy convention: an L1 actor physically cannot read L2/L3 because it lacks those keys.

The multi-layered encryption approach is implemented through a nested structure per node — Outer (L1, blob connectivity) wraps Middle (L2, key ranges) wraps Inner (L3, fact values):

1. **Level 3 encryption (inner layer)**: encrypts the actual fact values; can use different encryption keys for different fact groups; only accessible to authorized collaborators.
2. **Level 2 encryption (middle layer)**: encrypts key-range information; wraps the L3-encrypted content; enables tree-structure validation.
3. **Level 1 encryption (outer layer)**: encrypts child references; wraps the L2-encrypted content; enables basic blob-connectivity traversal.

**Key derivation and management**:

- **Hierarchical keys**: access keys are derived from a root key (root → L1/L2/L3 access keys → within L3, Group A/B/C keys).
- **Group-specific keys**: within L3, different groups have different keys.
- **Key distribution**: keys are securely distributed to authorized parties.
- **Key rotation**: supported without rebuilding the entire tree.

Because each level's information is wrapped by the level below it in the onion, holding an L1 key decrypts only child references; the L2 and L3 payloads stay ciphertext. The tier is therefore enforced by key possession, not by a trusted server honoring a policy — the L0 infrastructure never holds any of these keys.

Named security considerations: key management (secure storage and rotation), authorization validation (proper UCAN-chain validation), side-channel attacks (metadata leakage), forward secrecy (key-rotation strategies), and revocation (revoking delegated access).

Source: [notes/privacy.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/privacy.md) at commit `f777fe7c`.
