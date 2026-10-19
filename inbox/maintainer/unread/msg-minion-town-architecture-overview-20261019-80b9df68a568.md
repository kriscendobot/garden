from_host: endolin-garden-ece02cb4
from: gardener:minion-town-architecture-overview-20261019
reply_to: minion-town-architecture-overview-20261019
msg_key: msg-minion-town-architecture-overview-20261019-80b9df68a568
notice_count: 1
first_seen: 2026-10-19T23:39:28Z
last_seen: 2026-10-19T23:39:30Z
sent_at: 2026-10-19T23:39:30Z
---
minion.town architecture overview published (job minion-town-architecture-overview-20261019).

URL: https://2ry66ivxikmvxgr67lmrgvlf44p7osbbgttnzlwsxrfcd3cjgs3q.ocap.site/
Source: kriscendobot/minion.town main @ dc3240231cf11e7b618af77475353b95c2a9b0ac (2026-10-19), stated on the page with the date.

Files (7): index.html, glossary.html, styles.css, overview.svg, mcp-ocap.svg, clip.svg, deploy.svg. All fetched back with curl (HTTP 200, correct content types) and cmp-identical to the local build. Published with powers = inert pet name `minion-town-architecture-inert` (empty writeText), never sites/@agent. No smoke clip was published, so nothing needed unpublishing.

Sections: guests + Endo daemon, web service + guest API, MCP (OAuth as a thin admission layer over the guest facet), clips/shell/ocap.site framing + isolation, gateway (content + powers planes, GC, git remote), accounts + persistence, CD, probe + canary (marked built-not-live), in review/planned by topic only (closed beta admission, New Clip, Chat), public links, and a one-page glossary (guest, clip, partition, formula, pet name, coupon).

Diagrams: hand-authored SVG (no mermaid, so no mermaid validation was needed); they parse as XML and render in light and in dark (CSS invert filter). Checked in Playwright at 375px: no horizontal scroll, no console errors, no failed requests. No inline script or style; same-origin assets only.

Scrub checklist (grepped the built files, all clean): AWS account ids/long digit runs; ARNs; instance/zone/VPC/SG ids; IPv4 addresses, ports, loopback/localhost; host filesystem paths (/etc, /opt, /var, /srv, /home, ~/, state dirs); Secrets Manager names, SSM/SendCommand, env var and key names, .env/.service/systemd unit names, tokens (eyJ, sk_/pk_, PEM); region and provider resource names (DynamoDB/Cognito/S3); internal or subdomain hostnames (only minion.town and ocap.site appear); vulnerability/exploit wording. I also left out by hand: the anonymous guest credential's lack of rotation/revocation, the live listener topology, and any PR-level security detail. Links go only to public sites: minion.town, ocap.site, github.com/endojs/endo, ocapn.org, modelcontextprotocol.io, publicsuffix.org. The private repo is named in plain text as the source, not linked.

Because a clip is immutable, a refresh will publish under a new hash.
