## Completion report: endojs-endo-but-for-bots-pr1497-gauntlet-undraft

PR #1497 (https://github.com/endojs/endo-but-for-bots/pull/1497) is no longer a draft. Its head is still `e18af8019c6e86eb7ac7ebdac20e6d28df1ac0e2`, the commit the panel passed.

**What I did**
1. **Advisory appellate pass:** a light `claude -p` (sonnet) review of the PR diff, which changes 2 design files (+253/−21). It does not block the un-draft. The notes are recorded here only; I did not post them to the PR:
   - **Open-item count:** the Status section says four items are open, but the README row and the Implementation Plan intro list three (Phases 2c, 7, 8). The #950 package-manager projection has no phase, and the text both calls it a "design" and calls it "open".
   - **Open Question 4:** the timeline of the endo-fetch redirect versus the formula is unclear, and the doc never says which path it recommends. The Phase 3.6 `makeHttpTool` binding may point at the wrong path.
   - **Phase 2c:** the text calls it both "optional for M3 exit" and "required before the Phase 7 acceptance loop".
   - **Phase 4 checkbox:** the acceptance-test item may be checked too early, since the push and inspect steps only appear later as Phase 7 work.
   - **Next Slice:** it assumes APIs exist that the diff never confirms (`makeSandboxSpawner`, `stdoutByteLimit`, `SandboxFactory` in the formula). That last one would be a new formula field, which sits oddly with the "no new formula type" claim.
   - **Wording:** the Ownership-map row conflicts slightly with the Shape section, and with Open Question 6 on whether dropping a slice kills its processes.
   - **Links:** several new design-doc links need checking against `designs/`.
   - **Prompt section:** the new quote reads as an instruction ("Do not start a build") rather than a record of the original request.
2. **Pre-mutation check:** `state=OPEN`, `headRefOid=e18af8019c…`, `isDraft=true`, so the gate passed.
3. Ran `gh pr ready`, and it succeeded.
4. **Post-mutation check:** `isDraft=false`, and `headRefOid` is still `e18af8019c…`.

**What changed:** only the PR's draft state. Nothing was committed to the garden.

**Follow-ups (optional):** the advisory notes, mainly the open-item count and the Phase 2c optional-versus-required question, could go to the maintainer's review of this design PR.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1497-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (230799 cached reads)
- Output: 1623 tokens
- Cost: $0.42879579999999995
- Wall-clock: 78s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
