---
title: §LLM-discoverability section (§novel-design-shape)
source-slug: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin
section-id: Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-os-sandbox-plugin.md
authors: [Kris Kowal (prompted), Joshua T Corbin (revised)]
repo: endojs/endo-but-for-bots
path: designs/daemon-os-sandbox-plugin.md
total-lines: 544
status: Superseded by endo-posix-sandbox (2026-05-07)
ingest-cycle: 228
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
---

§The-load-bearing-new-shape of this design. §A-section-named-LLM-discoverability with §two-named-mechanisms:

> 1. **`help()` methods must be comprehensive.** [...] `help()` text should be written as if the reader is an LLM that has never seen the plugin before: explain what the capability does, enumerate every method with its parameters and return type in prose, and give a concrete example invocation.
>
> 2. **Interface guards must be maximally specific.** The `M.interface()` patterns are the machine-readable schema an LLM can inspect [...] Guards must use precise pattern shapes — named record fields, enumerations, and descriptive remotable tags — rather than opaque `M.record()` or `M.any()`.

§Two-mechanisms-for-LLM-discoverability:
1. §help()-text-narrative for the LLM to reason over.
2. §Interface-guards-machine-readable-schema for the LLM to validate calls against.

§Together-they-provide-the-narrative + §the-structural-contract — §if-either-is-vague-the-LLM-will-be-unable-to-use-the-capability-reliably.

§Borrowable-pattern: §LLM-as-the-target-reader for API design. §When-the-consumer-is-an-LLM-not-a-human, §the-help()-text + §the-interface-guards-together-must-be-sufficient-to-construct-valid-calls-without-out-of-band-documentation.

§Sibling to cycle 226 endoclaw-cluster's §help()-method-on-every-interface — but cycle 226 says "every interface has help"; cycle 228 says "help must be comprehensive + interface guards must be maximally specific because the reader is an LLM". §Cycle-228-deepens-the-motivation.

§Three-cycles-on-help()-method now:
- Cycle 226 endoclaw-cluster: §help()-method-on-every-interface as uniform introspection.
- Cycle 228 daemon-os-sandbox-plugin: §help()-methods-must-be-comprehensive-for-LLM-discoverability.
- (Other cycles use help() but don't name it in their Idiom).

§The-API-must-be-self-documenting-to-the-LLM. §This-is-a-new-design-discipline emerging in 2026 as agents become primary consumers of Endo APIs.

### §M.splitRecord-for-LLM-discoverable-shapes

```js
const FsEndowmentShape = M.splitRecord(
  { path: M.string(), mode: M.or(M.literal('read'), M.literal('read-write')) },
  { mountAt: M.string() },
);
```

§M.splitRecord-distinguishes-required-fields-from-optional-fields. §M.or(M.literal('read'), M.literal('read-write')) enumerates the value space. §Borrowable-pattern: §precise-pattern-shapes-rather-than-opaque-M.record()-or-M.any() — §the-LLM-can-introspect-the-pattern-and-construct-valid-calls.

§The-discipline-extends-cycle-102-checkKey's-Rejector-trio-pattern to §interface-guards-as-LLM-discovery-mechanism.
