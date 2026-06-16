---
title: "endoclaw-network-fetch.md — HttpClient/HttpClientControl two facets + structural origin allowlist + rate limit + max response bytes + no ambient DNS or socket + substrate for OAuth"
source-slug: endo-but-for-bots--llm-designs-endoclaw-network-fetch
section-slug: HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-network-fetch.md
source-repo: endojs/endo-but-for-bots
source-path: designs/endoclaw-network-fetch.md
source-author: Kris Kowal (prompted)
total-lines: 69
ingest-cycle: 261
ingest-date: 2026-06-10
lane: designs
kind: index
section_count: 17
---

Sections:

- [`endoclaw-network-fetch.md` — the foundational HTTP-confinement capability that the OAuth/Browser endoclaw designs build on](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-82177359--endoclaw-network-fetch-md-the.md)
- [§The foundational network-substrate of the endoclaw cluster](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--the-foundational-network-subst.md)
- [§Canonical two-facet pattern with explicit substrate role](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--canonical-two-facet-pattern-wi.md)
- [§Structural origin allowlist — the discipline named here at the substrate](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--structural-origin-allowlist-th.md)
- [§Three orthogonal control knobs on the control facet](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--three-orthogonal-control-knobs.md)
- [§No ambient DNS or socket access — the named non-exposure discipline at substrate root](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--no-ambient-dns-or-socket-acces.md)
- [§Composable with OAuth — the substrate names its principal extension point](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--composable-with-oauth-the-subs.md)
- [§Depends On bullets at the substrate root](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--depends-on-bullets-at-the-subs.md)
- [§Use-Cases section absent at the substrate — a discriminating signal](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--use-cases-section-absent-at-th.md)
- [§Endo Idiom section as the substrate's named pattern catalog](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--endo-idiom-section-as-the-subs.md)
- [§Cycle 261's structural moves](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-82177359--cycle-261-s-structural-moves.md)
- [§Recurring meta-patterns counter-bumps at cycle 261](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--recurring-meta-patterns-counte.md)
- [§Synthesis target — slot machine library](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-82177359--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing (substrate-level patterns)](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--tier-1-borrowing-substrate-lev.md)
- [§Tier-2 borrowing (substrate-establishing patterns)](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-an-82177359--tier-2-borrowing-substrate-est.md)
- [§Tier-3 borrowing (meta-counter-bumps)](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-82177359--tier-3-borrowing-meta-counter.md)
- [Pattern summary (tag-prefixed)](endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-82177359--pattern-summary-tag-prefixed.md)
