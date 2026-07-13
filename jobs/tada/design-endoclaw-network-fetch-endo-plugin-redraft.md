Inbox empty. The job is complete.

Completion report:

**Job:** design-endoclaw-network-fetch-endo-plugin-redraft (designer role, endojs/endo-but-for-bots)

**What I did.** Redrafted the M3 "confined outbound HTTP" exit-criterion capability's provisioning as an unconfined `@endo` plugin, aligned with the `@endo/reminder` pattern (design PR #682, implementation PR #721, both read from their branches since neither has merged to `llm` yet). Opened **draft PR #722** (`design/endo-fetch` -> `llm`): https://github.com/endojs/endo-but-for-bots/pull/722. Design slug: **endo-fetch**.

**What changed** (one commit, 5 files, +448/-43):

- `designs/endo-fetch.md` (new): `@endo/fetch`, an unconfined plugin exporting `make(powers, context, { env })`, provisioned via the generic `makeUnconfined` pathway. It composes the already-landed `makeHttpClientAndControl` (#566) rather than re-implementing anything; the returned `FetchService` hands out `client()` / `control()` facets mirroring `ReminderService`. Durable policy plus trust-on-first-bind pins live in a VFS store (`config.json` + `bindings.json`, write-then-move store contract); restart revival is integration-owned `@pins` retention; a small `initialBindings`/`onPolicyChange` persistence seam is specified for `@endo/exo-http-client` because request-time TOFU pins are invisible to any control-facet wrapper. Three implementation phases, 12 design decisions, 2 open questions for the maintainer (package name; policy-authority re-resolution). Mermaid sequence diagram validated by parse (`OK sequence`).
- `designs/endoclaw-network-fetch.md`: marked Superseded by endo-fetch (capability-shape sections remain normative by reference), mirroring the endoclaw-timer treatment in #682.
- `designs/cli-http-client.md`: partial-supersession note (formula-pair packaging superseded; facet split, SSRF defenses, and the `endo http` verb tree carry forward as the eventual user surface).
- `designs/daemon-agent-tools.md`: Phase 3.6 split — the `provideHttpClient`/#286 daemon-formula reconciliation item struck as superseded, the `makeHttpTool` binding retained; the § Granting network-tier paragraph rewritten to the plugin provisioning.
- `designs/README.md`: full plan sync — narrative header, summary-table rows (network-fetch superseded, endo-fetch added, daemon-agent-tools/cli-http-client Updated dates), totals recount (146 designs, 3 Superseded), dependency-graph node rename (`enetfetch` -> `efetch`, edge to `eoauth` kept), M3 capability and Strategic-Early rows, M3 bucket list, per-design estimates. All three README mermaid fences re-validated (`OK flowchart-v2`, `OK gantt`).

**Verification:** mermaid parse validation ran with real output cited above (fetch-1 OK sequence, readme-1 OK flowchart-v2, readme-2 OK gantt); linked-file check ran (all relative links resolve on the branch except `endo-reminder.md`, expected). No code was built; this is a design-only PR, so no test-suite claims are made.

**Follow-ups:**
- Links to `designs/endo-reminder.md` are forward references until PR #682 merges; the README edits will need a trivial rebase against #682's edits of the same M3 rows (flagged in the PR body — a weaver job once either merges).
- The build of `@endo/fetch` (Phases 1-3) is a separate builder job once the maintainer reviews; open questions on package naming and policy-authority resolution await maintainer answers on #722.

Self-improvement: nothing this time.
