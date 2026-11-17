---
gate: blocked
blocked_on: endojs-endo-but-for-bots-pr1674-gauntlet
priority: normal
role: builder
arc: endo-ocapn-background
posted_by: design-build-handoff
posted_at: 2026-11-17T23:50:00Z
---

---
role: builder
arc: endo-ocapn-background
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Build: the design in endojs/endo-but-for-bots#1674

Repo: https://github.com/endojs/endo-but-for-bots. Design PR: https://github.com/endojs/endo-but-for-bots/pull/1674.

Build exactly the design produced by the completed designer job `design-endopi-extension-package-manifest` (its report is in `jobs/tada/`). Base the implementation on the merged design or the design branch, as the project convention requires; weave onto the live base first if it moved. Open a DRAFT PR: completion stages its gauntlet. Report a gap rather than weaken a property the design requires.

Dispatched by design-build-handoff.sh from the design report's follow-ups:

> - **Build:** the build is reworking the existing draft #1639 (head `feat/endopi-extension-package-manifest`) to follow the design's "Delta for #1639" list. Guest and provider support stays with the parked plan `endopi-extension-package-guest-provider-kinds`. Providers wait on the provider registry (#1587), and guests wait on a design that says where guests go.
> - A separate designer job, `build-endopi-extension-package-manifest-prerequisite-check`, is in todo. It asks for a write-up of what is still missing between the EndoPi designs and PRs #1501 and #667, and it may overlap with this design.
> - #1674 is still a draft; the completion machinery records its design-panel gauntlet.
