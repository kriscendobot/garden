---
ts: 2026-05-13T03:54:59Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/034937Z-result-steward-b9d3d5.md
  - entries/2026/05/13/035237Z-message-steward-dc1809.md
---

# Dispatch: gardener batches three #128-derived meta-evolution asks

Dispatch root: `dispatches/gardener--pr-formation-topo-deps--20260513-035459--6f1a2e/`. Single batched gardener engagement, as the steward recommended in `entries/2026/05/13/035237Z-message-steward-dc1809.md` § Self-improvement.

The three asks are all gardener-shaped and structurally interlocked (topo sort consumes dependency data; both share an ordering vocabulary the journalist will read):

1. **Capture the PR-formation discipline as a skill** (or as additions to existing skills). Source: kriskowal's `#128#issuecomment-4437027474` ("Use the github template for pull requests. Do not include checklists or draw attention to specific files. These instructions are relevant to PR formation in general and should be captured in skills of relevant roles for future reference.") Reference: the gardener's analysis of which active roles author PRs (fixer, builder, weaver, conductor, boatman) and where the discipline fits.

2. **Add a topological-sort ordering rule to the journalist** within each milestone bin, breaking ties by PR number ascending. Rows whose dependencies are not in the same section sort to the top of their bin. Possibly extract `skills/pr-dependency-topo-sort/SKILL.md` if the algorithm earns its own home.

3. **Add a dependency registry to the journal** so the journalist (and any other role) can read PR dependencies declaratively, not by parsing row text. Steward recommended shape 1: per-PR files under `journal/pr-deps/<owner>--<repo>--<n>.md` with `blocks:` and `blocked_by:` frontmatter lists. Schema lives in `journal/pr-deps/README.md` (similar in pattern to `journal/worktrees/README.md`). Plus `skills/pr-dependency-graph/SKILL.md` for the read-and-walk algorithm shared by the journalist's topo sort and any future ordering use.

Out of scope:

- Do **not** edit any per-PR row text on `journal/README.md`. The steward already annotated #128 inline (`waiting on: fixer + exo-zip/exo-unzip merge (#160); CHANGES_REQUESTED; depends on #160`); leave that as-is until the next journalist run picks up the new dependency-registry data and rewrites the section.
- Do **not** dispatch a fixer for #128 in this engagement. That is its own future dispatch (the maintainer's directive authorized it; the fixer dispatch needs its own per-dispatch worktree triple and a separate dispatch entry).
- Do **not** port the investigator role. The steward's cycle summary mentions one is missing for SES-investigation work; that is a separate ask and a separate gardener engagement.

Report on return: per-ask file list + commit SHAs, one-paragraph design summary of how the three pieces interlock (esp. the dependency-graph format the journalist reads), any messages routed to liaison for follow-up.
