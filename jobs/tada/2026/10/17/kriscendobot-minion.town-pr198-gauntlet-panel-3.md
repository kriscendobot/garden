Panel round 3 on kriscendobot/minion.town#198 (head `65b37eef`, base `main-bda7739`) came back **must-fix**, and the verdict is posted on the PR.

**What I did**
- Made an isolated project checkout of `kriscendobot/feat/beta-home-splash-waitlist` with `ensure-project-worktree.sh`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 198 main-bda7739`. It exited 0 with disposition `must-fix`.
- Posted the aggregate as three review comments, at 14:47:55Z, 14:47:57Z and 14:47:59Z. The aggregate was about 100 KB, which is over GitHub's review-body limit, so it went in parts like rounds 1 and 2. Parts 1 and 2 hold the non-blocking seats. Part 3 is the must-fix verdict. GitHub won't accept a "request changes" review from the account that wrote the PR, so part 3 is a comment review labeled "treat this as request changes".

**Verdict**
Seven of 34 seats asked for changes. Since the same mechanism drew must-fix again, panel.sh forced the decomplector to ask whether the rate limiter is needed at all.
- **decomplector:** the one must-fix. Every waitlist row stores `rate_key`, nothing ever reads it, and it can be reversed: it is an unsalted SHA-256 of an IPv4 /24, so all 2^24 values can be hashed. Drop it from the row. A separate should-fix asks the maintainer to decide whether the limiter needs per-network keys or can use one global budget.
- **purist:** the same `rate_key` problem. Also, `WaitlistEmailError` doesn't set a `name`, and the router's catch should check `instanceof` instead of turning any error into a 400.
- **breaker / wire-watcher:** `home.js` saves a credential from the URL before the server checks it, so a crafted link can erase or replace a visitor's stored guest. The PutItem-only IAM grant still lets the holder read, probe and overwrite rows by known key, so "add-only" overstates it.
- **integrator:** deleting `guest.html`/`guest.js` removes the coupon client from sibling PR #199, and nobody is named to port it. The design doc cites garden job names instead of PR numbers, and an open question in `designs/clip-shell-framework.md` is out of date.
- **typist:** the `parseFragment` JSDoc return type is wrong, and `connect.html:173` re-adds a `←` glyph.
- **pruner:** several instructions and rationales are repeated across files, and some comments restate the code below them.

**Follow-ups**
- The fix-loop stage is next; the gauntlet driver posts it, not this job.
- The per-network-keys question needs a maintainer decision.
- Non-fatal: the panel couldn't resolve the PR-body template in its pre-pass, and noted it in `pr-body-template.log`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1091915 cached reads)
- Output: 6796 tokens
- Cost: $0.824735
- Wall-clock: 379s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
