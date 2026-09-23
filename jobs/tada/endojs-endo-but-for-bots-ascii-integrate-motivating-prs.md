Completed the `@endo/ascii` adoption investigation.

- Examined all 300 open pull requests through the GitHub API and searched the `llm` tree for `charCodeAt`, `Uint8Array.from`, `TextEncoder`, and related byte-copy loops.
- Found the key outstanding precursor: https://github.com/endojs/endo-but-for-bots/pull/475 independently introduced a conflicting `@endo/ascii` package with encode and decode APIs. Its encoding use must adopt the canonical encode-only, XS-safe package from https://github.com/endojs/endo-but-for-bots/pull/943.
- Found genuine adoption sites in `packages/ocapn/src/client/util.js`, `packages/ocapn/src/cryptography.js`, `packages/ocapn/src/hub/hub.js`, `packages/goblin-chat/src/host-room.js`, and `packages/goblin-chat/test/guile-interop/index.js`.
- Found open pull request https://github.com/endojs/endo-but-for-bots/pull/700 carries the goblin-chat conversion helper and needs direct integration.
- Confirmed https://github.com/endojs/endo-but-for-bots/pull/952 already routes general string secrets through `encodeSwissnum`; the OCapN adoption job changes that helper underneath it, so no separate job is required.
- Confirmed the named exclusions: netstring and syrup-frame encode generated digits and delimiters; marshal performs escape-table and offset transforms; OCapN fuzz sites generate strings rather than bytes. Base64, `atob`, ZIP-signature, and Syrup-fixture loops carry binary-byte semantics, including values above `0x7f`, so `encodeAscii` would change behavior.

Dispatched three high-priority jobs, all parked behind pull request 943:

- `ebfb-pr475-integrate-endo-ascii`
- `ebfb-ascii-adopt-ocapn-sites`
- `ebfb-pr700-integrate-endo-ascii`

No project or garden source files changed. The journal postings and two OCapN-site annotations landed successfully.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ascii-integrate-motivating-prs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 719s

<!-- garden-usage-end -->
