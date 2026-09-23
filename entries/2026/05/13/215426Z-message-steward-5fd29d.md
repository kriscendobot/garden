---
ts: 2026-05-13T21:54:26Z
kind: message
role: steward
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 121
    role: related
---

# Maintainer directive: dispatch `builder` to amend the just-landed #121 turborepo configuration

kriskowal at endojs/endo-but-for-bots#121 (post-merge inline comment, 2026-05-13T21:53:57Z):

> I forgot about this until after merging. Please dispatch a builder to amend this configuration on the assumption that we have obviated all devDependencies and can fully embrace turbo for ensuring packages are built before their transitively dependent tests.

Scope: amend the turbo configuration that landed in #121 (`b21f63b`) so it expresses the build-before-transitively-dependent-tests dependency, on the premise that devDependency cycles have been broken (per the recently-merged #206 design and follow-up impl work). New PR against `llm`; code work, not review feedback.

**Role gap**: `builder` is in `references/endo-but-for-bots/roles/builder.md` but not in the active library. Closest active roles (`fixer`, `designer`) are wrong shape:
- `fixer` is "address review feedback on an open PR" — doesn't cover opening a fresh implementation PR from a maintainer-directed brief.
- `designer` is "expand a short prompt into a full designs/*.md document" — design docs, not implementation.

This is the second role-gap surface routed (the first was `investigator` for #147 SES investigation, cycle 8). With two unrelated maintainer directives now blocked on missing per-role files, the pattern justifies a gardener engagement to port the missing roles:

- `builder` — covers this #121 follow-up + future implementation-from-spec engagements
- `investigator` — covers #147 SES + future bug-investigation engagements

Recommend the gardener port both in one engagement (similar batching shape to the prior `groom` port + roadmap edit).

The maintainer's directive carries per-action authorization to:
- Open a new PR against `endojs/endo-but-for-bots` with the amendment
- Comment / post status updates on the new PR

Steward will forward into the builder dispatch prompt once the role lands.

Self-improvement: the role-gap-surface count is now two; one more makes it a pattern. The garden's role library is catching up to maintainer demand reactively; a proactive "what active roles are missing" sweep by the gardener could shrink the gap-discovery cycle from "wait for the third occurrence" to "one engagement covers the next several".
