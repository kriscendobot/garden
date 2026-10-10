I surveyed minion.town, wrote a short plan, and parked seven increments for the `minion-town-ui` arc. Four of them can be drawn by the foreman right away. Nothing was built.

**What already exists on minion.town `main` (c9a073c):**
- **The clip gutter is already live.** It is the signed-in landing page (`deploy/aws/www/index.html` and `shell.js`, function `createClipGutter`). It lists the caller's clips from `GET /account/clips`, sits on the left in landscape and at the bottom in portrait, and has Cmd/Ctrl+1..9 switching, a `+` button and the settings corner.
- **What the gutter is missing:**
  - Every clip is named "Clip N", because the listing only carries the clip's hash and whether it is serving.
  - Clips can't be reordered.
  - Whether a clip is serving isn't shown.
  - The list only loads once per page load.
  - `+` shows a how-to card and doesn't create a clip.
- **The clip iframe only shows placeholder cards.** It never loads a real clip, by design. The gateway (`isolation-headers.ts`) blocks framing for every `*.ocap.site` response. Loosening that is open question #1 in `designs/clip-shell-framework.md`, which the maintainer hasn't decided.

**The plan:** `designs/minion-town-clip-gutter-plan.md` on garden `main2` (c9ad8fe36a8, pushed directly).

**Plans parked**, all stamped `arc: minion-town-ui` and checked on `origin/journal2`:

| # | Plan | Status | Waits on |
|---|---|---|---|
| 1 | `minion-town-ui-gutter-clip-labels` (builder): real clip names and icons, and show when a clip isn't serving | ready | — |
| 2 | `minion-town-ui-gutter-live-refresh` (builder): reload the list on focus, so clips published over MCP show up | ready | — |
| 3 | `minion-town-ui-gutter-reorder` (builder): drag and keyboard reorder, saved per account on the server | ready | — |
| 4 | `minion-town-ui-gutter-mint` (builder): `+` creates a real clip through the guest's own publish power | blocked | minion.town PR #142 (clip lifecycle authority) |
| 5 | `minion-town-ui-iframe-embed-design` (designer): a design PR answering open question #1, for the maintainer to decide | ready | — |
| 6 | `minion-town-ui-iframe-embed-headers` (builder): implement the approved header change | blocked | plan 5 |
| 7 | `minion-town-ui-iframe-live-frame` (builder): load the real clip in the iframe, falling back to the placeholder card | blocked | plan 6, and needs reconciling with PR #88 if that lands |

**Follow-ups:**
- Plan 6 is unblocked as soon as plan 5's job finishes, not when the maintainer approves the design. Its body tells the builder to stop if the design PR isn't approved.
- Iframe work can't get past plan 5 until the maintainer answers that design PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/plan-minion-town-clip-gutter-20261010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (881513 cached reads)
- Output: 9356 tokens
- Cost: $0.9045266
- Wall-clock: 192s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
