Fix round 1 for endojs/endo-but-for-bots#346 is done. The panel's only must-fix item was in the PR description, so I fixed it there and pushed no code. CI is green.

**The must-fix.** Review 5479295383 (round 1, head `6f11231cc6`, base `master-46d4edf`) had one request-changes seat, the pruner, with a `summary-fix` item:
- I removed the five empty template sections: Security, Scaling, Documentation, Compatibility and Upgrade Considerations.
- I folded "Testing Considerations" into one closing paragraph. That paragraph also absorbs the earlier sentence that said the companion `export-alias` test had been un-`.failing`'d, which would otherwise have repeated it.
- I updated the description with `gh pr edit --body-file`. No section headings with "Considerations" remain.

**CI.** I ran `ci-wait-merge.sh endojs/endo-but-for-bots 346 --no-merge` and it returned rc 0: 18 checks, 0 failed. The head commit is still `6f11231cc6`.

**Should-fix and comment-only items I did not act on** (this stage covers only the must-fix):
- The integrator wants the "summary-fix bundle" commit `6f11231cc6` squashed into `e472826f24` or renamed.
- The integrator asks whether the changeset should also bump `@endo/bundle-source`.
- Several seats ask for a compartment-mapper unit test of `importsCellSetter`, covering live `let` bindings, three or more aliases, and the default-export alias.
- Several seats suggest writing generated names as `cells[i][${q(name)}]` instead of `cells[i].name`, which breaks on string-named exports such as `export { x as "a-b" }`. This predates the PR.

The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr346-gauntlet-20261007-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (293867 cached reads)
- Output: 2284 tokens
- Cost: $0.4945734
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
