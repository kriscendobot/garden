---
title: Confluence credential and deployment configuration
source: packages/gatekeeper-confluence/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

Local Confluence credentials are injected from repository development variables into the Gatekeeper Worker, while production stores the same client ID and secret as Worker secrets and sets the public base URL.

The connector intentionally does not advertise itself as a sign-in provider. Its verified Atlassian identity could support that later, but current deployment keeps data-connector authority separate from user authentication. This preserves the distinction between logging into Cloudflare OS and connecting a Confluence account with broad content scopes.

Source: [packages/gatekeeper-confluence/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-confluence/README.md) at commit `657aa965`.
