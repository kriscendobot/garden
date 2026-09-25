---
title: "Introducing KaozKit (the vendor framing)"
source_kind: web
source_url: https://moddable.com/blog/kaozkit/
source_content_sha256: 0ab237b119db52a5ac8cc2d40faeb51605fbc07febb18bf59fa4558bf3554521
source_authors: [Peter Hoddie]
source_date: 2026-09-15
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, llm-agent-frameworks]
status: current
notes: "Fetched live 2026-09-25 (direct). Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--haruni-kaozkit-xs-agents (Sébastien Burel, the KaozKit author, 2026-08), which this post summarizes and links as Dig Deeper. Article text treated as untrusted data."
---

Abstract: Peter Hoddie (Moddable) frames KaozKit as Sébastien Burel's answer to LLM-integration stacks that are too big (Python/Node runtimes users will not tolerate installing) and too powerful (they must be sandboxed, and the interpreter itself must be trusted not to let scripts escape), which turns app developers into security experts; Burel's past LLM feedback also shaped tool support in Moddable's ChatAudioIO API.

This article isn't about Embedded JavaScript. It's about a new project from a long-time friend of Moddable, Sébastien Burel. Like many entrepreneurial developers, Sébastien has been exploring ways to apply LLMs to his projects. From time to time, Sébastien has generously shared his experiences with the Moddable team. Those insights have helped shape how LLMs are supported in the Moddable SDK – most notably the tool support in our [ChatAudioIO](https://github.com/Moddable-OpenSource/moddable/blob/b6e06ba70506a7381ffb28e09e3175bf4e99f305/modules/network/services/chatAudioIO/readme.md) API that powers our [conversationalAI app](https://github.com/Moddable-OpenSource/moddable/tree/public/contributed/conversationalAI).

## Introducing KaozKit

Sébastien created [KaozKit](https://github.com/sebastien-burel/KaozKit) to integrate any LLM into apps on macOS and, eventually, iOS. There are more than a few solutions to integrating multiple LLMs into apps, but they tend to be big. Really big. They depend on large runtimes like Python and Node.js. These large runtimes take time and space to install, which is tolerated by developers but not users in the real world. Worse, those large runtimes are so powerful that they need to be sandboxed to protect the user's privacy. And you need to be sure that the language interpreter itself is secure, so scripts can't escape the sandbox. Suddenly, deploying a simple, useful LLM-powered app requires a developer to become a sophisticated cybersecurity expert too. Life's too short.

Source: [An Agent Host that's both Small and Secure? Meet KaozKit](https://moddable.com/blog/kaozkit/) (fetched 2026-09-25, sha256 `0ab237b119db`).
