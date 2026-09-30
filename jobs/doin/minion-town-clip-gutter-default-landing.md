---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# build: make the clip gutter the real minion.town landing (kriscendobot/minion.town, follow-up to PR #90)

Repo: kriscendobot/minion.town (base `main`). Source directive: kriskowal on merged PR #90,
https://github.com/kriscendobot/minion.town/pull/90#issuecomment-5903046029 ("I see no evidence
that the deployment of minion.town has a clip gutter … create a follow-up if work remains").

Empirical state (verified 2026-09-30 by job kriscendobot-minion.town-pr90-d6a72a2f, SSM on
i-0380cd68b90020fad): `/srv/minion-town/www/shell.html` + `shell.js` ARE deployed, byte-identical
to `main` (sha256 d95b1689… / 317d04b3…), served gated at `https://minion.town/shell.html`. But:
1. `/` still serves `index.html`, which has NO gutter and NO link to `/shell.html`, so a signed-in
   user never meets the shell. #90 shipped it as an opt-in-by-URL draft surface.
2. The gutter holds only browser-localStorage PLACEHOLDER clips (`makePlaceholderClip`); it does not
   list the user's real published clips, and the pane frames only inert `srcdoc` placeholders.

Work:
- Make the clip-gutter shell the default signed-in landing at `/`: fold the index.html surfaces the
  shell already consolidates (login/account/guest formula id/billing) behind its bottom-left button,
  and keep any index-only surfaces (for example the connect.html entry) reachable. Keep the Caddy
  gated default route and the unforgeable-chrome properties from designs/clip-shell-framework.md.
- Populate the gutter from the user's REAL published clips (owner-scoped, the same data as the MCP
  `listSites` tool; add a gated same-origin read endpoint if none exists) instead of localStorage
  placeholders.
- Do NOT relax the per-clip isolation floor (design Open question #1 is unsettled and needs the
  maintainer). Until it is decided, the pane stays inert/sandboxed for real clips too (for example an
  inert card naming the clip's `https://<id>.ocap.site/` origin with an open-in-new-tab link). Name
  this explicitly in the PR body.
- Open a DRAFT PR through ensure-pr.sh; minion.town gauntlet notes: GARDEN_YARN=npm. After merge,
  CD deploys www. Verify live over SSM (/srv/minion-town/www hash and served `/` content) before
  claiming it is deployed, and link the PR back on #90.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T04:33:27Z
