---
tier: mentat
dispatch: manual
---
role: designer
handler-timeout: 14339

# Pivot `endo adopt-locator` into `endo store --locator`, and make "locator" mean any capability URL (with an https fragment encoding)

Repo: endojs/endo-but-for-bots (and dependents in kriscendobot/minion.town and kriscendobot/garden demo material). Requested by the maintainer (liaison session, endolin-garden2, 2026-09-28 ~20:45Z).

**Context:** open draft https://github.com/endojs/endo-but-for-bots/pull/1333 (head build/guest-locator-adoption, pinned base job-federation-nonce-f9cbcfc) adds `endo adopt-locator <name> [--file] [--as]`, which is stage 1 of the #1332 federation plan. Its daemon work (`EndoHost.adoptFromLocator` strictness, well-known-first endpoint locator, `isLocalNode`) stays valuable. The CLI shape changes.

**The maintainer's direction:**

1. **Fold adoption into the existing `store` verb:** `endo store --locator <locator> --name <name>`. Drop the separate `adopt-locator` command. Keep #1333's safety properties:
   - the bearer is readable from stdin/`--file` so it stays out of shell history and `ps`, so decide how `--locator` accepts stdin, for example `--locator -`;
   - resolve before committing the pet name;
   - redacted errors, and no route redirection by a tampered locator.
   Check how this composes with `store`'s existing flags and with the daemon's `storeLocator`/`adoptFromLocator` surfaces, and unify rather than duplicate.
2. **Propagate the ramifications to the Chat application.** It has command-executor and locate/storeLocator paths; see https://github.com/endojs/endo-but-for-bots/pull/152 for prior art. Chat should accept a locator wherever the CLI does, with the same semantics.
3. **"Locator" means any capability URL:**
   - an `endo://` URL is obviously a locator;
   - ANY `https://` URL is potentially a locator, with all the locator information carried only in the fragment (after `#`), so end users can pass ordinary https://minion.town links around;
   - the existing version key `v` (currently 1) must be sufficient to tell a locator URL from a non-locator URL: an https URL whose fragment parses with a recognized `v` is a locator, and otherwise it is not.
4. **Propose a URL scheme** in which ALL information of an Endo locator is captured in a query-string-shaped fragment under `#`. That covers:
   - the agent/node key;
   - the formula number;
   - the connection hints (possibly several, of different transports);
   - `type`;
   - the version;
   - any other field the current `endo://…@<encodeURIComponent(ocapn+noise+tcp://…)>?type=guest` form carries.
   Specify:
   - exact field names and encodings, and a canonical form so equal locators have one serialization;
   - how multiple hints are represented, for example repeated keys;
   - percent-encoding rules;
   - the lossless round-trip between the `endo://` form and the `https://…#…` form;
   - what the https origin/path means (nothing semantically, and whether it may serve as a default hint or a landing page);
   - how a non-Endo https URL with an unrelated fragment is rejected;
   - version-evolution rules;
   - security: fragments are not sent to servers (a bearer benefit), but they leak through referrers, history, clipboard and screenshots, so give guidance and UI affordances, and warn about phishing via look-alike origins since the origin carries no authority.

**Deliver:**
- **A design doc** in `designs/` on endojs/endo-but-for-bots covering 1 to 4, with worked examples (the #1333 guest locator in both forms, a multi-hint locator, and a minion.town share link). Include a parser/serializer API sketch, for example `parseLocator(url)` returning locator-or-undefined and `formatLocator(locator, { base: 'https://minion.town/' })`, and a `## Open questions` section for real forks (for example whether the https origin may contribute a hint). Open it as its own draft PR for the maintainer's review.
- **The implementation pivot:** rework #1333 (same branch, or a successor PR that supersedes it; state which) to `endo store --locator … --name …`, with the locator parser accepting both `endo://` and the proposed https-fragment form behind that single parser. Include tests: round-trip, canonical form, rejection of non-locator https URLs and of unknown `v`, and CLI stdin handling. Update the Chat app accordingly, with tests. If you judge the https form should wait for design sign-off, implement `endo://` fully, keep the https path behind the parser with tests, and say so.
- **Dependents:** find and update the demos and docs that use `adopt-locator`, for example kriscendobot/minion.town#117 (guest locator reveal and federation wiring), the verify-demo1/demo2 instruction work, garden issue 114 demo material, and the help text (`help.md`, `help-text-data.js`). minion.town should present share links in the https-fragment form once the design is accepted. Propose those changes as draft PRs or PR updates, and don't deploy anything.
- Leave every PR as a draft for the maintainer's gauntlet. Report every PR touched.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-28T21:23:05Z -->
