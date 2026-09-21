CI driven to green. Job complete.

## Completion report

**Job:** shepherd `endojs/endo-but-for-bots` PR #1303 (`test(ironhorse): add object-capability benchmark corpus`) → drive CI to green.

**Diagnosis:** The only red check was `format-ironhorse`. It failed at the `crate-graph.py --check` step: the PR's benchmark corpus introduced a dev-dependency from `ironhorse-262` on `ironhorse-snapshot`, but the checked-in `rust/engine/CRATE-GRAPH.md` was not regenerated, so the generated graph diverged by one edge (`ironhorse_262 -.->|"dev"| ironhorse_snapshot`). Every other check already passed.

**Fix:** In an isolated project worktree on the PR head branch, ran `python3 rust/engine/scripts/crate-graph.py` to regenerate the graph, discarded an unrelated yarn-install side-effect to `packages/floot/package.json`, and committed only `rust/engine/CRATE-GRAPH.md` (commit `107ec8db75`), pushed to `feat/ironhorse-ocap-benchmark-corpus` via a rebase-CAS loop.

**Result:** CI re-ran clean — `format-ironhorse` now passes; 27 pass / 7 skip / 0 fail; `mergeStateStatus: CLEAN`. Posted a status comment to the PR. The PR remains a draft (no un-draft was requested; shepherd only drives CI).

**Follow-ups:** None. The PR is a draft awaiting the maintainer's `run the gauntlet #1303` / promotion when ready.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1303-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 72 tokens (1841498 cached reads)
- Output: 13150 tokens
- Cost: $3.0907020000000003
- Wall-clock: 2604s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
