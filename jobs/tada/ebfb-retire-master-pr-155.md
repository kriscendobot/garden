This PR meets the job's explicit **long-idle mirror** bail condition, so I am honoring the guard and **not** mutating the PR. I did not push or edit the base — the rebase I ran was a local, non-destructive trial only.

Report:

---

**Job: retire master base for endojs/endo-but-for-bots#155 — DEFERRED to maintainer (long-idle mirror guard).**

**PR state confirmed (preconditions):**
- PR #155 is **OPEN** and currently targets **`master`** (baseRefOid `6804b7d`, a fork-master snapshot from 2026-05-22). ✓
- Head: `mirror/endo-3246-namespace-consistency` @ `7ef09a68` (in the `endojs` org repo, not a kriscendobot fork).
- Title: "fix(ses): exported namespace consistency … [mirror of endojs/endo#3246]".

**Why I did not proceed — the "long-idle / stale mirror" guard fired:**
- Mirror PR #155: no activity since **2026-05-22** (~56 days); head last commit **2026-05-08** (~70 days).
- Its upstream origin **endojs/endo#3246** is itself open-but-idle since **2026-05-08** (~70 days).
- Retiring the base to the upstream reflection would bridge **202 commits** of upstream `ses`/`compartment-mapper` drift (2026-05 → 2026-07). A clean git rebase over that much drift in fast-moving packages does **not** guarantee runtime correctness (weaver skill's tree-merge-vs-runtime caveat), and validating it would require a full build+test of a mirror that may be abandoned.

The job instructs: *"If the PR is a long-idle or stale mirror, do not wedge this sweep: record the condition in the completion report for maintainer follow-up."* This PR is objectively long-idle on both sides, so I flagged it rather than force-pushing/base-editing an idle mirror whose fate (keep-and-freeze vs. close alongside stalled #3246) only the maintainer should decide.

**Useful finding for when the maintainer chooses to proceed (low risk):**
- The upstream reflection **`master-46d4edf`** already exists on `endo-but-for-bots` and points at the current upstream `endojs/endo` master tip `46d4edf3` (per the directive: base SHA from upstream endo master, not fork master). No new reflection branch needs to be created.
- A trial rebase of the 10 PR commits onto `46d4edf` applied **cleanly, zero conflicts** — so the eventual retire is a focused, low-conflict operation. The only remaining question is post-rebase test validation across the 202-commit drift, which I did not run.

**Mutations performed:** none. No push, no `gh pr edit`, no fork-master change. Local trial rebase only, in the disposable project worktree.

**Follow-up for maintainer:** decide whether to (a) retire base + validate #155 given upstream #3246 is stalled ~70 days, or (b) close the mirror. If (a): reflection `master-46d4edf` is ready and the rebase is conflict-free; just needs `--force-with-lease` of the rebased head + `gh pr edit 155 --base master-46d4edf` + affected-package test run.
