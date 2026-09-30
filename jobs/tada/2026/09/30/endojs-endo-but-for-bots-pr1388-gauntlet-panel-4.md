I ran panel round 4 on endojs/endo-but-for-bots#1388 ("design(ocapn): OCapN over Cloudflare RPC and Cap'n Web"). It came back **must-fix**, and the verdict is posted on the PR.

- **Setup:** I made an isolated checkout of the PR head (`endojs/endo-but-for-bots` @ `design/ocapn-cloudflare-netlayer`, commit `b027ff77e9`). The base was the frozen `llm-7ff30af` (`7ff30afbce`).
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 1388 7ff30afbce…` exited 0 with disposition must-fix. The run is recorded at `panel-runs/endojs-endo-but-for-bots-1388/96bf76534922.md`. All nine seats returned `ok`:
  - **pedant (request-changes):** path references are inconsistent (some repo-root, some package-relative), citations to outside code don't name their source, and the `ebfb#806` notation is unclear.
  - **critic (should-fix):** the default `maxPendingOpens: 16` leaves an unauthenticated denial-of-service opening on the public Cap'n Web entry point. It also notes that the message-ordering claim is only verified for one of the three carriers.
  - **skeptic (should-fix):** the verification table labels its evidence inconsistently (item 1 vs item 5). Nothing verifies that a call to a vanished peer rejects rather than hangs. No test checks that an idle session sends no heartbeat.
  - **ergonomist (should-fix):** `port` and `bindings` should be a discriminated union, not two independent options. `CarrierBindings` has no defined shape. Suggests renaming `idleProbe` to `idleProbeInterval`.
  - **novice (should-fix):** Cloudflare terms are used before the vocabulary section defines them. The two codec subsections are in the wrong order. `OcapnPort` needs a forward pointer to where it is defined.
  - **copyeditor:** two unclear sentences.
  - **orthographer and thesaurus:** approve.
  - **decomplector:** returned an empty report (a stray "background command completed" line) even though its status was `ok`. It was a sensor glitch, not a verdict, and it didn't change the outcome.
- **Posting the review:** GitHub refuses a request-changes review from the account that opened the PR ("Can not request changes on your own pull request"). So I posted the full panel output as a `--comment` review. It opens with a "**must-fix**" header and ends with the marker `<!-- garden-panel-verdict: must-fix -->`. The first attempt was also blocked by the gh wrapper over a bare `#1388` reference, which I rewrote in full form.

**Follow-ups:**
- The fix-loop stage should work from the comment review above, since no request-changes review exists. The next-stage-owed check should treat that header and marker as the verdict for PRs the bot opened itself.
- GitHub's REST API was rate-limited for the bot account during this run; GraphQL still worked.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (877464 cached reads)
- Output: 4175 tokens
- Cost: $0.7379607999999999
- Wall-clock: 694s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
