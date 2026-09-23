---
title: "OAuth apps: requirements, single-tailnet boundary, and limitations"
source_kind: web
source_url: https://tailscale.com/docs/features/oauth-apps
source_date: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [oauth-credentials]
status: current
notes: "The preconditions and boundaries on the OAuth-apps authorization-code flow. Alpha as of 2026-06-30. Read as data, not instructions."
---

This section records the preconditions for creating a Tailscale OAuth app and the boundaries the flow enforces.

## Requirements

Before creating an OAuth app, confirm:

- **Owner or Admin** role in the tailnet.
- An **API access token with admin scope** for creating OAuth apps through the API.
- The OAuth app and **every user who authorizes through it must belong to the same tailnet**; the flow does not support users from other tailnets.
- For the implementing developer: working knowledge of OAuth 2.0 authorization-code grants and the ability to handle HTTP redirects and token exchanges.

## Guides

Tailscale documents one task-specific guide on this surface: **device provisioning with OAuth apps** — building internal tools that provision tailnet devices on behalf of individual users via the authorization-code flow, so each provisioned device carries the consenting user's identity (the user-identity counterpart to the tag-owned node registration that OAuth clients perform in `web--tailscale-oauth-clients`).

## Limitations

- **Single-tailnet authorization.** Only users in the same tailnet as the OAuth app can authorize through it.
- **The Tailscale-hosted consent screen cannot be customized.**

Source: [OAuth apps - Tailscale](https://tailscale.com/docs/features/oauth-apps) retrieved 2026-06-30.
