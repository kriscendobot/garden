---
title: The single most structurally interesting move
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

**§the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline** — every locator function follows the SAME decision tree:

```js
if (env.XDG_X !== undefined) {
  return `${env.XDG_X}/endo`;          // 1. Cross-platform XDG spec
} else if (platform === 'win32') {
  return `${whereHomeWindows(env, info)}\\Endo`;  // 2. Windows-native
} else if (platform === 'darwin') {
  return `${home}/Library/X/Endo`;     // 3. Mac-native
}
return `${home}/.X/endo`;              // 4. Linux/default fallback
```

**§the-named-cross-platform-spec-FIRST-platform-native-FALLBACK-discipline** — first-explicit-observation as a tier-3 meta-pattern. Each of the four locator functions follows this **four-tier decision tree**:
1. **XDG env var present** — use it (highest preference; cross-platform)
2. **platform === 'win32'** — use Windows-native conventions
3. **platform === 'darwin'** — use Mac-native conventions
4. **default** — use Linux/POSIX conventions

The discipline is the **implementation** of cycle 347's README policy: *"Endo attempts to use or infer XDG conventions paths in every meaningful way... Otherwise falls back to the native conventions on Windows and Mac/Darwin."* Cycle 347 named the policy at the README level; cycle 348 reveals it applied **uniformly across all four functions**.

**§the-named-XDG-FIRST-platform-SECOND-fallback-pattern** — first-explicit-observation. The pattern is enforced by structural similarity across functions: same decision-tree shape, different XDG env-var name + different platform-native path.

**§the-named-policy-uniformly-applied-across-functions-discipline** — first-explicit-observation as a tier-3 meta-pattern. When a package has multiple functions implementing variants of the same policy, the functions should share **structural similarity** so the policy is visible in the code.
