---
title: §The-six-layer-defense-in-depth
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
