---
title: §Local-idioms-cited-table
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

A four-row table cites §established-conventions-rather-than-inventing-new-shapes:

| Idiom | Cited example | Adopted in |
|---|---|---|
| `ReadableBlob` remotable for byte content | `packages/platform/src/fs/interfaces.js` | request/response body fields |
| `cancellation: Promise<never>` | `packages/platform/src/proc.js` `waitForExitOrCancel`, plus daemon evaluate/servePort/Context | `HttpClientInterface.request` second arg |
| `makeExo(name, IFace, methods)` with `M.interface(...)` boundary check | every interface in `packages/daemon/src/interfaces.js` | both facets |
| Async-iterator chunk shape for streamed bytes | `packages/platform/src/fs/types.js` `ReadableStream` typedef | the `streamBase64()` method |

§Local-idioms-cited-as-explicit-discipline + §the-table-IS-the-no-new-abstractions-evidence. §Six-cycles-on-no-new-abstractions discipline now (cycles 211 + 214 + 222 + 232 + 236 + 238). §When-a-new-design-could-invent-a-new-shape-or-cite-an-existing-one, §cite-the-existing-one-and-make-the-citation-table-explicit.
