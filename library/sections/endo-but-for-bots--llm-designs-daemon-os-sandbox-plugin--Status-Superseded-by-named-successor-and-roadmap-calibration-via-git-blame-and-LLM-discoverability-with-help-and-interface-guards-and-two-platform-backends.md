---
title: "daemon-os-sandbox-plugin — §Status-Superseded-by-named-successor + §roadmap-calibration-via-git-blame + §LLM-discoverability-with-comprehensive-help()-and-maximally-specific-interface-guards + §two-platform-backends-with-named-endowment-to-rule-table + §Test-Plan-with-Maybe-subsection + §named-future-stronger-isolation-mechanisms + §honest-acknowledgment-of-platform-deprecation"
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
---

# daemon-os-sandbox-plugin — Superseded historical proposal with rich LLM-discoverability discipline

A 544-line **Superseded** design (created 2026-02-15; updated 2026-05-18; superseded 2026-05-07). The §parent-design that became a §historical-proposal when `endo-posix-sandbox` landed in `designs/` as the successor. §Two-named-authors (Kris Kowal prompted + Joshua T Corbin revised).

§Retained-as-a-historical-proposal — §the-design-document-doesn't-just-go-away-when-superseded + §it-stays-as-an-archaeological-record.

## §Status-Superseded-by-named-successor (§new design-evolution shape)

```
| **Status**  | Superseded by [endo-posix-sandbox](endo-posix-sandbox.md) |
```

§Borrowable-pattern: §Status-Superseded-by-named-successor as §a-status-value-with-a-link-to-the-replacement. §The-design-still-lives-in-`designs/` + §the-Status-field-points-to-the-replacement.

§Eighth-different-shape-of-design-evolution-record in 2026-06 cluster:

| Cycle | Shape |
|-------|-------|
| 214 | §within-document self-correcting prose |
| 216 | §parent-Complete + §child-Not-Started extraction via Predecessor section |
| 218 | §sibling-Ready + §this-Not-Started via two-part Status |
| 220 | §three-state-Status + §design-deviations-section |
| 222 | §Parent-pointer-as-explicit-frontmatter-field |
| 224 | §Status-Complete-with-explicit-Design-deviations-None-significant |
| 226 | §six-Parent-pointer-children-sharing-a-template (design-document cluster) |
| 227 | §uniform-PassStyleHelper-shape-across-pass-style-kind-files (code-file cluster) |
| 228 | §Status-Superseded-by-named-successor with §Roadmap-calibration-via-git-blame |

§Nine-different-shapes-of-design-evolution-record now.

## §Roadmap-calibration-via-git-blame (§rare-archaeological-shape)

The Status section includes §a-Roadmap-calibration-subsection that uses §git-blame-as-source-of-truth:

```
### Roadmap calibration (per `git blame` on `llm`)

- Design phase: 2026-02-15 → 2026-03-13 (27 days, calendar). Initial
  add `37f65aaf5` 2026-02-15 ("design doc for OS sandbox plugin");
  roadmap-cycle edits `52bc71d6e` 2026-02-24 and `0ee0cbb3c`
  2026-02-28; expansion `b1074dacc` 2026-03-13 ("expand technique
  mentions").
- Superseded transition: 2026-05-07. On that date `endo-posix-sandbox`
  was mirrored into `designs/` (`fbf40d706`) as the successor; this
  document's status transitioned from open proposal to historical
  record.
```

§Named-commit-hashes-with-named-commit-message-summaries + §named-dates. §The-design-history-is-archaeologically-traceable. §Borrowable-pattern: §when-a-design-is-superseded, §a-Roadmap-calibration-subsection-citing-specific-commits-preserves-the-design-evolution-history.

§Borrowable-pattern: §use-git-blame-as-roadmap-archaeology for §retroactive-roadmap-reconstruction. §The-source-of-truth-is-the-commit-history + §the-design-document-distills-it.

§Different-from cycle 220's §design-deviations-section (cycle 220 lists deviations without commits) and cycle 224's §named-implementation-files (cycle 224 cites files without dates). §Cycle-228 cites commits-with-dates-with-message-summaries — §the-richest-historical-record-yet.

