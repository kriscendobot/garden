---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-30T23:47:21Z
---
# Scholar cycle: ingest Tailscale OAuth-apps + author oauth-use-case-patterns skill

Job: `scholar-ingest-tailscale-oauth-apps-and-oauth-skills`. Two deliverables: a
library ingest (journal2) and a recognition-and-application skill (main2).

## Phase 1 — library ingest (journal2)

The named URL `https://tailscale.com/docs/features/oauth-apps` is the
authorization-code/user-identity half of Tailscale's OAuth surface; the job's
Phase-1 bullets (scoped clients, client-credentials grant, tag-to-capability,
short-lived tokens from a durable client) actually describe the sibling
`oauth-clients` page. To cover the model the job names faithfully, ingested
**both** sibling pages (within one cycle's budget: 2 web sources, 5 sections).
Both fetched `direct` via `fetch-source.sh`.

- **`web--tailscale-oauth-clients`** (sha256 `52287f51…`, 3 sections):
  - `--client-credentials-scopes-and-token-lifecycle` (client-credentials grant; scope-to-endpoint least-privilege map; durable client mints hourly access tokens; renewal via official libraries).
  - `--tags-as-capabilities-and-auth-key-minting` (tags name grantable device identities; `auth_keys` scope mints tag-owned auth keys; tag-owner indirection; `get-authkey`, `tailscale up --auth-key`).
  - `--client-setup-and-secret-lifecycle` (who may create and only with held scopes/tags; secret shown once; secure storage; tailnet-owned client outlives its creator; revocation not offboarding).
- **`web--tailscale-oauth-apps`** (sha256 `5049588b…`, 2 sections; alpha):
  - `--user-delegated-authorization-code-model` (RFC 6749 §4.1 on behalf of a user; user-attributed audit/quota; the explicit OAuth-apps-vs-OAuth-clients decision contrast).
  - `--requirements-and-limitations` (Owner/Admin + admin-scoped API token; single-tailnet boundary; non-customizable consent screen; device-provisioning guide).

New topic page **`oauth-credentials`** (OAuth 2.0 application-credential models;
5 sections). New concept page
**`oauth-client-credentials-vs-authorization-code`** with 17 keyword aliases in
`keywords.md`. Updated indexes: `sources/README.md` (+2 web rows),
`topics/README.md` (+1 Index row), `concepts/README.md` (+1 bullet),
`keywords.md` (+17 lines). All landed via `land-journal-edit.sh`.

Integrity gate (step 8): `library-link-check --source-slug` clean on both
clusters. `regenerate-topics-counts --check`: counts already current (the new
topic's 5 matched). Step 9: `regenerate-sections-index` landed the rebuilt flat
index; `regenerate-topics-counts` nothing to land.

## Phase 2 — skill (main2)

Authored **`skills/oauth-use-case-patterns/SKILL.md`** (committed `51698a16d`,
pushed `HEAD:main2`): a design-time identify-and-apply playbook. Identify signals
(program-not-person ongoing access, scoped-not-all-or-nothing, short-lived tokens
from a durable secret, user-attribution); the client-credentials-vs-
authorization-code grant-choice table; apply steps (least-privilege scope/tag
mapping, capture-secret-once, secure storage with live-read-over-file-baked,
mint/rotate short-lived tokens, revocation as retirement); failure modes
(over-broad scopes, leaked client secret, mishandled expiry, wrong grant,
forgotten identity dimension). Grounded in the just-ingested Tailscale model and
related to the garden's existing OAuth touchpoint (`designs/fleet-gh-identity.md`
live-read bot token) and plausible future ones (multibot tailnet node
provisioning via `auth_keys` clients; web-surface user-delegated OAuth).

A full skill was warranted (not a thin follow-on): the garden has a real current
touchpoint and concrete plausible future ones, and the Tailscale exemplar gives
the playbook substance.

## Follow-ons

None posted. The two pages cover the OAuth-apps/clients model completely; the
shared `oauth-clients` Scopes/Legacy-scopes sections merely redirect to a
trust-credentials page (a distinct future source, not part of this ask).

Self-improvement: the CLAUDE.md "Current inventory" skill list and the scholar
role's must-not-edit-skills bound mean a gardener authoring a new skill under an
explicit job cannot itself index it in the top-level inventory. Routed as a
self-improvement note to liaison to add the `oauth-use-case-patterns` row to
CLAUDE.md's skills inventory (a meta-doc edit reserved for the liaison).
