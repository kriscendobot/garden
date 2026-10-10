## Panel round 4 report: endojs/endo-but-for-bots#1403

The round-4 panel returned **must-fix** on head `e59b07369f`, and the verdict is posted on the PR.

**What I did**
- **Checkout:** made an isolated checkout of `endojs/endo-but-for-bots@build/endo-inference-seam-1357` at `scratch/project-wt-endojs--bc6847e0b381-71024cd0`.
- **Panel run:** ran `panel.sh` in single-round mode against base `80054c34` (the PR's actual `base.sha`, frozen `llm-80054c3`). It exited 0 with the terminal line `code-panel single-round — must-fix`. All 34 seats returned.
- **First attempt lost:** my first try at a detached run killed the in-progress panel. I stopped the orphaned seat processes and deleted the half-written run directory. A retry then failed because `/tmp` is mounted noexec. The run that produced this verdict started from a clean state.
- **Posted verdict:** review 5478776997 with overflow seat details in PR comment 6097011461. It is a COMMENT review because GitHub refuses request-changes on a PR this account authored, so it should be read as request-changes. That matches rounds 1–3.

**Must-fix items**
1. **Version and bump level (packager):** the `@endo/inference` initial-release version and changeset bump level have flipped back and forth across fix rounds. They now sit at major@0.1.0 after round 3. The seats cite rules that disagree, so this is a maintainer call. The fixer should cite the governing rule or a sibling precedent and ask for confirmation, not flip it again.
2. **Spelling (orthographer):** `packages/inference/SECURITY.md:21` says "acknowledgement"; it should be "acknowledgment".

**Should-fix:** remove the header-only `CHANGELOG.md` stub, and squash the 28-commit history into logical commits, keeping the `yarn.lock` commit separate.

**Comment-only:** whether the `cancelled` identifier should become `canceled` is a naming question for the maintainer. The decomplector's check for a mechanism repeated across rounds found that `makeProcessGroupKiller` is already gone at head, and found nothing in `makeLimitEnforcer` that needs a must-fix.

**Follow-up:** the version/bump question has now been the must-fix in four rounds, so it needs a maintainer decision to stop the loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2113123 cached reads)
- Output: 9009 tokens
- Cost: $1.2606366
- Wall-clock: 3765s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
