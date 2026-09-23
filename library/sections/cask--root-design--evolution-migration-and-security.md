---
title: Evolution, Migration, and Security
source: doc/design/root-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

Abstract: How the CASK root evolves across schema versions and the security properties it must protect. **Schema versioning**: the `schema_hash` in `Links[0]` identifies the root structure version (ZeroHash means version 0; a non-zero value is the hash of a schema-definition block describing field layout, component versions, and migration requirements). **Migration via zippers**: when loading a root with a different schema version, load the old and new schema definitions, find or construct a zipper (old → new), apply it during load to produce the new-version structure, and optionally write the migrated structure with the new schema hash; zippers compose (v0→v1, v1→v2 chain to v0→v2). For **backward compatibility** a server accepts older schema versions (migrating on load), refuses unknown future versions (requiring an upgrade), and preserves the schema hash when not migrating. **Security considerations** span four areas: the identity private key (encrypt at rest with a strong KDF, never log, prefer an HSM in production, rotate on suspected compromise); sessions (confidentiality via ChaCha20-Poly1305, integrity via the Poly1305 tag, replay protection via counters, forward secrecy via ephemeral DH); cell capabilities (32-byte bearer tokens where possession is authorization, with no revocation short of key rotation); and cluster trust (membership in the `trusted` set grants consensus, replication, and routing, so it should require out-of-band verification, explicit administrative action, and audit logging). The document closes with five open questions: where the current-root hash is stored, how to rotate server identity keys, how to handle cluster partitions, whether multiple applications share a root, and whether sessions should be ephemeral or persistent.

## Evolution and Migration

### Schema Versioning

The `schema_hash` in Links[0] identifies the root structure version:

- **ZeroHash**: Version 0 (this document)
- **Non-zero**: Hash of schema definition block

Future versions will define schema blocks that describe field layout, component structure versions, and migration requirements.

### Migration via Zippers

When loading a root with a different schema version:

1. Load schema definition for old version.
2. Load schema definition for new version.
3. Find or construct zipper (old → new).
4. Apply zipper during load, producing new-version structure.
5. Optionally: write migrated structure with new schema hash.

Zippers are composable: v0→v1, v1→v2 can chain to v0→v2.

### Backward Compatibility

Servers should accept roots with older schema versions (migrate on load), refuse roots with unknown future versions (require upgrade), and preserve the schema hash when not migrating.

## Security Considerations

### Private Key Protection

The identity private key is the server's most sensitive secret: encrypt at rest with a strong KDF, never log or expose in errors, consider an HSM for production, rotate if compromise is suspected.

### Session Security

Sessions provide confidentiality (ChaCha20-Poly1305), integrity (Poly1305 tag), replay protection (counters), and forward secrecy (ephemeral DH in Option B). Session state in the table is encrypted; the session key itself is derived from the handshake and stored encrypted.

### Capability Security

Cell capabilities are bearer tokens: 32 bytes of cryptographic randomness, possession means authorization, no revocation without key rotation, so guard allocation carefully.

### Cluster Security

Membership in the `trusted` set grants participation in consensus, replication of data, and routing of requests. Adding peers to `trusted` should require out-of-band verification, explicit administrative action, and audit logging.

## Open Questions

1. **Root Storage**: where is the "current root hash" stored (file on disk, separate metadata store, multiple locations for redundancy)?
2. **Key Rotation**: how to rotate server identity keys (generate new pair, update membership on all peers, transition period with both keys)?
3. **Cluster Partition**: how to handle network partitions (Raft handles leader election, but what about long partitions and the rejoin protocol)?
4. **Application Isolation**: should multiple applications share a root (single application_hash suggests one app per server; cells could provide multi-tenancy; complexity-vs-isolation trade-offs)?
5. **Ephemeral vs Persistent Sessions**: the current design persists sessions; sessions could be purely in-memory (restart loses sessions vs disk I/O), or hybrid (persist long-lived, memory for short-lived).

Source: [doc/design/root-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/root-design.md) at commit `cdb975d8`.