## §No-further-implementation-phase-is-planned-against-this-document

```
No further implementation phase is planned against this document;
the forward-looking work lives under `endo-posix-sandbox` (and its
per-phase status is tracked in `packages/sandbox/README.md`).
```

§Explicit-statement-of-deprecation. §Borrowable-pattern: §when-a-design-is-superseded, §explicitly-state-no-further-work-is-planned-against-it + §point-to-where-the-forward-looking-work-lives. §Don't-leave-the-reader-guessing-whether-this-design-is-still-live.

## §LLM-discoverability section (§novel-design-shape)

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

## §Capability-flow as ASCII tree

```
HOST
 └─ makeUnconfined("sandbox-worker", "./sandbox-plugin.js")
     └─ SandboxMaker                        (held by host or granted to guests)
         │
         ├─ describe({ fs, net, exec, env })
         │   └─ Sandbox                     (scoped to declared endowments)
         │       ├─ run(command, args, opts)
         │       │   └─ { stdout, stderr, exitCode }
         │       ├─ help()
         │       └─ getEndowments()
         │
         └─ help()
```

§ASCII-tree-of-capability-flow with §nested-indentation-showing-creation-hierarchy. §Borrowable-pattern: §when-a-design-has-a-multi-level-capability-graph, §an-ASCII-tree-with-method-arrow-return-values-shows-the-full-call-shape-at-a-glance.

§Fourth-cycle-with-ASCII-illustration in 2026-06: cycles 214 (tree) / 218 (UI mockup) / 220 (flow diagram) / 228 (capability tree).

## §Two-platform-backends (macOS SBPL + Linux bwrap+seccomp)

§Two-named-backends with §a-table-mapping-endowments-to-platform-rules per backend:

```
| Endowment | SBPL rules |
|---|---|
| `fs[].mode === 'read'` | `(allow file-read* (subpath "<path>"))` |
| `fs[].mode === 'read-write'` | `(allow file-read* file-write* (subpath "<path>"))` |
| `net.allowOutbound` | `(allow network-outbound)` with SBPL ip/port filters |
| ... |

| Endowment | bwrap flags |
|---|---|
| `fs[].mode === 'read'` | `--ro-bind <path> <mountAt>` |
| `fs[].mode === 'read-write'` | `--bind <path> <mountAt>` |
| `net.allowOutbound \|\| net.allowInbound` | `--share-net` (default is `--unshare-net`) |
| ... |
```

§Borrowable-pattern: §endowment-to-platform-rule-mapping-table-per-backend. §The-mapping-IS-the-implementation-contract — §the-table-defines-what-the-platform-backend-must-emit.

§Sibling to cycle 226 endoclaw-cluster's §uniform-shape-with-pluggable-fields — cycle 226 is a §uniform-handler-interface; cycle 228 is a §uniform-mapping-table-per-backend.

## §Apple-deprecation-acknowledgment + §named-future-replacement

```
Note: `sandbox-exec` is marked deprecated by Apple but remains functional
and is still used internally by Apple (e.g. BlastDoor). The SBPL engine
is actively maintained as a private interface. Should Apple remove it in
a future release, the macOS backend can be updated to use the Endpoint
Security framework or a user-space FUSE-based approach.
```

§Honest-acknowledgment-of-platform-deprecation + §two-named-future-replacement-APIs (Endpoint Security framework + user-space FUSE). §Borrowable-pattern: §when-the-platform-API-is-deprecated-but-still-functional, §name-the-deprecation + §name-the-evidence-it-still-works (Apple still uses it internally for BlastDoor) + §name-the-future-replacement-paths.

§Sibling to cycle 220 familiar-localhttp-protocol's §`sandbox-exec` deprecation note (different design, same shape — §honest-acknowledgment-of-platform-deprecation). §Cycle-220-mentions-it-briefly; §cycle-228-treats-it-as-a-full-paragraph-with-named-replacement-paths.

## §Per-rule-network-filtering-limitation as §honest-disclosure

