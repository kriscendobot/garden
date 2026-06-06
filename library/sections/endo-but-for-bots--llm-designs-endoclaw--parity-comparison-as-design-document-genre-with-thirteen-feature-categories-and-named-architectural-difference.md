---
source: designs/endoclaw.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endoclaw.md
section_kind: design
ingested: 2026-06-06
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Joshua T Corbin (edited)
topics:
  - daemon
  - capability-security
status_at_ingest: Reference
genre: §endo-but-for-bots-design §parity-comparison-as-design-document
cycle: 196
lane: designs
status: current
---

# Parity comparison as design-document genre with thirteen feature categories, status matrix with named equivalents, gap priority classification, and honest architectural difference (ambient-vs-object-capability)

> §Designs-lane after cycle 195's chat-lane. §The-thirtieth-
> consecutive designs/chat alternation cycle (166-196). §Status:
> **Reference** (Created 2026-03-03, Updated 2026-03-04) —
> §the-design-is-an-informational-comparison rather than a
> §propose-implement-ship artifact.

`endoclaw.md` (444 lines, **Reference**) maps OpenClaw
(formerly ClawdBot, formerly Moltbot — Peter Steinberger's
personal AI assistant) features to Endo equivalents across
§thirteen-feature-categories. §The-design's-purpose: name
the parity gaps and the architectural disagreements so
future Endo work can decide what to copy, what to refuse,
and what to ignore.

§The-single-most-structurally-interesting-move is §parity-
comparison-as-design-document-genre + §thirteen-feature-
categories + §status-matrix-with-named-equivalents-and-
status-tags + §gap-priority-classification (High/Medium/Low)
+ §honest-architectural-difference-named (ambient-vs-object-
capability). §Five-named-moves in 444 lines.

## §The-§parity-comparison-as-design-document-genre

§Most-endo-but-for-bots-designs follow the §propose-
implement-ship pattern: name a problem, sketch a solution,
list phases, ship. §endoclaw-takes-a-different-shape: §enumerate-
the-prior-art, §map-each-feature-to-Endo-status, §name-the-
architectural-disagreement.

§Status-Reference is the §lifecycle-marker for this genre.
§Compare-to-cycle-170-daemon-capability-filesystem (also
Status: Reference) which is §the-wider-vision that concrete
slices (cycle 166 daemon-mount) implement. §Cycle-196-endoclaw
is §the-feature-roadmap-comparator that future concrete
designs reference.

§Compare-to-cycle-180-hex-package's §design-after-
implementation-as-ratification (the design ratifies what
shipped). §Cycle-196-endoclaw is the §design-as-feature-
mapping; it doesn't ratify, it inventories.

§Compare-to-cycle-188-perf's §three-variant-benchmark-as-
bottleneck-triangulation. §Cycle-188-uses-the-comparison-to-
isolate-the-cost; §cycle-196-uses-the-comparison-to-isolate-
the-design-direction.

§Tier-1-borrowing: §parity-comparison-as-design-document-
genre for §taking-stock-against-a-named-prior-art. §The-
Reference-status tells future readers "this informs design
decisions; it doesn't propose new work."

## §The-§thirteen-feature-categories

§Thirteen-tables (one per category):

1. **§Messaging-Channels** (13 channels; WebChat **Complete**,
   12 Not planned).
2. **§AI-Model-Support** (7 models; 6 **Available** via Lal,
   Gemini not yet).
3. **§System-Access-Tools** (6 tools; 2 Designed, 4 Not).
4. **§Browser-Control** (6 features; all Not designed).
5. **§Productivity-Integrations** (7 services; all Not).
6. **§Smart-Home** (7 integrations; all Not).
7. **§Agent-Management** (7 features; 5 Available/Complete,
   1 Designed, 1 gap).
8. **§Persistence-and-Memory** (6 features; 3 Available/
   Complete, 3 gaps).
9. **§Voice-and-Media** (4 features; all Not designed).
10. **§Security-Model** (9 rows; OpenClaw 4 +/Endo 5 — §where-
    Endo-is-stronger-named-explicitly).
11. **§Companion-Apps** (4 apps; macOS Familiar Complete,
    iOS/Android Not, WebChat Complete).
12. **§Skills/Plugin-Ecosystem** (6 features; 3 Available,
    3 gaps).
13. **§Summary** (Already / Designed / Not-yet-designed
    bucketing).

§Each-table-has-three-or-four-columns: OpenClaw-feature +
Endo-equivalent + Status (+ optional Notes/Status-comment).

