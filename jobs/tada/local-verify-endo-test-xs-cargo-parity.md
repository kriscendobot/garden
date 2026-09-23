Implemented and pushed commit `66ed3602f7` to `main2`.

- Added a stable Rust toolchain to the garden image, including build-time `cargo` and `rustc` smoke checks.
- Made `test:xs` initialize direct git submodules generically before execution while remaining silent on success.
- Added an uninitialized-submodule regression fixture. It produced 4 failures without the fix and passed all 76 tests with it.
- `bash -n` and ShellCheck passed.
- A real `endojs/endo-but-for-bots@llm` hardened262 XS run completed silently with the pinned xst, initialized `c/moddable`, and Cargo. The broader deliberately build-skipped probe later failed at `packages/ses` because `dist/ses.umd.js` was not built.
- Docker itself was unavailable, so a full image build was not run. The exact rustup/proxy arrangement was exercised separately with Cargo and rustc 1.98.0.
- Self-improvement: updated the local-verify skill and field notes with the Cargo and submodule parity requirements.
- Removed the isolated project checkout and temporary Rust installation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/local-verify-endo-test-xs-cargo-parity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1247s

<!-- garden-usage-end -->
