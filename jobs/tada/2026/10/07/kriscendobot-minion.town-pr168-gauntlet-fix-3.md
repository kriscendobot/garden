Fix round 3 is done for kriscendobot/minion.town#168, the design PR `designs/guest-oauth-bonds.md`. I pushed one follow-up commit (`583e879` → `13402a5`) to `design/guest-oauth-bonds` with `safe-push-pr-head.sh`. CI finished green (3/3 checks) and `ci-wait-merge.sh --no-merge` returned 0.

Here is how the commit answers the must-fix items from the three request-changes reviewers (critic, skeptic and copyeditor):

- **§ 6.3, sign-out after removing the sign-in that recovered this browser (critic 1, skeptic 5):**
  - It now reuses the sign-out URL that `shell.html` and `index.html` already use. The two allowlist entries that redirect chain needs already exist, and the section names both: the Cognito domain in oauth2-proxy's `whitelist_domains`, and `logout_uri=https://minion.town/`, which is the guest page.
  - The build must reuse that URL exactly. A failed sign-out is harmless because the sign-in is already gone: the user sees Cognito's error page and Back returns to the guest page.
  - The dialog copy is softer.
  - It now describes what happens when the `sessionStorage` marker is lost, and the manual browser check covers that case.
- **§ 5, rate limits and the origin check (critic 2, skeptic 4):**
  - Every limit is keyed on the bearer's fingerprint, which exists before the first sign-in. The counters are DynamoDB items with a TTL, so all app processes share them and they survive a deploy or restart.
  - It now states that every call is a same-origin `fetch` from the page, and that Caddy passes `Origin` through unchanged.
- **§ 3, migration (critic 3, skeptic 3):**
  - The script now checks that every stored ciphertext decrypts under the current `recoveryKey`. A row that fails is quarantined. That rules out an earlier key rotation having split one guest across two fingerprints, so merging rows by fingerprint is safe.
  - It also lays out a cutover order with no race. Deploy first; after that, only the new schema is written and recovery falls back to the legacy row. Then run the script, which skips identities that already have a new record, and re-run it until nothing is left to migrate.
- **§ 4, removal by whoever holds the bearer (skeptic 1–2, critic 4):**
  - A guest with no sign-ins lists `[]`, and its account record is created on the first add.
  - Sign-ins follow the guest's identifier, so a future identifier rotation must move them too.
  - It now states the worst case: a thief adds their own sign-in and removes the owner's. It labels "no way to evict a thief" as a known limitation.
  - The audit event is now described as a record nothing reads yet, not as a mitigation.
- **Copyedits (copyeditor 1–5):** fixed in §§ 1, 6.2, 6.3, 7 and 8.

I also took some cheaper non-blocking suggestions:

- Older sign-ins are labeled by a short suffix of their `signInId`, which stays fixed when other rows are removed, instead of "1 of 2".
- `fingerprintKey` becomes its own config value in this build rather than at the first key rotation.
- The `mcpReachesBearerGuest` deployment flag is gone. `guest.html` is a static file, so the "MCP is separate" paragraph is now checked against what the code actually does (test 7).
- New tests cover a guest with no sign-ins, two first adds at once, rate limiting (`429`), the decryption check during migration, and skipping identities that already have new records.

Not addressed are the novice seat's suggestions for a glossary and a background section, and the ergonomist's notes on focus handling and where the section sits on the page. All were comment-only. The panel was not re-run; the gauntlet driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr168-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1381663 cached reads)
- Output: 20815 tokens
- Cost: $1.3815206000000004
- Wall-clock: 493s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
