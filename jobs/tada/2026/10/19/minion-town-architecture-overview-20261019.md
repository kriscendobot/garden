The minion.town architecture overview is live at https://2ry66ivxikmvxgr67lmrgvlf44p7osbbgttnzlwsxrfcd3cjgs3q.ocap.site/, and the report (URL, file list, scrub checklist, source commit) is in the maintainer inbox.

**Source:** `kriscendobot/minion.town` `main` at `dc3240231cf11e7b618af77475353b95c2a9b0ac` (2026-10-19). The page states the commit and the date.

**Files (7):** `index.html`, `glossary.html`, `styles.css`, `overview.svg`, `mcp-ocap.svg`, `clip.svg`, `deploy.svg`.
- I fetched each file back from the published URL with `curl`. All returned 200 with the right content type and are byte-identical to the local build (`cmp`).
- It was published with an inert pet name, `minion-town-architecture-inert` (empty `writeText`), not `sites` or `@agent`.
- I didn't publish a smoke clip, so there was nothing to unpublish.

**Content:**
- **Sections:** the guest and Endo daemon model, the web service and guest API, the MCP surface, the clip shell and how a clip is framed from its own ocap.site origin, the gateway, accounts and persistence, CD, the probe and the canary, then public links.
- **OAuth:** the MCP section presents it as a coarse admission check, with the guest's capabilities doing the actual authorization.
- **In review / planned:** names closed beta admission, New Clip and Chat by topic only.
- **Glossary:** a separate page defining guest, clip, partition, formula, pet name and coupon.
- **Coupon:** this doesn't exist on `main` yet. The glossary describes it as an in-review, off-by-default admission token.
- **Canary:** described as built but not yet running live, which is its status in `DEPLOYMENT.md`.

**Diagrams:** I drew the four SVGs by hand rather than in mermaid, so the mermaid-validation step didn't apply. They parse as XML. In Playwright at a 375px phone width, both light and dark modes showed no horizontal scroll, no console errors and no failed requests. The page has no inline script or style and loads nothing from other origins. The server's CSP header matches what the publishing skill expects.

**Scrub:** a final grep over all seven built files found none of the following:
- AWS account ids or long digit runs, ARNs, and instance, zone, VPC or security-group ids
- IP addresses, ports, localhost or loopback
- file-system paths of the host (`/etc`, `/opt`, `/var`, `/srv`, `/home`, `~/`, state directories)
- Secrets Manager names, SSM command names, environment-variable and key names, and systemd unit names
- token shapes (`eyJ`, `sk_`/`pk_`, PEM headers)
- the region and AWS resource names
- internal hostnames: only `minion.town` and `ocap.site` appear
- vulnerability or exploit wording

I also deliberately left out three things:
- the anonymous guest credential's lack of rotation or revocation
- the live daemon listener layout
- any PR-level security detail

Links go only to public sites: minion.town, ocap.site, github.com/endojs/endo, ocapn.org, modelcontextprotocol.io and publicsuffix.org. The private repo is named as the source in plain text but not linked.

No garden repo changes. A refresh will publish under a new address, since clips are immutable.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-architecture-overview-20261019.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (3476070 cached reads)
- Output: 27398 tokens
- Cost: $2.1234299999999995
- Wall-clock: 316s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
