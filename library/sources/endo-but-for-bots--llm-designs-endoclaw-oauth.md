---
title: "endoclaw-oauth — OAuth/Credential Capability that the agent never sees; tenth member of the endoclaw cluster"
source-slug: endo-but-for-bots--llm-designs-endoclaw-oauth
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-oauth.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-oauth.md
total-lines: 99
status: Not Started (Parent: endoclaw)
ingest-cycle: 234
ingest-date: 2026-06-08
lane: designs
---

# endoclaw-oauth

A 99-line **Not Started** design. The §tenth-member of the endoclaw cluster. An `OAuth` capability lets an agent make authenticated HTTP requests to a third-party API without ever seeing the credential.

## Key design moves

- **§The-agent-never-sees-the-token** as §the-canonical-ocap-pattern (authority-to-use, not authority-to-delegate-outside-the-capability-graph).
- **§Two-facet-control-pair** consistent with cycle 226's canonical template (OAuth + OAuthControl).
- **§Four-named-control-methods** + revoke + help.
- **§Path-restrictions-structural-confinement** — `setAllowedPaths(['/gmail/v1/...'])` so an agent with Gmail read access cannot call the Calendar API on the same Google domain.
- **§Two-layer-confinement** (baseUrl scope + path allowlist within scope).
- **§Read-only-mode** boolean toggle restricting to GET/HEAD; §sibling to cycle 226 endoclaw-browser's setReadOnly.
- **§Six-step-OAuth-flow** with §step-5-as-five-substep-internal-flow (prepend + validate + check + inject + make).
- **§Token-refresh-handled-transparently-by-the-exo** + §explicit-control-via-control-facet-method.
- **§Caretaker-revocation** with §two-layered-revocation (local invalidation + optionally remote provider-side).
- **§Built-on-endoclaw-network-fetch** — §a-higher-level-capability-is-a-wrapper-around-a-lower-level-capability.
- **§Use-Cases-section** with §enumerate-concrete-use-cases-and-then-generalize (Gmail + Calendar + Notion + Todoist + Any OAuth2-compatible API).

## Section files

- [§the-agent-never-sees-the-token + §authority-to-use-not-authority-to-delegate + §path-restrictions-structural + §read-only-mode + §tenth-member-of-endoclaw-cluster](../sections/endo-but-for-bots--llm-designs-endoclaw-oauth--the-agent-never-sees-the-token-and-authority-to-use-not-authority-to-delegate-and-path-restrictions-structural-and-read-only-mode-and-tenth-member-of-endoclaw-cluster.md) — full design ingest.

## Ingest scope

Cycle 234 (designs-lane): full 99-line ingest. §The-tenth-member of the endoclaw cluster (extending cycle 232's nine to ten). §Twenty-seventh-honest-design-evolution-record family member (§reinforcing cycle 232's later-member-of-an-established-cluster-template shape rather than introducing a new one).
