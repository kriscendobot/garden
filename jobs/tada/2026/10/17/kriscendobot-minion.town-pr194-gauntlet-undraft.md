# Gauntlet un-draft: kriscendobot/minion.town PR #194

PR #194 ("feat(gateway): let only the Minion Town shell frame a clip") is now marked ready for review, at the same head the panel passed (`74c521d9ea51c0437e8d894e6714c675dd799dac`).

**How the un-draft was gated**
- **Before:** the PR was OPEN, still a draft, and its head was exactly `74c521d…`, so I ran `gh pr ready`.
- **After:** a fresh check shows `isDraft=false` and the head still `74c521d…`.

**Appellate review (advisory only; it did not block the un-draft)**

A short `claude -p` review of the diff raised these possible follow-ups:
- **Headers never tested live.** Every test is a regex over the Caddyfile, and CI has no caddy binary. So nobody has run `caddy validate`, and no probe has confirmed that the appended CSP or `handle_errors` really produce the headers a browser receives.
- **Deploy order.** The docs run the gateway step, which relaxes the clip's framing rule, before `deploy-caddy.sh`. That briefly contradicts "apex floor must be live first". It is harmless until a live clip `src` exists.
- **Iframe sandbox.** `frame-ancestors` cannot stop a framed clip from navigating the top window. The future live-`src` work must leave out `allow-top-navigation*` and `allow-same-origin`, and nothing in this PR pins that.
- **Site-wide `nosniff`.** It now applies to every apex route, including JS/CSS served from S3 under `/static/*`. Any asset with a wrong Content-Type will stop loading.
- **Fragile test and probe checks.** The route allowlist is self-declared, the line-based Caddyfile parser misses `import` and snippets, and the deploy probe's detection depends on the text `frame-src`.
- **Minor:**
  - `handle_errors` changes error bodies and sets the CSP rather than appending it.
  - Caddy's own error and redirect responses on `*.ocap.site` carry no framing floor.

No follow-up job was posted; these are recorded here only.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr194-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168628 cached reads)
- Output: 1553 tokens
- Cost: $0.3966496
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
