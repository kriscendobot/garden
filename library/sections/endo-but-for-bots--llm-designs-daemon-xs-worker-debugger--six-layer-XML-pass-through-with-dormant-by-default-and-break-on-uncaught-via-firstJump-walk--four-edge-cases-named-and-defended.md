---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
title: §Four-edge-cases-named-and-defended
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

The augmentation section enumerates four edge cases:

| Case | Behavior | Mitigation |
|------|----------|------------|
| **Promises** (`Promise.reject` / unhandled rejections) | Go through `fxCheckUnhandledRejections`, not `XS_CODE_THROW`. Augmentation doesn't apply. | XS's existing unhandled-rejection reporting handles this separately. |
| **Re-throw** (`catch` rethrows) | `XS_CODE_THROW` fires again; firstJump walk reflects new handler chain. | Correct by construction. |
| **`finally` without `catch`** | Compiles to `XS_CODE_CATCH` with `flag == 1`; walk sees it as "caught" though it will re-throw after finally. | Accepted as minor false negative for v1; could distinguish with `flag == 2`. |
| **Nested C host boundaries** | `flag == 0`; walk does not count as JS catch. | Usually correct: host-boundary catches typically indicate error. |

§The-§finally-without-catch case is the §honest-known-limitation
discipline. §Cycle-178-daemon-xs-worker-snapshot had §revised-
scope-discussion-2026-04-15; §this-design-names-the-limitation-
in-the-edge-case-table. §Both-are §honest-design-evolution-
record patterns.
