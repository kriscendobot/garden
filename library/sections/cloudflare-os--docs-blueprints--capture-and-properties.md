---
title: Blueprint capture and properties
source: docs/blueprints.md
source_repo: cloudflare/cloudflare-os
source_commit: 69c39d5037609b7efe8e2ed7e704e86bb1ce7002
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [reusable-app-blueprints, ai-generated-apps]
status: current
---

A Blueprint is a versioned snapshot of gadget code and binding requirements that lets another user create an independent gadget without receiving the source gadget's data, history, or credentials.

One gadget may publish several Blueprints at different code versions. Public Blueprints normally receive random 128-bit IDs and are shared by link. Anyone with the link can inspect public metadata, while creating a gadget requires authentication.

The captured source is a compact snapshot of final Yjs file contents. Metadata describes the title, author, version, and required bindings. SQLite contents, chat and edit history, credentials, and live connections are excluded. New instances receive their own bindings, storage, and chat history.

Source: [docs/blueprints.md](https://github.com/cloudflare/cloudflare-os/blob/69c39d5037609b7efe8e2ed7e704e86bb1ce7002/docs/blueprints.md) at commit `69c39d50`.
