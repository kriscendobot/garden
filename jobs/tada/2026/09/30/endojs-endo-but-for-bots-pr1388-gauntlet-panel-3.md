Round 3 of the review panel on PR #1388 came back **must-fix**, and I posted the verdict to the PR.

**What ran**
- Isolated checkout of `endojs/endo-but-for-bots` branch `design/ocapn-cloudflare-netlayer` at head `de75b72554`: `scratch/project-wt-endojs--768bddcb0531-3fa65e46`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 1388 7ff30afbce95…` against the PR's recorded base commit (branch `llm-7ff30af`). The diff is 2 files, +808 lines (`designs/ocapn-cloudflare-netlayer.md`, `designs/README.md`).
- panel.sh exited 0 with the final line `design-panel single-round — must-fix`. All 10 seats ran without error.
- Seat verdicts:
  - **Request-changes (5):** critic, skeptic, decomplector, pedant, pruner.
  - **Approve (3).**
  - **Comment-only (2).**
- Two pre-checks flagged problems before the panel ran, so it added two seats: decomplector, because the ownership map needed attention, and pruner, because the PR description may be too long.
- Run files are in `scratch/panel-run-pr1388-r3/`, with the aggregate in `round-1.md`.

**Verdict posted**
- Posted as a `gh pr review` headed "Gauntlet panel round 3 — disposition: **must-fix**", with the marker `<!-- garden-panel-verdict: must-fix round=3 head=de75b72… -->`.
- GitHub refused a request-changes review because the bot opened this PR itself, so it went up as COMMENTED, the same as earlier own-PR panel reviews.

**Main findings for the fix round (critic)**
1. The "Trust model of the supervisor" section says the supervisor can read its facets' storage. Cloudflare's docs say a facet's storage is isolated from the supervisor. The design's own "Verification of platform claims" section checks only the other direction and never verifies this claim. It should be struck or corrected.
2. The `cf-do`, `cf-facet` and `capnweb` hints don't match the sibling design `ocapn-network-transport-separation.md`, which requires one hint per `<transport>+<codec>` combination, each value a single dial string. `cf-facet` is not a dial string at all. The design needs to say whether it follows, extends or deliberately breaks that rule.

The other request-changes findings from skeptic, decomplector, pedant and pruner are in the posted review. I did no fixing and didn't un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (363131 cached reads)
- Output: 2736 tokens
- Cost: $0.45914620000000006
- Wall-clock: 228s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
