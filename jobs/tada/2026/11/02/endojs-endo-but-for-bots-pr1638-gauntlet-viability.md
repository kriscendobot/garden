**`viability=overtaken`: the reference flow this PR adds is already on `llm`, so the gauntlet should not start.** I only read the PR, `llm` and the journal, and ran no tests or gauntlet stages.

Deciding question: Is the roadmap's worked end-to-end reference flow still an unmet need on current `llm`, not yet delivered by a landed implementation?

Answer: No. The PR is open and unmerged, and nothing newer replaces it, but #707 already delivered the need behind it.

Evidence:
- **PR state:** #1638 is an open draft with head `89ca89a`. Its base `llm-48d6f3e` is identical to the `llm` tip, and it has no comments, reviews or linked issues.
- **Stale source:** the producing job cites `designs/daemon-git-next-steps.md` § Open Work. On `llm` that section no longer exists, and the bullet survives only in the old journal copy, `plan/designs/endo-but-for-bots/daemon-git-next-steps.md` (updated 2026-07-12).
- **Already delivered:** the current roadmap makes the worked flow the Phase 3 deliverable, which closes the milestone. #705 (Phase 1) and #707 (Phase 3) both merged on 2026-07-29, and Phase 2 merged earlier as #706.
- **Same flow on `llm`:** `packages/agent-tools/test/git-worked-loop.test.js` runs branch, file-tool edit, shell build, status/diff/commit, push limited to `refs/heads/agent/*`, and `filesystemAt` inspection with identity checks. It describes itself as the M3 exit criterion. #1638's own body says this test "already covers this loop", and #1638 drops the shell build step.
- **Direction has moved:** open issue #731 parks the JSON tool wrappers in favor of code mode, including `makeWorkspaceTools` and its worked loop. The roadmap says "the door closes" on follow-on JSON catalog expansion once #705 and #707 land. #1638 adds no catalog, but it adds a second acceptance test on that parked surface. The code-mode equivalent is #1544, a draft currently halted on Ubuntu 26.04 runner failures unrelated to its diff.
- **No maintainer request:** the journal shows no maintainer message asking for this flow, only the `minion-town-git-remote` arc job built from the stale bullet.

Counter-evidence:
- **New coverage in #1638:**
  - a refused push to the protected base that names no host path;
  - an upstream `llm` that moves after the clone;
  - inspection from a separate reviewer clone;
  - a `PiAgent` loop through `toPiAgentTool`.
- **Why it doesn't change the verdict:** these are extras, not the need that motivated the PR. Its "model" is also a scripted `streamFn`, not a real one.
- **JSON tools still in use:** draft #1589 keeps them live for Fae and Lal, so the parked surface isn't dead.
- **If the maintainer wants the extras:** a smaller PR adding those checks to `git-worked-loop.test.js` or `git-remote-tool.test.js` would cover them.

Option: close as superseded

Follow-ups for the liaison or maintainer (I changed nothing):
- **Possible duplicate build:** `jobs/todo/daemon-git-end-to-end-reference-flow-build.md` is still on the board with a reaped marker, though it already produced #1638. Unless it is withdrawn, it can run again and spend more on the same work.
- **Stale plan copy:** the journal copy still lists the reference flow as open work, so it could produce another job like this one.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1638-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (466386 cached reads)
- Output: 8805 tokens
- Cost: $0.8449291999999999
- Wall-clock: 267s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
