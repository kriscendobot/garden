---
title: "ADR 0045: Apt packaging custody gap"
source: docs/decisions/0045-debian-package-worker-custody.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [node-packaging, agentic-sdlc]
status: current
---

> Abstract: The apt provider emits a ZIP rather than a Debian package, guesses neither target architecture nor dependency coordinates, and abandons selected-worker custody when packaging returns to the controller.

The `package-apt` Flavor promises a deterministic Debian binary package, but the
current adapter produces a ZIP containing `DEBIAN/control`. It neither constructs a
`.deb` nor asks Debian tooling to inspect one. Its control file also declares
`Architecture: all` without proving platform independence and cannot derive installable
Debian dependency coordinates from human-facing runtime requirement names.

Package orchestration has another custody mismatch. It can select and observe a Linux
worker for the accepted build lifecycle, then returns to the controller to construct
native package bytes. A macOS or Windows controller therefore cannot truthfully satisfy
an apt request even when the selected worker has the required Debian tools. Merely
replacing the ZIP writer on the controller would preserve that contradiction.

The accepted `PackagePlan` already binds the Component lock, target, artifact graph,
logical inputs, entrypoints, runtime requirements and packager identity. Provider-native
path, architecture, dependency and tool decisions must become exact derived authority
rather than ambient choices made after the plan is accepted.

Source: [docs/decisions/0045-debian-package-worker-custody.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0045-debian-package-worker-custody.md) at commit `fcc40bc6`.
