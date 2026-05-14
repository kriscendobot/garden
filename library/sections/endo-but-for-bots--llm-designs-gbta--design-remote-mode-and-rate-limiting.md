---
title: Design (remote-mode env var + CIDR allowlist + rate limiting + TLS warning)
source: designs/gateway-bearer-token-auth.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 069d5ecbf79d90409069cfe72ed0c54e79c7bc77
source_date: 2026-03-07
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, tooling]
status: current
notes: The "explicit opt-in" via `ENDO_GATEWAY=remote` — separate from `ENDO_ADDR=0.0.0.0` binding — is the canonical capability-discipline detail. Binding to all interfaces alone doesn't enable remote access; operator must take a second deliberate action. The accruing per-IP penalty (1-second per failure stacking) is the brute-force defense.
---

> Abstract: **Remote mode** controlled by `ENDO_GATEWAY=remote` env var (default `local`). **Two configurations**: unset/`local` uses localhost IP check; `remote` uses bearer token via CapTP. **Explicit opt-in**: binding to `0.0.0.0` without `ENDO_GATEWAY=remote` accepts connections on all interfaces but still rejects non-localhost IPs — operator must opt in to remote access. **`ENDO_GATEWAY_ALLOWED_CIDRS`** allows specific IP ranges without fully disabling the address check. **Rate limiting** per IP on failed `fetch()` attempts to prevent online brute force: state is single value (earliest `Date.now()` accepting the next attempt); accruing 1-second penalty per failure; on attempt — reject if `Date.now() < nextAllowedTime` with `"Rate limited"`; on failure — advance `nextAllowedTime` by 1 second from whichever is later (current deadline or now); consecutive failures stack (2 → 2s, 10 → 10s); successful fetch — no state change. **Collection**: entry stale 10 seconds after last failure (10× penalty interval); lazy sweep on subsequent `check()` calls. **TLS warning**: when remote mode is active, gateway logs at startup: `[Gateway] Remote mode active. Ensure TLS termination (reverse proxy) is configured — bearer tokens are transmitted over the WebSocket connection.` Docker design addresses TLS via reverse proxy.

### Remote mode

Remote mode is controlled by the `ENDO_GATEWAY` environment variable:

```js
const allowRemote = env.ENDO_GATEWAY === 'remote';
```

| Configuration | Mode | Auth |
|---|---|---|
| `ENDO_GATEWAY` unset or `local` (default) | Local | Localhost IP check |
| `ENDO_GATEWAY=remote` | Remote | Bearer token via CapTP |

Remote mode must be set explicitly alongside `ENDO_ADDR`. Binding to `0.0.0.0` without `ENDO_GATEWAY=remote` will accept connections on all interfaces but still reject non-localhost IPs — the operator must opt in to remote access.

`ENDO_GATEWAY_ALLOWED_CIDRS` can also be used to allow specific IP ranges without fully disabling the address check.

### Rate limiting

Failed `fetch()` attempts are rate-limited per IP to prevent online brute force. The state per IP is a single value: the earliest `Date.now()` at which the next fetch attempt will be accepted.

- **Rate:** 1-second penalty per failed attempt per IP, accruing.
- On a fetch attempt: if `Date.now() < nextAllowedTime`, reject with `"Rate limited"`.
- On a failed fetch: advance `nextAllowedTime` by 1 second from whichever is later — the current deadline or now. Consecutive failures stack: 2 rapid failures impose a 2-second wait, 10 impose 10 seconds, etc.
- On a successful fetch: no state change.
- **Collection:** An entry is stale 10 seconds after the last failure (10× the penalty interval). Stale entries are collected via lazy sweep on subsequent `check()` calls.

Only failed attempts impose a penalty. Successful fetches don't affect rate limit state.

### TLS warning

When remote mode is active, the gateway logs a warning at startup:

```
[Gateway] Remote mode active. Ensure TLS termination (reverse proxy)
is configured — bearer tokens are transmitted over the WebSocket connection.
```

The Docker design addresses TLS termination via reverse proxy.

Source: [designs/gateway-bearer-token-auth.md](https://github.com/endojs/endo-but-for-bots/blob/069d5ecbf79d90409069cfe72ed0c54e79c7bc77/designs/gateway-bearer-token-auth.md) at commit `069d5ecb` on branch `llm`.
