role: designer

# Design: `@endo/exo-google-sheets` — a Google Sheets connector

**Repo:** `endojs/endo-but-for-bots` · **Roadmap branch:** `llm` (designs land as a
draft PR against `llm` per `roles/designer/AGENT.md` § Operating norms).

Expand this into a full design document at `designs/exo-google-sheets.md` (slug
`exo-google-sheets`) and open a **draft** PR against `llm`, per the designer role's
default. Sync `designs/README.md` (summary table, milestone bucket, recently-added
entry, last-updated line) as the repo conventions require.

## Prompt

Propose a design for a **Google Sheets connector**, `@endo/exo-google-sheets` — an
Exo that presents a Google Sheets spreadsheet (or the Sheets API surface) as a
passable capability an agent can call over CapTP without ever seeing the OAuth
credential. Consider whether it is **backed by a lower-level `@endo/google-sheets`
package** (a plain, non-CapTP Sheets API client library) that the `exo-` package
wraps and hardens — mirroring the `@endo/exo-zip` shape (`@endo/exo-zip` wraps
`@endo/zip`). The `exo-` prefix is correct here because the package's primary
surface is a passable interface exchanged over CapTP (`roles/designer/AGENT.md`
§ `exo-` package-name prefix).

Design questions the document should settle or surface as open questions:
- The capability shape: what methods does the Sheets Exo expose (read range,
  write range, append row, list sheets, watch for changes)? How do cell values,
  ranges (A1 notation), and structured records map onto passable values?
- Read-only vs read-write facets, and whether write access is a separate,
  narrower capability (hidden-facet attenuation, as `daemon-mount` does).
- **Credential handling:** the host performs the OAuth flow and injects the token;
  the agent calls `E(sheet).getRange(...)` and the credential is structurally
  inaccessible. This is exactly the [`endoclaw-oauth`](endoclaw-oauth.md) `OAuth`
  capability pattern (its own example is `E(gmail).fetch('/messages')`), layered
  on the [`endoclaw-network-fetch`](endoclaw-network-fetch.md) `HttpClient`
  allowlist substrate. Name that dependency explicitly rather than reinventing it.
- Where the connector sits: is it a daemon capability (like `daemon-mount`), a
  weblet/integration under **Milestone 7 (Weblets and Integrations)** — whose goal
  is literally "OAuth-based external service integrations" — or a standalone
  library consumed by both? Place the design in the right roadmap milestone.
- Change notification / polling vs webhooks (the Sheets API push model).
- Rate limiting, batching (batchUpdate), and error/quota surfacing over CapTP.

## Library and project references

Consult these before drafting (the floor, not the ceiling; run library-lookup for
the rest). No existing Google-Sheets or spreadsheet design exists on `llm` as of
2026-07-06 — this is new — but the connector pattern is well-precedented:

- [`endoclaw-oauth`](endoclaw-oauth.md) — the `OAuth` / credential-capability
  pattern: host holds the token, agent gets a proxy Exo, credential structurally
  inaccessible. The canonical prior art for a third-party-API connector. **Build on
  this; do not reinvent the credential-injection mechanism.**
- [`endoclaw-network-fetch`](endoclaw-network-fetch.md) — the `HttpClient`
  origin-allowlist substrate the OAuth capability and "all external integrations"
  are founded on. A Sheets connector's outbound HTTP should ride this.
- [`exo-zip-package`](exo-zip-package.md) — the naming and shape precedent for an
  `@endo/exo-<thing>` package that wraps a plain backing library (`@endo/zip`) and
  presents it as a passable Exo tree over CapTP. Directly analogous to
  `@endo/exo-google-sheets` backed by `@endo/google-sheets`.
- [`daemon-mount-capabilities`](daemon-mount-capabilities.md) — hidden-Exo-facet
  attenuation and read-only vs read-write facet split; a model for narrowing the
  Sheets write capability.
- **Roadmap Milestone 7 (Weblets and Integrations)** in `designs/README.md` —
  "OAuth-based external service integrations"; the likely home milestone.
- Related gaps to cross-reference, not duplicate: `endopi-provider-registry-and-oauth`
  (LLM-provider OAuth) and the `gateway-oauth-bonding` gap (bonding an OAuth
  identity to a public-key identity) are **distinct** from an agent-uses-a-service
  connector; note the distinction so the reader is not confused.
- Garden skill [`oauth-use-case-patterns`](../../skills/oauth-use-case-patterns/SKILL.md)
  in the garden library, if the designer needs OAuth-flow shape guidance.

## Reporting back to the maintainer

This design was requested by a maintainer comment on the garden's own issue #25.
When the draft PR is open, **post a reply comment on the issue thread** naming the
design slug and the PR number so the requester can follow it. Never close the
issue — the submitter does that.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-25
issue_url: https://github.com/kriskowal/garden/issues/25#issuecomment-4889651367
submitter: kriskowal
----- END ISSUE NOTE -----
