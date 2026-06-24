---
title: Handshake Protocol
source: packages/ocapn-noise/README.md
source_repo: endojs/endo
source_commit: a1de705b
source_date: 2025-12-31
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn]
status: current
parent: endo--pkg-ocapn-noise-readme--usage
---

The OCapN Noise Protocol uses a 3-message handshake (SYN, SYNACK, ACK) based on
the Noise XX pattern with the following enhancements:

1. **Key Generation**: Each party generates:
   - An ephemeral X25519 key pair for encryption
   - An Ed25519 key pair for signing and verification

2. **Prefixed SYN Message**: The initiator sends:
   - **Cleartext prefix**: The intended responder's Ed25519 public verifying key (32 bytes)
   - **Encrypted payload**:
     - Their Ed25519 public verifying key
     - A signature of their X25519 ephemeral public key using their Ed25519 private key
     - Supported encoding versions

   The cleartext prefix enables relay/hub routing: a relay can read the intended
   recipient and forward the message without being able to decrypt its contents.
   The responder verifies this prefix matches their own public key.

3. **SYNACK Message**: The responder sends:
   - Their Ed25519 public verifying key  
   - A signature of their X25519 ephemeral public key using their Ed25519 private key
   - The negotiated encoding version

4. **ACK Message**: The initiator sends:
   - A final message to conclude the Noise Protocol handshake.

Each party verifies the other's signature to ensure they control both the
ephemeral encryption key and the static signing key, providing strong
authentication and preventing key substitution attacks.

Source: [packages/ocapn-noise/README.md](https://github.com/endojs/endo/blob/a1de705b/packages/ocapn-noise/README.md) at commit `a1de705b`.
