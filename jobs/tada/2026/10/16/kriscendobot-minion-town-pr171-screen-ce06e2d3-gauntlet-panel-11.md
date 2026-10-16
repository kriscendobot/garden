Panel round 11 for kriscendobot/minion.town#171 finished with a verdict of **must-fix**. `panel.sh` exited 0 and printed `code-panel single-round — must-fix`.

**What I ran:**
- **Checkout:** an isolated project checkout of `kriscendobot/minion.town` on `feat/claude-arc-prod-validation`, at head `3b2146c`, compared against base `main-30a4c62`.
- **Panel:** single-round mode. All 34 seats ran with no seat errors.
- **Restart:** I restarted the run once. I had launched it as a background command with a 10-minute limit, which could have killed it partway, so I stopped it and relaunched it detached. Only the second run produced the verdict below.
- **Pre-pass probes:** two fired.
  - The PR-body concision probe: 3 file bullets lead with a code span.
  - The repeated-mechanism probe: rounds 9 and 10 also raised must-fix findings on `--version` and `claude-harness.mjs`, so the panel put the decomplector's "is this needed" question to the PR.

**Must-fix findings:**
- **saboteur:** the new staging handover in `deploy/aws/scripts/deploy-app.sh:64-72` uses `find … -exec chown -h` on full paths, working top-down. A running `minion-mcp` process can swap in a symlink partway through, so the chown lands outside the artifact (for example on `/usr/local/bin`). Since root later runs `/usr/local/bin/node`, that is a path to root. The suggested fix is `-execdir`, or `chown -R -P` per subtree.
- **archivist:** the `claude-harness-pinned-upgrade-policy` row in DEPLOYMENT.md says the observer's content is pinned. The code only checks the observer's type, owner and mode.

**Also flagged:**
- **engine-realist (should-fix):** the observer reads the whole 249 MB binary into memory as root, outside any memory cap. It should hash the file through a small fixed buffer.
- **Seat verdicts:** five seats requested changes (archivist, saboteur, engine-realist, decomplector, pruner), 13 approved and 16 were comment-only.

**Review posted:** review 5542456115 on commit `3b2146c`, posted as a comment like rounds 9 and 10 (it is not a request-changes review). It opens with the `<!-- garden-panel-verdict -->` header and a summary, followed by the per-seat blocks. I cut those blocks off at about 63 KB to fit GitHub's size limit. The 19 blocks kept include the three seats behind the findings above.

I made no garden or project commits, as this stage requires: no fixing, no un-drafting.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-panel-11.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1013037 cached reads)
- Output: 6210 tokens
- Cost: $0.8064794
- Wall-clock: 426s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
