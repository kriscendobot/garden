---
title: Architecture
source: packages/ocapn/README.md
source_repo: endojs/endo
source_commit: 36db20f1
source_date: 2026-01-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, captp]
status: current
---

> Abstract: How @endo/ocapn composes the lower-level packages (captp, marshal, netstring, noise) to realize the protocol. The package-composition view of the OCapN realization.

## Architecture

The package is organized in layers, from high to low:

1. **Client** (`src/client/`): Session management, handoffs, sturdy references
2. **CapTP** (`src/captp/`): Message dispatch and slot management
3. **Codecs** (`src/codecs/`): Syrup encoding, descriptors, and operations
4. **Netlayer** (`src/netlayers/`): Network and transport abstraction


Source: [packages/ocapn/README.md](https://github.com/endojs/endo/blob/36db20f1/packages/ocapn/README.md) at commit `36db20f1`.
