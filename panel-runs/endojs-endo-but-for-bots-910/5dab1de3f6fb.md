---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 910
panel_kind: code
base_ref: a3064e1a2
rounds: 1
disposition: error
must_fix_total: 6
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 5dab1de3f6fb
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #910 (code)

Terminal disposition: **error** after **1** round(s).

## Round 1 — head `5636be6e`

seat verdicts (10): archivist=error assessor=error curator=error locksmith=error migrator=error packager=must-fix prover=error stylist=must-fix typist=error warden=error
must-fix items (6):
- packager: ## Per-juror block — packager (PR endojs/endo-but-for-bots#910)
- stylist: **must-fix** — `packages/daemon/src/mount.js:1557` and `packages/daemon/src/manager.js:1850` name a freshly-authore...
- stylist: **must-fix** — `packages/platform/test/blob-range.test.js:24`, `const bytesOf = str => encoder.encode(str)`. Freshl...
- stylist: **should-fix** — `packages/platform/src/fs/blob-range.js:381` hardcodes `'ReadableBlob range: ...'` in `help()`, wh...
- stylist: **should-fix** — `packages/daemon/src/types.d.ts:1217`, `:1272`, `:1316` declare `range(start: bigint, end: bigint)...
- stylist: **comment-only** — `RichReadableBlob` names a comparative rather than the capability it adds (content address plus ...
