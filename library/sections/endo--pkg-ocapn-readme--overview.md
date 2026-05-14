---
title: Overview
source: packages/ocapn/README.md
source_repo: endojs/endo
source_commit: 36db20f1
source_date: 2026-01-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn]
status: current
---

> Abstract: What @endo/ocapn provides: the application-facing API for OCapN-based capability-bearing messaging. Distinct from the spec docs (which describe the wire-level requirements) in that this package is the JS-side library application code calls into.

## Overview

OCapN is a protocol for secure distributed object programming.
It enables networked programming with the convenience of calling methods on
remote objects, much like local asynchronous programming.

This package provides:

- **CapTP**: The Capability Transport Protocol, the core message-passing
  layer of OCapN.
  See also the related [`@endo/captp`](../captp/README.md) package for a
  minimal CapTP implementation.
- **Syrup codec**: Encode and decode [Syrup][], the canonical binary
  serialization format tentatively used by OCapN.
- **Netlayer interface**: An abstraction for transport layers, allowing CapTP
  to operate over various network protocols.
- **Third-party handoffs**: Cryptographic mechanisms for securely transferring
  object references between peers.

For more information about the protocol, see [ocapn.org][OCapN].


Source: [packages/ocapn/README.md](https://github.com/endojs/endo/blob/36db20f1/packages/ocapn/README.md) at commit `36db20f1`.
