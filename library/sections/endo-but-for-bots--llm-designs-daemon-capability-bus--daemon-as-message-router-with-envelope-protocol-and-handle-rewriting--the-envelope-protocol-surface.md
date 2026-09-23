---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: The envelope-protocol surface
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

The §Subprocess protocol section defines what *one wire format for
every subprocess* actually means. All subprocesses — manager and
workers alike — communicate with the daemon using the same envelope
protocol on fd 3/4. The pipe layout:

| fd | Direction | Purpose |
|----|-----------|---------|
| 0  | inherited | stdin (unused, closed) |
| 1  | inherited | stdout → daemon log capture |
| 2  | inherited | stderr → daemon log capture |
| 3  | child → parent | CBOR-framed envelopes from subprocess |
| 4  | parent → child | CBOR-framed envelopes to subprocess |

Each envelope is a four-tuple CBOR array:

```
[handle: uint, verb: text, payload: bytes, nonce: uint]
```

- **handle** identifies the target (outgoing) or sender (incoming)
- **verb** is the operation name (`"init"`, `"spawn"`, `"deliver"`,
  `"ready"`, `"log"`, ...)
- **payload** is CBOR-encoded operation-specific data
- **nonce** is 0 for fire-and-forget; >0 for request/response
  correlation

The *startup sequence* is a four-step handshake: daemon spawns
manager with `ExtraFiles = [fd3_write, fd4_read]`; daemon sends
`[managerHandle, "init", empty, 0]`; the manager reads the init
envelope, extracts config, and starts up normally; the manager
signals `[0, "ready", empty, 0]`.

The *handle topology* assigns:

| Handle | Entity | Notes |
|--------|--------|-------|
| 0 | Daemon (control plane) | Always handle 0 |
| 1 | Manager child | First subprocess |
| 2+ | Workers | Spawned by the daemon on manager request |
