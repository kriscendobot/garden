---
title: Portal trust tier and the annotation-trust flag
source: packages/gatekeeper-mcp-portal/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 4fd43ffe37435637e818357035a50054bacba297
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

Approvals and sharing match the bring-your-own MCP connector except for the trust tier: a portal is an aggregator whose annotations are written by upstream servers the administrator never reviewed, so the tier is `byo` unless a deployment sets `MCP_PORTAL_TRUST_ANNOTATIONS=true`.

`destructiveHint` and `idempotentHint` are written by whichever upstream server the portal fronts, and any one of them could self-declare both and get writes that skip the approval prompt. So the tier stays `byo` — no auto-apply of writes on the server's word — unless the deployment opts in with `MCP_PORTAL_TRUST_ANNOTATIONS=true`, which is the "trusted server" assertion MCP's guidance asks for and has to be about the upstreams themselves, not just the portal in front of them. `addObserver` refuses everyone as it does for user-supplied endpoints, because reaching the portal is not the same as being allowed to see a particular tool result and the Gadget runs on the owner's credentials regardless; a sharper check is available here (`portal_list_servers` is per-user and Access-filtered, so it could confirm a collaborator may reach the same server) but that is still server-granular, not record-granular.

The bring-your-own connector's limitations apply here too — no simulation, no revert, no hooks, no scoping below tool names, `tools/*` only, and SSRF enforced by `global_fetch_strictly_public` rather than hostname patterns — with two additions. There is one portal per deployment, because `MCP_PORTAL_URL` is a single value and a second portal needs a second Worker. And server ids come from tool-name prefixes, so an aggregator that flattens tools without prefixing them exposes no upstream seam: the connector finds no server to scope a grant to, the form stays unsubmittable, and it is never granted as a whole endpoint — that grant does not exist here. Such an endpoint should be pointed at the bring-your-own MCP connector, where endpoint-wide breadth is an explicit, reviewable choice.

Source: [packages/gatekeeper-mcp-portal/README.md](https://github.com/cloudflare/cloudflare-os/blob/4fd43ffe37435637e818357035a50054bacba297/packages/gatekeeper-mcp-portal/README.md) at commit `4fd43ffe`.
