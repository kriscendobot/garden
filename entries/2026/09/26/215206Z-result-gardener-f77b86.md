---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-26T21:52:08Z
---
Answered the maintainer's range-offset question on https://github.com/endojs/endo-but-for-bots/pull/1089#issuecomment-5850195539. The `Number.MAX_SAFE_INTEGER` ceiling is imposed by the project's safe-number adapters, not Node: Node 22.23.2 accepted a `FileHandle.read` position of `9007199254740992n` and returned EOF. `cap_std::fs::FileExt::read_at` accepts `u64`, so both hosts can support wider offsets after the shared backing contract and XS bridge carry 64-bit positions. Recommended keeping that cross-backing change separate from this narrow overflow fix. No source changes or pushes were made.

Self-improvement: nothing this time.