§The-§status-tags-are-named: **Complete**, **Available**,
**Designed** (with cross-link to the design), Not designed,
Not planned.

§Compare-to-cycle-180-hex-package's §three-way-classification-
of-sites (migration / boundary / non-byte-array). §Cycle-196-
endoclaw has §five-status-tags. §Both-are-§explicit-named-
status-bucketing patterns.

§Tier-1-borrowing: §thirteen-feature-categories-with-status-
matrix for §parity-comparison; §five-status-tags (Complete /
Available / Designed / Not designed / Not planned) cover the
§implementation-and-intent space.

## §Named-architectural-difference (ambient-vs-object-capability)

§The-design-anchors-on §one-load-bearing-difference: OpenClaw
grants agents ambient authority; Endo uses object-capability
discipline.

```
The fundamental architectural difference is the capability
model.  OpenClaw grants agents ambient authority — any tool
the agent calls operates with the user's full permissions.
Endo's object-capability model means agents hold only the
specific `Dir`, `Shell`, `Git`, and other capabilities
explicitly granted to them.  This is Endo's primary
differentiator for security.
```

§The-§§"fundamental architectural difference" phrase is the
§named-anchor for every comparison-row that follows. §Reader-
must-know-this-before-reading-the-tables.

§Compare-to-cycle-178-snapshot's §single-most-structurally-
interesting-move (§snapshot-as-internal-implementation-detail).
§Both-name-one-load-bearing-difference at the design's
opening; the rest of the design unfolds from that anchor.

§Compare-to-cycle-190-endo-posix-sandbox's §three-rules-of-
security-boundary-clarity. §Both-are-§named-security-
discipline-anchors; cycle 190 enumerates rules; cycle 196
names the §axis-of-disagreement.

§The-§§"primary differentiator for security" claim is repeated
in the Security-Model section with concrete attack examples:

```
OpenClaw's agent has ambient authority — it can read
`~/.ssh/id_rsa`, run `curl` to exfiltrate data, or modify
`~/.bashrc` for persistence.  Endo's object-capability model
makes these attacks structurally impossible: the agent
literally cannot name paths outside its granted `Dir` root,
cannot execute commands outside its `Shell` allowlist, and
cannot access network endpoints outside its granted scope.
```

§Three-named-attacks (~/.ssh/id_rsa + curl-exfiltration +
~/.bashrc-persistence) + §three-structural-defenses (Dir
confinement + Shell allowlist + network scope). §Symmetric-
enumeration.

§Compare-to-cycle-186-break-dev-deps' §three-cited-costs-of-
the-cycle (cosmetic noise + silent-by-default conflict +
weaker cache hash). §Both-are-§three-named-instances of an
underlying claim. §Cycle-186-on-process; cycle-196-on-attack-
surface.

## §Gap-priority-classification (High/Medium/Low)

```
| Gap                                                 | Priority | Notes                                               |
| Web Fetch and Search capability                     | High     | Basic fetch and search provider API usage           |
| Core workspace / memory system                      | High     | This is the core engine that contitues a claw       |
| Heartbeat Timer                                     | High     | This is the core "there" that makes a claw tick     |
| Chat Channel Bridge                                 | Medium   | At least for easy ones like Telegram                |
| Cron/scheduler capability                           | Medium   | Timer capability in bank taxonomy                   |
| Proactive agent outreach                            | Medium   | Agent-initiated messages, morning briefings         |
| Browser automation capability                       | Low      | Puppeteer/Playwright-backed `Browser` exo           |
| System notifications                                | Low      | Electron `Notification` API in Familiar             |
| Productivity integrations (Gmail, Calendar, Notion) | Low      | Guest plugins with OAuth capabilities               |
| Smart home integrations                             | Low      | Guest plugins with network capabilities             |
| Skill registry / marketplace                        | Low      | Index of community plugins                          |
| Voice input                                         | Low      | Web Speech API in Chat UI                           |
| Mobile companion apps                               | Low      | iOS/Android; browser-based mobile access is interim |
```

§Thirteen-gaps-each-with-priority-and-note. §High-priority-
three: §Web-Fetch-and-Search + §Core-workspace/memory +
§Heartbeat-Timer. §These-are-the-§§"core engine that
constitutes a claw" and §§"core there that makes a claw tick"
items.

§The-§§"core engine that contitues a claw" (sic — "contitues"
is a typo in the design itself; the original is preserved
here without correction) names the §domain-specific-vocabulary.
§§"a claw" is the OpenClaw user's mental model of a personal
agent.

