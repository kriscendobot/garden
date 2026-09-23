Work complete. Summary report follows.

---

**Job:** attention directive on endojs/endo-but-for-bots PR #855 (`docs(designs): Endor packaging and release system`).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no prior peer resolution) → proceeded.

**Directive (untrusted comment, treated as data):** maintainer kriskowal asked to *wait for #600 to liberate xsnap of a C-toolchain dependency*, noted this also bears on *whether to rely on a Rust crate with libgit bindings*, and asked to *cross-reference the relevant PRs and issues*.

**Routing:** This is a design-stage draft PR receiving reviewer feedback. Routed to a design-doc amendment (not a build — the maintainer wants to wait), plus a reply on the PR.

**What I did** (in an isolated project worktree off `design/endor-packaging`):
- Amended `designs/endor-packaging.md` (commit `44e84b4bd`, pushed to `design/endor-packaging`):
  - Added a **"Contingent on the in-flight XS-to-Rust port — wait for #600"** callout right after the C-toolchain premise, stating the C-toolchain-per-target shape is the *pre-#600 baseline*, not a permanent given, and packaging should wait for #600 before committing to the native-runner matrix.
  - Added a **coupled-decision** callout on the git backend: `git2` (libgit2, C) vs pure-Rust `gitoxide`/`gix` carries the same C-toolchain question; post-#600 it becomes the *deciding* factor for a pure-Rust `endor`.
  - Cross-referenced #600, `daemon-endo-rust-sqlite`, `daemon-git-capability`, and `daemon-git-remotes` in the **Dependencies** table (with a directive-gating row), **Known Gaps**, and the **Status** field. Flagged the residual `rusqlite` SQLite C that #600 does not remove.
  - Verified all four relative doc links resolve on the branch.
- Posted a PR reply summarizing the resolution: https://github.com/endojs/endo-but-for-bots/pull/855#issuecomment-5078782024

**Verification:** commit pushed (`a6473d547..44e84b4bd`), diff = +54/−3 in one file; link targets confirmed present; reply comment posted. No code/tests touched (design-doc only, no runtime surface).

**Follow-ups:** None to schedule. PR #855 stays a design-stage draft, deliberately gated on #600 — no build or un-draft should be posted until #600's direction settles. When #600 lands, this design needs re-scoping (native-runner matrix, `vendor-xs.sh`, "needs a C compiler" caveats all become conditional) and the git-library choice should be made in the git-backend design.
