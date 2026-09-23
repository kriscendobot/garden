Completed `ebfb-exo-stream-drop-base64-stream-methods`.

- Removed `streamBase64` throughout `packages/**`; bytes now use generic `stream()` with immutable `Uint8Array` chunks.
- Retained the four byte adapters as the canonical freeze/thaw boundary.
- Updated 75 files across consumers, interfaces, types, tests, generated artifacts, documentation, help text, dependencies, and major changesets.
- Measured and documented the current byteArray marshal regression, copy/transfer constraints, and Node/XS immutable-ArrayBuffer emulation.
- Opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1100
- Full GitHub gauntlet passes across Node 22/24, Linux/macOS, coverage, lint/types, XS, browser, sandbox, and release checks.
- Follow-up: compact byteArray marshalling and ownership-aware transfer are needed to recover wire size and throughput.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-drop-base64-stream-methods.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 11934s

<!-- garden-usage-end -->
