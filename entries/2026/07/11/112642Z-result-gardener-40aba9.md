---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-11T11:26:43Z
---
---
role: scholar
job: scholar-ingest-source-habitat-chronicles-4
---

# Ingested: The Tripartite Identity Pattern (habitat-chronicles.com, Randy Farmer, 2008)

Fourth habitat-chronicles.com ingest. One web-essay source, 5 sections, one new
topic, one new concept.

## Source ingested

- **The Tripartite Identity Pattern** — https://habitat-chronicles.com/2008/10/the-tripartite-identity-pattern/
  (`source_kind: web-essay`, Randy Farmer, 2008-10-17). Fetched live via
  `fetch-source.sh` (`source_fetched_via=direct`); idempotency anchor
  `source_content_sha256=c2c4d696…`. 5 sections:
  - `--overview` (the problem: conflated identifier roles + engineering/user
    conjoining discourage participation; Yahoo! e-mail-farming datum; the
    three-component thesis) — topics identity, capability-security
  - `--account-identifier` (permanent, inert, random DB key with no inherent
    public capabilities — POLA applied to identity) — identity, capability-security
  - `--login-identifier` (name/password or federated **capability-based logins**:
    OpenID / OAuth / Facebook Connect; four separation payoffs) — identity,
    oauth-credentials, capability-security
  - `--public-identifier` (non-unique, compound, mutable, context-plural social
    face) — identity
  - `--iiw-critiques-and-scope` (2008-11-12 IIW update: no public identifier for
    session auth; RP sees only Public ID + **permission-bound session key**; local
    not global; capability-based identifiers out of scope) — identity, capability-security

## New taxonomy

- **New topic `identity`** — identity-decomposition into separable identifiers;
  keystone is Farmer's tripartite pattern. Added to `topics/README.md` (count 5).
  Distinct from capability-security (practice) and capability-theory (papers).
- **New concept `tripartite-identity`** — cross-links `object-capability`,
  `confused-deputy`, `delegates-and-epithets`, and the sibling `habitat-unum`,
  per the job's cross-link ask. 16 keyword aliases added to `keywords.md`.

## Existing pages touched

- `topics/capability-security.md`: +4 section rows (277 total).
- `topics/oauth-credentials.md`: +1 section row (login-identifier; 6 total).
- `concepts/object-capability.md`: +2 "touches" rows (account-identifier =
  identity-layer Property D; login-identifier = capability-based logins).
- `sources/README.md`, `topics/README.md`, `concepts/README.md`: index rows added.

## Follow-on

- Posted **`scholar-ingest-source-habitat-chronicles-5`** for the remaining germane
  post (**Adventures in LLM Land**, the dense 2026 AI-revolution essay), with a
  note that the chain ends there if nothing germane remains after it.

## Integrity gate (step 8)

- `library-slug-prefix-check.sh --changed`: OK (`habitat-chronicles` prefix matches
  the host's established siblings).
- `library-link-check.sh --changed`: OK — every section-table target and
  sections/README row resolves to a committed file.
- `regenerate-topics-counts.sh --check`: stale (informational; reconciled by --land).
- Final landing step: `regenerate-sections-index.sh` and
  `regenerate-topics-counts.sh` both landed then re-ran idempotent (nothing to
  land). identity=5, capability-security=277, oauth-credentials=6 confirmed at
  origin/journal2 tip.

All 15 content files + the two regenerated indexes landed via
`land-journal-edit.sh` to origin/journal2.
