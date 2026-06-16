---
title: §Test-plan section
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

§The-test-plan-section enumerates eight named test scenarios:

1. Controller methods land mutations that subsequent client calls observe.
2. Revoking the controller flips client methods to a structured rejection.
3. The client cannot reach the controller through any method.
4. All PR #144 defenses port unchanged.
5. Cancellation promise rejected mid-request behavior.
6. Request/response bodies pass through `ReadableBlob` correctly.
7. CLI integration: `endo http mk` followed by `endo http allow` followed by guest fetch.
8. CLI integration: `endo http revoke` causes subsequent guest fetch to fail.

§Test-plan-named-in-the-design-doc-not-deferred-to-the-builder + §the-test-plan-IS-the-acceptance-criteria. §Eight-named-test-scenarios-with-PR-defense-port-as-one-line-item. §When-a-design-replaces-an-earlier-shape, §the-test-plan-explicitly-names-the-port-of-the-earlier-shape's-tests.