§Three-medium-priority-gaps: Chat-Channel-Bridge + Cron/
scheduler + Proactive-agent-outreach. §These-make-the-claw-
useful-not-merely-functional.

§Seven-low-priority-gaps: Browser + Notifications +
Productivity + Smart-home + Skill-registry + Voice + Mobile-
apps. §These-are-the-§nice-to-have-extensions.

§Compare-to-cycle-180-hex-package's §five-phases-mostly-S +
cycle 184-metering's §seven-phases-all-Complete. §Cycle-196-
priority-tier-not-phase-numbered. §The-gap-list-doesn't-have-
ordered-phases; it has §thematic-priorities.

§Tier-1-borrowing: §High/Medium/Low priority classification
with §one-line-note-per-gap for §lightweight-roadmap-shaping.

## §Editor-attribution (Kris-Kowal-prompted + Joshua-T-Corbin-edited)

§The-metadata-has-two-authors. §Kris-Kowal-(prompted) generated
the initial document; §Joshua-T-Corbin-(edited) added
substantive editorial revisions visible in the source as
§§"> Josh:" quote blocks.

§Five-§Josh-quote-blocks appear inline:

1. **Browser**: "Only need a full-fat browser to evade
   countermeasures like Anubis... To get started, all we
   need is a pair of `web_fetch` and `web_search` tools..."
2. **Smart-home**: "if we're going to even sketch a thing
   on the roadmap, start with Home Assistant rather than any
   one of the vendor platforms..."
3. **Agent-Management**: "I'm really not convinced that the
   claw notion of session is 1:1 with our chat spaces"
4. **Persistence**: "whatever else we do internally, message
   history (sessions) should get stored as Pi-compatible
   jsonl files..."
5. **Soul/Identity**: "insufficient, the claw's soul,
   identity, memory file(s) need to be part of its mutable
   workspace so that it can 'evolve'..."
6. **Security**: "other claws like LocalGPT, PicoClaw, and
   IronClaw at least implement system level sandboxing..."
7. **Voice-and-Media**: three separate `> Josh:` quotes
   linking external resources and noting attachment-not-just-
   images-eh.

§The-§inline-editorial-disagreement is preserved-not-resolved
in the design. §The-§"insufficient" comment names a
disagreement: Kris named SOUL.md as available; Josh says the
agent's identity/memory file needs to be in mutable workspace
for self-modification.

§Compare-to-cycle-178-snapshot's §revised-scope-discussion-
2026-04-15 and cycle 192-engo's §honest-design-evolution.
§Cycle-196-endoclaw-preserves-the-iteration as §inline-co-
author-quotes rather than as §a-section-named-revised-scope.

§Tier-1-borrowing: §inline-co-author-quote-blocks (`> Josh:`
prefix) as §record-of-editorial-disagreement-without-
flattening. §Future-readers-see-both-perspectives.

## §The-§OpenClaw-history (footnote-shaped attribution)

```
OpenClaw (formerly ClawdBot, formerly Moltbot) is a free and
open-source personal AI assistant created by Peter
Steinberger.
```

§Three-names-for-the-same-tool: OpenClaw + ClawdBot +
Moltbot. §The-history-named-in-parenthetical-aside. §A-future-
reader-searching-for-any-of-the-three-finds-this-document.

§Compare-to-cycle-180-hex-package's §sibling-extract-pattern
naming cycle 172-bytes + cycle 174-gateway. §Cycle-180-names-
prior-Endo-designs; §cycle-196-names-prior-non-Endo-tool-
names.

§The-§three-rename-history pattern is sibling to §cycle-49-
daemon-locator-terminology's locator-rename-design (Endo's
own §rename-history-preserved-as-design). §Both-record-the-
sequence-of-names for future readers.

## §The-§§"Endo-specific advantages (no OpenClaw equivalent)"

```
- **Object-capability confinement:** Agents cannot exceed granted authority
- **Interface guards:** Machine-readable method contracts enforce valid calls
- **Caretaker revocation:** Host can revoke any capability instantly
- **Structural filesystem confinement:** Cannot name paths outside granted root
- **Hardened JavaScript (SES):** Frozen primordials prevent prototype pollution
- **Formula-based persistence:** Typed, graph-structured durable state
- **Locator-based identity:** 256-bit cryptographic agent identifiers
```

§Seven-named-Endo-advantages, each phrased as a §named-
property + §one-line-explanation.

