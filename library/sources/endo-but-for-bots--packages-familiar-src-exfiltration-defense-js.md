---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/familiar/src/exfiltration-defense.js
source_line_range: 1-167
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 436 chat-lane ingest. 167-line exfiltration-
  defense.js from @endo/familiar/src — the security-
  critical module that implements three of six defense
  layers against data exfiltration from weblet iframes.
  Eighty-fourth AUTHORED conformant single-body section
  doc in post-refactor era. One-hundred-and-twenty-
  sixth consecutive non-garden source after the pivot
  (310-436). §one-hundred-and-twenty-six-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  exfiltration-as-inside-out-threat-distinct-from-
  cotenant — the file reveals a SECOND THREAT MODEL
  perpendicular to the cluster's accumulated cap-
  security framings. Cluster's cotenant model (cycle
  433): host and guest in same runtime, mutually
  suspicious. The capability discipline protects both
  sides from each other. Cycle 436's exfiltration
  defense: user-installed weblets running locally try
  to phone home to external servers. The threat is
  INSIDE-OUT — the user's content is the agent of
  attack against the user's data. The capability
  discipline alone does not prevent network-based
  exfiltration; that requires distinct defense layers.
  §the-named-cotenant-vs-exfiltration-as-perpendicular-
  threats as tier-3 meta-pattern; the cluster's
  security vocabulary now distinguishes:
  - COTENANT threat (cycle 433): horizontal isolation
    between coexisting programs in a runtime
  - EXFILTRATION threat (cycle 436): outbound
    isolation preventing data from leaving the
    user's machine
  Cap-security addresses the first; network defenses
  address the second.

  §the-named-six-layer-exfiltration-defense — lines
  9-17. Six explicit defense layers:
  - Layer 1 (CSP): protocol-handler.js
  - Layer 2 (request interception): THIS FILE
  - Layer 3 (DNS poisoning): THIS FILE
  - Layer 4 (navigation delegate): navigation-guard.js
  - Layer 5 (WebRTC disabled): THIS FILE
  - Layer 6 (iframe sandbox): applied by Chat
  §the-named-six-layer-defense-in-depth-distributed-
  across-files as tier-3 meta-pattern.

  §the-named-defense-layer-distribution-across-files —
  defense decomposed across multiple modules: CSP in
  protocol-handler, navigation in navigation-guard,
  request/DNS/WebRTC here, iframe-sandbox in Chat.
  §the-named-security-architecture-as-multi-file-
  decomposition as tier-3 meta-pattern.

  §the-named-localhttp-as-custom-URL-scheme-for-
  weblets — line 7: weblets served on `localhttp://`
  origins. Custom URL scheme; the trust boundary.
  §the-named-custom-URL-scheme-as-trust-boundary as
  tier-3 meta-pattern.

  §the-named-DNS-poisoning-via-unreachable-DoH-secure-
  mode — lines 51-65. Configures Chromium to use
  `https://invalid.localhost/dns-query` as the DoH
  server in 'secure' mode (won't fall back to system
  DNS). Since the endpoint is unreachable, all DNS
  resolution fails. Only literal IPs work. §the-
  named-poison-resolver-with-unreachable-secure-DoH
  as tier-3 meta-pattern; clever defense — the
  resolver IS the failure mode.

  §the-named-host-resolver-rules-as-catch-all-NOTFOUND
  — lines 39-42: `MAP * ~NOTFOUND, EXCLUDE 127.0.0.1`
  maps every hostname to NOTFOUND except localhost.
  §the-named-Chromium-host-resolver-rules-as-defense
  as tier-3 meta-pattern.

  §the-named-WebRTC-disabled-multiple-ways — lines
  31, 45-48: disable-features +
  force-webrtc-ip-handling-policy. WebRTC is a major
  exfiltration risk via STUN/TURN. §the-named-WebRTC-
  multi-flag-disable as tier-3 meta-pattern.

  §the-named-hyperlink-ping-disabled-via-no-pings —
  line 35: `--no-pings`. Disables the `<a
  ping="...">` attribute. Another exfiltration vector
  closed. §the-named-hyperlink-ping-disabled as
  tier-3 meta-pattern.

  §the-named-allow-localhttp-block-others-from-
  localhttp-origin — lines 67-95. Request
  interception filter:
  - Allows ALL requests from non-localhttp origins
    (Chat itself)
  - Allows localhttp-to-localhttp requests
  - Blocks localhttp origins requesting non-
    localhttp URLs
  §the-named-asymmetric-request-filter-by-origin as
  tier-3 meta-pattern.

  §the-named-localhttp-origins-denied-all-permissions
  — lines 97-113. Permission request handler denies
  all permissions from localhttp origins (camera,
  mic, geolocation, WebRTC). Other origins get
  default (allow). §the-named-permission-handler-as-
  permission-gate as tier-3 meta-pattern.

  §the-named-runtime-defense-verification-with-canary
  — lines 115-150. The defenses are VERIFIED at
  runtime via:
  - DNS resolution of canary.exfiltration-test.invalid
    should fail (returns warning if it succeeds)
  - host-resolver-rules flag should be present
  §the-named-active-defense-verification as tier-3
  meta-pattern; defense in depth + active testing.

  §the-named-invalid-TLD-canary-for-DNS-leak-
  detection — line 131: `canary.exfiltration-test.
  invalid`. Uses the `.invalid` TLD (RFC 6761
  reserved, always fails). The canary should ALWAYS
  fail; if it succeeds, DNS is leaking. §the-named-
  RFC-6761-invalid-TLD-as-test-vector as tier-3
  meta-pattern.

  §the-named-canary-tests-Node-DNS-not-Chromium-DNS
  — lines 127-129. The comment notes: `dns.promises.
  resolve` uses the Node.js resolver, not Chromium's.
  Test is APPROXIMATE — Node and Chromium have
  separate DNS resolvers. §the-named-approximate-
  verification-due-to-multiple-DNS-stacks as tier-3
  meta-pattern.

  §the-named-pre-ready-vs-post-ready-flag-application
  — lines 24-26, 51-53. Two-phase setup:
  - Command-line flags MUST be set before
    `app.whenReady()`
  - Other configuration (configureHostResolver,
    webRequest.onBeforeRequest) MUST be after
    whenReady
  §the-named-Electron-lifecycle-phases-for-security-
  setup as tier-3 meta-pattern.

  §the-named-await-null-as-microtask-tick-forcing —
  line 125. `await null` in the async verify function.
  Forces a microtask yield at the top of an otherwise-
  sync function. Pattern in JS for "be genuinely
  async from the start." §the-named-await-null-for-
  microtask-tick as tier-3 meta-pattern.

  §the-named-defense-via-flag-vs-defense-via-API —
  the file uses BOTH command-line flags (set before
  app.whenReady) AND runtime APIs (set after
  app.whenReady). Different defenses have different
  configuration surfaces. §the-named-defense-config-
  surface-axis as tier-3 meta-pattern.

  §the-named-eighty-four-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 435 (1, adjacent
  forward; Familiar README confirmed Electron shell;
  cycle 436 reads the SECURITY-CRITICAL Electron
  module inside it) + cycle 433 (5, cotenant-as-
  threat-model now paired with exfiltration-as-
  threat-model; two perpendicular security concerns
  named) + cycle 429 (3, CapTP-mutual-suspicion-
  default is the COTENANT defense; exfiltration-
  defense is the OUTBOUND defense) + cycle 425 (3,
  three ocap patterns defend against cotenant;
  six-layer-exfiltration-defense defends against
  inside-out) + cycle 424 (3, defense-layer-
  distribution echoes two-phase-validation
  decomposition) + cycle 416 (3, trust-boundary-as-
  error-handling-asymmetry parallels localhttp-as-
  trust-boundary) + cycle 322 (75, errors framing
  applies — security errors trigger logged warnings)
  + cycle 326 (75) + cycle 364 (4, shapes growing
  with second threat model) + cycle 318 (3, Endo
  idiom — Electron Lifecycle phases). Pushes
  citation-arc-closures-in-pivot to EIGHT-HUNDRED-
  AND-TWENTY-TWO (812 + 10 net new).
