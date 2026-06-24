---
id: casksock-local-protocol
aliases: ["casksock", "cask/sock", "cask.sock", "cask local protocol", "local unix socket protocol", "CLI-to-daemon protocol", "casw", "coll", "colr", "hedr", "nonc", "nncr", "ackn", "cask local socket"]
topics: [networking]
status: current
---

# casksock-local-protocol

CASK's plaintext, unencrypted protocol over a local Unix domain stream socket at `.cask/cask.sock` (relative to the store directory), used for CLI-to-daemon communication. It is trusted (no authentication or encryption) precisely because it is reachable only on the local machine and gated by filesystem permissions; SHA-256 hash validation of every block is the only integrity check. The command set is twelve 4-byte lowercase ASCII codes paired request/response: `stor`/`ackn` (store a block / batched acknowledgement), `load` (request a block; answered by a `stor`), `casw`/`casr` (compare-and-swap write / response), `coll`/`colr` (trigger GC / result), `head`/`hedr` (current HEAD hash / response), `nonc`/`nncr` (store nonce / response), `stop` (shutdown), `eror` (error). Store is reliable (retransmit until `ackn` or context expiry); `ackn` batches up to 32 hashes on an RTT-bounded hold-back timer; the send queue is CoDel-paced and ACKs ride the data queue with priority boosted by the blocks they acknowledge. Distinct from the encrypted inter-node casknet protocol (`[[casknet-wire-protocol]]`).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--protocol--casksock-transport-and-message-types](../sections/cask--protocol--casksock-transport-and-message-types.md) | The Unix-socket transport and the twelve-command inventory. |
| [cask--protocol--message-and-block-formats](../sections/cask--protocol--message-and-block-formats.md) | Byte-exact `stor`/`load`/`ackn` layouts and the 1024-byte body + 12-byte footer block format. |
| [cask--protocol--flow-reliability-and-security](../sections/cask--protocol--flow-reliability-and-security.md) | Store/load flow, reliable retransmit, CoDel pacing, priority-boosted ACKs, local-socket security posture. |
| [cask--readme--protocols](../sections/cask--readme--protocols.md) | The casknet-vs-casksock split from the README side. |

## See also

- [[casknet-wire-protocol]] — the **encrypted inter-node** counterpart; reversed-response commands over Noise-IK sessions. casksock is the local, plaintext sibling.
- [[content-addressed-block-store]] — the 1KB block that `stor`/`load` move.
- [[codel-send-buffer-shedding]] — the CoDel sojourn-time pacing casksock shares with the casknet send buffer.
- [[cask-protocol-v2-abandoned]] — the never-implemented UDP v2 that would have replaced this with uppercase commands.
