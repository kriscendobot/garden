Inbox is empty. The shepherd directive is satisfied — CI is fully green, no fixes were needed.

## Completion report

**Job:** shepherd directive on endojs/endo-but-for-bots PR #570 — drive CI to green.

**What I found:** On claim, PR #570 (`refactor(genie): intra-package plain re-exports pass (#544 follow-up)`, base `llm`, draft) had 20/22 checks already green, with `lint` and `sandbox-drivers` still IN_PROGRESS. The triggering comment was an `[APPROVED] LGTM` review by erights — no requested changes, so no fix-driving was implied.

**What I did:** Polled the check rollup until all in-progress checks completed (~5 min). No failures appeared; no shepherd intervention (rerun, fix, or code change) was required.

**Final state:**
- All **22 checks SUCCESS** — including `lint` and `sandbox-drivers` which finished green.
- `mergeStateStatus: CLEAN`, `mergeable: MERGEABLE`.
- CI is green.

**No changes committed** — nothing to fix; the branch was already healthy.

**Follow-ups:** The PR remains DRAFT with an erights LGTM. Un-drafting and merge are outside shepherd scope (judge un-drafts; conductor merges). If the maintainer/liaison wants it landed, the next step is a judge/conductor dispatch — but that's a separate directive, not a CI matter.
