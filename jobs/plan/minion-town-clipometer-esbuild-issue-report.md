---
gate: orchestrated
orchestrated_by: minion-town-clipometer-esbuild-orchestration
priority: normal
posted_by: producer
posted_at: 2026-09-03T06:52:10Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
project: minion-town
orchestration: minion-town-clipometer-esbuild-orchestration (child 4 of 4, serial — runs last)

File a GitHub issue on `kriscendobot/minion.town` reporting the outstanding challenges surfaced across this whole exploratory effort (children 1-3): moving CLIPOMETER's clip client from a hand-rolled CapTP-lite implementation to real `@endo/captp` via an esbuild pipeline. Maintainer directive (dckc), 2026-09-03: *"I would also be obliged if a report can be made by posting an issue to the minion.town repository with any outstanding challenges revealed in the process."*

## What to include

Pull the concrete findings from children 1-3's completion reports and the PR(s) they opened — do not re-derive from scratch. At minimum, cover:

- Whether `@endo/exo-stream` was vendored or pulled via a git dependency, and how that went (this package is confirmed **not published to npm** as of this engagement — a real gap if other clip authors hit the same need).
- The achieved bundle size, and whether `ses`/`@endo/init` (required because `@endo/captp` is HardenedJS and needs `lockdown()`) dominates it as expected, or whether tree-shaking left something surprising in.
- Whether `publish`'s lack of a file-path option (inline base64 only) is worth a feature request in its own right, now that a programmatic build+publish path exists to route around it — note that the workaround exists, but ask whether upstream support would still be worth it for guests without the tooling to build one themselves.
- Anything from child 2's live validation that was surprising (browser CapTP wiring vs. the server's netstring-over-UDS transport in `src/endo/captp-client.ts` — confirm whether that module's SES/lockdown discipline transplanted cleanly, or needed adjustment for the browser entry point).
- Whether the `@endo/gateway` package (`packages/gateway` in `endojs/endo-but-for-bots`, referenced from this repo's own `journal/projects/minion-town` notes as the intended eventual home for this kind of code) is a better long-term home for the programmatic publish tooling than this repo, per the maintainer's standing architecture directive that minion.town is "a deployment + configuration layer, not a code home."
- Any open questions children 1-3 flagged but didn't resolve (name them plainly; don't silently drop them).

## How to post it

Use `gh issue create --repo kriscendobot/minion.town` with a clear title (something like "Clip client: hand-rolled CapTP vs. real @endo/captp — findings from the CLIPOMETER esbuild migration") and a body that links the PR(s) from children 1-3 (fully-qualified `owner/repo#N`, per this garden's standing convention — never a bare `#N`) and the primer's live URL from child 3. This is a **report**, not a request for more work to be auto-assigned — end it by naming the concrete open items rather than a vague "let us know what you think."

## Deliverable

The issue's URL, cited in your completion report.
