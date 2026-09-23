---
section: three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
source: endo-but-for-bots--llm-designs-app-sharing-milestone
topics: [daemon, agent-conventions, chat-ui]
status: current
title: The §Pillar-1-adopts-familiar-release.md discipline
parent: endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline
---

The most structurally interesting *governance* move:

> *This pillar is already an active workstream — defer to it,
> do not restate. The gap analysis and release plan live in
> `familiar-release.md` (PR #231)...*
>
> *This milestone adopts `familiar-release.md`'s plan for
> Pillar 1 rather than offering a competing one.*

The §adopt-existing-plan-don't-compete-with-it discipline.
This document *refuses* to re-spec what another design owns.
The §two-designs-must-not-define-the-same-thing-twice
invariant: if Pillar 1 has an owner-design, this milestone
defers; it doesn't *re-enumerate* the sixteen gaps G1-G16, it
*cites* them.

The §named-deferral move: the document explicitly names what
it's *not* covering and where to look. Readers can follow the
trail to `familiar-release.md` (PR #231) for the actual
release plan; this milestone provides *only* the framing that
ties Pillar 1 to Pillars 2 and 3.

The §macOS-arm64-first MVR scope (inherited from
`familiar-release.md`):

> *...importantly — scopes the MVR to macOS arm64 only (the
> maintainer's primary platform), deferring Linux/Windows to
> followups.*

The §narrow-MVR-scope discipline: rather than ship-everywhere-
or-don't-ship, the plan ships *first* on the maintainer's
primary platform. Linux/Windows are explicitly *MVR
followups*, not blockers. The §maintainer-platform-first
ordering.

The §swarm-of-G-item-PRs catalog (lines 67-79) lists ten
named PRs implementing specific G-items: CI build pipeline
(G1, PR #318), arm64+x64 matrix (G15, #321), icon projection
(G7, #319), Node LTS pin (G5, #316), stop/purge (G8, #320),
LICENSE aggregation (G14, #323), Primer-CAS smoke (G16,
#324), Flatpak (#322), telemetry (#317), packaging lanes
(#360). The §workstream-already-in-flight observation.
