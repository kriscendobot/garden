---
title: Single most structurally interesting move
section-slug: garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value
source-slug: garden--scripts-dispatch-prepare-and-teardown-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/dispatch-prepare.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/{dispatch-prepare.sh, dispatch-teardown.sh}
total-lines: 111 (65 + 46)
ingest-cycle: 298
ingest-date: 2026-06-11
lane: chat
scope: full
parent: garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value
---

**§the-named-search-bare-clones-for-the-project-worktree** combined with **§the-named-search-IS-the-named-no-sidecar-state** — teardown doesn't *know* which bare clone owns the project worktree. Rather than *store* that association in a sidecar file (which would require prepare to write a small JSON or text file and teardown to read it), the implementation **searches every bare clone in turn** by asking `git --git-dir="$bare" worktree list` and grepping for the dispatch's project path.

This IS the **named-state-vs-search tradeoff**: the simpler design (no sidecar state) at the cost of an O(N) search at teardown time, where N IS the number of bare clones (typically a handful). The named tradeoff IS *fewer files-to-keep-consistent* vs *more-work-at-teardown*.

The pattern generalizes: any cleanup that needs to know "which resource owns this child" can either store the association at creation time (and risk staleness) or search at cleanup time (and risk O(N) cost). The named choice IS context-dependent. **§the-named-state-vs-search-tradeoff** as a named design dimension.

§the-named-implementation-makes-the-tradeoff-explicit: the comment in teardown explicitly names "We don't store which bare; ask each bare clone in turn." The choice IS visible in the code AND in the prose; the reader IS told *what was chosen* + *why* + *what was avoided*.
