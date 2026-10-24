I stopped without pushing anything: this job repeats work that is already done.

**Background.** An earlier run of this job opened draft PR endojs/endo-but-for-bots#1547, which carries this job's marker. It is stacked on the #1504 head `ee79556`, and its head is `16149772df`. It adds `@endo/claude`'s `workspace-session.js`. That code reads the Shell's own `inspect()` result and refuses any engine other than `sandbox` before it creates a guest. It also adds `packages/sandbox/test/endo-claude-acceptance.test.js`, which drives edit → build → commit → push → `filesystemAt` through MCP `evaluate`.

**CI on #1547.**
- The acceptance test passed under live bwrap in `sandbox-drivers`, in all four runs.
- All 182 `@endo/claude` tests passed.
- The red legs are known Ubuntu-runner breakage, unrelated to this PR:
  - bwrap `ulimit -u` and "parent death" tests fail in `sandbox-drivers`, `test` and `cover`.
  - `tred: command not found` fails `build`.
  - #1542 fixes the bwrap tests; I didn't look for a `tred` fix.

**Why I stopped.** The gauntlet's viability check for #1547 (`endojs-endo-but-for-bots-pr1547-gauntlet`, 2026-10-24) found it **overtaken**. Draft PR #1544, opened by the already-completed job `build-daemon-agent-tools-endo-claude-acceptance-loop` on 2026-10-23, implements the same Phase 7:
- same design refs (#1497, #1504) and the same `ee79556` stack;
- the same `inspect()` refusal of non-sandbox engines;
- the same `evaluate` acceptance loop;
- and it is the more complete of the two (it has a README and 100% coverage).

Pushing more to #1547 would be wasted work.

**Maintainer decisions needed:**
- Close #1547 as a duplicate of #1544. I left it open because closing it is the maintainer's call.
- Carry Phase 7 on #1544: weave it once #1542 lands, then re-run its gauntlet. Its gauntlet halted only on the runner breakage above.
- Decide whether Phase 7 still matters while design PR #1543 is open. It proposes marking the `endo-claude` design superseded, because `claude --bare` rejects subscription credentials.
- Garden defect: this job body repeats an already-completed job with a different base name, so the board's idempotency check didn't catch it. The two PRs have head branches `build/daemon-agent-tools-endo-claude-acceptance-loop` (#1544) and `build/daemon-agent-tools-endo-claude-loop` (#1547). Whoever posted this job should check for the earlier job before posting a reworded copy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-tools-phase-seven-endo-claude-acceptance-loop.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 34 tokens (1284087 cached reads)
- Output: 6066 tokens
- Cost: $1.0389454 (1 engagement(s) unpriced)
- Wall-clock: 7321s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
