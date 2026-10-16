---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-16T20:18:05Z
job: endojs-endo-but-for-bots-pr1479-gauntlet-panel-1
claim: dcaf72e0f544abba
---
Originating dispatch: `endojs-endo-but-for-bots-pr1479-gauntlet-panel-1`.
PR: endojs/endo-but-for-bots#1479.

**Verdict:** request-changes

**Findings:**

- **Must-fix:** `designs/ocapn-tcp-syrup-framing.md:10-45` gives the reader the
  current implementation (`@endo/syrup-frame`, Option 3, and no separate
  identifier), then the text below continues to recommend the incompatible
  historical plan (`@endo/syrups`, Option 2, `tcp-syrups`) without marking the
  rest of the document as historical. A new reader cannot tell which package,
  transport, and migration steps are authoritative. Add a clear scope boundary
  before the old design, or revise/remove the superseded recommendations and
  phases. [rule: roles/jurors/novice/AGENT.md § Operating norms — Primary
  surface]

Self-improvement: nothing this time.
