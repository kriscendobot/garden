---
source: docs/decisions/0045-debian-package-worker-custody.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
section_count: 4
status: current
content_caveat: "foreign-content gate classified (jev-1.13.0): disposition proceed, injection 0.1 clean, slant neutral at confidence 0.87; fetched raw content sha256 4b10f8f9"
---

> Abstract: Literate AI ADR 0045 replaces a controller-built apt-shaped ZIP with an exact target-specific Debian projection, construction on a compatible Linux worker, and complete non-installing inspection of the returned archive.

| Section | Topics | Status |
|---------|--------|--------|
| [Apt packaging custody gap](../sections/literate-ai--docs-decisions-0045-debian-package-worker-custody--apt-packaging-custody-gap.md) | node-packaging, agentic-sdlc | current |
| [Exact Debian projection, worker construction, and archive inspection](../sections/literate-ai--docs-decisions-0045-debian-package-worker-custody--exact-debian-projection-and-worker-custody.md) | node-packaging, software-supply-chain, capability-security | current |
| [Qualification and rollout](../sections/literate-ai--docs-decisions-0045-debian-package-worker-custody--qualification-and-rollout.md) | testing, node-packaging | current |
| [Consequences](../sections/literate-ai--docs-decisions-0045-debian-package-worker-custody--consequences.md) | node-packaging, software-supply-chain | current |
