---
id: leak-canary-testing
aliases: [leak canary, secret propagation test, redaction canary]
topics: [http-secret-handling, worker-observability, testing]
---

# leak-canary-testing

A test technique that injects a distinct non-functional marker into each sensitive request carrier, exercises normal and failure paths, and scans declared caches, logs, traces, errors, queues, and browser stores. A marker outside its allowlisted sink proves accidental propagation and identifies the leaking carrier; unlike a honeytoken, it tests copying rather than attacker use.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [framework controls and leak canaries](../sections/web--secret-seal--framework-controls-and-leak-canaries.md) | Defines per-carrier markers and scanning of every declared sink. |

## See also

- [[request-carrier-leakage]] — the surfaces the canaries measure.
