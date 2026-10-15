Fix round 6 for kriscendobot/minion.town PR #189 is done: the panel's one must-fix and most of its should-fix items are applied, pushed, and CI is green.

**What changed:** commit `e1198f1` on `design/clip-iframe-embedding`, editing only `designs/clip-shell-framework.md`. It was pushed fast-forward from `09624c4` with `safe-push-pr-head.sh --mode advance`.

**Must-fix (copyeditor), fixed:**
- §5 said a "wide-but-short window" gets the bottom bar, which contradicts the section's own rule. It now says "tall-but-narrow".
- The prose now treats a square viewport as portrait, matching the inclusive `@media (max-aspect-ratio: 1/1)` query in the shipped `index.html`.

**Should-fix items, also applied:**
- **Fallback if browsers disagree:** §3.1 now says in advance what happens if an engine honors `X-Frame-Options: DENY` over the CSP: drop it from clip responses only, and the security cost is named. If an engine applies CORP to the frame navigation, nothing live ships. Approval is stated as revocable if the browser gate fails. §3.7's failure paragraph points to this fallback.
- **Where the headers come from:** the clip CSP is emitted only by `isolation-headers.ts`, behind `clip-gateway.caddy`. The apex `'none'` policy comes only from `minion-town.caddy`. A new header test checks the two never mix.
- **Rejected alternative added to §3.6:** granting `allow-scripts` without `allow-same-origin`. The cost is stated: the clip gets an opaque origin, so its `localStorage` and same-origin WebSocket connection break inside the frame.
- **§3.1 restructure:** split into labelled subsections, with a numbered five-step rollout order. The site-wide `frame-ancestors 'none'` header is named as the primary control and the other mechanisms as backstops.
- **Route admission:** apex responses now require `nosniff`, and the route list must record that `/static/*` and `/mcp*` serve no HTML or SVG derived from uploads.
- **`www` redirect:** justified on its own merit, not just for the framing gate. The design notes the oauth2-proxy cookie is apex-only; I confirmed `oauth2-proxy.cfg` has no `cookie_domains`.
- **Visible fallback when a frame is blocked:** a persistent caption under the frame, "Clip not loading? Open it in a new tab".
- **Open question #1:** split into five parts (a–e) so the maintainer can approve or reject each one separately.
- **Copy fixes:**
  - The chat-spaces-gutter reference now has a real link.
  - Stale wording about "a section 6 follow-on" and "this pass" is removed.
  - §8's cross-reference now points to §3.1, and its `mcp-*.html` sentence is clearer.
  - §4 no longer overclaims; it admits a clip can paint an imitation bubble in portrait.
  - The arrow and middle-dot characters in the mermaid diagram are replaced with plain ones.
  - Open-question references are consistently written with `#`, and acronyms are spelled out at first use.
  - Lines over 100 characters in the edited paragraphs are rewrapped.

**Not done (comment-only, left alone):** the link-label wording suggestion, converting §3.7's lists into tables, and the 27 em-dashes that were already in the file before this PR.

**CI:** the single workflow run, "test (typecheck + vitest)", succeeded on `e1198f1`. `ci-wait-merge.sh --no-merge` returned 0 (CI GREEN). It had to use the Actions runs API because the token can't read the PR's status-check rollup.

**Follow-ups:** none from this stage. The driver re-posts the next panel round (panel-7).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1806188 cached reads)
- Output: 13326 tokens
- Cost: $1.2625896
- Wall-clock: 1346s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
