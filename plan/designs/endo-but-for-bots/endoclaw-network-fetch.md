---
slug: endoclaw-network-fetch
repository: endo-but-for-bots
status: Superseded
size: M
milestone: M3
depends_on: []
created: 2026-03-03
updated: 2026-11-02
superseded_by: endo-fetch
pr: endo-but-for-bots#566
source: imported from origin/llm designs/README.md
---

# EndoClaw: Network Fetch Capability

| | |
|---|---|
| **Created** | 2026-03-03 |
| **Updated** | 2026-11-02 |
| **Author** | Kris Kowal (prompted) |
| **Status** | Superseded by endo-fetch |
| **Parent** | [endoclaw](endoclaw.md) |

## Implementation status (reconciled 2026-11-02)

**Do not dispatch a build from this record.** `designs/endoclaw-network-fetch.md`
on `llm` has been Superseded by `endo-fetch` since 2026-07-13; this record kept the
March import's `Not Started` and so re-minted a build job on 2026-11-02.

- Capability shape below: landed in endo-but-for-bots #566 (`@endo/exo-http-client`
  over `@endo/http-confine`).
- Provisioning: #723 landed the first plugin; draft #1588 splits it into
  `@endo/fetch` and `@endo/confined-fetch`. Track remaining work on the
  [endo-fetch](endo-fetch.md) record.

## Summary

An `HttpClient` capability lets an agent make HTTP requests to a
host-controlled allowlist of origins. Prevents data exfiltration to
attacker-controlled servers while enabling web research and API access.
Foundation for the OAuth capability and productivity integrations.

## Capability Shape

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

## How It Works

1. Host creates an `HttpClient` / `HttpClientControl` pair with an
   origin allowlist (e.g., `['https://api.github.com', 'https://httpbin.org']`).
2. Agent calls `E(http).fetch('https://api.github.com/repos/endojs/endo')`.
3. The `HttpClient` exo parses the URL, checks the origin against the
   allowlist, enforces rate limits, makes the request, and returns the
   response (truncated to max response size).
4. Requests to disallowed origins throw immediately.

## Endo Idiom

**Origin allowlist is structural.** The agent cannot construct a URL
that reaches an origin not in the allowlist. There is no wildcard or
bypass — the exo parses the URL and checks the origin before making any
network call.

**Rate limiting and size limits.** The control facet sets per-minute
request caps and maximum response sizes. This prevents an agent from
using network access for denial-of-service or downloading large files.

**No ambient DNS or socket access.** The agent has no `net.connect` or
`dns.resolve` — only the `fetch` method on its granted `HttpClient`.
Protocols other than HTTP/HTTPS are not supported.

**Composable with OAuth.** The OAuth capability
([endoclaw-oauth](endoclaw-oauth.md)) wraps an `HttpClient` with token
injection and path restrictions, adding authentication as a layer on
top of network confinement.

## Depends On

- Node.js `fetch` (available in Node 22+) or `undici` for HTTP
- No other Endo designs required; standalone capability
