I checked the live minion.town box. You're right that signed-in users see no clip gutter. Work remains, so I posted a follow-up build job and replied on PR #90.

**What's deployed** (checked on the server `i-0380cd68b90020fad` over SSM):
- `shell.html` and `shell.js` from PR #90 are on the box, byte-identical to `main` (deployed 2026-09-29 22:03Z). They're served behind the login gate at `https://minion.town/shell.html`; signed out, it redirects to the sign-in page.
- `/` still serves `index.html`, which has no gutter and no link to `/shell.html`. PR #90 shipped the shell as a draft you only reach by typing its URL, so a signed-in user never sees it.
- Even at `/shell.html`, the gutter only lists placeholder clips stored in the browser, not the user's published clips. The main pane only shows inert sandboxed placeholders, because the design's Open question 1 (whether to relax the per-clip isolation floor so a real clip can be framed) is still undecided.

**What I did:**
- **Follow-up job:** `minion-town-clip-gutter-default-landing` is on the board in `jobs/todo/`. It asks for a draft PR that:
  - makes the gutter shell the signed-in landing page at `/`;
  - fills the gutter from the user's real published clips (the same data as the MCP `listSites` tool);
  - keeps real clips inert in the pane until the maintainer decides Open question 1.

  It also requires checking the deploy on the box before claiming it's live. The first post attempt was deduplicated into this job, because it derived the same identity from the source comment. I re-posted with an explicit identity of its own.
- **Reply on PR #90:** https://github.com/kriscendobot/minion.town/pull/90#issuecomment-5903078250. It gives the evidence, explains that a merged PR can't be reactivated, and names the follow-up job.

The duplicate-check script found nothing that addressed the comment; its only hit was the bot's own "On it" acknowledgment. I changed no garden code, so there was nothing to commit.

**Needs your decision:** Open question 1 in `designs/clip-shell-framework.md` has to be settled before real clips can be shown live in the pane.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr90-d6a72a2f.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (822271 cached reads)
- Output: 6328 tokens
- Cost: $0.7733981999999999
- Wall-clock: 97s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
