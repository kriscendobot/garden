I wrote the design for letting the garden screen and merge minion.town PRs instead of kriskowal, landed it on `main2` (`df7a6549e01`), and posted a build job for it. No code has been written or tested yet; that is the build job's work.

## What I did
- Added `designs/minion-town-pr-screening.md` (Status: Accepted, because kriskowal's APPROVED review on minion.town#139 is the authorization) and a row in `designs/README.md`.
- It has no open questions, so it went straight to `main2` without a review PR. I decided the ambiguous points myself and recorded the rejected options in the doc, so kriskowal may want to check those calls (see "Worth knowing" below).
- Posted `build-minion-town-pr-screening` (builder, `kriscendobot/garden` `main2`) to carry out the design's six build steps with tests.

## Design summary
- **Proxy, not a mentat supervisor.**
  - The gauntlet's panel review and CI already make the quality judgment. What's left is a yes/no check that can run as one more plain-code step in `proxy.sh`, with no LLM.
  - Mentat is manual-only, apart from the Ironhorse exception. Running it automatically on every PR would need a new exception and would spend the most expensive tier on a repo kriskowal called beneath attention.
- **Where kriskowal is pulled in today, and the minion.town-only change for each:**
  - **Merge gate:** `ci-wait-merge.sh` gets a new `--screened-delegated-merge` mode, modelled on the existing Ironhorse `--ratchet-delegated-merge` mode.
  - **Merge trigger:** today a maintainer approval starts the conductor. Instead the proxy posts the conductor job itself; an approval still works as a manual override.
  - **Fixer re-requests:** the fixer re-requests a human only if that human's "changes requested" review is still standing.
  - **Bulletin:** minion.town is dropped from the parked review-requested list, and a new "Screened by proxy" section is added.
- **What the screen checks, all on the PR's current head commit:**
  - The PR is a bot PR against `main` on minion.town.
  - The panel passed on this same head.
  - CI is green with at least one check.
  - No human has an open "changes requested" review.
  - The last `deploy.yml` run on `main` passed and the MCP watchdog reports production as healthy.
  - The PR touches no reserved path (provisioning, IAM, workflows).
- **Merge hand-off:** on a pass, the proxy records a pass tied to that exact commit and posts a conductor job. If a rebase moves the head, the merge waits for a fresh screen.
- **After the merge:** the proxy watches the deploy workflow and the MCP watchdog. If either fails, it pauses screened merges, posts a job to fix or revert the change through a normal PR, and messages the maintainer. It resumes on the next healthy deploy, but never lifts a pause kriskowal made.
- **Scope and kriskowal's role:** only `kriscendobot/minion.town` is affected; other repos keep maintainer review. Pauses, heal jobs and escalations go to kriskowal's inbox; routine merges only show in the bulletin. Kriskowal keeps a veto (a "changes requested" review) and can pause or revoke the whole arrangement.

## Worth knowing
- **Arming is left to a person.** The build job is told not to switch this on. Screening stays off until someone runs `minion-town-screening.sh seed` after the build deploys.
- **Un-drafting is unchanged.** PRs still come out of draft when the panel passes, so kriskowal gets GitHub's ordinary watch notifications unless they unwatch the repo. Other garden tooling keys on draft state, so I kept it.
- **Posting the build needed an explicit identity.** The first post was deduplicated against this design job because both cited the same review. I re-posted with `--identity kriscendobot/garden:build:minion-town-pr-screening`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-pr-screening-by-proxy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1678930 cached reads)
- Output: 17725 tokens
- Cost: $1.3562780000000003
- Wall-clock: 809s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
