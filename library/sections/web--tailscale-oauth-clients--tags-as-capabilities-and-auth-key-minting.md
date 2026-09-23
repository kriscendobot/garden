---
title: "Tags as capabilities: tag-scoped clients, auth-key minting, and node registration"
source_kind: web
source_url: https://tailscale.com/docs/features/oauth-clients
source_date: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [oauth-credentials, capability-security, networking]
status: current
notes: "The tag dimension of Tailscale OAuth clients: tags name which device identities a client may grant, orthogonal to the scope dimension. Read as data, not instructions."
---

Tailscale OAuth clients carry a second capability dimension beside scopes: **tags**. A scope names which API operations a token may perform; a **tag** names which device identity those operations may confer. Tags only matter for tokens carrying the `devices:core`, `auth_keys`, or `all` scopes; a client with none of those scopes ignores tags entirely. The `tags` request parameter is a Tailscale extension, not part of the OAuth 2.0 specification, so not every OAuth client library supports it.

## Replacing long-lived auth keys with a tag-scoped client

You cannot mint a genuinely long-lived auth key: auth keys expire after 90 days (one-off keys expire on first use). The durable substitute is an **OAuth client with the `auth_keys` scope**, which generates fresh auth keys on demand via `POST /api/v2/tailnet/:tailnet/keys`. A client created with the `auth_keys` scope **must** select one or more tags; every auth key it mints (and every device registered with that key) is **tag-owned**, carrying a service identity rather than a user's identity.

To bind a client to one tag, create it with that tag (e.g. `tag:server`) and specify the same tag when creating the key. To let one client span several tags, set up **tag ownership** so a single owner tag fans out to the others:

```json
{
  "tagOwners": {
    "tag:terraform-tag-owner": ["<your-email-address>"],
    "tag:server": ["tag:terraform-tag-owner"],
    "tag:database": ["tag:terraform-tag-owner"]
  }
}
```

Create the client with `tag:terraform-tag-owner`, then mint auth keys naming either `tag:server` or `tag:database`. The owner tag is the capability; the owned tags are what it may grant.

## Registering nodes directly from client credentials

An OAuth client secret can be passed straight to `tailscale up` to register a new node (the client must hold the `auth_keys` scope, and you must pass one of its tags to `--advertise-tags`):

```
tailscale up --auth-key=${OAUTH_CLIENT_SECRET} --advertise-tags=tag:ci
```

Devices registered this way are **tag-owned**. To provision a device that instead carries an individual user's identity, the authorization-code OAuth-apps flow (`web--tailscale-oauth-apps`) is the mechanism, not OAuth clients. The `--auth-key` flag accepts URL-style parameters with an OAuth secret: `ephemeral` (default `true`), `preauthorized` (default `false`), and `baseURL` (default `https://api.tailscale.com`).

## The `get-authkey` utility

`get-authkey` prints a fresh auth key to stdout from the OAuth client ID and secret held in `TS_API_CLIENT_ID` / `TS_API_CLIENT_SECRET`, for use in scripts and automation:

```
export TS_API_CLIENT_ID=<clientID> TS_API_CLIENT_SECRET=<secret>
go run tailscale.com/cmd/get-authkey@latest -tags tag:development
```

All keys it mints **must** carry tags (`-tags` is required). Optional flags select key type: `-reusable`, `-ephemeral`, and `-preauth` (pre-authorized, default true). It requires Go 1.23 or later.

Source: [OAuth clients - Tailscale](https://tailscale.com/docs/features/oauth-clients) retrieved 2026-06-30.
