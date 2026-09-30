**Panel round 1 on endojs/endo-but-for-bots#1388 came back must-fix.** The PR is "design(ocapn): OCapN over Cloudflare RPC and Cap'n Web", a draft that adds `designs/ocapn-cloudflare-netlayer.md` (+586 lines) and a `designs/README.md` entry.

- **Checkout:** I made an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `design/ocapn-cloudflare-netlayer`, head `0953969`) at `scratch/project-wt-endojs--a614780402bb-3fa65e46`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` ran against the PR's `baseRefOid` `7ff30af…` (`llm-7ff30af`). Its last line was `design-panel single-round — must-fix`. The single-round branch only reaches that line on the `exit 0` path. I launched the script detached, so the exit code itself wasn't captured. The check that ownership crosses boundaries forced the decomplector seat, and the PR-description length check forced the pruner.
- **Seats:** all 10 finished with status `ok`: 6 request-changes, 2 comment-only, 2 approve.
- **Main findings:**
  - Skeptic: the designator-authentication (Ed25519) security model depends on a platform capability nobody has checked.
  - Critic: the section on making the codec generic misses the `data.slice(start)` error-diagnostic paths in `ocapn.js` and `handshake.js`.
  - Critic: `compareSessionKeysForCrossedHellos` is cited as if it could be called directly, but it only fits the `op:start-session` flow this design bypasses.
- **Review posted:** GitHub refused a request-changes review ("Can not request changes on your own pull request"), so I posted the full aggregate as a COMMENTED review headed "Garden panel — round 1 — must-fix" (submitted 2026-09-30T05:09:26Z).

I did no fixing or un-drafting, per the stage contract. The fix-loop stage should work from that review.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (625162 cached reads)
- Output: 3656 tokens
- Cost: $0.6153444
- Wall-clock: 210s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
