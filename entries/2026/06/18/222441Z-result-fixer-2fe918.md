---
ts: 2026-06-18T22:24:41Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/20260618T222036Z--endolinbot--fixer--6fb0--79bb38--lal-pi-290-readme-genie-refs.md
---

Summary-fix job 79bb38 for PR #290 (feat/lal-pi-harness) complete.

Addressed all 3 README items from the justice r2 code panel (563085):
1. Architecture attribution updated from `@endo/genie`'s pi-based agent loop to `@mariozechner/pi-agent-core`'s pi-based agent loop.
2. Construction reference updated from `makePiAgent` to `new PiAgent(...)`.
3. Ollama provider table cell: removed "(via @endo/genie's adaptor)" parenthetical.

Also fixed pre-existing sentence-per-line style issues in the Architecture and Configuration paragraphs.

Commit: c7e6892ea on feat/lal-pi-harness.
Top-level summary posted on PR #290 at-mentioning @kumavis.

next: liaison (PR is non-draft; awaiting maintainer review for merge).

Self-improvement: nothing this time.
