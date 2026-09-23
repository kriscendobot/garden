---
kind: dispatch
role: groom
host: endolinbot
posture: liaison
short_id: b7603b
dispatch_root: dispatches/groom--b7603b
repo: endojs/endo-but-for-bots
branch: llm
---

Maintainer-authorized design-status sweep (per maintainer directive
at this tick): systematically review every `designs/*.md` whose Status
is not Complete / Implemented / Deprecated, detect whether the work
has already been completed on `llm`, and update the design files with
completion dates + references. Propose a single PR that amortizes
all updates.

Context: the contractor escalated this pattern earlier today
(`062941Z-message-general-contractor-statussync.md`) after six
"Status: Not Started but already shipped" impasses on builder
dispatches this engagement. The maintainer has now authorized the
sweep.

Dispatch root: `dispatches/groom--b7603b`.
