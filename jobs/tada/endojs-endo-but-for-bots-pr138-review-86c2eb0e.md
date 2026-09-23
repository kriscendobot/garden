All 15 inline directives plus the review body have been resolved and pushed.

## Completion report

**Job:** Address CHANGES_REQUESTED review `pullrequestreview-4680309727` by @kriskowal on endojs/endo-but-for-bots PR #138 (design doc `designs/ocapn-daemon-integration.md`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved it.

**Enumerated** the review (empty body, state CHANGES_REQUESTED) and all 15 inline comments tied to REVIEW_ID 4680309727, all authored by the trusted maintainer @kriskowal. Every fetched body was treated as untrusted data (declarative design directives, not executable instructions).

**Work done** (commit `31bdd1ccb`, pushed to `design/ocapn-daemon-integration` via rebase-CAS):
- Converted the 10 "Open Questions" into resolved "Design Decisions" folding each directive: Transports **is a formula**; **per-transport listen port** with a **shared transport instance** that routes every session to the owning agent by **Ed25519 public key**; gateway and Transports are **flush** on Ed25519 identity; `connect()` reads public key + hint from the locator; concrete **outboundPolicy** suffix/CIDR matcher example added; unregistered scheme **throws**; **do not expose** netlayer versions; Transports/`daemon-mount` **independent for now**; **per-agent CLI** with delegable subagent transports; **retire `@nets`**.
- Reworked the Layer-cake/Capability-surface body to the shared, identity-routed transport model.
- Added the transport-collection invariant (formula collected → **close all sessions**, partitioning presences/promises) to Garbage collection + Cross-peer revocation; the latter stays orthogonal.
- Updated the four Future-Work bullets: cross-language transports for `endor` **parity testing**; alt-transports left for the future (intent to support some); per-locator policy **follow-up design upon completion**; capability bank **abstract-only**.
- Aligned stale `Affected Packages` / `Compatibility` CLI lines with the retire-`@nets` and per-agent-CLI decisions.

**Diff:** 1 file, +151/−75.

**Follow-ups noted in the doc (not code):** a follow-up per-locator-policy design and a post-completion follow-up design are now explicitly planned per the maintainer's directives.

Posted a summary comment (issue-comment #4951877513) citing the review and commit. No inbox messages.