§This-is-the-§positive-side of the parity-comparison: not
just "what OpenClaw has that Endo doesn't" but "what Endo
has that OpenClaw doesn't." §The-symmetry-makes-the-
comparison-honest.

§Compare-to-cycle-178-snapshot's §two-named-use-cases (suspend-
idle-agents + checkpoint-long-computations) + cycle-180-hex-
package's §three-concrete-costs-of-duplication. §All-three-
are-§enumerated-named-positive-claims.

§Compare-to-cycle-190-endo-posix-sandbox's §six-non-goals
(scope-clarification-via-negation). §Cycle-196-symmetric:
§seven-Endo-advantages (positive enumeration) + the §thirteen-
gaps (negative enumeration).

§Tier-1-borrowing: §seven-named-advantages-with-one-line-
explanation for §positive-side-of-parity-comparison.

## §The-§Related-Designs-section (cross-link discipline)

```
## Related Designs

- [daemon-agent-tools](daemon-agent-tools.md) — Claw-like coding tools
- [daemon-capability-filesystem](daemon-capability-filesystem.md) — `Dir`/`File` capabilities
- [daemon-capability-bank](daemon-capability-bank.md) — Capability category taxonomy
- [lal-fae-form-provisioning](lal-fae-form-provisioning.md) — Form-based agent setup
- [familiar-bundled-agents](familiar-bundled-agents.md) — Bundled agents in Familiar
- [daemon-docker-selfhost](daemon-docker-selfhost.md) — Docker self-hosting
- [gateway-bearer-token-auth](gateway-bearer-token-auth.md) — Remote gateway auth
```

§Seven-cross-links to other designs. §Each-line-has §name +
§one-line-description. §This-is-the-§hub-design-pattern: the
Reference-status design connects to multiple concrete design
slices.

§Cycle-170-daemon-capability-filesystem also had §named-
relationships (§six-named-relationships in Endo-already-has-
this-pattern section). §Both-Reference-status-designs serve
as §hubs for §concrete-implementable-slices.

§Compare-to-cycle-188-perf's §working-copy-inventory mapping
uncommitted change clusters to design documents. §Cycle-196-
endoclaw's Related-Designs section is §the-shipped-equivalent:
a navigation-aid from this Reference document to the
concrete slices that implement parts of the parity story.

§Tier-1-borrowing: §Related-Designs-section-with-one-line-
descriptions for §Reference-status-designs as §hub-and-spoke
navigation.

## §The-§§"Available" vs §§"Complete" status distinction

§The-status-tags-include-both-§§"Available" and-§§"Complete".
§What's-the-difference?

Reading the design:

- **§§"Available"**: the feature exists in Endo, can be
  used by callers (e.g., "Multi-agent routing" in Agent-
  Management table).