---

167-line exfiltration-defense.js from @endo/familiar/src — the security-critical module implementing three of six defense layers against data exfiltration from weblet iframes. Chat-lane after cycle 435 designs-lane familiar/README.md. **Single most structurally interesting move**: §the-named-exfiltration-as-inside-out-threat-distinct-from-cotenant — *the file reveals a SECOND THREAT MODEL perpendicular to the cluster's accumulated cap-security framings. Cluster's cotenant model (cycle 433) addresses HORIZONTAL isolation between coexisting programs. Cycle 436's exfiltration defense addresses OUTBOUND isolation preventing user-installed weblets from phoning home. The threat is INSIDE-OUT — user's content acts against user's data. Cap-security alone does not prevent network-based exfiltration; that requires distinct defense layers.* §the-named-cotenant-vs-exfiltration-as-perpendicular-threats as tier-3 meta-pattern. §the-named-six-layer-exfiltration-defense (CSP + request-interception + DNS-poisoning + navigation-delegate + WebRTC-disabled + iframe-sandbox; distributed across 4 files); §the-named-six-layer-defense-in-depth-distributed-across-files. §the-named-defense-layer-distribution-across-files; §the-named-security-architecture-as-multi-file-decomposition. §the-named-localhttp-as-custom-URL-scheme-for-weblets; §the-named-custom-URL-scheme-as-trust-boundary. §the-named-DNS-poisoning-via-unreachable-DoH-secure-mode (clever — resolver IS the failure mode); §the-named-poison-resolver-with-unreachable-secure-DoH. §the-named-host-resolver-rules-as-catch-all-NOTFOUND (`MAP * ~NOTFOUND, EXCLUDE 127.0.0.1`); §the-named-Chromium-host-resolver-rules-as-defense. §the-named-WebRTC-disabled-multiple-ways; §the-named-WebRTC-multi-flag-disable. §the-named-hyperlink-ping-disabled-via-no-pings (closes `<a ping>` vector); §the-named-hyperlink-ping-disabled. §the-named-allow-localhttp-block-others-from-localhttp-origin; §the-named-asymmetric-request-filter-by-origin. §the-named-localhttp-origins-denied-all-permissions; §the-named-permission-handler-as-permission-gate. §the-named-runtime-defense-verification-with-canary; §the-named-active-defense-verification (defense in depth + active testing). §the-named-invalid-TLD-canary-for-DNS-leak-detection (RFC 6761 .invalid TLD); §the-named-RFC-6761-invalid-TLD-as-test-vector. §the-named-canary-tests-Node-DNS-not-Chromium-DNS (Node and Chromium have separate DNS resolvers); §the-named-approximate-verification-due-to-multiple-DNS-stacks. §the-named-pre-ready-vs-post-ready-flag-application (Electron lifecycle phases for security setup); §the-named-Electron-lifecycle-phases-for-security-setup. §the-named-await-null-as-microtask-tick-forcing; §the-named-await-null-for-microtask-tick. §the-named-defense-via-flag-vs-defense-via-API; §the-named-defense-config-surface-axis. §the-named-eighty-four-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-TWENTY-TWO.
