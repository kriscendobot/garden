Completion report:

## Job `design-refine-endoclaw-oauth-foundation` — complete

**What I did.** Refined `designs/endoclaw-oauth.md` in endojs/endo-but-for-bots (design slug `endoclaw-oauth`, branch `design/endoclaw-oauth-foundation`) so it stands as the credential foundation for the domain connectors that ride it, per @kriskowal's review of PR #612. Opened **draft PR #621** against `llm` (https://github.com/endojs/endo-but-for-bots/pull/621) and posted a cross-link comment on #612 under the repo's standing authorization; both artifacts are journaled in a `result` entry.

**First-mint flow settled** (the core ask):
- The **host** runs the flow; the default is **authorization-code with PKCE against a loopback redirect** (RFC 8252 § 7.3, system browser, never an embedded webview), reusing the mint plumbing already decided in `endopi-provider-registry-and-oauth` (Familiar pane in Electron, `127.0.0.1` listener in the daemon-only build).
- The **device-code grant (RFC 8628) is a per-provider-profile alternative**, not the default. The decisive fact: Google's device flow supports only a small scope allowlist that excludes the Sheets, Gmail, and Calendar scopes, so the founding Google connectors can only mint over the redirect flow.
- Configurable via a durable provider-profile record; **fully hidden from connectors**, stated as an explicit invariant that #612's Resolved Question 5 defers to.

**Surface confirmed and gaps closed.** The token record is split from facets (`OAuthTokenControl` mints `OAuth`/`OAuthControl` pairs) so one consent backs several base URLs, closing the gap where `SheetsService` needs both the Drive and Sheets hosts and the Gmail/Calendar siblings share the same credential. `setScopes` is removed (scopes are mint-time consent; narrowing is `setAllowedPaths`/`setReadOnly`, widening is an incremental-auth re-mint). Auth-layer errors are structured and separable from pass-through provider errors, path-pattern semantics and header hygiene are pinned, refresh is single-flight on the token, and revocation is split facet-vs-provider (RFC 7009 § 2). A new **Connector Contract** section enumerates the six guarantees connector designs may reference. One deferral noted: `Response.bytes()` for binary media, additive when needed.

**Open questions surfaced for the maintainer:** remote/headless-daemon redirect (gateway route once M5 public hosting lands, follow-up design to be filed) and OAuth client-id provisioning (per-host registration recommended for v1).

**README synced:** summary-table Updated date, recently-revised note, M7 per-design estimate bumped S-M 3 days → M 4-5 days (milestone week-range totals unchanged). Note: this PR's README edits will textually race #612's own README sync in the recently-revised list; whichever merges second needs a trivial weave.

Self-improvement: nothing this time.
