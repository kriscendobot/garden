# Topic: networking

> Abstract: Transport-layer networking design, as practiced by `kriskowal/cask` (CASK). CASK reacts against TCP's limitations (head-of-line blocking, congestion-loss confusion, bufferbloat, no in-flight priority or expiry, sliding-window coupling) by moving to a UDP substrate where every 1KB block is one independently-acknowledged datagram, encrypted with ChaCha20-Poly1305 over Noise IK sessions, and scheduled by a 256-bit priority figure that enables per-traffic-class load shedding. Seeded 2026-06-24 from the cask README. Distinct from `captp` and `ocapn` (capability-transport and the OCapN protocol family, which are about *what* messages carry, not the datagram substrate) and from `content-addressed-storage` (CASK's block-store side, with which it shares the block abstraction).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [cask--readme--overview](../sections/cask--readme--overview.md) | cask README | The 1KB block as the unit of both storage and block-at-a-time UDP transfer within the Ethernet MTU. |
| [cask--readme--why-1kb-blocks](../sections/cask--readme--why-1kb-blocks.md) | cask README | One block = one UDP datagram; packet loss is statistically independent block to block. |
| [cask--readme--what-tcp-costs-you](../sections/cask--readme--what-tcp-costs-you.md) | cask README | The TCP critique: HOL blocking, congestion-loss confusion, bufferbloat, no priority/expiry, sliding-window coupling; CoDel borrowing. |
| [cask--readme--storage-transport-single-abstraction](../sections/cask--readme--storage-transport-single-abstraction.md) | cask README | Blocks move over encrypted UDP and land in storage as the same bytes, no marshalling layer. |
| [cask--readme--priority-load-shedding](../sections/cask--readme--priority-load-shedding.md) | cask README | Traffic class + 128-bit trace → 256-bit priority; per-class backpressure; coordinated fan-out shedding. |
| [cask--readme--noise-cryptography](../sections/cask--readme--noise-cryptography.md) | cask README | ChaCha20-Poly1305 AEAD over a two-message Noise IK handshake; no DNS/TLS/CA; plaintext only on the local socket. |
| [cask--readme--protocols](../sections/cask--readme--protocols.md) | cask README | casknet (encrypted UDP, inter-node) vs casksock (plaintext Unix socket, local CLI↔daemon). |

## See also

- [`content-addressed-storage`](content-addressed-storage.md): CASK's block-store side; the 1KB block is shared between transport and storage.
- [`captp`](captp.md): capability transport protocol — the message semantics layer, a different concern from the datagram substrate.
- [`ocapn`](ocapn.md): the OCapN protocol family (netstring, noise, codecs) — note OCapN also uses Noise; the comparison is worth a future cross-link.
