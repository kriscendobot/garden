Gauntlet fix round 3 for kriscendobot/minion.town PR #189 is done: I applied all of the panel-3 must-fix items and pushed them as one follow-up commit, and CI is green.

**Fixes in `designs/clip-shell-framework.md`** (commit `42bc9dc`, which advances the PR head `design/clip-iframe-embedding` from `fdf8bd9`):
- **critic:** A clip can navigate its own frame to a `minion.town` page and become same-origin with the shell. The design now makes the shell's domain unframeable on every route as a precondition for live embedding. Every `minion.town` response carries the two anti-framing headers (`frame-ancestors 'none'` and XFO `DENY`), set once for the whole site so an upstream server can't remove them. Section 3.3 now says the cross-origin argument only holds for the frame's first page load. Section 3.7 adds a browser test where a clip navigates its frame to several `minion.town` routes and each one must be refused, plus a header test covering every route. Open question 2 changes from an optional follow-on to the first step of the header change.
- **skeptic:** `www.minion.town` and `minion.town` are separate origins. The design now has `www.minion.town` serve only a permanent redirect (308) to `minion.town`, so the single allowed origin is enough. This is supported by the existing oauth2-proxy `redirect_url`, which already returns sign-in to `minion.town`. Both hosts are tested.
- **decomplector:** I rewrote the ownership map so each row is a piece of state with its owner. It separates the guest's clip content, the publication registry, browser storage keyed by origin, the shell's in-memory selection, and the frame outcome the shell cannot observe. The endpoint, the gateway and `frameConfiguration` now appear only as mechanisms, not owners.
- **novice:** Section 3.2 now opens by explaining the three documents and what CORP and COEP each control before the spec detail. The anti-framing header is now credited to the already-merged #90 instead of "this PR".
- **copyeditor and pedant:** I removed the em dashes from the Open questions headings (Q2, Q3 and the flagged Q4), added the missing "or", and spelled out CapTP the first time it appears.

**Checks:**
- The American-spelling and cliché grep scripts both came back clean, and the diff adds no em dashes.
- `ci-wait-merge.sh` returned 0: one Actions run, no failures. The bot token can't read the PR's combined check status, so the script fell back to the Actions runs API, which doesn't show commit statuses or checks from outside Actions.

**Follow-ups:** None from this stage. The driver will post panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1667014 cached reads)
- Output: 13917 tokens
- Cost: $1.1973988000000002
- Wall-clock: 955s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
