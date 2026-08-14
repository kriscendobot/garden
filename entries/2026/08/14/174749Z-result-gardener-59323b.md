---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-14T17:47:51Z
---
Completed `scholar-ingest-opensandbox-remainder`.

Sources ingested:
- `README.md` at file commit `7166129aa7a00c49021fcf8409019ace2b6d1c30`: 3 sections.
- `docs/guides/multi-tenancy.md` at file commit `138ce5cb3bac6f3bb9dfcce3f72382b372c4cdd5`: 3 sections.
- `docs/guides/credential-vault.md` at file commit `e52d1d498e57b84b24b7a711eb2d40e18e65ef75`: 4 sections.
- `docs/guides/secure-access.md` at file commit `918dea19e399aea5a1ee56070c273a6b22ec0c89`: 3 sections.
- `docs/components/execd.md` at file commit `7b969bd64935682895e077342b42007b68490585`: 4 sections.

Indexes touched: `sources/README.md`; topics `sandbox-platforms`, `capability-security`, `compartments`, `multi-tenant-platform`, `networking`, and `tooling`; concept `opensandbox`; `concepts/README.md` unchanged because the concept already existed; `keywords.md` expanded with MCP, Credential Vault, Secure Access, and multi-tenancy aliases. Regenerated `sections/README.md` and topic counts after all content landed.

Authority comparison: the new sections distinguish OpenSandbox's bearer keys, namespace/RBAC routing, proxy request matching, Linux identities, path allowlists, and OS namespaces from Endo's non-discretionary object-reference authority. OpenSandbox remains a complementary outer process boundary rather than an SES, XS/xsnap, or object-capability substitute.

Integrity: all five source-cluster link checks pass from a fresh `origin/journal2` staging clone; the topic-count generator reports current; 17 new section files are present. No remainder or follow-on job.

Self-improvement: none.
