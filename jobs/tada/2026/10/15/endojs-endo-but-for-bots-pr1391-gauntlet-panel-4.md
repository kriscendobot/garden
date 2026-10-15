## Completion report: PR #1391 gauntlet, panel round 4

**Outcome:** The panel reached a real verdict, **must-fix**, but I couldn't post it to the PR, so I'm completing with the `panel-error` marker so the driver retries this round on another host.

**What I did**
1. Set up an isolated project checkout of `endojs/endo-but-for-bots` on branch `build/sturdyref-ses-accommodation` at head `3c39e7d2e`: `/Users/dom/garden/scratch/project-wt-endojs--4c3f9683266f-a4365e14`.
2. Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 1391 origin/build/sturdyref-shim-first-wins-dbd2b00`. It exited 0 with disposition **must-fix**. It did not re-run the seats; it reused the saved panel record `8d366db30f85` for the same head, which an earlier attempt at this job recorded at 21:09Z but never posted.
3. The aggregate (`review-body.md`, about 61 KB, under the 65,536-character review limit) covers 34 seats:
   - **Request-changes (6):** decomplector, archivist, breaker, spec-keeper, integrator, pruner.
   - **Comment-only:** 16 seats. **Approve:** 12 seats.
   - **Main blocker (breaker):** `Reflect.construct(Parcel, …, ProxyNT)` gives child code a branded Parcel whose prototype it chooses. The cause is at `packages/ses/src/tame-parcel-constructor.js:39`, and the fix is to require `new.target === SharedParcel`.
   - The same mechanism also showed up as must-fix in the two previous rounds (heads a10a201e and 17390624).
4. Tried to post the review with `gh pr review --request-changes`, then again with `--comment`. Both failed with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This is the known problem on this host (oros-studio): the bot's access token can't write PR reviews on endojs repositories.

**Why panel-error and not must-fix:** No verdict review exists on the PR, so the next stage has nothing to act on. Claiming `must-fix` would move the gauntlet forward on a review that was never posted. When the retry runs on a host that can write to endojs (an endolin host), it will reuse the saved record for the unchanged head and only needs to post it.

**Other changes:** I added this round to the existing memory note `bot-pat-no-pr-write-endojs.md`. Nothing was committed to the garden repo.

**Follow-up:** The lasting fix is to give the kriscendobot token "Pull requests: write" on the endojs org. Until then, panel rounds that land on oros-studio for endojs PRs will keep needing a retry on another host.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 66 tokens (1753160 cached reads)
- Output: 10182 tokens
- Cost: $1.4673920000000005
- Wall-clock: 899s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
