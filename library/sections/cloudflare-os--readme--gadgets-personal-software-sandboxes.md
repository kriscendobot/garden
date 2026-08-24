---
title: Gadgets as personal software sandboxes
source: README.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda, "Yo'av Moshe", Nathan Disidore, Phillip Jones, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [ai-generated-apps, agent-workspaces, sandbox-platforms]
status: current
---

A gadget is a private, modifiable application instance generated for one user and isolated from every other user's copies.

Creating a slide deck does not call a centralized software-as-a-service application. Cloudflare OS creates a private instance of the slide-deck software in its own sandbox. The sandbox controls access to the instance, while ownership of the code lets the user ask an agent to add missing features without waiting for a central vendor.

The model treats AI-generated software as cheap enough that each user can run and evolve a personal copy. Gadgets play the role of processes in the project's operating-system analogy.

Source: [README.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/README.md) at commit `1ef6020a`.
