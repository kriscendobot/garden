Implemented XS bundle reconciliation and opened endojs/endo-but-for-bots#937 at head `aa8fc3ac30`.

Changes:
- Injected Node-only git and host-spawner powers; XS receives explicit unavailable stubs.
- Added platform-neutral `@endo/sha256`, removing `node:crypto` from the XS graph.
- Added `yarn bundle:xs` and a required xsnap CI bundle gate.

Verified all three XS bundles build. SHA-256, daemon XS/host-tool, platform, and chat tests passed; type checks, formatting, lint, and xsnap Cargo check passed. GitHub checks remain queued.

Self-improvement: reported the missing documented pre-push gate driver to the liaison.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-xs-bundle-llm-reconcile.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 933s

<!-- garden-usage-end -->
