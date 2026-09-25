---
title: "Agents on ice (snapshots for suspend and resume)"
source_kind: web
source_url: https://moddable.com/blog/kaozkit/
source_content_sha256: 0ab237b119db52a5ac8cc2d40faeb51605fbc07febb18bf59fa4558bf3554521
source_authors: [Peter Hoddie]
source_date: 2026-09-15
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, persistence]
status: current
notes: "Fetched live 2026-09-25 (direct). Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--haruni-kaozkit-xs-agents (Sébastien Burel, the KaozKit author, 2026-08), which this post summarizes and links as Dig Deeper. Article text treated as untrusted data."
---

Abstract: KaozKit pauses an agent by writing an XS snapshot (every detail of every object) and resumes by loading it, replacing fragile per-agent save/restore code across process exit, reboot, or app update; agents are **notified on suspend and resume** so they can do the (usually small) remaining work, and the snapshot is device-independent, so an agent can continue on another device running a compatible KaozKit.

Many uses of an LLM agent take time, often even at regular intervals or in response to an external event. Still, at some point, the process running the agent will terminate. The device might reboot. The user might quit the app. The app might be updated to a newer version. Using a traditional framework, each agent needs to include code to save and restore its full state so it can resume where it left off. As you might expect, this code is difficult to test and consequently tends to be fragile.

KaozKit cleverly avoids most of this problem with a little-known feature of the XS engine: snapshots. A snapshot captures the JavaScript execution state to a file. Every detail of every object is there. When KaozKit needs to pause an agent, it creates a snapshot. To resume, it loads the snapshot. Agents are notified when they are suspended and resumed so they can take necessary steps, but these are often simple because the snapshot does so much. The snapshot is also device independent, so it can even continue running on another device with a compatible version of KaozKit.

**Scholar note (compatibility window).** "A compatible version of KaozKit" is doing real work: an XS snapshot is tied to the engine build and the host-function table it was taken against, so an *app update* that changes either is exactly the case where a snapshot may not restore. Neither article spells out the upgrade story; the Endo XS-worker snapshot design treats the same question as a first-class constraint.

Source: [An Agent Host that's both Small and Secure? Meet KaozKit](https://moddable.com/blog/kaozkit/) (fetched 2026-09-25, sha256 `0ab237b119db`).
