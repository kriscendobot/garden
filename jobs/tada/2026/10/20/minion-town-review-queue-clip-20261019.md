---
handed-off: minion-town-review-queue-clip-20261019-publish
deliverable-complete: false
---
The ranked review queue is built and its generator is pushed to main2, but the clip is **not published yet**. This host has no AWS credential for the minion.town MCP bridge (the credential read fails), so I handed publishing to the successor job `minion-town-review-queue-clip-20261019-publish`, which requires `aws` and is now on the board.

**What I built** (commit `aca90c21e69`, `scripts/jobs/minion-town-review-queue/`):
- `queue.json` holds the hand-made ranking: for each row, what it unblocks, the action asked of you, the exact command, review topics, and whether the panel looks converging or churning.
- `build.py` combines that with live state:
  - All 55 open PRs, with CI per head commit read through the Actions runs API (the bot token can't read check rollups).
  - The `main` commit and the last deploy.
  - Panel must-fix trends from the journal.
  - Parked minion.town jobs.
- **Dependency order:** edges come from stacked base branches, "depends on #N" lines in PR bodies, parked-job gates and the curated dependencies. Rows are sorted so a blocker always comes before what it blocks, with my priority rank breaking ties. That ranked tie-break replaces the skill's PR-number one.
- **Page:** a static `index.html` plus `styles.css`, light and dark, phone-width layout, no JavaScript. It shows the generation time and `main` commit and ends with "The chain", "Parked jobs waiting on you" and "Everything else open".
- **Privacy:** the build stops on any scrub hit (exit 3).
- `publish.sh` builds a fresh snapshot and creates an empty, powerless pet name. Pet names are limited to `minion-town-review-queue-*`. It publishes through the MCP bridge, then `curl`s and `cmp`s both files. `--unpublish <url>` removes a clip.
- **Tested:** a local build at 01:22Z passed the scrub, with CI read for all 55 PRs. `publish.sh` has only been syntax-checked, because publishing can't run here.

**Ranking** (snapshot at `main` `dc3240231cf1`; last main deploy green):
1. **#144** coupons design: merge. Unblocks #199, the parked coupons phase-1 build, and the flip. Converging.
2. **#199** coupons (default-off): merge after #144, or grant 2 rounds. Unblocks the flip. Converging.
3. **#198** landing + waitlist: merge or revise. Unblocks the flip and #200, which is stacked on it. Findings are new each round, none repeat. Open question: keep the waitlist's CSV mode?
4. Go ahead on `minion-town-coupon-admission-flip-20261019` once 1–3 are merged and deployed.
5. Run `deploy-accounts-store.sh` as the fleet admin; #200 can't deploy without it.
6. **#200** settings: revise, don't merge. Churning, with real defects.
7. **#207**: no action. A small Firefox flake fix that the screening merge job already has queued.
8. **#201** New Clip: merge. Converging. Unblocks #202.
9. **#202** Chat: revise after #201. One must-fix concurrency defect.

10–16. Lower pressure:
- **#37** and **#142** designs each unblock a parked build.
- **#151** is the base of the four-PR JavaScript-migration stack (through #154).
- **#180** and **#178** have used all their review rounds and are still churning: grant more, revise, or park.
- **#171** unblocks the parked node-interpreter probe.
- **#183**'s parked fix job ran out of retries: re-scope it or close #183.

**Corrections to the job's starting facts:**
- #200 is stacked on #198's branch, and #202 on #201's, so #201 is not a leaf.
- The heal job `heal-minion-town-cfafabe` gave up after repeated retries, and production has deployed green since; it should be withdrawn. `kriscendobot-minion-town-pr148-gauntlet-viability` is stale because #148 already merged.

**Scrub checklist** (enforced in `build.py`): no tokens, AWS keys or ARNs, 12-digit account ids, garden host names, home paths, email addresses, IP addresses, bearer/secret/password strings, or exploit wording. Review hints are topics only; the security-adjacent ones on #200 and #180 appear only as topics. No text copied from outside parties' comments, and no maintainer-private matters.

**Maintainer inbox:** I sent this ranking plus the scrub list (`msg-minion-town-review-queue-clip-20261019-5e6e365c18a8`). The successor job will send the clip URL after publishing and checking the page at phone width in light and dark.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-review-queue-clip-20261019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3946294 cached reads)
- Output: 38440 tokens
- Cost: $2.5173067999999996
- Wall-clock: 863s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
