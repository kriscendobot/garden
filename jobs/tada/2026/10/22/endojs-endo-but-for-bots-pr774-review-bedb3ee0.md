Kriskowal's approving review on #774 had two asks. Both are handled: a merge job for #774 is waiting on the job board, and a build plan for the next Parcel layer is parked for the foreman.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (proceed). The review has no inline comments, so the body was the whole directive: "conduct and post a plan to build for the foreman to pick up on the parcel budget".

**PR #774 state (layer 1, `@endo/parcel` first-wins shim):** still a draft, open and mergeable. CI shows 25 checks passing and 10 skipped, none failing.

**Ask 1, "conduct":**
- A merge job, `endojs-endo-but-for-bots-pr774-conduct`, was already in `jobs/todo/` on `origin/journal2`. The approval reconciler posted it at 06:15.
- I checked it is on the board and did not post a duplicate.
- It un-drafts and merges #774, choosing the merge method itself.

**Ask 2, "post a plan to build … on the parcel budget":**
- I took "the parcel budget" to mean the `endo-ocapn-background` arc. Its summary covers SturdyRef, which `designs/parcel.md` renames to Parcel. There is no arc named "parcel".
- I parked a builder plan, `ebfb-parcel-layer2-build-20261022`, with gate `deferred` and `arc: endo-ocapn-background`, so the foreman can promote it from that arc's spare budget. It is confirmed on `origin/journal2` under `jobs/plan/`.
- Its scope is layer 2 of the Parcel design (the SES changes):
  - Take over the existing draft #1391 rather than opening a new PR.
  - Move its base to a fresh frozen snapshot of `llm` once #774 has merged, and resolve the rebase conflicts.
  - Bring it in line with layer-2 row: the `%InitialParcel%` and `%SharedParcel%` constructors, `locate` withheld from child compartments, both constructors hardened at lockdown.
  - Run local checks, then let completion start the normal review gauntlet.
- If the plan is promoted before #774 merges, the builder stops without changes and re-parks the job blocked on #774. Layers 3–9 (#1392–#1399) are left for later plans.

**Follow-up guard:** I added no new channel, endpoint or design question, so nothing needed to wait for the maintainer.

**Not done:** I posted no reply on the PR. This host's bot token can't write PR comments on endojs, and the conductor will comment when it merges.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr774-review-bedb3ee0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (987373 cached reads)
- Output: 6545 tokens
- Cost: $0.7986065999999999
- Wall-clock: 254s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
