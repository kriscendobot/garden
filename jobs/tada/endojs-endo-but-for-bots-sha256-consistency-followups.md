Implemented and pushed the SHA-256 consistency follow-ups to https://github.com/endojs/endo-but-for-bots/pull/903.

- Migrated both `@endo/git` hashing sites from `node:crypto` to `@endo/sha256`.
- Added binary-safe Rust `sha256Bytes`, exposed as `globalThis.hostSha256Bytes`, returning a 32-byte `ArrayBuffer`.
- Appended the callback to preserve snapshot table indices.
- Added the XS ambient declaration and Rust coverage for binary input, empty input, raw output, and host aliasing.
- Updated dependencies and `yarn.lock` in separate commits.
- Pushed commits `67b6b015d8` and `f6cd2b4fab`; posted the required PR summary.

Verification passed: `@endo/git` tests, typecheck and ESLint; `@endo/daemon` typecheck; immutable install; all three XS bundle generators; focused Rust `crypto_sha256` test. GitHub reported no CI checks immediately after the push.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-sha256-consistency-followups.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 612s

<!-- garden-usage-end -->
