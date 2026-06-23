---
title: "Netlayer framing placement and migration call sites"
source: designs/ocapn-tcp-syrups-framing.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a4978698b19bbea5fcb8049e5cb7944ac8f2485a
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
topics: [streams, ocapn]
status: current
---

> Abstract: Two placement options for syrups framing in the OCapN stack, with Option A (framing inside the netlayer) recommended. Option A: the `tcp-test-only` netlayer owns the framer; on ingress it pipes a `net.Socket`'s async-iterable byte chunks through `makeSyrupsReader` and calls `handlers.handleMessageData(connection, frame)` with each whole frame; on egress it layers `makeSyrupsWriter` on top of the socket writer so `connection.write(bytes)` means "send one frame." This is the Endo daemon's own pattern in `packages/daemon/src/networks/tcp-netstring.js`. Option B (framing in OCapN core) is rejected: every future OCapN network would reimplement the same plumbing, and the chunk-boundary bug would be preserved in the API surface. The migration adds a new `tcp-syrups.js` netlayer file while keeping `tcp-test-only.js` and adding proper `@endo/netstring` framing to it (bug fix, no wire-format change against the Python test suite). Phased implementation: (1) publish `@endo/syrups` standalone; (2) fix `tcp-test-only` with real `@endo/netstring` framing; (3) add `tcp-syrups` netlayer; (4, optional) propose upstream.

**Option A recommendation (lines 340-368):**
Framing belongs at the netlayer boundary, aligning with `designs/ocapn-network-transport-separation.md`: networks own transport concerns and deliver sessions (and framed messages) to the core. `handleMessageData` and `handleActiveSessionMessageData` receive whole frames after the change; the `while (syrupReader.index < data.length)` loop in `dispatchMessageData` collapses to a single read. The daemon's `tcp-netstring.js` pattern (lines 88-95 of that file) is the cited model.

**Call sites affected (lines 326-336):**

| File | Change |
|------|--------|
| `packages/ocapn/src/netlayers/tcp-test-only.js` | Wire the raw `net.Socket` through `@endo/syrups` reader/writer |
| `packages/ocapn/src/client/index.js` | `handleMessageData` receives whole frames; `while` loop collapses to single read |
| `packages/ocapn/src/client/handshake.js` | `handleHandshakeMessageData` becomes one-frame-one-call |
| `packages/ocapn/src/client/ocapn.js` | `dispatchMessageData` simplifies or framing moves to netlayer boundary |
| `packages/ocapn/package.json` | Add `@endo/syrups` dependency |

**Named structural fact: §the-named-framing-at-netlayer-not-core** — framing is a transport concern; the network interface delivers sessions (and framed messages) to OCapN core. Consistent with the `ocapn-network-transport-separation` design direction that networks own the full lifecycle from transport selection through session establishment.

**No dual-protocol support:** The design explicitly rejects a compatibility mode that reads either netstrings or syrups frames. Two transport identifiers (`tcp-testing-only` and `tcp-syrups`) are registered separately; the locator disambiguates. Complicating the reader with a peek-for-comma fallback would permanently poison the grammar.
