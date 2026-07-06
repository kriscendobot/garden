All steps verified. Inbox is empty, the fork PR is open (base `main`, head `design/opencollective-ertp`), and the clone-keeper change landed on `main2`.

## Completion report

**Job:** Dead-lettered pickup — dckc's comment on kriskowal/garden#26: "register a fork of dckc/vattr97 and put the design there." The design in question is the OpenCollective⟷ERTP integration **design of record** the garden designer posted on that issue.

**What I did:**

1. **Registered a fork of `dckc/vattr97`.**
   - Created `kriscendobot/vattr97` via `gh repo fork`.
   - Created the standing bare clone at `worktrees/kriscendobot-vattr97.git` in the deployed garden root, with the fleet's fetch refspec and `.garden/` exclude, so `ensure-project-worktree.sh` can cut worktrees from it.
   - Added it as a second tracked row in `clone-keeper.sh`'s `GARDEN_TRACKED_CLONES` (tracking the fork's `origin/main`), committed and pushed to `main2` (`adf354174`), so the bare clone stays fresh. Noted in the code comment that the fork is *not* on any watcher's safe-to-watch set — registration is purely a standing bare clone, no surveillance widening.

2. **Placed the design in the fork.**
   - Wrote `designs/opencollective-ertp.md` — the design of record, faithful in substance, with the `purse.ts`/`escrow-ertp.ts`/`sealer.ts` links made repo-relative (verified all three files exist in the repo), a provenance header pointing at issue #26, and open question #2 ("where should the design file live") marked resolved by this placement.
   - Committed on branch `design/opencollective-ertp`, pushed to the fork, and opened **fork-internal PR** [kriscendobot/vattr97#1](https://github.com/kriscendobot/vattr97/pull/1) (base = the fork's own `main`). I deliberately did *not* open a PR against upstream `dckc/vattr97`, since dckc asked to put the design *in a fork* rather than PR it directly, and upstream interaction wasn't authorized.

3. **Replied on the issue thread** ([issue #26 comment](https://github.com/kriskowal/garden/issues/26#issuecomment-4896563761)) reporting the fork, the file, and the PR; noting the still-open questions (#1 how much Zoe, #3 hold representation, #4 spike deployment particulars); and offering to open an upstream PR or pick up follow-on work on dckc's say-so. Did not close the issue.

**Follow-ups (awaiting dckc):** whether to open a PR against upstream `dckc/vattr97`, and answers to design open questions #1/#3/#4.
