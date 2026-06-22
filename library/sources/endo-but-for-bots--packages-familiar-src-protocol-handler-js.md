---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/familiar/src/protocol-handler.js
source_line_range: 1-91
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 440 chat-lane ingest. 91-line protocol-handler.js
  from @endo/familiar/src — Layer 1 (CSP) of cycle 436's
  six-layer exfiltration defense. Companion to cycle 436's
  exfiltration-defense.js (layers 2, 3, 5) and cycle 438's
  navigation-guard.js (layer 4). Eighty-eighth AUTHORED
  conformant single-body section doc in post-refactor era.
  One-hundred-and-thirtieth consecutive non-garden source
  after the pivot (310-440). §one-hundred-and-thirty-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  webletId-as-origin-hostname-AND-daemon-routing-key —
  lines 65-71. The `localhttp://<weblet-id>/` URL's
  hostname is extracted at line 65 (`url.hostname`
  → webletId) and used for TWO PURPOSES simultaneously:
  (1) as the origin boundary for CSP's `connect-src
  'self'` — each weblet gets its own isolated origin
  because the hostname IS the weblet's identity; and (2)
  as the routing key forwarded to the daemon via the
  overridden `Host` header (`Host: webletId` at line 71).
  The protocol handler is the hinge point where Electron's
  security model (origin isolation via custom scheme) and
  the daemon's routing model (identify which weblet is
  making the request) converge on the same datum: the
  webletId. Neither the CSP nor the daemon routing would
  work correctly without the hostname being the weblet
  identity. §the-named-webletId-as-dual-use-origin-and-
  routing-key as tier-3 meta-pattern.

  §the-named-layer-1-CSP-injected-at-response-time —
  lines 79-87. The CSP is not a static Electron
  configuration; it is injected into EVERY response by
  the protocol handler itself (lines 80-86: `const
  headers = new Headers(proxyResponse.headers); headers.
  set('Content-Security-Policy', cspDirectives); return
  new Response(..., headers)`). Co-location: the same
  code that controls the origin (by serving localhttp://)
  also controls the confinement policy (by injecting CSP
  on every response). The policy cannot be circumvented
  by the daemon's response because the protocol handler
  always overwrites it. §the-named-CSP-injection-by-
  protocol-handler-not-daemon as tier-3 meta-pattern.

  §the-named-four-privileges-each-justified — lines 44-52:
  `standard: true` (makes the scheme a full origin),
  `secure: true` (treated as HTTPS for privileged APIs),
  `supportFetchAPI: true` (allows fetch/XHR from weblets),
  `corsEnabled: true` (allows cross-origin resource
  sharing for assets). Cycle 220's localhttp-protocol
  design named §privileged-scheme-registration-with-four-
  named-privileges-each-documented-with-purpose; cycle 440
  confirms the implementation exactly matches the design.
  §the-named-four-privileges-match-design as tier-3
  meta-pattern; design-to-implementation correspondence.

  §the-named-connect-src-self-as-load-bearing-network-
  confinement — line 27: `"connect-src 'self'"`. Cycle
  220's design marked this directive as one of the
  §three-load-bearing-directives with the annotation
  "restricts fetch/XHR/WebSocket/EventSource to own
  origin." Cycle 440 confirms: the directive's load-
  bearing claim is that each weblet's origin is UNIQUE
  (because the hostname is the webletId), so `'self'`
  resolves to that weblet's specific origin only. Without
  the unique-hostname-per-weblet origin model, `connect-
  src 'self'` would allow cross-weblet traffic.
  §the-named-connect-src-self-requires-unique-per-weblet-
  origin as tier-3 meta-pattern.

  §the-named-unsafe-eval-for-SES-lockdown — line 19 in
  source comment: "`script-src 'unsafe-eval'`: required
  for SES lockdown's eval-based loader." Cycle 433's
  SES-lockdown ingest (packages/init/src/lockdown.js)
  named the eval-based loader pattern. Here the
  consequence shows: the CONFINEMENT layer (CSP) must
  be relaxed at the eval surface to allow SES to function.
  Security through eval and security against eval coexist
  in the same CSP: `'unsafe-eval'` opens the eval surface
  for SES while `connect-src 'self'` closes the network
  surface for data exfiltration. §the-named-unsafe-eval-
  opened-for-SES-while-network-closed as tier-3 meta-
  pattern; two security concerns pull in opposite directions
  in the same CSP.

  §the-named-pre-ready-registration-post-ready-install —
  line 39-41 comment: "Must be called before
  `app.whenReady()`." Line 58-59 comment: "Must be called
  after `app.whenReady()`." Cycle 436's exfiltration-
  defense.js named §the-named-pre-ready-vs-post-ready-
  flag-application and §the-named-Electron-lifecycle-
  phases-for-security-setup as a pattern. Cycle 440
  confirms the pattern persists in Layer 1: scheme
  REGISTRATION is pre-ready, handler INSTALLATION is
  post-ready. Two separate exports for two lifecycle
  phases. §the-named-pre-ready-post-ready-persists-in-
  layer-1 as tier-3 meta-pattern; the lifecycle
  discipline is architectural, not incidental.

  §the-named-proxy-as-protocol-handler-core — lines 63-77.
  The protocol handler is fundamentally a reverse proxy:
  it rewrites the URL from `localhttp://webletId/path?q`
  to `http://127.0.0.1:gatewayPort/path?q`, forwards
  the method, headers (with Host overridden), and body,
  then returns the proxied response with CSP injected.
  The daemon does not need to know about localhttp://; it
  only sees standard HTTP on localhost with a Host header.
  §the-named-protocol-handler-as-localhost-reverse-proxy
  as tier-3 meta-pattern.

  §the-named-object-src-none-blocks-plugins — line 29:
  `"object-src 'none'"`. Blocks `<object>`, `<embed>`,
  `<applet>` plugins entirely. Plugin execution is an
  exfiltration vector (Flash, Java, Silverlight, etc.).
  §the-named-plugin-surface-closed-via-object-src as
  tier-3 meta-pattern.

  §the-named-form-action-self-prevents-external-submit —
  line 33: `"form-action 'self'"`. Form submissions
  blocked to external URLs. Classic exfiltration vector
  (hidden form POST to attacker domain). §the-named-
  form-action-as-exfiltration-vector-closed as tier-3
  meta-pattern.

  §the-named-base-uri-self-prevents-base-tag-injection —
  line 32: `"base-uri 'self'"`. Prevents a `<base>` tag
  from redirecting relative URL resolution to an attacker
  domain. §the-named-base-uri-restriction-as-defense as
  tier-3 meta-pattern.

  §the-named-data-and-blob-allowed-for-images-media —
  lines 27, 28: `"img-src 'self' data: blob:"` and
  `"media-src 'self' blob:"`. Images and media can use
  data: URIs and blob: URLs. This permits inline images
  and audio/video blobs that weblets might generate
  locally. §the-named-data-and-blob-exemption-for-local-
  media as tier-3 meta-pattern.

  §the-named-frame-src-self-weblet-iframe-allowed —
  line 30: `"frame-src 'self'"`. Weblets can iframe
  other localhttp:// origins but not external origins.
  Since all localhttp:// origins are weblets, this means
  weblets can only iframe other weblets, not external
  sites. §the-named-frame-src-self-confines-iframes-to-
  localhttp as tier-3 meta-pattern.

  §the-named-layer-1-of-six-now-grounded — cycle 438
  named layers 1 and 6 as unread. Cycle 440 reads layer
  1. The six layers are now mapped to source:
  - Layer 1 (CSP): THIS FILE (cycle 440)
  - Layer 2 (request interception): exfiltration-
    defense.js (cycle 436)
  - Layer 3 (DNS poisoning): exfiltration-defense.js
    (cycle 436)
  - Layer 4 (navigation delegate): navigation-guard.js
    (cycle 438)
  - Layer 5 (WebRTC disabled): exfiltration-defense.js
    (cycle 436)
  - Layer 6 (iframe sandbox): applied by Chat (not
    yet read)
  Five of six layers now grounded. §the-named-five-of-
  six-exfiltration-layers-grounded as tier-3 meta-
  pattern.

  §the-named-eighty-eight-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 439 (1, adjacent
  forward; liveness-revocation as security dimension
  pairs with Layer 1's network-confinement dimension) +
  cycle 438 (5, MAJOR COMPLETION — Layer 1 of six-layer
  exfiltration defense now grounded; 5 of 6 layers
  mapped to source) + cycle 436 (5, Layer 1 completes
  the primary defense trio: cycles 436+440 cover layers
  1-3+5; only Layer 6 in Chat remains) + cycle 433 (3,
  SES lockdown's unsafe-eval requirement visible in
  Layer 1's CSP; SES and network confinement coexist
  in one CSP) + cycle 220 (5, MAJOR DESIGN CLOSURE —
  familiar-localhttp-protocol design named the four
  privileges and three load-bearing CSP directives;
  cycle 440 confirms implementation matches design) +
  cycle 326 (75) + cycle 322 (75) + cycle 364 (4,
  shapes growing; webletId-as-dual-use datum is a new
  structural shape) + cycle 318 (3, Endo idiom —
  Electron custom protocol API) + cycle 435 (3,
  Familiar architecture confirmed at Layer 1).
  Pushes citation-arc-closures-in-pivot to EIGHT-
  HUNDRED-AND-SIXTY-TWO (852 + 10 net new).
---

91-line protocol-handler.js from @endo/familiar/src — Layer 1 (CSP) of cycle 436's six-layer exfiltration defense. Companion to cycle 436's exfiltration-defense.js (layers 2, 3, 5) and cycle 438's navigation-guard.js (layer 4). Chat-lane after cycle 439 designs-lane lal/primer/howto-inventory.md. **Single most structurally interesting move**: §the-named-webletId-as-origin-hostname-AND-daemon-routing-key — *lines 65-71: the `localhttp://<weblet-id>/` URL's hostname is extracted as `webletId` and used for TWO PURPOSES simultaneously: (1) as the origin boundary for CSP's `connect-src 'self'` (each weblet gets its own isolated origin because the hostname IS the weblet identity); and (2) as the routing key forwarded to the daemon via the overridden `Host` header (`Host: webletId`). The protocol handler is the hinge point where Electron's security model (origin isolation) and the daemon's routing model (identify the weblet) converge on the same datum.* §the-named-webletId-as-dual-use-origin-and-routing-key as tier-3 meta-pattern. §the-named-layer-1-CSP-injected-at-response-time (CSP added to every proxy response by the handler, not by the daemon; cannot be circumvented); §the-named-CSP-injection-by-protocol-handler-not-daemon. §the-named-four-privileges-each-justified (standard + secure + supportFetchAPI + corsEnabled); §the-named-four-privileges-match-design (design cycle 220 named them; implementation confirms). §the-named-connect-src-self-as-load-bearing-network-confinement; §the-named-connect-src-self-requires-unique-per-weblet-origin (the directive is only effective because the hostname is unique per weblet). §the-named-unsafe-eval-for-SES-lockdown (SES needs eval; cycle 433's lockdown framing now visible in the CSP relaxation); §the-named-unsafe-eval-opened-for-SES-while-network-closed (two security concerns in opposite directions in one CSP). §the-named-pre-ready-registration-post-ready-install (cycle 436's Electron lifecycle pattern persists in Layer 1: registerLocalhttpScheme before ready, installLocalhttpHandler after ready); §the-named-pre-ready-post-ready-persists-in-layer-1. §the-named-proxy-as-protocol-handler-core; §the-named-protocol-handler-as-localhost-reverse-proxy. §the-named-object-src-none-blocks-plugins; §the-named-plugin-surface-closed-via-object-src. §the-named-form-action-self-prevents-external-submit; §the-named-form-action-as-exfiltration-vector-closed. §the-named-base-uri-self-prevents-base-tag-injection; §the-named-base-uri-restriction-as-defense. §the-named-data-and-blob-allowed-for-images-media; §the-named-data-and-blob-exemption-for-local-media. §the-named-frame-src-self-weblet-iframe-allowed; §the-named-frame-src-self-confines-iframes-to-localhttp. §the-named-layer-1-of-six-now-grounded; §the-named-five-of-six-exfiltration-layers-grounded (5 of 6 layers mapped to source; only Layer 6 in Chat unread). §the-named-eighty-eight-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-SIXTY-TWO.
