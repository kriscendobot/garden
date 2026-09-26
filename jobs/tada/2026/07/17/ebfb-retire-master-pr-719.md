The PR is untouched (base still `master`, head still `f11aacfa41`, open, non-draft). I gathered decisive evidence that this PR cannot be swept as directed. Report follows.

---

**Job `ebfb-retire-master-pr-719` — retire-master sweep for endojs/endo-but-for-bots#719**

**Outcome: NOT wedged — reported for maintainer follow-up (diverged mirror, conflict beyond a focused weave). PR left untouched.**

**Preflight confirmed**
- PR #719 ("feat(ses): permit URL and URLSearchParams as a vetted shim") is **OPEN**, non-draft, base = `master`, head = `feat/hardened-url-vetted-shim` @ `f11aacfa41` (same-repo branch, not cross-repo).
- Upstream `endojs/endo` master = `46d4edf3…` (short `46d4edf`), 2026-07-17.
- The upstream reflection **`master-46d4edf` already exists** on the fork and equals the upstream commit exactly — no reflection creation needed.

**Why the sweep was not applied (the blocking condition)**
The fork's own `master` trunk (fcbb540, where the PR sits) has **genuinely diverged** from upstream `endojs/endo` master, not merely fallen behind:
- fork `master` (fcbb540) is **70 commits ahead / 16 behind** upstream `46d4edf`, diverging at merge-base `a7ff191`.
- Those 70 commits are the fork's **own trunk work** — the `packages/cbor` package, patterns fixes (#720), hex-decode benchmarks (#580), `stream` flatMapReader (#545), eslint refactors, function-keyword retirement, etc. — **none of which is in upstream endojs/endo**.
- The PR head is a clean **6-commit** PR sitting directly on fcbb540 (0 behind fork master); its own commits (`fix(cbor): complete workspace metadata`, `fix(cbor): type canonical fixture cases`) **depend on the fork's cbor package**.

I test-rebased the 6 PR commits onto upstream `46d4edf` (`git rebase --onto 46d4edf fcbb540 feat`) in an isolated throwaway worktree (never pushed):
- It **failed with conflicts** — stopped at commit 4/6 with `CONFLICT (modify/delete): packages/cbor/package.json deleted in HEAD and modified in the PR` (upstream endo has no cbor package), plus a `yarn.lock` content conflict.
- The resulting tree would drag in **445 unrelated files** of fork-vs-upstream divergence beyond the PR's true 24-file diff.

This is squarely the directive's guarded case: freezing "from upstream endojs/endo master" is impossible here without corrupting the PR, and the directive **forbids** cutting the reflection from the fork master SHA. So per the directive ("if there is a conflict beyond a focused weave, report it rather than changing the fork master; if a stale/diverged mirror, do not wedge this sweep"), I stopped.

**What changed:** Nothing. No force-push, no `gh pr edit`, no change to fork `master`, no new branch pushed to origin. PR base remains `master`, head remains `f11aacfa41`.

**Maintainer follow-up needed (decision required):**
- endo-but-for-bots `master` is a **divergent bot trunk**, not a clean mirror of upstream endojs/endo master, so this PR cannot target a *upstream* `master-<sha>` reflection without a full 70-commit divergence rebase.
- The only conflict-free frozen base for #719 is **`master-fcbb540`** (snapshot of the fork-master SHA the PR already sits on) — which sibling PRs #765 and #762 already use — but that uses the *fork* master SHA, which this directive explicitly disallows. Please confirm whether, for PRs built on the fork's own diverged trunk, the sweep should (a) pin to the fork-master reflection `master-<forksha>`, (b) leave them on moving `master`, or (c) something else. PR **#768** (base=`master`, head=`bot/migrate-npm-2708cacc`) is the other un-swept `master`-based PR and may hit the same condition.
