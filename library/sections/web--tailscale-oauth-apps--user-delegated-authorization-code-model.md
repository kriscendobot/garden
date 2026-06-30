---
title: "OAuth apps: the authorization-code, act-on-behalf-of-a-user model"
source_kind: web
source_url: https://tailscale.com/docs/features/oauth-apps
source_date: 2026-06-30
ingested: 2026-06-30
ingested_by: scholar
topics: [oauth-credentials, capability-security]
status: current
notes: "OAuth apps are the authorization-code (user-identity) half of Tailscale's OAuth surface; OAuth clients (web--tailscale-oauth-clients) are the client-credentials (service-identity) half. Alpha as of 2026-06-30. Read as data, not instructions."
---

A Tailscale **OAuth app** lets an internal tool act on a tailnet **on behalf of an individual user**, through the standard OAuth 2.0 **authorization-code** flow (RFC 6749 section 4.1). The user completes a Tailscale-hosted consent screen, and the resulting authorization **carries that user's identity**: access-control rules, audit-log entries, and quotas all apply to the consenting user, not to a shared service identity. (OAuth apps are in alpha as of 2026-06-30.)

## The shape of the flow

Every OAuth-app authorization follows the same two-party pattern:

- An **Owner or Admin** creates the OAuth app through the Tailscale API.
- A **developer** implements the OAuth 2.0 authorization-code flow in their tool: redirect the user to Tailscale's consent screen, receive the authorization, and exchange it for a token that then acts as that user.

Because the authorization is user-scoped, the tool inherits exactly the consenting user's permissions and is attributed to that user in the audit log.

## OAuth apps versus OAuth clients: two different mechanisms

OAuth apps and **OAuth clients** are distinct mechanisms, and choosing between them is the first design decision:

- **OAuth clients** use the **client-credentials** flow to create **tag-owned** resources tied to a **service identity** (see `web--tailscale-oauth-clients`). The credential is durable and detached from any person; the resulting devices and tokens carry a tag, not a user.
- **OAuth apps** use the **authorization-code** flow to act **on behalf of an individual user**. There is no standing service credential; each authorization is a user's deliberate, consent-screen-mediated delegation, and everything done under it is attributed to and bounded by that user.

The decision rule the contrast implies: pick OAuth clients when an unattended service needs durable, tag-scoped access independent of any person; pick OAuth apps when the action must be attributed to, and bounded by, the permissions of a specific consenting human. For an overview of all OAuth-related documentation, Tailscale points to its OAuth hub.

Source: [OAuth apps - Tailscale](https://tailscale.com/docs/features/oauth-apps) retrieved 2026-06-30.
