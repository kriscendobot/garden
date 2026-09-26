Job complete. Inbox empty, no garden-dev changes to commit (this was a project-repo mutation only).

## Completion report — `ebfb-retire-master-pr-250` (weaver)

**Task:** Retire the live `master` base for endojs/endo-but-for-bots#250 under the 2026-07-16 maintainer directive.

**Preconditions confirmed:**
- PR #250 is **OPEN**, non-draft, and was targeting the live `master` branch.
- endojs/endo-but-for-bots is *not* a fork of endojs/endo (`isFork: false`); its `master` branch is a drifting mirror. I sourced the base SHA from **upstream endojs/endo master** (`46d4edf3171…`, the current tip), never from the fork master (`fcbb540…`), which is **diverged** from upstream (70 ahead / 16 behind, and `fcbb540` is not even present in endojs/endo) — exactly the drift the directive guards against.

**What I did:**
1. Reused the existing fork reflection branch **`master-46d4edf`** (already present in endojs/endo-but-for-bots, pointing at upstream endo master tip `46d4edf`).
2. Identified the PR head's true fork point from endo master (`c2fc02eb8bf`) and rebased its 4 CI commits onto `master-46d4edf` via `git rebase --empty=keep --onto`. **No conflicts** — a clean forward-rebase across the intervening endo history; the empty CI-nudge commit was preserved.
3. Verified the net diff is still the focused, meaningful change: **8 `.github/workflows/*.yml` files, npm lifecycle scripts disabled** (58 insertions, 3 deletions).
4. Pushed the rebased head (`fff9c65…` → `6029ba736a8`) with `--force-with-lease`.
5. Moved the PR base with `gh pr edit --base master-46d4edf`.

**Final state:** PR #250 — OPEN, **base `master-46d4edf`** (frozen reflection), head `6029ba736a8`, **MERGEABLE**, 8 changed files. The live-master base is retired; the fork master was not touched.

**Follow-ups:** None. The rebase was clean (no conflict beyond a focused weave), and the PR is not stale/wedged. Note only that GitHub reports 66 Dependabot vulnerabilities on the repo's default branch (pre-existing, unrelated to this sweep).
