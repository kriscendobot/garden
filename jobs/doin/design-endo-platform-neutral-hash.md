---
role: designer
---

# designer — platform-neutral hash package to unblock XS/endor daemon bundling

## Origin & problem
Maintainer direction, resolving the xs2rust-endor blocker on
`endojs/endo-but-for-bots` PR #600: `daemon_bootstrap.js` cannot be generated
because `@endo/platform/fs/extended/shared/blobref.js` imports **`node:crypto`**,
which the SES/XS bundler cannot handle — blocking `test:rust` and full endor
daemon integration. (The Rust engine itself is healthy: 82/82 cargo tests, ~2750
dual-run oracle tests, stage-5 byte-identity met — the blocker is purely the
bundling/host-crypto layer.)

## Maintainer's design direction (the charter — follow it)
1. **Isolate the actual crypto functionality blob-ref imports.** The maintainer
   expects it is **sha256 or sha512** (likely `crypto.createHash`). Confirm
   exactly which digest(s) and which usage shape (one-shot vs streaming/`update`)
   blob-ref (and any sibling on the XS daemon path) actually needs. Design only
   for what is really used.
2. **Provide a small package (e.g. `@endo/sha256`)** — one per needed primitive if
   sha512 is also required — exposing a **platform-neutral, buffer-oriented JS
   API**, e.g.:
   - `sha256(bytes) -> bytes`, and/or
   - `sha256Into(hash, bytes)` — **bring-your-own-buffer** (caller supplies the
     output buffer).
   Pin down the exact signatures, byte types (`Uint8Array`), streaming needs, and
   error behavior in the spec.
3. **Per-platform implementations via conditional exports:**
   - **node** condition → falls through to **`node:crypto`**.
   - **browser** condition → **WebCrypto** (`crypto.subtle.digest`) — note its
     async shape and reconcile with the sync API (design the seam).
   - **xs** condition → **a host function we provide with Endor, backed by the
     Rust native implementation.** Specify this host-function interface: how the
     xs-condition module calls into the Endor-provided native hash, the binding
     surface, and how Endor registers/exposes it to the XS runtime.
4. Show how blob-ref (and the XS daemon path) is refactored to consume the new
   package instead of `node:crypto`, so `bundle-bus-daemon-rust-xs.mjs` /
   `daemon_bootstrap.js` can generate and `test:rust` can run.

## Deliverable
A design doc on `endojs/endo-but-for-bots` (or `main2` if it is garden-side — use
judgment; the packages live in the fork) covering: the isolated crypto surface,
the package API + signatures, the conditional-exports map (node/browser/xs), the
**XS-host-function ⇄ Endor-Rust-native** interface contract, the blob-ref
refactor, and a phased build plan (what the first buildable increment is). Call
out any open questions (e.g. sync-vs-async WebCrypto seam) for maintainer
resolution rather than guessing. This unblocks the topic-11 xs2rust arc; note that
the follow-on implementation likely wants the **dedicated builder** the press has
been recommending, not the hourly press.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  worker_kind: gardener
  claimed_at: 2026-07-22T05:15:39Z
