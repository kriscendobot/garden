Both links resolve; the helper script was untracked scratch (torn down with the worktree). Everything is complete.

## Completion report

**Job:** Dead-lettered directive from kriskowal on garden issue #57 — "Please revise all references above to fully qualified URLs. Please take this advice generally when communicating through Github." The original addressee (`issue-kriskowal-garden-57`) had completed, so I picked up its intent.

**What I did (two parts):**

1. **Revised the references above (the literal ask).** Edited all 7 of kriscendobot's comments in the thread in place, fully-qualifying every bare reference to a repo, commit, or site as an explicit `https://` link — via a deterministic, anchor-and-count-asserted transform (no comment mangled):
   - Repo shorthands → `https://github.com/kriscendobot/ymax-e2e`, `.../ymax-stdio-mcp`, `https://github.com/agoric-labs/ymax-agent-local-mcp`, `.../kriscendobot/ymax-agent-local-mcp`
   - Bare commit SHAs (`7a6ca39`, `a3ebcca9…`) → linked to their commit URLs
   - Bare `main0.ymax.app` hostnames → `https://main0.ymax.app`

2. **Encoded the advice generally (the standing ask).** Added `skills/fully-qualified-github-urls/SKILL.md` — a GitHub-communication style rule (distinct from `relative-paths`, which keeps in-tree links relative), indexed it in `roles/COMMON.md` (§ Style + § House style) and the `CLAUDE.md` inventory. Committed and pushed to `main2` (`e488cea748`).

3. **Replied on the issue thread** (comment `#5026149113`) acknowledging the revision and the new convention, with all fully-qualified links. Caught that the garden's default branch is `main2` (no `main` branch), fixed my own reply's `/blob/main/` links to `/blob/main2/` so they resolve, and verified both. **Did not close the issue** — left open per the directive; the submitter closes.

**Follow-ups:** None. The convention now applies fleet-wide to every role authoring GitHub-rendered text; it will deploy to running instances on the next deliberate garden deploy.
