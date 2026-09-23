---
source: designs/gateway-package.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/design/gateway-package/designs/gateway-package.md
source_path: designs/gateway-package.md
source_branch: design/gateway-package
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 174
lane: designs
status: current
title: §Frame-relay-without-decryption (Feature 6)
parent: endo-but-for-bots--llm-designs-gateway-package--ten-feature-decomposition-of-one-package-with-one-factory-many-configurations
---

> *The gateway sees only Noise-encrypted ciphertext after
> the handshake; relay targets receive the same ciphertext
> and complete the handshake themselves.*

§Gateway-is-a-frame-relay-and-never-decrypts. §End-to-end-
encryption-survives-the-relay.

§Noise-handshake's-intended-responder-prefix tells gateway
which target to forward to **before handshake completes**.
§Routing-decided-from-cleartext-prefix; §encrypted-body-
passes-through.

§Cycle-162's-Ken-protocol-FIFO-via-TCP-not-receive-side-
reordering has the §borrow-property-from-lower-layer
sibling: there, FIFO comes from TCP; here, encryption +
peer-auth come from Noise.

§The-gateway-doesn't-need-to-be-a-trusted-third-party:
it routes ciphertext but cannot read it. §Confidentiality-
survives-relay.
