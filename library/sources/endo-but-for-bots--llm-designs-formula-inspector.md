---
source: designs/formula-inspector.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 069d5ecbf79d90409069cfe72ed0c54e79c7bc77
source_date: 2026-02-14
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-fourth-comment-style design ingest (cycle 145 pivot
  after duplicate-skip of gateway-bearer-token-auth, ingested
  2026-05-14). Small 110-line *Not Started* status design by
  Kris Kowal *(prompted)*, created 2026-02-14 / updated
  2026-02-24.

  Subject: *popping the bonnet* on pet-named capabilities —
  surface the daemon's 26-formula-type structure to the user
  so they can see the formula graph below each capability.

  Single most structurally interesting move: §load-bearing-
  metaphor *popping the bonnet*. The §pet-name-hides-the-
  formula observation: the chat UI shows only the *rendered
  value* of each capability; the daemon storage holds a
  *richer formula structure* — 26 types with fields like
  `worker`, `source`, `endowments`, `hub`, `path`. The
  inspector surfaces the second layer to advanced users.

  §26-formula-types-with-type-specific-metadata: six concrete
  shapes listed (eval / lookup / guest / make-bundle / make-
  unconfined / peer) with field-by-field metadata. The
  §`InspectorHub.lookup(petName)` API *already* returns this
  metadata; the design's add is mostly UI. §`makePetStoreInspector`
  reference at `packages/daemon/src/daemon.js` 3210-3319.

  §Formula-references-as-clickable-links discipline: the UI
  renders formula identifier references as clickable links
  navigating to that referenced formula's inspector. The
  §formula-graph-as-hypertext idiom + §navigation-via-formula-
  identifiers. Combined with retention-path reveal gives a
  complete *navigability story* over persistent state.

  §Edit-toggle-with-revise-API discipline: §read-only-default
  + opt-in edit toggle. The new daemon method `E(agent).revise
  (petName, patch) → revised-formula-identifier` validates
  formula invariants before persisting (a `worker` field must
  reference a valid worker formula).

  §Retention-path-reveal facility ties to cycle 49's
  retention-path-notation cluster. *Every retention path in
  the formula graph for identified formulas*. §why-retention-
  paths-matter: removing the last retention path GCs the
  formula; showing paths in inspector tells the user *exactly
  which removals lose the capability*.

  §CLI-mirror: `endo inspect <name>` prints formula JSON. The
  §two-surfaces-one-API discipline (same InspectorHub.lookup
  data backs both UI and CLI).

  §Security-gated-edit: host-level authority required for
  `revise()`; audit trail on every call. §Inspection-vs-
  editing-security-asymmetry — inspection visible to owner;
  editing host-level only.

  §Three-affected-packages partition: daemon (data + revise
  API) / chat (visual inspection) / cli (JSON output). The
  §thin-API-thick-UI principle — daemon adds *one* method.

  §Not-Started-design-as-roadmap shape. §Existing-API-leverage
  observation: most data already available via
  InspectorHub.lookup — implementation path is *additive* on
  existing infrastructure. §Maybe-prefix-on-tests discipline
  is honest about test-scope uncertainty.

  Cycle 145 was nominally papers-lane (cycle 144 was
  comments). Papers-lane has been blocked for 39+ consecutive
  cycles. Cycle 145 pivoted to designs-lane after duplicate-
  skip of gateway-bearer-token-auth.
---

> Abstract: `formula-inspector.md` (110 lines, *Not Started*)
> is a small structurally clear "popping-the-bonnet" debug-
> tool design. Sits between daemon internals and chat UI.
> Surfaces daemon's 26-formula-type structure so users can
> *see* what's behind each pet-named capability — and
> optionally edit it.
>
> **The §load-bearing-metaphor**: *popping the bonnet*. The
> §pet-name-hides-the-formula observation: chat UI shows
> *rendered value*; daemon storage holds *richer formula
> structure*. Inspector surfaces the second layer.
>
> §26-formula-types-with-type-specific-metadata: existing
> `InspectorHub.lookup(petName)` API surfaces it.
> §Formula-references-as-clickable-links: navigate the
> formula graph by chasing references. §Formula-graph-as-
> hypertext.
>
> §Edit-toggle-with-revise-API: `E(agent).revise(petName,
> patch)` validates formula invariants before persisting.
> Host-level only; audit trail.
>
> §Retention-path-reveal facility ties to cycle 49's
> retention-path-notation. *Every retention path in the
> formula graph for identified formulas*.
>
> §CLI-mirror (`endo inspect <name>` → JSON). §Two-surfaces-
> one-API.
>
> §Three-affected-packages partition (daemon + chat + cli)
> with §thin-API-thick-UI principle. §Not-Started-design-as-
> roadmap. §Existing-API-leverage (most data already
> available via InspectorHub.lookup → additive implementation
> path).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal](../sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md) | daemon, agent-conventions, tooling | current |

Tight 110-line *Not Started* design. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@069d5ecbf`
  (branch `origin/llm`) via the local bare-clone.
- Created 2026-02-14 / updated 2026-02-24 / status *Not
  Started*. Author Kris Kowal *(prompted)*.
- Cycle 145 was nominally **papers-lane** (cycle 144 was
  comments). Papers-lane has been blocked for **39+
  consecutive cycles** due to lack of PDF-fetching
  infrastructure.
- Cycle 145 originally targeted `gateway-bearer-token-auth.md`
  but the duplicate-check discipline caught: that source was
  already ingested 2026-05-14 with 3 sections under slugs
  `endo-but-for-bots--llm-designs-gbta--*`. Pivoted to
  `formula-inspector.md`.
- One cohesion-honest section.
