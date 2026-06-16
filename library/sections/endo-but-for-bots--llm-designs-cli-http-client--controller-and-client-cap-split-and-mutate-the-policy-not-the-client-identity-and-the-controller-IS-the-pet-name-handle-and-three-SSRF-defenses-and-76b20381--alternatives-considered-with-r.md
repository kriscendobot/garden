---
title: §Alternatives-considered with rejected/deferred labels
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

The design enumerates §three-alternatives-with-named-fates:

- **§Alt-A: keep PR #144's single-formula shape; add per-policy CLI commands that re-create the client in place.** §Rejected: §the-rebuild-would-invalidate-any-guest-reference-to-the-old-client — §which-is-the-opposite-of-what-the-host-typically-wants. §Also-forces-the-rate-limit-window-and-any-in-flight-requests-to-reset-on-every-policy-edit.

- **§Alt-B: single facet with a method-level cap split.** §Rejected: §this-is-what-Far-plus-manual-attenuation-looks-like-in-practice + §it-sidesteps-the-makeExo-M.interface-boundary-check + §creates-two-interface-contracts-on-one-object-that-have-to-be-kept-mutually-consistent-by-hand. §The-two-facet-kit-is-the-idiomatic-Endo-expression-of-this-attenuation.

- **§Alt-C: three-way split (controller, client, inspector).** §Deferred: §the-inspection-surface-is-small-for-now + §a-later-split-into-a-separate-inspector-cap-is-a-non-breaking-change-because-no-method-moves-off-the-client-only-onto-a-new-third-facet.

§Alternatives-considered-with-three-fates (rejected + rejected + deferred) + §each-rejection-names-the-specific-failure-mode + §deferral-names-the-non-breaking-property. §When-an-alternative-is-rejected, §name-the-specific-failure-mode-not-just-the-disagreement; §when-an-alternative-is-deferred, §name-the-non-breaking-condition-under-which-it-can-be-revisited.
