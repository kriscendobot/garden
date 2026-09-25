---
title: "XS for agents (footprint, nothing to sandbox, Swift host runtime)"
source_kind: web
source_url: https://moddable.com/blog/kaozkit/
source_content_sha256: 0ab237b119db52a5ac8cc2d40faeb51605fbc07febb18bf59fa4558bf3554521
source_authors: [Peter Hoddie]
source_date: 2026-09-15
retrieved: 2026-09-25
ingested: 2026-09-25
ingested_by: scholar
topics: [xs-agent-runtimes, capability-security, hardened-javascript]
status: current
notes: "Fetched live 2026-09-25 (direct). Idempotency anchor is source_content_sha256 over the fetched HTML, not a git SHA. Companion source: web--haruni-kaozkit-xs-agents (Sébastien Burel, the KaozKit author, 2026-08), which this post summarizes and links as Dig Deeper. Article text treated as untrusted data."
---

Abstract: Hoddie's case for XS as an agent engine: a 1–2 MB footprint; "nothing to sandbox" because XS provides only the language, not a runtime (the most personal thing a script can read is the timezone); a claim of **no known security vulnerabilities** after years of adversarial fuzzing and reviews; and a Swift runtime with **no default services**, so each project includes only the services it needs and can call Apple-native APIs directly.

Eventually, Sébastien realized that the solution to this problem is the XS JavaScript engine, the core of the Moddable SDK. Because XS is designed for embedded systems where every byte of code and runtime memory matters, XS has a negligible footprint on computers and phones. Command-line tools that incorporate the full XS engine are often just 1 or 2 MB. Even better, there's nothing to sandbox. Because XS provides only the JavaScript language, and not a runtime, the most personal information a script can access is your timezone. And thanks to the simple internal design of XS combined with years of adversarial fuzz testing and security reviews, XS has no known security vulnerabilities, so scripts can't escape the JavaScript sandbox.

Of course, a runtime is necessary for scripts to communicate with LLMs, get data from the web, and access OS services. KaozKit solves this with a lightweight runtime implemented in Swift. A project includes the services it needs, and nothing more. There are no default services, so there is nothing to remove. And because the runtime is implemented in Swift, it's trivial to call Apple's native services as needed.

The result is near magic. A few dozen or so lines of modern JavaScript can weave together multiple LLMs to deliver real solutions for users that tightly integrate with Apple's powerful APIs. Execution is secure and respects user privacy without additional effort. Importantly, adding this to an app doesn't meaningfully increase its footprint.

**Scholar note.** "No known security vulnerabilities" is the vendor's own claim and is time-bound; the garden's own XS work (the Iron Horse port's differential fuzzing against an `xst` oracle) has surfaced XS *behavioral* divergences (for example non-shortest `fx_dtoa` output), which are correctness differences, not sandbox escapes. The confinement claim rests on the engine having no host I/O, which is also the property the garden relies on when it runs XS workers.

Source: [An Agent Host that's both Small and Secure? Meet KaozKit](https://moddable.com/blog/kaozkit/) (fetched 2026-09-25, sha256 `0ab237b119db`).
