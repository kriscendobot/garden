---
title: Notion workspace, page, and database resources
source: packages/gatekeeper-notion/README.md
source_repo: cloudflare/cloudflare-os
source_commit: 657aa96504f23fda775df46a5a6a95eaf135ec6d
source_date: 2026-08-17
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, oauth-credentials, cloudflare-workers-agent-hosting]
status: current
---

The Notion Gatekeeper mediates a Gadget's access to a user's Notion workspace — pages and databases — through an OAuth 2.0 public connection, granting a whole workspace or a single page or database, with reachability limited to what the user shares during the OAuth page-picker.

The connector runs as its own Cloudflare Worker auto-discovered from its `GATEKEEPER_NOTION` binding. Authentication configures a Notion public integration whose client credentials reach the Worker as `CLIENT_ID` / `CLIENT_SECRET` (local dev maps `NOTION_CLIENT_ID` / `NOTION_CLIENT_SECRET`); the integration's redirect URI must match `<BASE_URL>/oauth`, and recommended capabilities are read/insert/update content, read/insert comments, and read user info — no email is needed, so `providesAuth` is false. The connect flow uses a two-phase nonce (initiation to OAuth), stores access and refresh tokens in a `UserAccount` Durable Object, and refreshes access tokens on a `401`.

Resources come at two granularities: a whole workspace (`https://*` catch-all, session type `NotionWorkspace`) or a page or database (`https://www.notion.so/:path+`, session type `NotionPage` or `NotionDatabase`, detected server-side). Only the pages and databases the user shares with the integration during the OAuth page-picker are reachable. The full Session API lives in `src/types.d.ts`; page bodies are exchanged as Markdown and property values use a simplified union. `NotionWorkspace` offers `search`, `getPage`, `getDatabase`, `createPage`, and `listUsers`; `NotionPage` covers metadata, properties, content, `appendContent`, title/property/icon setters, `createSubPage`, archive/restore, comments, and `listChildPages`; `NotionDatabase` covers `getSchema`, typed `query`, `getPage`, and `createPage`.

Source: [packages/gatekeeper-notion/README.md](https://github.com/cloudflare/cloudflare-os/blob/657aa96504f23fda775df46a5a6a95eaf135ec6d/packages/gatekeeper-notion/README.md) at commit `657aa965`.
