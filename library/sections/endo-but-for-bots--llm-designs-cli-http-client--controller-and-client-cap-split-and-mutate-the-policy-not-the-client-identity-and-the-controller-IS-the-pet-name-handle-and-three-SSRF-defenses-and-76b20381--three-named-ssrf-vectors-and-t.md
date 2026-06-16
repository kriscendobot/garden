---
title: §Three-named-SSRF-vectors-and-three-named-defenses
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED
---

The design preserves PR #144's three SSRF mitigations and clarifies which facet owns each knob:

1. **§Redirect-following defense.** `fetch` is invoked with `redirect: 'manual'` so a `302 Location` from an allowlisted origin to an unallowed one (instance-metadata, RFC1918) is §never-followed-by-the-daemon. §The-client-surfaces-the-Location-to-the-caller + §the-caller-may-re-issue-against-the-new-URL-which-goes-through-the-allowlist-again. §When-redirects-could-pivot-to-private-addresses, §redirect-manual-and-let-the-caller-re-validate.

2. **§Slow-loris defense.** Each `fetch` is wrapped in an `AbortController` with a wall-clock timeout (default 30 seconds; mutable via the controller's `setTimeoutMs`). §The-controller-owns-the-knob + §the-client-owns-the-per-call-wiring. §When-a-defense-is-a-policy-knob, §the-policy-facet-owns-the-knob-and-the-use-facet-owns-the-wiring.

3. **§Response-flooding defense.** Streaming reader accumulates chunks until the byte cap is reached, then aborts the upstream stream and returns a truncated prefix with `truncated: true`. §The-cap-survives-a-Content-Length-lie-because-truncation-runs-at-read-time. §When-the-server-can-lie-about-Content-Length, §truncate-at-read-time-not-at-header-parse-time.

§Origin-allowlist-is-name-based: §a-hostname-whose-A-record-resolves-to-a-private-address-still-passes-if-allowlisted. §The-trust-on-first-bind-addendum-will-offer-an-opt-in-that-pins-the-resolved-IP-at-first-contact. §The-allowlist-is-the-strict-by-default-mode + §future-trust-modes-extend-it.
