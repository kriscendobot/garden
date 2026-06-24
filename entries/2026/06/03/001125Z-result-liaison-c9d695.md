---
ts: 2026-06-03T00:11:25Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--c9d695
cycle: 131
---

# Cycle 131 — endopi-prompt-templates.md (Kris Kowal, endo-but-for-bots) — **ninth and FINAL endopi-* spinout**

Ingested `designs/endopi-prompt-templates.md` (104 lines,
*Proposed* status, Parent: endopi.md) from
`endojs/endo-but-for-bots@f4a9dc6d` (branch `origin/llm`).
**Twenty-seventh-comment-style design ingest.** One cohesion-
honest section:

- **mustache-placeholder-editor-expansion-not-agent-invocation-
  with-shared-discovery-walker** — closes the §Prompt templates
  gap from cycle 121's family keystone (*self-contained,
  low-risk feature; useful before larger workflow features
  land*). The smallest endopi-* design in the family at 104
  lines.

## The single most structurally interesting move

The §editor-expansion-not-agent-invocation distinction:

> *Templates expand the user's editor; they do not run
> autonomously. Autonomous prompts are endoclaw's proactive-
> messages territory.*

> *Selecting one expands the template body into the editor; the
> agent loop does not run until the user presses Enter. This
> matches Pi's UX: a template is editor expansion, not agent
> invocation.*

The §template-is-text-not-trigger discipline locks in cycle
129's per-kind-confinement table: *prompts are pure text
expansion. No capability surface at all*.

## Family arc closure — endopi-* family is now **9/9 complete**

The endopi-* family is now complete across **19 cycles (112 →
131)**:

| Cycle | Design | Lines | Status |
|-------|--------|-------|--------|
| 112 | endopi-skills-markdown-format.md | 172 | Proposed |
| 117 | endopi-jsonl-transcript-format.md | 165 | Proposed |
| 121 | **endopi.md (keystone)** | 583 | Reference |
| 122 | endopi-edit-tool.md | 122 | Proposed |
| 124 | endopi-iterative-compaction.md | 152 | Proposed (partially satisfied) |
| 126 | endopi-stdio-rpc-bridge.md | 149 | Proposed |
| 128 | endopi-provider-registry-and-oauth.md | 181 | Proposed (partially satisfied) |
| 129 | **endopi-extension-package-manifest.md (unifier)** | 149 | Proposed |
| **131** | **endopi-prompt-templates.md (this cycle)** | 104 | Proposed |

The family has one keystone (121, *Reference*) + eight spinouts.
The unifier (129) consumes four resource kinds via the `endo`
manifest key: `guests` (Endo native) + `skills` (112) + `prompts`
(this cycle) + `providers` (128). Two designs are *partially
satisfied* (124, 128) per the §Genie-substrate-already-ships
lifecycle pattern visible in cycle 121's §Genie section.

The arc shape:

- **Status mix**: 1 Reference + 6 Proposed + 2 Proposed
  (partially satisfied). The *partially-satisfied* lifecycle
  pattern is a structural innovation in this family.
- **Size range**: 583 (keystone) to 104 (this cycle). Each
  spinout is *strictly smaller* than the keystone — by design,
  the spinouts are focused single-concern designs.
- **Cross-references**: each spinout traces back to the keystone
  as Parent; many spinouts cross-reference each other (cycle 122
  references cycles 116 + 118; cycle 124 references cycles 105 +
  117; cycle 126 references cycles 109 + 111 + 119; cycle 128
  references cycles 109 + 111; cycle 129 references cycles 112
  + 128 + 131; this cycle references cycles 112 + 116 + 129).

## §The smallest endopi-* design

At 104 lines, this is the *smallest* endopi-* design in the
family. Sizing chart:

- 583 — cycle 121's keystone
- 526 — cycle 119's daemon-capability-bus
- 435 — cycle 116's daemon-form-request
- 350 — cycle 107's daemon-agent-tools
- 331 — cycle 103's daemon-value-message
- ... [intermediate sizes] ...
- **104 — this cycle's endopi-prompt-templates**

The *smallest-feature-bullet-self-contained-low-risk* shape that
the §Prompt cell of the design names: *useful before larger
workflow features land*.

## Rotation note

Cycle 131 was nominally **papers-lane** (cycle 130 was
comments). Papers-lane has been blocked for **25+ consecutive
cycles** (97/100/102/104/106/108/110/112/113/114/116/117/118/119
/120/121/122/123/124/125/126/127/128/129/130) due to lack of
PDF-fetching infrastructure. Cycle 131 pivoted to designs-lane
to close out the family.

## Counts

- 634 → **635** sections (+1).
- 175 → **176** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row — ninth
  and final endopi-* row in this topic).
- Keywords index extended with ~25 prompt-templates-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 132 wakes in 1500s. **The endopi-* family is exhausted**;
future design-lane cycles will pick from the other design
clusters (daemon-* still has ~25 unexplored designs;
familiar-* has 5 more; gateway-* / ocapn-* / hardened-* a few
each). Or pivot back to comments-lane for variety.
