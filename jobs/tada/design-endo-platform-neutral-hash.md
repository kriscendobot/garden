Draft PR #824 confirmed: draft against `llm`. Inbox empty. The job is complete — this is a project-side deliverable (design doc + draft PR), no `main2` changes needed.

---

## Completion report

**Job:** `design-endo-platform-neutral-hash` — designer job to spec a platform-neutral hash package unblocking the XS/endor daemon bundle (`endojs/endo-but-for-bots#600`).

**What I did**
- Investigated the *actual* crypto surface on the XS daemon bundle path rather than designing for the assumed one. Key findings, all evidence-backed by reading the tree:
  - The needed digest is **SHA-256 only, one-shot, over binary (`Uint8Array`)**. SHA-512 exists only in `check-bundle` and `compartment-mapper/node-powers.js`, both **off** the XS daemon bundle graph → **no `@endo/sha512` needed now**.
  - The named blocker is `blobref.js`'s **module-scope static** `import { createHash } from 'node:crypto'`, reached via `fs/extended` → `wrap-backend.js`, which is **not** in the bundler's `EXCLUDED_PACKAGES` and genuinely executes at runtime (can't be elided).
  - **Streaming SHA-256 is already solved** — the injected `CryptoPowers` (`makeXsCryptoPowers`) is already backed by Rust host functions; it's not a bundler blocker because nothing statically imports `node:crypto` for it. The fix is narrow: only the static-import seam.
  - The **xs condition can bind to host SHA-256 that already exists** (`hostSha256Init/UpdateBytes/Finish` in `rust/endo/xsnap/src/powers/crypto.rs`, `sha2` crate) → **first buildable increment needs zero engine changes**. Also caught that the existing one-shot `hostSha256` is string→hex and **binary-unsafe** — a real trap the design routes around.
  - The **browser condition** has prior art: `packages/chat/node-crypto-shim.js` is a 216-line synchronous pure-JS SHA-256, which also resolves the WebCrypto async-vs-sync tension.

**What changed**
- New design doc `designs/platform-neutral-hash.md` on `endojs/endo-but-for-bots`, covering: isolated crypto surface, `@endo/sha256` API (`sha256`, `sha256Into` BYOB) + signatures, node/browser/xs conditional-exports map, the **XS-host-function ⇄ Endor-Rust-native interface contract** (existing globals table + optional `host_sha256_bytes` addition with registration-order discipline), the one-line `blobref.js` refactor, the git-injectability distinction, a 5-phase build plan, alternatives, and open questions.
- Mermaid diagram validated (parse-only): `OK flowchart-v2`.
- Committed on `design/platform-neutral-hash`, pushed to the bot fork, opened **draft PR #824** against roadmap branch `llm` (verified `isDraft:true`, `base:llm`).

**Follow-ups / open questions for the maintainer**
- **WebCrypto sync/async seam** (flagged in the doc + PR body): design proposes pure-JS-sync as browser default with WebCrypto as an optional async export, rather than forcing `BlobRef` construction async — needs maintainer confirmation.
- Whether to add the one-shot `host_sha256_bytes` Rust function in increment 1 or defer.
- Whether to migrate `native-git-backend.js`'s two sha256 sites in the same arc (they exit the XS bundle by exclusion regardless).
- Implementation should go to the **dedicated xs2rust builder** the topic-11 press has been recommending, not the hourly press.

No `main2` (garden-side) changes were required.
