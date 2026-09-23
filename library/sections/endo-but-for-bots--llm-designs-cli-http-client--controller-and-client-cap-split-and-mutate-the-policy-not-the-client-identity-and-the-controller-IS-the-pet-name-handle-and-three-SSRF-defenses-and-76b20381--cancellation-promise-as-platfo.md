---
title: §Cancellation-promise-as-platform-neutral-interface
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

The `request` method takes a §`cancellation: Promise<never>` second argument — §the-existing-daemon-convention (cited examples: `waitForExitOrCancel`, `WorkerFacetForDaemon.evaluate`, `SocketPowers.servePort`, `Context.cancelled`). §A-platform-neutral-caller-never-sees-AbortController + §it-only-sees-the-promise.

§AbortController-is-mapped-one-way-at-the-platform-boundary: the daemon's implementation constructs an `AbortController` per request, attaches the `cancellation` rejection to it via `cancellation.catch(reason => controller.abort(reason))`, and uses the controller's `signal` for the underlying `fetch`. §The-mapping-is-from-platform-neutral-to-platform-specific-not-the-reverse. §When-the-platform's-cancellation-shape-is-AbortController-but-the-cap-system's-shape-is-Promise<never>, §map-at-the-boundary-not-throughout.
