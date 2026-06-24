---
title: §Two-facet-control-pair (consistent with cycle 226 template)
source-slug: endo-but-for-bots--llm-designs-endoclaw-oauth
section-id: the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-oauth.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-oauth.md
total-lines: 99
status: Not Started (Parent: endoclaw)
ingest-cycle: 234
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster
---

```ts
interface OAuth {
  fetch(path: string, options?: FetchOptions): Promise<Response>;
  baseUrl(): string;
  scopes(): string[];
  help(): string;
}

interface OAuthControl {
  setScopes(scopes: string[]): void;
  setAllowedPaths(patterns: string[]): void;
  setReadOnly(flag: boolean): void;  // restricts to GET/HEAD
  refresh(): Promise<void>;  // force token refresh
  revoke(): void;
  help(): string;
}
```

§Consistent-with-cycle-226's-canonical-two-facet-control-pair. §Four-named-control-methods (setScopes + setAllowedPaths + setReadOnly + refresh) + §revoke + §help.

§Borrowable-pattern: §the-control-facet-has-more-methods-than-the-capability-facet because the host needs more knobs than the user; §the-capability-facet-is-minimal (fetch + baseUrl + scopes + help).
