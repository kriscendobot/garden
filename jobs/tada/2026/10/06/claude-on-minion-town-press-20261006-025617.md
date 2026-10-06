Press tick for the Claude-on-minion.town arc (kriscendobot/garden#89), 2026-10-06 ~03:10Z.

**What changed since the last press comment (2026-10-05 22:51Z):**
- kriscendobot/minion.town#164 merged at 02:32Z after kriskowal approved it ("Proceed"). It adds kriscendobot's own GitHub subject (`79b9090e-…`) to `ENDO_CLAUDE_ROOT_SUBJECTS`. The verification job `minion-town-verify-claude-root-subjects-ea5263d` confirmed it is live: the deploy ran, the setting is in place, and `/account/claude` returns 200 for that subject. The production canary therefore no longer waits on the maintainer signing in.
- kriscendobot/minion.town#163, the deploy fix that restarts Caddy when its gate token is stale, is no longer a draft and is waiting for review.
- kriscendobot/minion.town#160 is still open, not a draft, mergeable, at head `a9740e1`, with no review yet.

**What I did:**
- **Checklist:** I updated the evidence line at the top of the issue body with the changes above. No box changed and no item text was touched.
- **Comment:** I posted https://github.com/kriscendobot/garden/issues/89#issuecomment-6008531985.
  - The main review ask stays #160. Merging it clears the last code gap (kriscendobot/minion.town#149) the maintainer asked to accept before `ENDO_CLAUDE_ENABLED` goes on in production (items 4 and 5).
  - A smaller second ask is #163, which stops the `/account/claude` Forbidden from coming back.
  - The comment also tells the maintainer they no longer need to sign in at `/account/claude`.
- **New job:** I posted `minion-town-claude-kriscendobot-connect-canary-20261006`. It will:
  - sign in as kriscendobot through GitHub;
  - get a token with `claude setup-token` and submit it straight into the page, never printing or recording it;
  - run the four production observations from the parked `minion-town-claude-cli-production-canary-after-connection-20261004`, using kriscendobot's subject instead of the maintainer's;
  - then withdraw that parked job so the canary doesn't run twice.

  Before posting I checked the board: nothing else covers the connect flow, and the verification job's report says it did not drive it.

**Follow-ups:**
- `claude setup-token` may need an interactive login that a job can't do on its own. If so, the new job is told to send the maintainer exactly one question rather than guess.
- The maintainer inbox still has several unread messages from earlier canary attempts (2026-10-04) asking them to connect their subscription. They are now out of date, and the liaison may want to clear them when it next works through the inbox.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/claude-on-minion-town-press-20261006-025617.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1218267 cached reads)
- Output: 8327 tokens
- Cost: $0.9748734000000001
- Wall-clock: 314s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
