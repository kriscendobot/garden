---
title: Git compatibility and programmatic surfaces
source_kind: web
source_url: https://developers.cloudflare.com/artifacts/llms-full.txt
source_content_sha256: d81d8779a3e3a3b645c62b871ca8c06e35acfc66ccfde4986186904f06cb9996
source_authors: ["Cloudflare, Inc."]
source_date: 2026-08-25
ingested: 2026-09-10
ingested_by: gardener
topics: [cloudflare-workers-agent-hosting, content-addressed-storage, capability-security]
status: current
---

Artifacts exposes one repository through three surfaces. Standard clients use Git-over-HTTPS, control-plane clients use a REST API, and Cloudflare Workers use an Artifacts binding. Clone and fetch support upload-pack protocol versions 1 and 2, including ordinary shallow and deepen flows. Push uses receive-pack version 1; receive-pack version 2 and some optional filtering capabilities are absent.

The REST API can resolve files at a ref and read commits, trees, and blobs by immutable Git SHA-1 object identifiers. The Worker binding manages repositories, forks, imports, tokens, logs, commits, and trees, but does not provide file mutation or blob-reading methods. This distinction makes the binding a control plane and partial read plane, not a complete filesystem interface.

Authentication follows the surface. A Worker binding carries namespace authority from configuration, REST calls use a Cloudflare API token, and Git clients receive short-lived repository-scoped read or write tokens.

Supporting pages: [Git protocol](https://developers.cloudflare.com/artifacts/api/git-protocol/), [REST API](https://developers.cloudflare.com/artifacts/api/rest-api/), and [Workers binding](https://developers.cloudflare.com/artifacts/api/workers-binding/).

Source: [Cloudflare Artifacts complete documentation](https://developers.cloudflare.com/artifacts/llms-full.txt), retrieved 2026-09-10.
