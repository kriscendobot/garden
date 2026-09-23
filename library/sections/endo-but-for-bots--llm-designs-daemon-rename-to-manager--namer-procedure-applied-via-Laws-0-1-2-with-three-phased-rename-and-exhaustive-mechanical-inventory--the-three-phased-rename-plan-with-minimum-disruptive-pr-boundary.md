---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §three-phased rename plan with §minimum-disruptive-PR-boundary
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

§Phased Implementation:

| Phase | Scope | Reviewability |
|-------|-------|---------------|
| **1** | File renames only via `git mv`; import-specifier updates | Mostly path changes |
| **2** | Identifier renames (project-wide grep-replace) | Semantic content change |
| **3** | Consumer updates in workspace | Cross-package validation |

The §minimum-disruptive-PR-boundary discipline: each phase is
*independently mergeable*; phase 2 depends on phase 1, phase 3
depends on phase 2. §incremental-rename-not-big-bang.

§Phase-1-safest-review-rationale:

> *Phase 1 file renames create the largest mechanical churn but
> are the safest review. Reviewers can validate by reading
> import diffs; nothing about runtime behavior changes.*

The §big-churn-but-easy-review insight: counterintuitive that
the *largest* diff is the *easiest* review. The §git-mv-
preserves-blame property makes phase 1 trivially reversible
and trivially verifiable.
