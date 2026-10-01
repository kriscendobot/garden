Panel round 3 for endojs/endo-but-for-bots PR #1390 came back **must-fix**, and the verdict is now posted on the PR as a review.

- **Panel run:** `panel.sh` ran in single-round mode against the PR head (`build/pet-name-path-only` at `784decdc`) and the merge base `8e53cc0f` (`llm-8e53cc0`). It exited 0 with must-fix. It did not run the seats again. It reused the saved run record `panel-runs/endojs-endo-but-for-bots-1390/3992f5b21fa7`, which covers this exact head and has all 33 seats finished. That same run was already posted as review 5374560621 under the sweep-3 gauntlet.
- **Review posted:** a COMMENT review headed "round 3, gauntlet `ebfb-petname-path-only-sweep-4-gauntlet`: must-fix". Earlier panel verdicts on this PR were also posted as COMMENT reviews. It points to review 5374560621 for each seat's full output.
- **Must-fix items:**
  1. floot `container-mounts.js:305` passes a bare string to `storeValue`, and the test fakes accept that, which hides the bug.
  2. spaces-util `command-executor.js` splits user-supplied pet names on `/`, which widens authority.
  3. Parameter names in `types.d.ts` no longer match the `*NamePath` help text.
  4. `petNames` is still not renamed in `lal`, and some help-text headers are stale.
  5. The overlap with #1343 needs a stated landing order, and the phase/evidence pre-pass mismatch needs a one-line note in the PR body.
- **Should-fix:** the `lookup` shape exemption in `interfaces.js:97` (from purist), and `resultName` in `agent-tools` `evaluate-tool.js` (from integrator).

The GitHub REST quota was briefly exhausted when I started. It had reset by the time I needed it, so nothing was blocked. Nothing changed in the garden repo. Following the gauntlet, the next step is a fixer stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (638778 cached reads)
- Output: 4680 tokens
- Cost: $0.6661636000000001
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
