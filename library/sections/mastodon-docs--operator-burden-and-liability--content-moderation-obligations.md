---
title: Content moderation obligations
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

The Mastodon moderation documentation (docs.joinmastodon.org/admin/moderation/) describes the moderation toolset operators must actively use:

**Individual user moderation (four levels):**
- **Sensitive:** all media automatically marked sensitive.
- **Freeze:** account suspended (user sees "You can no longer login to your account or use it in any other way, but your profile and other data remains intact").
- **Limit** (formerly "silence"): account hidden from public views except to followers; content still searchable and accessible via mention.
- **Suspend:** effective public deletion — "All of the posts, uploads, followers, and all other data are removed publicly." Data retained in admin backend for 30 days; permanent purge after.

**Server-wide (domain block) moderation (three levels):**
- **Reject Media:** blocks media files (avatars, headers, emojis, attachments) from the remote server.
- **Limit:** applies account-limiting to all users from that server.
- **Suspend:** removes all content from that server except usernames. Operators can import blocklists from other admins.

**Spam prevention:** email confirmation, IP-based rate limiting, email domain blacklisting against dynamically maintained lists, IP blocking (IPv4/IPv6 / CIDR ranges, configurable duration and severity).

**Appeals:** As of version 3.5.0, moderated users receive email notification and can appeal within 20 days. Operators must process appeals.

The moderation surface is substantial. A busy instance operator may face hundreds of reports per day, ongoing defederation decisions, and appeal processing — all requiring human judgment.

Source: Mastodon admin documentation (docs.joinmastodon.org), kriskowal.com/giants. Retrieval date: 2026-06-11.
