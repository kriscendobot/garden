The reply is posted. The issue remains open.

## Completion report

**Job:** Dead-lettered message for `issue-kriscendobot-garden-58` — a new comment from maintainer `kriskowal` on kriscendobot/garden#58 asked: *"Is it possible to obviate the `weblet` term in `*.weblet.minion.town` subdomains? Let's assume all subdomains of minion.town are themselves weblets."*

**What I did:** Grounded the answer in the live minion.town repo rather than opinion — read the Caddy config (`weblet-gateway.caddy`, `minion-town.caddy`, root `Caddyfile`), the DNS provisioning script (`deploy-weblet-dns.sh`), and the gateway resolver (`gateway.ts` `hostToWebletId`, `config.ts` `parentDomain`, `base32.ts` label grammar). Then posted a substantive design reply on the issue thread (did **not** close it).

**Finding delivered:** Obviating `weblet` is feasible and low-risk. The resolver already keys on the *shape* of the leftmost label (a 52-char RFC-4648 base32 encoding of a 256-bit id), not on the `weblet` word — so every infrastructure name (`www`, `github-idp`, `siwe-idp`, apex, multi-level) already fails the grammar and falls closed. The change set is essentially: `MINION_TOWN_DOMAIN=minion.town`, a wildcard DNS record swap, a Caddy wildcard-block rename (exact-host blocks still win by specificity, on-demand-TLS ask gate still fail-closed), plus a host-only-cookie re-confirmation. I noted the real tradeoff (spending the first-level subdomain namespace on user content; a light future-naming discipline) and clarified that `weblet.` was never a web-origin security boundary (weblets are same-registrable-site to the apex either way — only a PSL entry changes that).

**Reply:** https://github.com/kriscendobot/garden/issues/58#issuecomment-5235389858

**Changed:** nothing in any repo — this was a design question answered in a comment. No garden `main2` commit was needed.

**Follow-ups:** I offered to turn the analysis into a PR against `kriscendobot/minion.town` if the maintainer wants it built. None posted unprompted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5235358040.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (774790 cached reads)
- Output: 13701 tokens
- Cost: $1.3580460000000003
- Wall-clock: 223s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