- **§§"Complete"**: the feature is shipped + tested + the
  primary path callers reach for (e.g., "WebChat" → "Chat UI
  packages/chat").

§The-distinction-is-subtle-but-named-implicitly through
usage. §Complete-implies-finished; Available-implies-usable-
even-if-still-evolving.

§Compare-to-cycle-188-perf's §seven-distinct-design-lifecycle-
statuses (Complete / In Progress / Proposed / Active /
Reference / Implemented / Not Started). §Cycle-196-uses-five-
status-tags within the feature-tables (a different vocabulary
for feature-completeness rather than design-lifecycle).

§Tier-1-borrowing: §status-tag-vocabulary-for-feature-tables
distinct from §design-lifecycle-status. §Available + Complete
+ Designed + Not designed + Not planned are §feature-
implementation-states; not design-document-states.

## §The-§§"Not planned" status (the §scope-refusal)

§Many-tables-mark-OpenClaw-features as Not planned. §This-is-
the-§scope-refusal-named-explicitly: §we-considered-this-and-
chose-not-to-do-it.

§Twelve-of-thirteen messaging-channels are Not planned (only
WebChat is Complete). §The-design-makes-the-§scope-refusal-
visible: messaging-channel-bridges-to-external-platforms-are-
not-on-the-roadmap.

§The-§explicit-not-planned discipline is sibling to cycle
190-endo-posix-sandbox's §six-non-goals-explicitly-named.
§Both-are-§scope-clarification-via-explicit-refusal.

§Compare-to-cycle-180-hex-package's §five-known-gaps-with-
add-if-a-consumer-asks. §Cycle-196's Not planned is §a-
stronger-refusal than known-gap; §"add if a consumer asks"
implies a path; Not planned implies no plan.

## §The-§External-link-attribution (Anubis + Home Assistant + Voxtral)

```
> Josh: Only need a full-fat browser to evade countermeasures like [Anubis][anubis].

[anubis]: https://github.com/TecharoHQ/anubis

> Josh: if we're going to even sketch a thing on the roadmap, start with [Home Assistant][homeass]

[homeass]: https://www.home-assistant.io/

> Josh: <https://github.com/TrevorS/voxtral-mini-realtime-rs>
```

§Three-external-links named in Josh-quote-blocks. §Each-link-
has §a-named-anchor (Anubis, homeass, autolink). §Markdown-
reference-style-links keep the inline prose readable.

§Compare-to-cycle-189-marshal-justin's §URL-attribution to
a TC39 YouTube discussion. §Cycle-196-endoclaw-cites-three-
URLs in §inline-co-author-quotes. §Different-shape-same-
discipline.

## §Cohesion notes

- §Parity-comparison-as-design-document-genre is the
  §Reference-status pattern for inventorying prior-art
  features against an Endo equivalent.
- §Thirteen-feature-categories with §status-matrix per
  category (OpenClaw-feature + Endo-equivalent + Status).
- §Five-status-tags (Complete / Available / Designed / Not
  designed / Not planned) cover the §implementation-and-
  intent space.
- §Honest-architectural-difference-named (ambient-vs-object-
  capability) is the design's §load-bearing-anchor.
- §Gap-priority-classification (High/Medium/Low) with §one-
  line-note-per-gap for §lightweight-roadmap-shaping.
- §Three-High-priority gaps (Web-Fetch-and-Search + Core-
  workspace-memory + Heartbeat-Timer) named as §"core engine"
  and §"core there that makes a claw tick".
- §Inline-co-author-quote-blocks (`> Josh:` prefix; seven
  blocks total) preserve §editorial-disagreement-without-
  flattening.
- §Three-rename-history (OpenClaw + ClawdBot + Moltbot)
  named in parenthetical-aside for future-reader-searching.
- §Seven-Endo-specific-advantages with §one-line-explanation
  for §positive-side-of-parity-comparison.
- §Seven-Related-Designs cross-links as §hub-and-spoke
  navigation from Reference to concrete slices.
- §Three-named-attacks (~/.ssh/id_rsa + curl-exfiltration +
  ~/.bashrc-persistence) + §three-structural-defenses for
  §symmetric-attack/defense-enumeration.
- §The-§"Available"-vs-§"Complete" status distinction is
  subtle-but-named-implicitly through usage.
- §Twelve-of-thirteen messaging-channels Not planned —
  §explicit-scope-refusal at the table level.
- §Three-external-links in Josh-quotes (Anubis + Home
  Assistant + Voxtral) using §markdown-reference-style.

## §Tier-1 borrowing

- §parity-comparison-as-design-document-genre (Reference-
  status; inventory prior-art against equivalents)
- §thirteen-feature-categories-with-status-matrix
- §five-status-tags (Complete / Available / Designed / Not
  designed / Not planned)
- §honest-architectural-difference-named at design's
  opening (load-bearing-anchor)
- §gap-priority-classification (High/Medium/Low) with one-
  line-note-per-gap
- §inline-co-author-quote-blocks (`> Josh:`) for editorial-
  disagreement-preserved
- §three-rename-history-in-parenthetical-aside for prior-
  art with multiple names
- §seven-named-advantages-with-one-line-explanation (positive
  side of parity)
- §Related-Designs-section-with-one-line-descriptions for
  Reference-status hub
- §symmetric-attack/defense-enumeration
- §explicit-scope-refusal at table-level (Not planned)
- §markdown-reference-style for external-link-attribution

## §Synthesis-target

The §slot-machine-library's prior-art-comparison (if any)
can §borrow-the-parity-comparison-as-design-document-genre
directly. §Thirteen-feature-categories + §five-status-tags +
§gap-priority-classification + §one-named-architectural-
anchor is the canonical recipe.

§The-§inline-co-author-quote-block pattern is borrowable for
any §multi-author-design that wants to preserve §editorial-
disagreement-without-resolution. §Future-readers see both
perspectives; the design isn't flattened to one voice.

§The-§Reference-status with §Related-Designs hub-and-spoke
navigation is borrowable for any §inventory-document that
informs but doesn't propose. §Concrete-design-slices linked
from the Reference doc become the §implementation-path.
