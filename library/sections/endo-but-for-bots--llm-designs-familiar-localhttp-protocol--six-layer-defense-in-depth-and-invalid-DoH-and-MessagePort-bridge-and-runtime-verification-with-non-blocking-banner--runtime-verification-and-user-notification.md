---
title: §Runtime-verification-and-user-notification
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