```
- **Network filtering granularity.** macOS SBPL can filter connections
  by CIDR and port natively via ip-filter rules. Linux `bwrap` alone
  can only toggle network namespace sharing (all-or-nothing). To enforce
  the per-rule CIDR/port restrictions expressed in `allowOutbound` and
  `allowInbound` on Linux, the backend must either set up nftables rules
  inside a network namespace, use Landlock network scoping (Linux ≥ 6.3),
  or delegate to a container runtime that provides its own network
  namespace. The initial Linux implementation falls back to
  all-or-nothing network sharing when fine-grained rules cannot be
  enforced and logs a warning.
```

§Honest-disclosure-of-platform-limitation + §three-named-future-paths-to-fix-it (nftables + Landlock + container runtime) + §the-initial-implementation-falls-back-to-all-or-nothing-and-logs-a-warning.

§Borrowable-pattern: §when-the-design-can-promise-less-on-one-platform-than-another, §name-the-asymmetry + §name-the-future-paths-to-fix-it + §name-the-current-fallback-behavior + §name-the-warning-emitted.

§Sibling to cycle 220 familiar-localhttp-protocol's §Research-needed-section. §Both designs §honest-acknowledgment-of-incomplete-implementation. §Cycle-220 names verification gaps; cycle-228 names implementation gaps.

## §Three-named-future-stronger-isolation-mechanisms (Landlock + container runtimes + Lightweight VMs)

§The-Problem-section names §three-future-paths-for-stronger-isolation:

1. **§Landlock** — Layered on top of bubblewrap for filesystem-scope and network-scope restrictions.
2. **§Container-runtimes** (Podman, LXC/Incus, systemd-nspawn, Docker) — Full namespace isolation including network namespace.
3. **§Lightweight-VMs** (Firecracker, Incus VMs) — Hardware-assisted isolation; strongest confinement; higher startup latency.

§Borrowable-pattern: §name-the-future-stronger-isolation-mechanisms with §per-mechanism-trade-offs-named (Landlock layers + container provides namespace + VM provides hardware-assisted at higher cost).

§Sibling to cycle 218 familiar-chat-weblet-hosting's §two-CapTP-transports + §primary-transport-and-stretch-goal-transport — both designs §enumerate-future-paths-with-trade-offs-named.

## §Test-Plan with §Maybe-subsection

```
## Test Plan

- Unit tests for SBPL profile generation: verify correct SBPL output...
- Integration test (macOS): sandbox a command that attempts to read...
- ... (eight named tests) ...

### Maybe

- Fuzz testing of SBPL profile generation with adversarial path inputs.
- Performance benchmarks for sandbox startup latency on each platform.
```

§Test-Plan-with-Maybe-subsection — §the-Maybe-subsection-collects-tests-that-are-not-required-but-suggested. §Borrowable-pattern: §when-the-Test-Plan-has-both-required-tests-and-optional-tests, §collect-the-optional-ones-in-a-Maybe-subsection. §The-distinction-is-clear + §the-author-doesn't-have-to-pretend-everything-is-required.

§Sibling to cycle 220 familiar-localhttp-protocol's §Research-needed-section + §Open-Questions: (None remaining.) — §three-different-shapes-for-naming-non-essential-future-work:
- Cycle 220: §Research-needed (verification gaps).
- Cycle 220: §Open-Questions: (None remaining.) (decision-completeness signal).
- Cycle 228: §Maybe (optional-tests).

§Four-different-shapes-now-for-naming-non-essential-future-work.

## §Five-section-Considerations (Security + Scaling + Test Plan + Compatibility + Upgrade)

§The-same-five-section-considerations as cycle 218 familiar-chat-weblet-hosting. §Borrowable-pattern: §a-rich-design-needs-five-considerations-sections — each names a different stakeholder concern. §Cycle-228 follows the same template.

§Two-cycles-with-the-five-section-considerations-template: cycle 218 + cycle 228. §The-template-is-becoming-a-standard.

## §Profile-generation-is-security-critical

```
**Profile generation is security-critical.** The SBPL and bwrap
argument generators must be carefully audited to prevent injection.
Paths in endowment descriptors must be validated and canonicalized
before interpolation into SBPL strings or command arguments.
```

