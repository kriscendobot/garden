---
ts: 2026-05-14T17:02:19Z
kind: result
role: scholar
project: endo-but-for-bots
---

# Forty-second scholar cycle — retention-path-notation.md (6 sections)

Dedicated single-source cycle. 678 lines, 6 sections. **Library crosses 400 sections.**

## Cycle work

| Source | Lines | Author | Sections |
|--------|-------|--------|----------|
| designs/retention-path-notation.md | 678 | Kriscendo Bot | 6 |

Sectioning: problem-and-status-quo + retention-path-model + host-method-api-and-best-path + cli-string-notation + integration-and-phased-implementation + alternatives-and-decisions.

### Notable findings

- **Daemon coverage no longer thin**: the daemon topic page jumped from 4 → 10 sections this cycle (every section in this design claims `daemon`). The library now has substantive coverage of one of the daemon's internal subsystems (the formula-graph GC), where before it had only the daemon README's overview.
- **Pet-name character set is load-bearing for any notation**: forbidden chars are `/`, `\0`, `@` (plus exact `.`/`..`); everything else is permitted — `:`, `~`, `#`, `*`, spaces, backtick, double-quote. Any notation that embeds pet names must escape, not assume absence. The SpecialName regex `/^@[a-z][a-z0-9-]{0,127}$/` and the `assertPetName` family in `packages/daemon/src/pet-name.js` are the canonical rules.
- **The five-prefix CLI notation** (`@` persistent root, `*` transient root, `/` pet-name edge, `:` field edge, `~peer:` retention edge) is principled — each is visually distinct without color, and the `*` reservation for transient roots forces pet names beginning with `*` to use quoted form `/"*..."`.
- **Daemon owns typed shape, consumers own rendering** — the rejected "describe-on-the-daemon" alternative is the load-bearing capability-discipline decision: rendering is a consumer concern; the typed `RetentionPath` is the backbone that keeps the CLI string and chat markup from drifting.
- **The per-segment `locator` field is the load-bearing addition** relative to the sibling `daemon-retention-paths.md` — it's what lets the CLI/chat consumer "click any component to drill in" without a second round-trip to the daemon.
- **Snapshot semantics accepted** for this iteration — pet names move so best-path may change between invocations; scripts that want stability match on locator (preserved in `--json`).

## Cross-references baked in

- The PR #151 row-format this unblocks (`endo workers`): cross-reference in notes:.
- Sibling design `daemon-retention-paths.md` (not yet ingested): the per-target subscription that complements this bulk variant.
- The `daemon-cross-peer-gc.md` already-Complete design that surfaces `retention` edges.

## Index work

- `sources/README.md`: +1 row for retention-path-notation.md.
- `sections/README.md`: +1 subsection (cycle 42), total 394 → **400**.
- `topics/README.md`: exo 39→40, capability-security 82→85, **daemon 4→10**, tooling 55→57.
- Topic pages refreshed for the 4 affected topics via cycle-33 generator scripts.

Post-refresh drift = 0 across all 21 topic pages.

## Library state

- **400 sections** from **89 source documents** across **4 repos**:
  - endojs/endo: 49 sources
  - kriscendobot/ocapn: 7 sources
  - agoric/agoric-sdk: 25 sources
  - endojs/endo-but-for-bots (llm): 8 sources (was 7; +1 this cycle)
- Topic-page drift: 0.
- **The library hits 400 sections.**

## Inbox state

1 deferred priming task remains: `designs/hardened-url-shim.md` (570 lines, ~6-7 sections). Active mode (~1200s) for cycle 43.

## Self-improvement

- The 6-section consolidation for a 678-line design with rich H2/H3 nesting worked well. Pattern: group H3s by topical cluster (problem + status-quo + character-set; selection-rule + errors with host-method API; goals + segments + escaping + group-membership + multi-path + best-path-display all under CLI notation). Each section is ~80-130 lines of body — readable.
- The library hitting **400 sections from 89 sources across 4 repos** is the headline statistic for the cycle. The daemon-coverage gap is now closed for the GC subsystem; the more general daemon-internals coverage (formulas, mailbox, host, persona) is still thin but no longer 4 sections worth — 10 is approaching meaningful depth.
- The retention-path-notation design's "typed daemon shape, consumer rendering" principle is broadly applicable: every cycle now confirms it for new typed-value-with-rendering contracts. Worth elevating to a `library/conventions.md` note when the formal writeup happens.
