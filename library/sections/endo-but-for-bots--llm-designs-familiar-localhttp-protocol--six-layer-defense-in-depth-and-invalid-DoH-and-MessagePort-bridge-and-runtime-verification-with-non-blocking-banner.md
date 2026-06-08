---
title: "familiar-localhttp-protocol — §six-layer-defense-in-depth + §invalid-DoH-as-DNS-poisoning + §MessagePort-bridge + §runtime-verification-with-non-blocking-banner + §honest-implementation-deviations"
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
---

# familiar-localhttp-protocol — Six-layer defense in depth for in-Familiar weblet hosting

A 636-line **Partially implemented** design. The Familiar-side infrastructure ships (five named modules in `packages/familiar/`); the Chat-side and Layer-6-iframe-sandbox remain. This is the §parent-with-ready-infrastructure that cycle 218 (familiar-chat-weblet-hosting) referenced via its §two-part-status. The natural follow-on to cycle 218.

## §The-status-section names §three-states explicitly

```
**Partially implemented.** The Familiar-side infrastructure is in place: [5 bullets]
**Not yet implemented:** [3 bullets — Layer 6 / MessagePort bridge / Chat banner]
**Design deviations from implementation:** [3 bullets — split files / Host header bare-id / etc.]
```

§Three-state-status is a new shape. §Borrowable-pattern: §a-design-with-implementation-history-needs-three-status-bullets:
1. §What's-in-place.
2. §What's-not-yet.
3. §What-the-implementation-did-differently-from-the-design.

The §design-deviations-section is §honest-design-evolution-record-family-member-nineteen: the design itself records where the implementation diverged from the original prose. §Borrowable-pattern: §the-design-document-tracks-its-own-divergence-from-the-implementation.

Sibling shapes to consider:
- Cycle 214 lal-reply-chain-transcripts (Complete): §within-document self-correcting prose.
- Cycle 216 lal-transcript-memory-management (Not Started): §parent-Complete + §child-Not-Started extraction.
- Cycle 218 familiar-chat-weblet-hosting (Not Started): §sibling-Ready + §this-Not-Started two-part-status.
- Cycle 220 familiar-localhttp-protocol (Partially Implemented): §three-state-status + §design-deviations-section.

§Now-nineteen-shapes-of-honest-design-evolution-record.

## §Three-problems-being-solved (numbered)

The §What-is-the-Problem-Being-Solved section names §three-numbered-problems:

1. **Origin isolation.** §Every-weblet-needs-a-unique-origin so same-origin-policy + cookie jars + localStorage isolate weblets from each other and from Chat.
2. **Network confinement.** §Guest-page-cannot-send-HTTP-requests + open-WebSockets + trigger-DNS-lookups to external hosts.
3. **Navigation confinement.** §Hyperlinks-must-not-silently-navigate the Electron window away.

§Borrowable-pattern: §enumerate-the-distinct-attacker-capabilities-the-design-defends-against. §Different-from cycle 218's §three-named-properties (which named goals); §this-design-names-attacks. §Threat-modeling-as-design-driver.

## §Privileged-scheme-registration with §four-named-privileges

```js
protocol.registerSchemesAsPrivileged([
  {
    scheme: 'localhttp',
    privileges: {
      standard: true,       // URL parsing like http (host, path, query)
      secure: true,         // access to secure-context APIs (crypto.subtle, etc.)
      supportFetchAPI: true,// fetch() from renderer to this scheme
      corsEnabled: true,    // CORS requests within the scheme
    },
  },
]);
```

§Each-privilege-named-with-purpose. §Borrowable-pattern: §when-an-API-takes-an-options-bag-of-booleans, §the-design-document-names-each-one-with-its-purpose so future readers understand the trade-off.

## §The-CSP-with-named-key-properties

```
default-src 'self';
script-src  'self' 'unsafe-inline' 'unsafe-eval';
connect-src 'self';
img-src     'self' data: blob:;
... (8 directives total)
```

