Implemented and pushed the initial Endor Git bindings tranche in commits through `e16e1979e`.

Opened draft PR: https://github.com/kriscendobot/endo-but-for-bots/pull/4

Added `rust/endor-git` with pinned vendored libgit2, safe filesystem and custom ODB/refdb backends, isolated panic-safe FFI callbacks, distinct SHA-1/SHA-256 object IDs, bounded blocking execution, conformance tests, safety documentation, cross-build tooling, linkage/sanitizer/reproducibility audits, and CI coverage.

Verified:

- 3 unit and 6 filesystem/custom conformance tests pass.
- Clippy, formatting, shell checks, AddressSanitizer, linkage, and reproducibility checks pass.
- Native Linux, macOS, and Windows CI passes.
- All four Linux Zig cross-build targets pass.
- Workflow security audit passes.
- Controlled regressions proved custom storage and reference CAS tests fail when their implementations are broken.

The structured gap report records the expected Windows GNU failure: Zig 0.15.2 compiles vendored libgit2 and dependencies but cannot link Rust’s `msvcrt` imports. Remaining release work includes ARM-native execution, provisioned macOS cross-signing, streaming/pack callbacks, the Endor materializer, and Minion Town smart HTTP integration. The repository-wide JavaScript verifier was attempted but stalled while spawning excessive daemon test processes; affected processes were terminated.

The PR remains draft for the automatic staged gauntlet handoff. A library-corpus follow-up was sent to the scholar role.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-build-endor-git-bindings.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3655s

<!-- garden-usage-end -->
