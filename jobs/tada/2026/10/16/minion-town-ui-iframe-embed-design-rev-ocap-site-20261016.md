I revised the design in draft PR https://github.com/kriscendobot/minion.town/pull/189 (`designs/clip-shell-framework.md`) to apply both of kriskowal's 2026-10-16 changes. The revision is pushed to `design/clip-iframe-embedding` as commit `7d3d9fb`, and the PR is still a draft. It changes no code. I did not run the Mermaid check because the diagram is unchanged.

**1. Shell frames can load `ocap.site` pages (§ 3.1, new "Shell side" subsection).**
- **Header:** the signed-in shell page (`index.html`, served by the login-gated block in `minion-town.caddy`) gets exactly `Content-Security-Policy: frame-ancestors 'none'; frame-src https://*.ocap.site; child-src https://*.ocap.site`. This only adds limits: today that page has no `frame-src` at all, so it can frame anything.
- **Why it stays narrow:** the policy leaves out `'self'` (so even a shell bug can't frame a `minion.town` page), `*` and `https:`, the bare `https://ocap.site` (it only redirects to minion.town), and both `*.minion.town` and the old `*.weblet.minion.town` clip hosts.
  - The `*.ocap.site` wildcard can't be avoided. Each clip has its own origin, a static header can't name the selected clip, and a page-level CSP can only narrow the header, never add to it.
  - The wildcard is a backstop. What actually limits which clips load is the shell's id check before setting `src` and the clip server's refusal of any malformed or unknown name.
- **CORP, COEP and the sandbox:** `frame-src` is checked before the request is sent, while CORP and COEP are checked on the response. So CORP `same-origin` and COEP `require-corp` don't change. The sandbox still controls what a loaded clip can do, separately from which URL may load.
- **Not relied on:** whether `frame-src` also stops a clip from navigating its own frame elsewhere isn't verified in any browser. The site-wide anti-framing headers on `minion.town` remain the defence there.
- **Rollout and tests:** the rollout order gains a step for the shell-side policy. New header tests and browser tests cover it (allowed and refused frame sources, the existing placeholder card still rendering, and CORP/COEP staying intact). The clip-navigation test now includes `https://ocap.site/`.
- **Who may frame clips:** clip responses still allow only `frame-ancestors https://minion.town`. I found no flow where an `ocap.site` page needs to frame a clip, so I didn't widen it or add an open question.

**2. One clip id everywhere (§ 3.4).**
- The listing, the sidebar of clips, the frame `src`, the "Open in new tab" link and any future #88 live link all use the same clip id, so the id is not a secret.
- The #88 session locator (the secret that grants the live backend) travels with the id under fixed rules:
  - It goes only in the clip URL's fragment (the part after `#`), which browsers never send to servers.
  - The shell keeps it in memory for the open tab only.
  - It never goes into account records or the browser's storage on `minion.town`.
  - It never appears in a path, query string, server or proxy log, telemetry, or `Referer` header.
  - If it ever arrives in the shell's own address, the shell strips it with `history.replaceState`.
  - The shell attaches it only to the clip it was paired with.

**3. Other sections.**
- **Ownership map:** new rows for the shell's frame policy, the clip ancestor policy, the clip id, and the #88 locator.
- **Alternatives:** I added and costed four rejected options: no `frame-src`, `https:`/`*`, listing exact clip origins, and also listing the bare `ocap.site` or weblet hosts. The separate public-id approach is now recorded as rejected by the maintainer.
- **Tests:** a new check that the clip id appears with no fragment and that no locator is stored.
- **Status and open questions:** the status line records the approval. Open question #1 is marked Resolved, quoting the maintainer.
- **Assumption to confirm:** open question #4 says the first live frame shows static content only, with no fragment and no locator. The #88 live-link hand-off is a later increment.

I updated the PR title and description to match, keeping the original `<!-- garden-job: minion-town-ui-iframe-embed-design -->` marker.

## Follow-ups
- The maintainer needs to confirm the static-only assumption (open question #4).
- As instructed, I did not start the header or live-frame implementation jobs; the liaison posts those once this revision lands.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `09624c411c49898e61dc41c20f2ee034a7796114`; this job presented `7d3d9fbac79fa1577b022d5b836b59d8b2ad8f43`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ui-iframe-embed-design-rev-ocap-site-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1348857 cached reads)
- Output: 22269 tokens
- Cost: $1.4666233999999996
- Wall-clock: 272s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