§Key-properties-section pulls out §three-load-bearing-directives:

- `script-src 'unsafe-eval'` — §required-for-SES-lockdown's-eval-based-module-loader.
- `connect-src 'self'` — §the-network-confinement-mechanism (blocks all fetch / XHR / WebSocket / EventSource to non-self origins).
- `form-action 'self'` — §prevents-form-submissions-to-external-URLs.

§Borrowable-pattern: §don't-just-paste-the-config — §pull-out-the-load-bearing-lines + §name-the-reason-for-each.

§Chat-is-not-served-through-localhttp — §the-CSP-applies-only-to-weblet-iframes. §Two-different-trust-zones with §two-different-CSPs (Chat has its own; weblets get the restrictive one).

## §ASCII-mermaid-style-flow-diagram

```
┌─────────────────────────────┐      MessagePort       ┌────────────────────┐
│  Chat (file:// or http://)  │◄═══════════════════════►│  Weblet iframe     │
│  1. Creates MessageChannel  │  ArrayBuffer transfers │  (localhttp://     │
│  2. Opens ws:// to gateway  │                         │   <weblet-id>/)    │
│  3. Bridges ws ↔ port       │                         │  Runs CapTP over   │
│                             │                         │  MessagePort       │
└─────────────────────────────┘                         └────────────────────┘
```

§Sibling to cycle 214's §ASCII-tree-diagram and cycle 218's §ASCII-mockup-of-UI. §Three-cycles-with-ASCII-illustration in 2026-06 (cycles 214/218/220).

## §The-MessagePort-bridge — §why-WebSocket-doesn't-work-from-localhttp

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

## §Navigation-delegate via §allowedProtocols-set

```js
const allowedProtocols = new Set([
  'file:',
  'localhttp:',
]);
```

§Two-named-allowed-protocols. §Dev-mode-exemption for the Vite dev server. §Three-cases:
1. allowedProtocols → continue.
2. dev-mode + Vite-origin → continue.
3. else → preventDefault + promptExternalNavigation.

§Borrowable-pattern: §allowlist-based-navigation-confinement + §named-dev-mode-exemption.

## §The-six-layer-defense-in-depth

§The-load-bearing-architectural-move. §Each-layer-numbered-and-named-with-its-confinement-purpose:

| Layer | Mechanism | Confines |
|-------|-----------|----------|
| 1 | Content-Security-Policy | network requests (CSP-governed) |
| 2 | Electron request interception | CSP bypasses (service worker fetch, navigation, future features) |
| 3 | DNS poisoning (invalid DoH + flags) | DNS prefetch, speculative connects |
| 4 | Navigation delegate | window navigation to external URLs |
| 5 | WebRTC disabled | ICE-candidate exfiltration via STUN/TURN |
| 6 | iframe sandbox | iframe escape attempts (top-navigation, popups) |

§Six-named-layers each with §the-attack-it-blocks. §Borrowable-pattern: §defense-in-depth-with-named-attack-per-layer — §a-guest-would-need-to-bypass-all-of-them-simultaneously.

§Sibling-but-different-from cycle 200 worker-rust-xs (§engine-level-confinement-via-XS-native-Compartment) + cycle 212 outliner (§SES-Compartment-confinement) + cycle 218 familiar-chat-weblet-hosting (§iframe-sandbox-attribute) + cycle 220 (§six-layer-stack-of-confinement). §Cycle-220-names-the-stack-not-just-one-substrate.

§Five-cycles-on-confinement now, with cycle 220 as the §multi-layer-synthesis.

### §Invalid-DoH-as-DNS-poisoning (Layer 3)

§The-novel-move-of-the-design. §Set-DoH-to-an-invalid-endpoint so all DNS resolution fails:

```js
app.configureHostResolver({
  secureDnsMode: 'secure',
  // Invalid DoH endpoint — all DNS resolution fails.
  secureDnsServers: ['https://invalid.localhost/dns-query'],
});
```

