The design is delivered as a draft PR on the correct base, and the inbox is clear. The job is complete.

## Completion report

**What I did.** Wrote `designs/weblet-gateway.md` in `kriscendobot/minion.town`, a design decomposing the `*.minion.town` wildcard weblet gateway (the last primary-phase target on kriskowal/garden#58 with no design/code/artifact) into four independently deployable, edge-verifiable increments, and opened it as a draft PR for review.

**Grounding.** Reconciled against the live stack at HEAD `af30574` (**B2** of the daemon-guest build): the actual Caddy site block + oauth2-proxy cookie config (host-scoped, no `cookie_domains`), the hand-managed Route53 zone (`Z05121952LNOCCNVIXFAO`, EIP `13.56.17.18`), the `src/endo/` transplant module (the one grant site `guest-control.ts:guestFacetFor`, the pinned `llm` commit `f6650503`), and the companion designs (daemon-guest tools, endo-guest, ertp-credits). Confirmed there is **no** existing `weblet`/CAS/gateway code and `@endo/gateway` is an unconsumed upstream stub.

**Design decisions made.**
- **TLS:** chose **on-demand TLS + an `ask` endpoint** (zero new credentials; unknown hash fails closed at the TLS layer before any ACME order) over a wildcard DNS-01 cert, with DNS-01 documented as the scale escape hatch and the trade-off/rate-limit cliff stated. Both share one hand-added `*.minion.town` A record.
- **Origin isolation:** four independent layers — the browser gate structurally absent from weblet origins; the parent session cookie kept host-scoped (reframed as an invariant to *preserve*, not a gap to close); a non-negotiable CSP/CORP/COOP/no-CORS header floor; distinct-origins-by-construction — with the exact header set specified.
- **Content plane:** weblet id = DNS-base32-encoded immutable weblet-formula id; CAS streaming bypasses CapTP (control plane resolves, data plane streams); `ETag` + `immutable` hard caching.
- **Powers plane:** the three `.well-known` OCapN/CapTP WS endpoints + `ocapn-bootstrap` bound to the vhost record's powers formula.
- **Publish:** granted at the existing single grant site, surfaced as `weblet_*` MCP tools, gated on a Minion Town Credits charge **seam that is wired and stubbed** (ERTP charging deferred per #58).
- Called out the `@endo/gateway` (+ `@endo/mcp` seed) vs. minion.town split per increment, plus a build-decomposition table and five open questions.

**What changed.** One new file `designs/weblet-gateway.md` (511 lines); committed under the bot identity on branch `design/weblet-gateway`; mermaid validated (parse-only); **draft PR #21** opened against `main`. No production change.

**Follow-ups.** The design ends on §9 open questions (on-demand→wildcard-TLS cutover threshold; whether manifests may add CSP; gateway↔daemon CAS coupling; powers-auth default; `@endo/mcp` run-ahead-branch timing) — all maintainer-resolvable at review. Natural next step per §10 is an orchestration job parking the four build increments (halt-on-failure), after design review un-drafts PR #21.

Design slug: `weblet-gateway`; PR: kriscendobot/minion.town#21 (draft).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-gateway-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (2505587 cached reads)
- Output: 45827 tokens
- Cost: $4.874509999999999
- Wall-clock: 685s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
