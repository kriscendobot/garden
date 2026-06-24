---
title: Transport Key Derivation and Forward Secrecy
source: doc/design/net-crypto.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: How casknet turns the completed Noise IK handshake into the keys that protect data traffic, and why those keys survive long-term-key compromise. After the handshake both sides call `Split()` on the symmetric state to produce two 32-byte transport keys via the Noise two-output HKDF over HMAC-BLAKE2b: `temp_key = HMAC-BLAKE2b(chaining_key, "")`, `k1 = HMAC-BLAKE2b(temp_key, 0x01)`, `k2 = HMAC-BLAKE2b(temp_key, k1 || 0x02)`. The keys are **directional**: the initiator encrypts with `k1` and decrypts with `k2`, the responder does the reverse, so a packet one side encrypts can only be decrypted by the other. **Forward secrecy** follows because each handshake generates fresh ephemeral x25519 keypairs and the transport keys derive from DH operations involving those ephemerals (`ee`, `es`, `se`); compromise of a node's long-term ed25519 key does not reveal past session keys, since only the discarded ephemeral private keys could. This is a marked improvement over the previous PSK design, where compromise of the PSK revealed all past and future session keys.

## Transport Key Derivation

After the two-message Noise IK handshake, both sides call `Split()` on the symmetric state to produce two 32-byte transport keys:

```
k1, k2 = HKDF(chaining_key, empty)
```

where HKDF uses HMAC-BLAKE2b:

```
temp_key = HMAC-BLAKE2b(chaining_key, "")
k1       = HMAC-BLAKE2b(temp_key, 0x01)
k2       = HMAC-BLAKE2b(temp_key, k1 || 0x02)
```

The initiator uses `k1` to encrypt (send) and `k2` to decrypt (receive). The responder uses `k2` to encrypt and `k1` to decrypt. This provides **directional keys**: a packet encrypted by one side can only be decrypted by the other.

## Forward Secrecy

Each handshake generates fresh ephemeral x25519 keypairs on both sides. The transport keys derive from DH operations involving these ephemeral keys (`ee`, `es`, `se`), so compromise of a node's long-term ed25519 key does not reveal past session keys: only the ephemeral private keys (discarded after the handshake) could do that.

This is a significant improvement over the previous PSK-based design, where compromise of the PSK revealed all past and future session keys.

Source: [doc/design/net-crypto.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-crypto.md) at commit `cdb975d8`.