§Correctness-argument-section: this is acceptable because:
- Gateway proxy uses 127.0.0.1 (literal IP, no DNS).
- localhttp:// is protocol-handler-routed (no DNS).
- file:// requires no DNS.
- External links open in system browser (which has its own DNS).

§Borrowable-pattern: §intentionally-misconfigure-a-platform-API-to-deny-a-capability + §name-each-traffic-pattern-that-still-works.

§Belt-and-suspenders: §three-named-Chromium-command-line-flags added redundantly (`disable-features=DnsOverHttpsUpgrade,AsyncDns` + `--no-pings` + `--host-resolver-rules=MAP * ~NOTFOUND, EXCLUDE 127.0.0.1`). §Each-flag-has-a-named-purpose; §the-host-resolver-rules-flag-provides-a-definitive-block.

§Sibling to cycle 205 evasive-transform's §SES-censorship-evasion-strategies (different layer, same §lock-down-by-design-intentionally discipline).

### §Layer 5 — WebRTC ICE-candidate exfiltration

§The-attacker-channel-named: §an-RTCPeerConnection-can-encode-data-in-the-ufrag-field-and-trigger-STUN/TURN-requests-bypassing-CSP. §WebRTC-traffic-is-not-governed-by-CSP-directives.

§Borrowable-pattern: §name-the-out-of-band-channel-that-bypasses-your-primary-defense. §The-existence-of-this-attack is why §six-layers-not-one are needed. §Defense-in-depth-because-no-single-mechanism-blocks-everything.

§Three-named-mitigations for WebRTC:
1. `app.commandLine.appendSwitch('disable-features', 'WebRtcHideLocalIpsWithMdns')`.
2. `force-webrtc-ip-handling-policy=disable_non_proxied_udp`.
3. `setPermissionRequestHandler` denying media permissions from localhttp origins.

§Forward-looking-statement-naming-future-flexibility: §future-allowlist-by-origin for §user-granted-WebRTC-permission.

## §Runtime-verification-and-user-notification

§The-defenses-might-not-have-loaded — §verify-them-at-startup-and-tell-the-user-if-any-failed.

```js
const verifyExfiltrationDefenses = async () => {
  const warnings = [];

  try {
    await dns.promises.resolve('canary.exfiltration-test.invalid');
    warnings.push('DNS resolution succeeded unexpectedly. DNS-based exfiltration may be possible.');
  } catch {
    // Expected: resolution should fail.
  }

  if (!app.commandLine.hasSwitch('host-resolver-rules')) {
    warnings.push('host-resolver-rules flag not set. DNS prefetch may not be fully blocked.');
  }

  return warnings;
};
```

§Three-novel-moves:
1. §Canary-DNS-resolution to verify-DNS-is-actually-broken — §the-test-that-it-fails-IS-the-verification.
2. §Command-line-switch-presence-check.
3. §Warnings-collected-into-list-then-returned.

§Renderer-notification via §non-blocking-yellow-banner-in-Chat-UI — §the-user-is-informed-but-not-blocked. §Sibling to cycle 100's §unhandled-rejection display (both designs route information to the user via console/banner without blocking).

§Detected-via-window.familiar-API: §the-Familiar-environment-is-detected-by-its-own-preload-API; §in-Vite-dev-mode-window.familiar-is-undefined and §no-banner-appears. §Borrowable-pattern: §the-warning-banner-only-appears-when-the-defense-was-supposed-to-be-active.

## §Research-needed section

§Four-named-open-verification-items:
1. Verify `app.configureHostResolver` with unreachable DoH prevents *all* DNS queries.
2. Confirm literal IP addresses bypass `--host-resolver-rules` MAP and DoH path.
3. Test whether `setProxy({ proxyRules: 'direct://' })` provides additional DNS isolation.
4. Determine whether `<a ping="...">` hyperlink auditing bypasses CSP `connect-src`.

