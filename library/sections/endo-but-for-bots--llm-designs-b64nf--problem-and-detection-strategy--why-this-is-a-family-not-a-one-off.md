---
title: Why this is a family, not a one-off
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
notes: **Status: Not Started** upstream. Third member of the *vetted-shim-or-ponyfill* design family alongside `hardened-url-shim` and `hardened-text-codecs-shim`. The detection-and-capture-before-lockdown pattern shared with the two prior shims gets its first full treatment here as a deliberate API discipline. Sibling design `@endo/hex` applies the identical structure to `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`.
parent: endo-but-for-bots--llm-designs-b64nf--problem-and-detection-strategy
---

The pattern is named explicitly: `@endo/hex` is a sibling parallel
proposal that applies *the identical detection-and-capture pattern*
to `Uint8Array.fromHex` / `Uint8Array.prototype.toHex`. The two
packages will share a module structure (see
[[endo-but-for-bots--llm-designs-b64nf--module-layout-and-option-mapping]])
and a common test strategy.

This is the third member of the vetted-shim family alongside
[[endo-but-for-bots--llm-designs-hardened-url-shim]] and
[[endo-but-for-bots--llm-designs-hardened-text-codecs-shim]]; together
they constitute the *"tame and dispatch to native intrinsics inside
SES"* convention. The distinction here is that `base64` and `hex`
are **ponyfills** — they fall back to a JS polyfill when the native
is absent — whereas the URL and TextEncoder shims are **vetted shims**
that simply expose the host-provided intrinsic and degrade silently
on hosts that lack it (no polyfill is provided). The choice is
driven by whether a JS-only fallback is practical: URL is too large
to polyfill; base64 already has one.
