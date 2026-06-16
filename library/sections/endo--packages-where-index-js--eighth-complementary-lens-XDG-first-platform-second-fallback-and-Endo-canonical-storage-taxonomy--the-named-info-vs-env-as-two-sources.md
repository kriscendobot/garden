---
title: §the-named-info-vs-env-as-two-sources
source: endo--packages-where-index-js
url: https://github.com/endojs/endo/blob/master/packages/where/index.js
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/where/index.js
total-lines: 115
ingest-cycle: 348
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline
  - the-named-XDG-FIRST-platform-SECOND-fallback-pattern
  - the-named-Endo-canonical-storage-taxonomy
  - the-named-four-functions-locate-four-kinds-of-storage
  - the-named-state-vs-ephemeral-vs-sock-vs-cache
  - the-named-progressive-degradation-fallback
  - the-named-named-pipes-have-special-place-comment
  - the-named-ashen-hearts-comment-as-frustration-marker
  - the-named-LOCALAPPDATA-favoring-rationale
  - the-named-five-step-fallback-chain-for-Windows-home
  - the-named-ENDO_SOCK-override-with-named-rationale
  - the-named-XDG-doesnt-fit-so-we-invent-our-own
  - the-named-info-vs-env-as-two-sources
  - the-named-protocol-versioned-socket-path
  - the-named-CapTP0-as-protocol-versioning
  - the-named-typedef-as-types-imports
  - the-named-complementary-lens-re-ingest
  - eight-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-fourteenth-instance
  - thirty-nine-cycles-with-named-pivot-domain-stay
  - one-hundred-thirty-citation-arc-closures-in-pivot-now
parent: endo--packages-where-index-js--eighth-complementary-lens-XDG-first-platform-second-fallback-and-Endo-canonical-storage-taxonomy
---

Every function takes BOTH `env` and `info`:

```js
export const whereEndoState = (platform, env, info) => { ... };
```

- `env` is the environment variables dictionary (XDG_*, HOME, TMPDIR, USER, etc.)
- `info` is platform-detected info (home + temp + user)

**§the-named-info-vs-env-as-two-sources** — first-explicit-observation. The two-source-discipline:
- **env**: user/OS-overridable; can be unset
- **info**: platform-detected; always available as fallback

Every function uses `env.X !== undefined ? env.X : info.X` for shared keys (HOME → info.home; USER → info.user; TMPDIR → info.temp). **§the-named-env-falls-back-to-info-discipline** — first-explicit-observation.

**§the-named-pure-function-by-injection** — first-explicit-observation. The functions are PURE — they don't read globals; they take env and info as parameters. This makes them testable + portable. Compare to cycle 342 @endo/lockdown's pre.js which directly accesses `globalThis.LOCKDOWN_OPTIONS` and `process.env`; cycle 348's where/index.js is the INJECTION-OF-DEPENDENCIES variant.

**§two-shapes-of-environment-access** (cycle 342 direct-globals + cycle 348 injection-of-env-and-info) — first-explicit-observation as a tier-2 multi-cycle pattern.
