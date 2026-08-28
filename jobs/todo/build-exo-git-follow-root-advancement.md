---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build exo-git followable root advancement

Repo: `endojs/endo-but-for-bots` (implementation work on the
`kriscendobot/endo-but-for-bots` fork).

Implement the accepted design `designs/exo-git-follow-root-advancement.md`,
merged from PR #889 into the roadmap branch `llm` at merge commit
`059e18d07c717a2d89dd852b374b82dde765c016`. This job was explicitly requested
by maintainer comment 5456448695.

Follow the builder role and the design's implementation plan and acceptance
criteria. Read the design from `llm`, but choose the implementation base using
the builder's package-availability rule (use the natural implementation branch
when `packages/exo-git` exists there). Implement the mergeable feature through
the core snapshot/transition follower, in-band mutation notifications, polling
watcher, and integration coverage described by the accepted design. Keep native
`fs.watch` work deferred behind the designed seam unless the accepted document
requires it for the initial implementation.

Open exactly one draft PR with `scripts/jobs/gardening/ensure-pr.sh`; the normal
builder gauntlet owns clean, panel review, fixes, and un-drafting. Run the
project's format, lint, type, and relevant test commands plus the garden
pre-push gates before the initial push. Demonstrate regression evidence for
each new test and report the commands and observed results.
