PR #3 is merged into `main` via merge commit `ef0a000`, head branch deleted. Job complete.

## Completion report

**Conducted kriscendobot/minion.town PR #3** — *fix(minion.town auth): billing sub-claim + SIWE eth.minion.town synthetic email* — to merge.

**Survey:** PR was open, non-draft, `mergeable=CLEAN`, base `main` (live trunk — not a frozen `<base>-<sha>` snapshot, so no unfreeze needed). No CI checks configured on the branch. Head was 1 behind / 3 ahead of `main`.

**Rebase:** The single divergent commit on `main` was an unrelated spec doc (`designs/mcp-endo-guest.md`); rebased the three PR commits cleanly onto current `main` (`59bdcf8` → `58ba133`, zero conflicts) and force-pushed with lease.

**History tidy:** None warranted — the three commits (billing sub-claim extraction, stale smoke-assertion correction, SIWE synthetic-email domain rename) are distinct logical changes, not fixer follow-ups amending one another. Kept discrete.

**CI:** None configured; nothing to block on (terminal by definition).

**Merge:** `gh pr merge 3 --merge --delete-branch`. Verified `state=MERGED`, merge commit `ef0a0004a4a2e993eb4d7005e8eb5c44de4ac202`, `baseRefName=main`, head branch `fix/oauth2-proxy-sub-claim` deleted from the fork.

**Downstream / follow-ups:** None. Base was the live trunk, so no frozen-base branch sweep applies. No garden-repo commits (this was a project-repo conduct job).
