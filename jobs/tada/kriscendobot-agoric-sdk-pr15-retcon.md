Retcon complete.

## Completion report: retcon kriscendobot/agoric-sdk PR #15

**Directive:** "retcon" from dckc's PR comment. Mapped to the canonical retcon: reset to base + restage per-package, separate `chore: Update yarn.lock` if applicable. The comment's musing about "a separate commit per exo" was explicitly flagged by the maintainer as "maybe not worth the bother," so I applied the standard per-package grouping (untrusted comment text treated as data).

**What I did:**
- Set up an isolated project worktree keyed to this job's base off `garden31-portfolio-exo-guards`.
- Confirmed the branch was current with its base (`master`) — no weave/rebase needed — and the working tree was clean, HEAD matched the remote head.
- Tagged the pre-retcon tip (`8f69703`), reset `--mixed` to `origin/master`, and restaged.

**What changed:**
- Collapsed the 3-commit history (`feat: add interface guards` + two `fix: tighten guards` review-followup commits) into **one per-package commit**: `feat(portfolio-contract): add interface guards to the remaining exos`. The net diff touches only `packages/portfolio-contract/src/` (4 files: `portfolio.contract.ts`, `portfolio.exo.ts`, `pos.exo.ts`, `evm-wallet-handler.exo.ts`), so the per-package rule yields a single commit. No `yarn.lock` change exists, so no lockfile chore commit was needed.
- Wrote a conventional-commit message whose body captures the *why* (which exos gained guards, the Foo-shape tightening + `mustMatch` removal, and the durable-state read-back looseness rationale) folded from all three original commit messages.

**Grouping note:** single package, no cross-package refactor, no top-level/config/docs files, no lockfile — the retcon is a clean 1-commit collapse.

**Net-diff invariant:** verified byte-identical — `git diff pre-retcon..HEAD` empty and both trees hash to `c275932bd0648a9506a174ebba2dc1c80d8b8c5f`.

**Push:** force-pushed with `--force-with-lease` (explicit lease against the confirmed-unchanged remote head `8f69703` after an initial stale-tracking-ref rejection; the remote had not actually moved). PR #15 now shows the single commit `51fc706`.

**Follow-ups:** none. The panel can re-run against the tidied single-commit history; the maintainer declined the per-exo split.
