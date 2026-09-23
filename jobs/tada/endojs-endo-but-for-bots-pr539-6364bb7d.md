The job is complete. Final report:

---

## Completion report: attention directive on endojs/endo-but-for-bots PR #539

**Directive (trusted, from kriskowal):** the `endor`-syscall design branch was not intended to land; repurpose the PR — rewrite title/description/content, remove the design file, drop FinalizationRegistry-release and `retain`/`release` syscalls for sturdyrefs/presences, and instead pursue sturdyrefs enlivened on demand by the closely-held OCapN network capability.

**Routed to:** a designer rewrite, executed in an isolated worktree off the PR branch (bot identity).

**What I did**
- Treated the comment as data; confirmed kriskowal as the verified author. Established that PR #539's whole diff was the file `designs/sturdy-refs-endor-syscall.md` (the same file #510 merged into `llm-65b0abe`), and that the abandoned design already contained the chosen on-demand-enlivenment direction — what the maintainer rejected was the daemon retention table / `retain`/`release` syscalls / per-turn `deleteExport` / FinalizationRegistry machinery.
- Removed `designs/sturdy-refs-endor-syscall.md` and authored `designs/sturdy-refs-ocapn-enlivenment.md` (694 lines): kept the inert-pass-by-copy-SturdyRef, on-demand `enlivenSturdyRef`, pass-style category, OCapN locator/boxing, pet-name-path-substitute, and #521-alignment sections; deleted all retention/syscall/FinReg machinery and the "competing plans / #511 / sibling" framing; added a top "Direction (maintainer decision 2026-06-26)" section naming the explicit non-goals; recorded the withdrawn-mechanism gaps as open questions rather than inventing replacements.
- Synced `designs/README.md` (required by `designs/CLAUDE.md`).
- Committed (`4a01012e5`) and pushed to `design/sturdy-refs-endor-syscall-followup`.
- Rewrote the PR title to *"design(sturdy-refs): on-demand enlivenment via the closely-held OCapN network capability"* and replaced the description.
- Posted a top-level summary comment on the PR acknowledging the directive and listing the changes.
- Tore down both the worktree I created and a stray earlier-draft worktree the subagent left behind (verified its orphan commit was a discarded 522-line alternate, on no branch).

**Changed:** PR #539 — old design file deleted, new design file added, README synced, title + description + summary-comment updated. PR remains DRAFT (unchanged; the directive asked only to repurpose, not to advance it).

**Follow-ups / flags**
- The PR carries forward one flag for the maintainer: #521 ships the symbol `getStudyRefLocator` (missing the `r`; should be `getSturdyRefLocator`) across source, exports, and tests.
- Open questions recorded in the new design (no mechanism invented): revocation agency for an un-named SturdyRef, enlivened-presence lifetime, enlivenment-cache bounding, and re-enlivenment idempotency — these are the natural next design decisions for this direction.
- The now-merged predecessor design (#510, at `llm-65b0abe`) is itself the `endor`-syscall approach the maintainer is abandoning; the maintainer only directed action on #539, so I left the merged predecessor untouched — worth surfacing if he wants that reconciled too.
