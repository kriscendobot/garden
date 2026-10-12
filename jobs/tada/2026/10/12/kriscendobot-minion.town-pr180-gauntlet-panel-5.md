Panel round 5 on kriscendobot/minion.town#180 came back **must-fix**. I posted the result to the PR.

**What I did**
- Checked out the PR head `design/git-remote-endo-binding` at `e825132` in an isolated worktree (`scratch/project-wt-kriscen-52efe840720c-479b7466`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 180 main-c7bdf20`. It exited 0 with `code-panel single-round — must-fix`, and all 34 seats returned `ok`.
- **Mistake during the run:** my first attempt was tied to a background-task timeout, so I killed it early. Before it died its seats were already writing into the shared rundir, and it left one extra panel-run record (`panel-runs/kriscendobot-minion.town-180/0e37df0870f6.md`). The posted verdict comes only from the clean rerun, recorded as `2b4dd7c6570f.md`.
- Posted the verdict in the same shape as round 4: a COMMENTED review (id 5488132194) carrying the marker `<!-- garden-panel-verdict: must-fix round=5 -->` and the two request-changes seats. The other 32 seats went into two follow-up PR comments (6120486667 and 6120487080), because the full aggregate (about 92 KB) is over GitHub's review-body size limit.

**Seat tally:** 2 request-changes, 6 approve, 26 comment-only. The archivist seat gave no verdict tag, but its text reads as approve. The round-4 procurer finding (the local `isRecord`) is resolved, and no seat repeated it.

**Must-fix findings for the next fix stage**
1. **breaker (security claim):** the code says `createKey` is "host-minted, never guest-chosen", but nothing enforces that. The guest holds the `git` exo, so it can call `E(git).create(<chosen key>)` itself and get back a readwrite partition it dropped. The fix is to either narrow the claim to the MCP tool path only, or have the host or control plane mint the key. The same seat also notes there is no per-owner limit on how many partitions `POST /partitions` will create, so a guest can exhaust disk.
2. **pruner:** trim implementation detail from the DEPLOYMENT.md control-plane and guest-provisioning sections, and shorten the design doc's item 2 under deferred work.

The PR is still a draft. I made no fixes and did not un-draft it.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1337446 cached reads)
- Output: 6499 tokens
- Cost: $0.9539492000000002
- Wall-clock: 235s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
