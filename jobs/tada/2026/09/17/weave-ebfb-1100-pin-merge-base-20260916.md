Completed endojs/endo-but-for-bots#1100 merge-base pin and semantic rebase.

- Pinned current `llm` (`387ea66146a0b64d9d94a858369b0d37b09c55db`) as `llm-387ea66`; PR base and frozen branch match.
- Rebased and pushed head `b9c91bd162e5caf4202dfead2a081b1cd5f0f60c`.
- Ported all three drifted consumers semantically:
  - 9p `Tread`: `byteLengthLimit: want`, the requested byte count already clamped to `msize`.
  - Asset-server file reader: `max(100_000, size + 1024)`.
  - Serve-tree blob reader: the same `max(100_000, size + 1024)`.
  The latter two preserve the default floor and framing headroom while removing the obsolete base64 4/3 expansion.
- Verified the complete 32-check GitHub rollup green. Local suites passed: 9p-server 57 tests, endo-fs-asset-server 25, codex-sandbox 187.
- Posted the completion summary: https://github.com/endojs/endo-but-for-bots/pull/1100#issuecomment-5706794209
- Resumed the halted gauntlet at FIX round 2 under `ebfb-exo-stream-drop-base64-stream-methods-gauntlet-resume-at-fix-20260917`; its fix child is running. It did not restart viability, clean, or prior panel rounds.
- Self-improvement: routed a structural gap to liaison requesting a supported CAS-safe resume-from-stage primitive for halted gauntlets.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-ebfb-1100-pin-merge-base-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (2 unmetered)
- Input: 368 tokens (40569413 cached reads)
- Output: 203120 tokens
- Cost: $31.582286499999995 (2 engagement(s) unpriced)
- Wall-clock: 6886s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
