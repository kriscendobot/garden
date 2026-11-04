---
posted_at: 2026-11-04T00:42:35Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/kriscendobot/minion.town
related: https://github.com/kriscendobot/minion.town/pull/170 (scrub and encrypt locator fragments), https://github.com/kriscendobot/minion.town/pull/236 (remote invitation hints)
tracker: https://github.com/kriscendobot/minion.town/issues/227
task: Maintainer direction (2026-11-04): move away from endo:// locators and toward https URLs on the site, with the cryptographic material in the URL FRAGMENT, e.g. https://minion.town/accept#<...> for invitations and https://minion.town/adopt#<...> for adopting a capability (or similar paths you recommend). An app that understands the URL may intercept it (universal-link style); when none does, the URL falls through to the minion.town site, whose page reads the fragment locally and completes the action. The fragment is never sent to the server.

Design and build the first working slice in minion.town (draft PR), per the build-location rule (new code in minion.town, no premature lift to Endo):
1. Define the URL grammar: paths /accept and /adopt (confirm or propose better names), what the fragment carries (the existing locator, possibly encrypted per PR 170), versioning, and how it round-trips with the endo:// form. Keep endo:// parsing working during the transition; new minting emits the https form.
2. The fall-through page: reads the fragment client-side only, never logs or transmits it, scrubs it from history after reading (see PR 170), and completes accept or adopt through the existing guest session (or sign-in then continue). Handle: spent invitation, malformed fragment, unauthenticated visitor.
3. Make `evaluate`-minted invitations produce the https form (this also closes the gap where an evaluate-made locator cannot be accepted from the web page; coordinate with job build-minion-town-tool-minimalism-20261104 rather than duplicating its fix, and note the overlap).
4. Prove it: a real-daemon test with Playwright; an invitation minted through evaluate, opened as an https URL in a fresh browser, accepted, mail flows. Check the server and Caddy access logs contain no fragment.
5. Threat notes in the PR: referrer leakage, link-preview crawlers (fragments are not sent), browser history, the PR 173 crawler/leak signal.
Constraints: draft PR; no deploy; no secrets in output. Write the PR description as a production-outcome report.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T01:09:15Z
