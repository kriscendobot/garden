**Fix round 5 for kriscendobot/minion.town PR #189: fixes pushed, CI green**

I pushed commit `09624c4` to `design/clip-iframe-embedding`. It applies the panel-5 must-fix items to `designs/clip-shell-framework.md`, plus three should-fix items that were quick to do.

**Must-fix:**
- **Skeptic:** the rule that every `minion.town` response must refuse framing now names the failure paths:
  - `forward_auth` refusals: the redirect to sign-in, and oauth2-proxy `401`/`403`.
  - `reverse_proxy` errors (`502`/`503`/`504`) when an upstream is down or slow.
  - Responses Caddy generates itself.

  The design now requires a `handle_errors` block that sets the same two headers (`frame-ancestors 'none'` and `X-Frame-Options: DENY`). This rests on my reading of Caddy, not a test: error responses go through a separate route chain that the site block's normal `header` rules don't reach. Section 3.7's header tests and child-navigation tests now cover each of these failure paths.
- **Pedant (copyeditor flagged the same line):** the "`defer`red `header` block" wording now reads "a `header` block that carries Caddy's `defer` subdirective".

**Should-fix:**
- **Copyeditor:** "It pins the every-ancestor check" now reads "It pins the check that every ancestor is enforced, on which section 3.1 relies."
- **Skeptic:** I added a route-admission rule. The site block's routes go on a checked-in list, each with a note that it serves no user-authored executable content. A header test fails if a route in the Caddy config is missing from that list. User-authored content belongs on `*.ocap.site`, not `minion.town`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (green). The one run, "test (typecheck + vitest)", sat queued for about 20 minutes before it ran. My first wait attempt hit the tool's time limit and was stopped, so I re-ran it with a 2400s deadline instead of 3600s, and that run finished green. As expected on this host, the token can't read the PR's combined check status, so the script checked the Actions runs instead. That means commit statuses and checks from outside GitHub Actions were not visible to it.

**Follow-ups:** none. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (880310 cached reads)
- Output: 6770 tokens
- Cost: $0.742942
- Wall-clock: 2900s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
