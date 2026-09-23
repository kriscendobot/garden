---
title: §the-local-IPC-socket-IS-the-local-attestation, not-a-separate-check (first-explicit-observation)
section-slug: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
source-slug: endo-but-for-bots--llm-designs-endo-gateway
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-gateway.md
authors: [Kris Kowal (prompted)]
status: Proposed
created: 2026-05-10
updated: 2026-05-10
ingest-cycle: 283
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 997
parent: endo-but-for-bots--llm-designs-endo-gateway--same-binary-two-configurations-and-host-scope-vs-user-scope-and-outbound-registration-and-pubkey-routing-and-noise-not-tls-and-content-addressed-cache-at-relay
---

**Decision: a local-only IPC channel is the local-attestation mechanism**, not a credential check on top of a TCP socket. The IPC channel is local-by-construction: a registration that arrives over the local IPC socket is, by construction, from a process on this host; **"local" is then a property of the channel rather than of any kernel-credential check or attested secret**.

**§the-channel-IS-the-property shape as named design move** (first-explicit-observation): instead of "open a generic transport + check the credential", the design uses "use a transport whose presence-of-traffic is the credential". This is `the-shape-of-the-pipe-IS-the-attestation` — a pattern with very low complexity surface.

**§three-named-rejected-alternatives section** (first-explicit-observation in design pattern terms): the design explicitly names two rejected alternatives **with the reason for rejection**:

1. **Loopback TCP plus a kernel credential check** (`SO_PEERCRED` on Linux, `LOCAL_PEERCRED` on macOS, `GetNamedPipeClientProcessId` on Windows) — *works, but requires per-OS kernel-API plumbing for what is otherwise the same property the IPC channel gives us by construction*.
2. **Cryptographic attestation backed by a host-only secret** (TPM-sealed key, file readable only by the local daemon at boot) — *heaviest infrastructure, gains nothing over the IPC channel on a cooperative host*.

The accepted choice is named alongside its rejected alternatives, with the rejection rationale that names what the alternatives **would gain** and **what they would cost**.
