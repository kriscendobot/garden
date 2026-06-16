---
title: Technical infrastructure burden
source_kind: web-survey
source_url: https://docs.joinmastodon.org/admin/moderation/
source_date: 2026-06-11
ingested: 2026-06-11
ingested_by: scholar
topics: [agent-conventions, capability-security]
status: current
notes: |
  Synthesized from: Mastodon admin moderation documentation
  (docs.joinmastodon.org/admin/moderation/, retrieved 2026-06-11),
  Mastodon admin prerequisites documentation (docs.joinmastodon.org/admin/prerequisites/,
  retrieved 2026-06-11, narrow technical focus — no legal/policy content),
  ActivityPub blog post by Eugen Rochko (blog.joinmastodon.org/2018/06/why-activitypub-is-the-future/,
  retrieved 2026-06-11 — promotional, no operator-burden content),
  kriskowal.com/giants overview (this library, kriskowal-com--giants--overview.md —
  the "A Choice of Giants" essay names Mastodon's operator-trust problem).
  The Verge article on Mastodon admin challenges was not retrievable (ERR_FETCH_BLOCKED).
  No legal liability case law or regulatory sources were found and retrieved;
  the legal dimension is described structurally, not with case citations.
parent: mastodon-docs--operator-burden-and-liability
---

Mastodon is a Ruby on Rails application with significant operational complexity: PostgreSQL database, Redis cache, Elasticsearch for search, Sidekiq background job processing, and separate media storage. The prerequisite documentation covers Linux hardening, firewall configuration, and intrusion prevention as baseline requirements before installation even begins. Ongoing maintenance includes keeping all components patched and monitoring for failures.

The prerequisites documentation (docs.joinmastodon.org/admin/prerequisites/) is narrowly technical and does not address legal or policy obligations. The operator must supply those independently.

Source: Mastodon admin documentation (docs.joinmastodon.org), kriskowal.com/giants. Retrieval date: 2026-06-11.
