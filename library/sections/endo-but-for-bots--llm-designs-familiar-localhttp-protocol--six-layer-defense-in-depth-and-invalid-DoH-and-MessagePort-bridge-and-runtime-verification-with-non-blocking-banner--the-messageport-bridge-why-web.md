---
title: §The-MessagePort-bridge — §why-WebSocket-doesn't-work-from-localhttp
source-slug: endo-but-for-bots--llm-designs-familiar-localhttp-protocol
section-id: six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/familiar-localhttp-protocol.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/familiar-localhttp-protocol.md
total-lines: 636
status: Partially implemented (Familiar-side Ready; Chat-side Not Yet)
ingest-cycle: 220
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-familiar-localhttp-protocol--six-layer-defense-in-depth-and-invalid-DoH-and-MessagePort-bridge-and-runtime-verification-with-non-blocking-banner
---

§The-design-names-the-load-bearing-constraint:

> Electron's `protocol.handle` does not intercept WebSocket upgrade requests. Weblet iframes served on `localhttp://<weblet-id>/` cannot open a raw WebSocket to the daemon gateway because (a) the CSP blocks `ws://` connect-src and (b) the protocol handler wouldn't intercept it anyway.

§Two-named-reasons-WebSocket-fails. §Borrowable-pattern: §when-the-obvious-solution-doesn't-work, §name-both-reasons-it-doesn't-work; §the-second-reason-is-the-deeper-architectural-constraint (protocol.handle scope).

§Five-step-bridge-flow:
1. Chat creates MessageChannel.
2. Chat transfers port2 to weblet iframe via postMessage.
3. Chat opens WebSocket to ws://127.0.0.1:8920/ with `Host: <weblet-id>` header.
4. Chat pumps marshaled CapTP messages bidirectionally as §ArrayBuffer-transfers-zero-copy with `[buffer]` transfer list moving ownership.
5. Weblet receives port + runs CapTP over MessagePort.

§Zero-copy-via-transfer-list named explicitly (§the-`[buffer]`-transfer-list-moves-ownership-rather-than-copying-it). §Sibling to cycle 213 stream-node's §Buffer-to-Uint8Array zero-copy conversion. §Two-different-zero-copy-patterns in library.
