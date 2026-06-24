---
title: Protocols (casknet, casksock)
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: CASK has two independent wire protocols. **casknet** (`net`) is encrypted UDP for inter-node block transfer: ChaCha20-Poly1305 AEAD over Noise IK sessions. **casksock** (`sock`) is a plaintext Unix domain socket for local CLI-to-daemon communication. The split is the same one that runs through the rest of the design: remote traffic is always encrypted and authenticated, local traffic relies on filesystem permissions.

CASK has two independent wire protocols:

- **casknet** (`net`): Encrypted UDP for inter-node block transfer. ChaCha20-Poly1305 AEAD, Noise IK sessions. (See the `net-crypto` and `net-session-init-design` docs.)
- **casksock** (`sock`): Plaintext Unix domain socket for local CLI-to-daemon communication. (See the `protocol` doc.)

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
