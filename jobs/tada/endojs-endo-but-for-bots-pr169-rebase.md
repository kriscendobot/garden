Rebased **endojs/endo-but-for-bots PR #169** (`design/pass-style-promise`) onto its base branch `llm`.

**What I did**
- Fetched base `llm` and the PR head in an isolated project worktree keyed to this job's base.
- Rebased the PR branch onto `origin/llm`. The single conflict was in `designs/README.md` — pure index bookkeeping: the PR's `f5a8a3…` commit registered the new design in the "See also" list, the Summary table, and the totals, while `llm` had heavily rewritten that whole file. I resolved by keeping `llm`'s current README and grafting in exactly the pass-style-promise entries (one prose mention next to `exo-zip-package`, one Summary-table row), bumping the totals to `30 Proposed … (146 designs)`. The remaining commits applied cleanly.

**Concurrency catch (important)**: mid-rebase, an 8th commit — `fce810d8` "integrate closed questions, drain Open Questions (per kriskowal #169 review)" — was pushed to the PR head after I'd started against the stale 7-commit tip `ecb7a8d9`. I detected this (design-doc content diverged where a byte-identical result was expected), re-fetched the current tip, and redid the rebase from `fce810d8` so no newer work was dropped. `rerere` auto-replayed my README resolution on the second pass.

**Verified before pushing**
- All 8 PR commits sit on top of `origin/llm` (`llm` is a full ancestor).
- `designs/pass-style-promise.md` is byte-identical to the pre-rebase remote tip at every commit level — no content corruption; the only intended change is the README bookkeeping.
- No stray conflict markers (the `SEARCH/REPLACE` strings in `cli-edit-verb.md` are pre-existing hashline-patch doc examples on `llm`, not artifacts).

**What changed**: force-pushed with `--force-with-lease` (lease held against `fce810d8`) → PR head is now `5d0f62f099`. GitHub reports PR #169 **MERGEABLE** (was CONFLICTING); `mergeStateStatus: BLOCKED` is just pending required checks/reviews under branch protection, not a conflict.

**Follow-ups**: none required. The untrusted PR comment ("And rebase.") was treated as data only; the directive matched the deterministic map. If CI needs to run/pass for the `BLOCKED` state to clear, that's a normal shepherd concern, not part of this rebase.
