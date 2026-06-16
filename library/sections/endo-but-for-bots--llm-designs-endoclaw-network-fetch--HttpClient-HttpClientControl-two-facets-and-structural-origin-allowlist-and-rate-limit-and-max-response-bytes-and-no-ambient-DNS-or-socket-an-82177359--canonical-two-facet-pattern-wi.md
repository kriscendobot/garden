---
title: §Canonical two-facet pattern with explicit substrate role
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
parent: endo-but-for-bots--llm-designs-endoclaw-network-fetch--HttpClient-HttpClientControl-two-facets-and-structural-origin-allowlist-and-rate-limit-and-max-response-bytes-and-no-ambient-DNS-or-socket-and-substrate-for-OAuth
---

Lines 18-34 establish the canonical-two-facet shape that the entire endoclaw cluster instantiates:

```ts
interface HttpClient {
  fetch(url: string, options?: FetchOptions): Promise<Response>;
  allowedOrigins(): string[];
  help(): string;
}

interface HttpClientControl {
  setAllowedOrigins(origins: string[]): void;
  setMaxRequestsPerMinute(n: number): void;
  setMaxResponseBytes(n: number): void;
  revoke(): void;
  help(): string;
}
```

§Three-use-facet-methods (fetch + allowedOrigins + help) vs §five-control-facet-methods (setAllowedOrigins + setMaxRequestsPerMinute + setMaxResponseBytes + revoke + help):

- §**the-control-facet-has-more-methods-than-the-use-facet** — established here at the substrate; reused by cycles 234 (OAuth: 4-method use vs 5-method control + revoke + help) and 259 (Browser: 2-method use vs 4-method control).
- §**three-named-control-knobs** (origins + rate-cap + size-cap) — each addresses a distinct attack class: origin = data-exfiltration; rate = DoS-against-allowed-origin; size = downloading-large-files-for-DoS-of-the-agent's-environment.
- §**revoke as named permanent-state transition** — sibling pattern to cycle 238 + 244 + 246 + 253 + 259; §six-cycles-with-revocation-as-named-permanent-state when counting this substrate (226 + 234 + 238 + 244 + 246 + 253 + 259 + 261 — actually now seven; the substrate establishes the discipline).
- §**`help()` on both facets** — the §help-method-IS-a-named-convention-from-the-`@endo/exo`-conventions; sibling pattern to the project CLAUDE.md `## Modules and exports` *"The `help()` method is conventional on capabilities and should return a descriptive string"*; §first-explicit-observation in library of §the-help-method-IS-a-named-convention-of-`@endo/exo`-derived-capabilities-named-in-the-project-CLAUDE.md.
- §**`allowedOrigins()` as introspection-on-the-use-facet** — the agent can read the policy that confines it; §self-reflective-capability gives the agent a way to ask "what am I allowed?" without trial-and-error; §a-named-introspection-method-on-the-use-facet; §first-explicit-observation in library.
