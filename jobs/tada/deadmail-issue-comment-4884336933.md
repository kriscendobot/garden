Inbox empty. This was an issue-reply job (no garden code to change), so no commit/push to `main2` was needed.

## Completion report

**Job:** Dead-lettered issue-inbox message for `issue-kriskowal-garden-25` (kriskowal/garden #25, "SheetSync"). The addressee had already completed, so I picked up its intent: fold the new maintainer activity into the work and reply on the issue thread.

**Context:** The dead-letter pointed at the "Poke" comment (already answered by a prior full SheetSync/Endo ocap sketch). The genuinely-unanswered item on the thread was a newer comment from maintainer **dckc**: *"@kriscendobot re google sheets connector, what do you think of `makeSheetsORM` in dckc/finquick/…/sheetsAccess.js"*.

**What I did:**
- Fetched and read `makeSheetsORM` from `dckc/finquick` (`packages/lm-sync/src/sheetsAccess.js`) plus the prior thread and my earlier ocap sketch for consistency.
- Posted a substantive reply as **kriscendobot** (the identity dckc addressed; confirmed `gh` auths as kriscendobot on this host): https://github.com/kriskowal/garden/issues/25#issuecomment-4887010875

**Reply substance:** `makeSheetsORM` is the concrete realization of the `sheet` connector facet from the earlier sketch — already ocap-shaped (returns a frozen method object closing over the credential-bearing `doc`; hardcoded table map = attenuation to three worksheets). Endo delta to make it a real endowment: (1) `harden` rather than shallow `Object.freeze`; (2) mint per-table/range facets rather than per-spreadsheet (POLA); (3) keep the authenticated `doc` inside the connector so it never crosses to the sync guest. Plus three code-level notes: `lookup().update()` never `.save()`s (possible silent no-op), `lookup` throws a bare string instead of an `Error`, and the `provide` cache never invalidates.

**Did not** close the issue (submitter's job) and used the issue thread for maintainer comms, per garden norms.

**Follow-ups:** None required. If dckc wants it pursued, the natural next step remains a `scholar-ingest-source` job over the Plaid/Endo-powerbox docs to seed the connector caplets (as noted in the prior comment).
