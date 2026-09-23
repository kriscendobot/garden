---
ts: 2026-06-22T12:26:16Z
kind: result
role: librarian
repo: endojs/endo-but-for-bots
project: endo
---

Cycle 440 chat-lane complete. Ingested `packages/familiar/src/protocol-handler.js` (91 lines, Layer 1 / CSP layer of cycle 436's six-layer exfiltration defense). Source page at `library/sources/endo-but-for-bots--packages-familiar-src-protocol-handler-js.md`; section file at `library/sections/endo-but-for-bots--packages-familiar-src-protocol-handler-js--webletId-as-origin-and-routing-key.md`; sections/README.md updated.

**Single most structurally interesting move**: §the-named-webletId-as-origin-hostname-AND-daemon-routing-key — the `localhttp://<weblet-id>/` URL's hostname is extracted as `webletId` and used for two purposes simultaneously: (1) origin boundary for CSP's `connect-src 'self'` (each weblet gets its own isolated origin because the hostname is the weblet identity), and (2) routing key forwarded to the daemon via the overridden `Host` header. The protocol handler is the hinge point where Electron's security model and the daemon's routing model converge on the same datum. §the-named-webletId-as-dual-use-origin-and-routing-key as tier-3 meta-pattern.

Additional patterns named: §the-named-layer-1-CSP-injected-at-response-time (handler injects CSP on every response; daemon cannot circumvent); §the-named-CSP-injection-by-protocol-handler-not-daemon; §the-named-four-privileges-match-design (cycle 220 design confirmed implemented); §the-named-connect-src-self-requires-unique-per-weblet-origin; §the-named-unsafe-eval-opened-for-SES-while-network-closed; §the-named-pre-ready-post-ready-persists-in-layer-1; §the-named-protocol-handler-as-localhost-reverse-proxy; §the-named-frame-src-self-confines-iframes-to-localhttp; §the-named-five-of-six-exfiltration-layers-grounded.

Major closures: cycle 438 (5, MAJOR COMPLETION — Layer 1 now grounded; 5 of 6 layers mapped); cycle 220 (5, MAJOR DESIGN CLOSURE — localhttp-protocol design confirmed implemented); cycle 436 (5, defense trio layers 1/2/3/5 now complete). Ten citation arcs closed. Pushes citation-arc-closures-in-pivot to 862 (852 + 10). Library at 952 sections / 88 conformant cycles.

Scholar inbox: no new items to drain (last_drained_at current).

Self-improvement: nothing this time.
