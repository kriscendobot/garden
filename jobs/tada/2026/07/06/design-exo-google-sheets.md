Inbox is empty; the job is complete.

## Completion report: design-exo-google-sheets

**What I did.** Expanded the maintainer's prompt (garden issue #25) into a full design document for a Google Sheets connector and opened draft PR **endojs/endo-but-for-bots#612** (`design/exo-google-sheets` → `llm`), per the designer role's roadmap-branch default.

**The design** (`designs/exo-google-sheets.md`, slug `exo-google-sheets`):
- Two packages mirroring the `@endo/exo-zip` / `@endo/zip` precedent: a plain, portable `@endo/google-sheets` REST client that takes an injected fetch power, wrapped by `@endo/exo-google-sheets`, whose primary surface is passable facets over CapTP (hence the `exo-` prefix).
- Three facets per spreadsheet with hidden-facet attenuation per `daemon-mount-capabilities`: read-only `Spreadsheet` (default grant), read-write `SpreadsheetWriter` (separate grant; `readOnly()` narrows, nothing widens), and a host-only `SpreadsheetControl` caretaker (allowed tabs, read-only brake, throttle, revoke). Tab-scoped attenuation via `sheet(title)`, with A1 ranges treated as confined selectors, not authorities.
- Credential handling builds on, and does not reinvent, `endoclaw-oauth` over `endoclaw-network-fetch`: the injected fetch power is the `OAuth` exo's fetch, so neither new package ever touches a token. The distinct `endopi-provider-registry-and-oauth` and `gateway-oauth-bonding` designs are explicitly disambiguated.
- Cell values map to copyable scalars (`UNFORMATTED_VALUE`, serial-date helpers), batched reads/writes are first-class, an in-exo token-bucket throttle governs quota, and quota errors surface as structured copyable errors. Change notification is a polling `follow()` async iterator first, with Drive push channels deferred behind the same contract until `endoclaw-webhooks` lands.
- Five open questions left for maintainer disposition (structural `batchUpdate` scope, push-notification design home, a wider `SheetsService`, record-writing sugar, OAuth-flow UX ownership), plus five phases of which 1-2 are unblocked today against a stub fetch power.

**README sync.** `designs/README.md` updated per the repo convention: summary-table row, Milestone 7 (Weblets and Integrations) bucket row and count (11 → 12), dependency graph (`eoauth --> esheets`), per-design estimate (M, 4-5 days), total-remaining count (57 → 58), recently-added entry, and the last-updated line.

**Reporting.** Posted the requested reply on kriskowal/garden#25 naming the slug and PR ([comment](https://github.com/kriskowal/garden/issues/25#issuecomment-4892456924)); the issue is left open for the submitter. A journal `result` entry is pushed to `journal2`.

**Follow-ups.** Maintainer review of PR #612 and disposition of the five open questions; implementation (Phases 1-2) would be a separate builder job; Phase 5 (push notifications) is a design to be filed once `endoclaw-webhooks` exists.

Self-improvement: `roles/COMMON.md` § Writing an entry points at `garden/skills/journal-sync/SKILL.md`, which does not exist in the v2 library (only `journalism` does); worth a liaison pass to repoint the reference.