§Borrowable-pattern: §when-a-design-generates-code-or-config-for-an-external-tool, §name-the-injection-risk + §name-the-canonicalization-requirement. §The-generator-is-the-most-security-critical-part.

§Sibling to cycle 220 familiar-localhttp-protocol's §six-layer-defense-in-depth — both designs §security-discipline-with-explicit-named-risks.

## §The-plugin-itself-is-unconfined

```
**The plugin itself is unconfined** (it needs `child_process` access).
Only the host should hold `SandboxMaker`; guests should receive
pre-scoped `Sandbox` objects.
```

§Honest-acknowledgment-of-the-unconfined-nature-of-the-plugin + §named-mitigation (only the host holds SandboxMaker; guests get pre-scoped Sandbox).

§Borrowable-pattern: §when-the-implementation-requires-unconfined-authority, §name-it-explicitly + §name-the-pattern-that-keeps-the-authority-from-leaking-to-guests.

§Sibling to cycle 226 endoclaw-cluster's §no-ambient-X enumeration — cycle 226 enumerates what's denied; cycle 228 enumerates what's granted-to-the-host-only.

## Related material in the library

- **endo-posix-sandbox** (the successor design; already ingested as cycle 196 endoclaw's §posix-sandbox sibling and possibly elsewhere).
- **cycle 220 familiar-localhttp-protocol**: §honest-acknowledgment-of-platform-deprecation sibling; §security-discipline-with-named-risks sibling.
- **cycle 218 familiar-chat-weblet-hosting**: §five-section-considerations template sibling; §power-levels-as-selectable-options sibling.
- **cycle 226 endoclaw-six-design-cluster**: §help()-method-on-every-interface sibling; cycle 228 deepens the motivation (LLM-discoverability).
- **cycle 224 daemon-web-gateway**: §named-implementation-files-in-Status-section sibling; §named-completeness-signals shape sibling.
- **cycle 200 worker-rust-xs**: §engine-level-confinement-via-XS-native-Compartment sibling — cycle 228 is §OS-level-confinement-via-platform-backends; six-cycles-on-confinement-substrates now (cycles 196 + 200 + 212 + 218 + 220 + 226 + 228).
- **cycle 102 checkKey + cycle 217 @endo/errors**: §M.interface() + §Rejector-typedef siblings — cycle 228's §M.splitRecord-for-LLM-discoverable-shapes extends the discipline.

## §The-cycle-228-additions-to-the-design-evolution-record-family

§Nine-different-shapes-of-design-evolution-record now. §Two-new-meta-clusters:

1. §Status-Superseded-by-named-successor — new completeness signal beyond cycle 224's Status-Complete-with-Design-deviations-None-significant.
2. §Roadmap-calibration-via-git-blame — new archaeological discipline beyond cycle 224's named-implementation-files.

§Cycle-228 adds two-related-disciplines that pair: §named-successor + §archaeological-trace. §A-superseded-design-needs-both — §where-did-it-go (successor) + §where-did-it-come-from (git-blame archaeology).

## §Seven-cycles-on-confinement-substrates

| Cycle | Substrate | Layer |
|-------|-----------|-------|
| 196 | endoclaw | capability framing (parent design) |
| 200 | worker-rust-xs | engine-level (XS native Compartment) |
| 212 | outliner | SES Compartment |
| 218 | familiar-chat-weblet-hosting | iframe sandbox attribute |
| 220 | familiar-localhttp-protocol | six-layer defense-in-depth |
| 226 | endoclaw-cluster | structural-confinement-at-only-call-site |
| 228 | daemon-os-sandbox-plugin | OS-level (SBPL + bwrap + seccomp + Landlock) |

§Seven-confinement-substrates-now-in-library. §From-capability-framing-down-to-OS-syscall-level. §The-stack-spans-the-full-range.

## §Library-reaches-734-sections at cycle 228 (designs-lane daemon-os-sandbox-plugin).

## §Sixty-second consecutive designs-chat alternation cycles 166-228.
