---
title: See also
source: packages/ses/src/error/tame-v8-error-constructor.js
source_repo: endojs/endo
source_branch: master
source_commit: 816bc2574052e686bb14efd95e4709180f79cca6
source_date: 2026-04-30
source_authors: [Richard Gibson and prior contributors]
source_lines: "212-end (tameV8ErrorConstructor function and exports)"
topics: [hardened-javascript, errors, capability-security]
status: current
parent: endo--packages-ses-src-error-tame-v8-error-constructor-js--tame-v8-error-constructor-and-system-vs-user-preparefns
---

- [[hardened-javascript]] (topic) — the SES substrate this taming inhabits.
- [[errors]] (topic) — the SES error-handling surface; `getStackString` is the start-compartment-only stack-read capability.
- [[capability-security]] (topic) — the system-vs-user prepareFn distinction is the canonical capability-attenuation pattern for a V8-defined hook.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--call-site-permit-list-and-filename-censors` — the first section: the 16-name permit list + five filename-censors that this section's `callSiteFilter` + `safeV8SST` consume.
- `endo--packages-ses-src-error-tame-v8-error-constructor-js--callsite-path-shortening-patterns` — the second section: the four regex patterns that this section's `callSiteStringifier` applies when `shortenPaths` is true.
- `endo--packages-pass-style-src-error-js--v8-stack-accessor-undeniable-channel-and-repair` (cycle 87) — the complementary pass-style-side V8-stack-accessor repair. The pass-style side fixes the *accessor channel*; this file attenuates the *prepareStackTrace API surface*.
- `endo--packages-eventual-send-src-track-turns-js--*` (cycle 90) — the causal-console + eventual-send module whose frames are dropped by this file's `FILENAME_EVENTUAL_SEND_CENSOR`. Track-turns *adds* causal annotations; tame-v8 *removes* the underlying frames from concise stacks. The two compose to produce a useful causal-but-not-noisy stack view.
