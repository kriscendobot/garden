---
gate: deferred
priority: normal
posted_by: liaison
posted_at: 2026-10-13T16:57:45Z
---

---
role: researcher
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Investigate: let `@endo/zip` fall through to Node.js's native Zip implementation, with behavioral parity

Repo: endojs/endo-but-for-bots @ `llm` (package `@endo/zip`). Maintainer (kriskowal, liaison session 2026-10-13) asked for this investigation; it is parked on the plan queue until he says go.

## The question

Can `@endo/zip` defer to the native Node.js implementation of Zip when running on Node.js, and keep the exact behavior it has today? Deliver a written finding and a recommendation, not an implementation.

## What to establish

1. **What Node.js actually provides.** Do not assume. Determine, for each Node.js release line the repo supports (see its `engines` fields and the Node LTS window skill, `skills/node-lts-window-watch/SKILL.md`), what native Zip support exists and its API (archive read, archive write, streaming, compression methods, ZIP64, encryption, data descriptors, directory entries, timestamps, permissions/external attributes, UTF-8 names, stored vs deflated). If Node.js has no native archive API on some or all supported versions, say so plainly, and say what the fall-through would then be (for example only `zlib` for the deflate layer).
2. **Parity.** Characterize `@endo/zip`'s current observable behavior (read and write APIs, byte-for-byte output determinism, ordering, timestamps, metadata, error shapes, malformed-archive handling, size limits, and behavior under SES lockdown). Build a differential parity harness that runs the same corpus through the pure-JS path and the native path and diffs bytes and behavior. Include hostile and malformed archives, since parity of failure matters as much as parity of success.
3. **Engine baseline recognition, the hard part.** The fall-through must be selected where the native implementation is present and correct, and must be skipped elsewhere (older Node.js, XS, browsers, other engines). Evaluate at least:
   - feature detection at module load (and its cost, and whether it holds under lockdown/`hardened` realms);
   - an **optional-dependency package split** with `engines` conditions, as is done for architecture- and platform-specific package variants, so the package manager installs the native-backed variant only on a qualifying Node.js. Examine how `engines`, `os`/`cpu`, `optionalDependencies`, Yarn's behavior and the repo's package-resolution tooling treat an `engines`-conditioned optional dependency, including whether `engines` mismatches are skipped or merely warned about (strict vs non-strict engines), what lockfile consequences follow, and what it does to bundlers and to the repo's no-install/vendored consumers;
   - conditional `exports` (`node`, `import`, custom conditions) as an alternative or a complement.
   Say which recognizes the baseline reliably, and which fail open to the pure-JS path (the safe direction).
4. **Risks.** Supply chain surface of the added package(s); behavior drift across Node.js minor versions; security of the native parser on untrusted archives versus the current implementation; effect on SES/hardened use; effect on bundle size and the `@endo/compartment-mapper` archive path.

## Deliverable

A design-style report committed as a draft PR only if the finding is positive; otherwise post the finding as a journal message and stop. State a clear recommendation: proceed, proceed behind a flag, or do not. Include the parity harness location and results. Be economical with quota; one concise pass per question, no speculative implementation.
