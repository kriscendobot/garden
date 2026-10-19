---
role: web-builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Architecture overview of minion.town, published as a clip on ocap.site

Maintainer request (kriskowal, liaison session 2026-10-19): produce an architecture overview of minion.town and post it to ocap.site. Publishing is authorized by this request.

**Source of truth:** `kriscendobot/minion.town` at `main` (private repo; read it in a per-job worktree), its `designs/` and `DEPLOYMENT.md`, and the garden's `context/operations/minion-town-mcp.md`. Cover what exists on `main` today: the guest and Endo daemon model, the web service and guest API, the MCP surface and how OAuth is a thin outer layer over object capabilities, the clip shell and how a clip is published and framed from its own ocap.site origin, the gateway, accounts and persistence, deploy and CD, the canary and probe. Add a short "in review / planned" section that names in-flight work by topic only (closed beta admission, New Clip, Chat), with no PR-level security detail. Include a few diagrams (validate any mermaid per skills/mermaid-validation, then ship as SVG files), a one-page glossary (guest, clip, partition, formula, pet name, coupon), and links to the public parts only.

**This is published to a PUBLIC site from a private repo, so scrub.** Include no secrets, tokens, key material, AWS account ids, ARNs, instance ids, internal hostnames or ports, Secrets Manager names, SSM command names, file-system paths of the host, or unfixed vulnerabilities or exploit details. Describe mechanisms and boundaries at the design level. Do a final pass over the built files specifically hunting for those, and list what you checked in your report.

**Publish:** follow skills/minion-town-clip-publishing exactly: static files only; the CSP is `script-src/style-src/connect-src 'self'`, so ship sibling `styles.css`/JS, no inline script or style, no cross-origin loads; never publish with `powers: "sites"` or `"@agent"`, use a purpose-specific inert pet name with empty `writeText`; drive the stdio bridge from a script for a clip of this size; `curl` the returned `<hash>.ocap.site` URL and `cmp` against the local files. Make it readable on a phone and in light and dark. Use `minion-town-architecture-*` for pet names and clean up any smoke clip with `unpublish`.

**Report** to the maintainer inbox: the published URL, the file list, the scrub checklist, and the source commit hash of `main` the overview describes (state it on the page too, with the date). A clip is immutable, so a later refresh publishes a new hash.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-19T23:34:24Z