§Borrowable-pattern: §Research-needed-section-as-honest-acknowledgment-of-incomplete-verification. §The-design-ships-but-the-author-names-what-isn't-verified-yet. §Honest-disclosure of §what-the-design-author-doesn't-know.

§The-Open-Questions-section at the end says explicitly: `(None remaining.)` — §the-design-knows-which-questions-have-been-resolved-and-which-haven't; §two-different-sections-for-two-different-classes-of-uncertainty (Research-needed = verification + Open-Questions = decision).

## §Affected-packages-with-implementation-status-per-package

§Each-package-row-tagged-`(implemented)`-or-`(not yet implemented)`. §Borrowable-pattern: §when-a-design-is-Partially-implemented, §the-Affected-Packages-section-becomes-a-status-board. §The-design-document-doubles-as-a-progress-tracker.

## §Open-Questions: (None remaining.)

§Explicit-empty-section-as-completeness-signal. §Borrowable-pattern: §a-design-with-an-Open-Questions-section-explicitly-marked-(None-remaining)-is-different-from-a-design-with-no-Open-Questions-section-at-all. §The-empty-marker-is-load-bearing.

§Sibling to cycle 198 patterns-diagnostic-feedback's §three-revision-pivots — different §design-completeness-signal: cycle 198 shows §the-pivots-that-resolved-the-questions; cycle 220 shows §the-questions-have-been-resolved.

## §Seven-Familiar-cluster-designs in library after cycle 220

| Cycle | Design | Status |
|-------|--------|--------|
| 174 | familiar-electron-shell | shipped |
| 176 | familiar-daemon-bundling | shipped |
| 182 | familiar-gateway-migration | shipped |
| 184 | familiar-unified-weblet-server | shipped |
| 208 | familiar-bundled-agents | shipped |
| 218 | familiar-chat-weblet-hosting | Not Started |
| 220 | familiar-localhttp-protocol | Partially implemented |

§Seven-design-cluster for §the-Familiar-feature with §three-different-status-values (shipped / Not Started / Partially implemented).

## Related material in the library

- **cycle 218 familiar-chat-weblet-hosting**: §parent-child-design-pair (this is the parent referenced by cycle 218's §two-part-status); §three-named-bullets-from-this-design appear in cycle 218's §Done-Elsewhere section.
- **cycle 184 familiar-unified-weblet-server**: §named-dependency (gateway routes by Host header to weblet handler).
- **cycle 182 familiar-gateway-migration**: §named-dependency (gateway must be built-in daemon service on port 8920).
- **cycle 174 familiar-electron-shell**: §the-Electron-context this design lives in.
- **cycle 213 stream-node**: §zero-copy-buffer-transfer sibling (different mechanism; same goal).
- **cycle 205 evasive-transform**: §intentionally-misconfigure-a-platform-API sibling.
- **cycle 200 worker-rust-xs + cycle 212 outliner + cycle 218 familiar-chat-weblet-hosting**: §confinement-substrate siblings; cycle 220 names §six-layer-stack-of-confinement as the §multi-layer-synthesis.
- **cycle 100 unhandled-rejection-display**: §user-warning-as-non-blocking-channel sibling.
- **cycle 197 panic**: §honest-disclosure-of-residual-trust sibling (this design's §design-deviations-section is the §design-document analog).
- **cycle 198 patterns-diagnostic-feedback**: §design-iteration-record sibling.

## §Library-reaches-726-sections at cycle 220 (designs-lane familiar-localhttp-protocol).

## §Fifty-fourth consecutive designs-chat alternation cycles 166-220.

## §Nineteenth-honest-design-evolution-record family member

§A-new-shape: §design-deviations-section-where-the-design-tracks-its-own-divergence-from-the-implementation. §Cycles-214/216/218/220 are §four-different-shapes-of-design-evolution-record in the recent ingest cluster:

| Cycle | Shape |
|-------|-------|
| 214 | §within-document self-correcting prose ("This is getting complex. Let's simplify:") |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor section |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section recording divergence between design and implementation |
