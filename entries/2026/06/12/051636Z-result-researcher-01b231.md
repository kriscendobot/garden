---
ts: 2026-06-12T05:16:36Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - dispatches/researcher--01b231
---

The proposed designer prompt drafts `designs/chat-value-modal-formula-view.md` on the `llm` branch of `endojs/endo-but-for-bots`: a card-flip affordance on the Chat application's Value modal that reveals a per-formula-type Formula view, with each property rendered either as literal data or as a button (named after the property) that flips back to Show Value for the referenced identifier. The refinement grounds the downstream designer in three load-bearing prior designs (`formula-inspector`, `chat-command-bar` Value modal, `inventory-grouping-by-type`), in the chat-UI invariants the design must honor (six MUST-hold invariants, especially keyboard-manual parity and Escape consistency), and in the 26-formula-type taxonomy from `daemon-256-bit-identifiers.md` that the per-type layout taxonomy fans out from.

```markdown
## Library and project references

### Library concepts and sections

**Formula inspector (the direct precedent for this design).**

- [`journal/library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md`](../../library/sections/endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal.md) — the *Not Started* `designs/formula-inspector.md` already names "pop the bonnet on pet-named capabilities", the 26-formula-type-specific metadata catalog (`eval` → endowments+source+worker; `lookup` → hub+path; `guest` → hostAgent+hostHandle; `make-bundle` → bundle+powers+worker; `make-unconfined` → powers+specifier+worker; `peer` → NODE+ADDRESSES; others → empty), and the §formula-references-as-clickable-links discipline ("navigate to the referenced formula's inspector view"). *The proposed design is a chat-UI-specific specialization of this design's substrate.* The designer must decide and record whether to (a) supersede / merge with `formula-inspector.md`, (b) cite it as the precedent and frame the new design as the UI surface for the same substrate, or (c) author the new design as independent. The §`InspectorHub.lookup(petName)` API and `packages/daemon/src/daemon.js` lines 3210-3319 (`makePetStoreInspector`) already surface most of the type-specific metadata the design needs.

**The current Value modal (the front face the design extends).**

- [`journal/library/sections/endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states.md`](../../library/sections/endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states.md) — the four value-states (Has ID + pet names, Has ID + no pet names, Has message context, Ephemeral) and the three modal actions (Close / Save / Enter Profile). The card-flip adds a fourth action (Flip-to-Formula) and a back-face mode. The §`Enter Profile` keyboard-parity-gap note is precedent for an *acknowledged parity gap* — the new design should not introduce a new gap silently; if the flip control lacks a keyboard equivalent, name it explicitly per the existing precedent.

**The 26-formula-type catalog (substrate for the layout taxonomy).**

- [`journal/library/sections/endo-but-for-bots--llm-designs-d256--formula-types-and-security.md`](../../library/sections/endo-but-for-bots--llm-designs-d256--formula-types-and-security.md) — the complete list of 26 formula types from `packages/daemon/src/formula-type.js`: `directory`, `endo`, `eval`, `guest`, `handle`, `host`, `invitation`, `keypair`, `known-peers-store`, `least-authority`, `lookup`, `loopback-network`, `mail-hub`, `mailbox-store`, `make-bundle`, `make-unconfined`, `marshal`, `message`, `peer`, `pet-inspector`, `pet-store`, `promise`, `readable-blob`, `resolver`, `worker` (plus `eval` listed in two forms). Categorized in this section as: Identity/agency, Naming/lookup, Messaging, Execution, Promises, Content, Network, Policy, Root. The proposed design's *Formula-view layout taxonomy* should align with (or explicitly diverge from) this categorization; the prompt's enumeration (`evaluate`, `worker`, `host`/`guest`, `directory`/`pet-store`, `readable-blob`/`readable-tree`) covers about half the catalog, so the design must either enumerate all 26 or defer the remainder with a named rationale.

**Inventory-grouping-by-type (the related Chat-side type-aware surface).**

- [`journal/library/sections/endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections.md`](../../library/sections/endo-but-for-bots--llm-designs-inventory-grouping-by-type--Group-table-and-Options-Considered-with-preferred-and-additive-API-change-and-five-Considerations-sections.md) — the *Not Started* sibling design that extends `followNameChanges()` events with a `type` field (preferred over a new `identifyType(petName)` method) and groups the inventory by formula type (Handles / Hubs / Workers / Everything Else). *The Formula-view design likely reuses that same `type` field on the daemon's existing `identify()` / `followNameChanges` shape* rather than introducing a new method — the additive-API-change-via-destructure-immune-consumers discipline applies. The design should also adopt the same Five Considerations sections (Security + Scaling + Test Plan + Compatibility + Upgrade), the Options-Considered-with-preferred shape (this author's recurring template), and the substrate-count-named-as-evidence-of-categorization-scope discipline (name the 26 types' count when categorizing).

**Chat invariants (the design MUST honor these six).**

- [`journal/library/sections/endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants.md`](../../library/sections/endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants.md) — six MUST-hold UI invariants: Modeline completeness, Keyboard-manual parity, State visibility, Escape consistency, Progressive complexity, plus one more. Direct consequences for the design:
  - **Keyboard-manual parity**: the flip control needs both a keyboard shortcut *and* a clickable button. If no keyboard equivalent is possible, the design must name the parity gap explicitly (the Enter-Profile precedent applies).
  - **Escape consistency**: Escape on the back face — does it return to the front face, or close the modal? The design must pick one; the section's table ("Any modal → Close and return to previous state") favors close-and-return, but a stack-aware navigation may want a stepwise back.
  - **State visibility**: the user must always know which face they are on; the title bar's identity-surface render (front face) and the formula-type title (back face) discriminate visually.
  - **Modeline completeness**: every keyboard action available on both faces must be hinted in the modeline (Flip, Close, Save, plus any reference-button activation).

**Inventory panel + value-modal entry points (where the user lands the front face from).**

- [`journal/library/sections/endo-but-for-bots--llm-designs-chat-components--inventory-and-messages.md`](../../library/sections/endo-but-for-bots--llm-designs-chat-components--inventory-and-messages.md) — the four entry points to the value modal (token chips, attachments, inventory name clicks, command-bar token-only state). The Formula view's back-to-value-by-identifier navigation should integrate with these existing entry points: navigating to an identifier should land the user on the front face of the modal for that value, indistinguishable from clicking the corresponding token chip.

### Project context

**Project rules and standing authorizations.**

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Rules of engagement: design PRs land as DRAFT against the `llm` branch; implementation PRs are separate dispatches against `master`; the two are never combined. The designer dispatch opens a DRAFT PR against `llm`.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Standing authorizations: the bot is "generally authorized to post freely on endo-but-for-bots"; no per-action authorization is needed for the DRAFT PR open, inline comments, or cross-references on this repo.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Authority structure: every commenter on `endojs/endo-but-for-bots` is maintainer-equivalent (kriskowal, kumavis, erights, danfinlay, 0xpatrick, jcorbin are named non-exhaustively); `CHANGES_REQUESTED` from any reviewer routes through the normal fixer dispatch.

**Related designs in the project's `designs/` tree (on the `llm` branch).**

- `designs/formula-inspector.md` — *Not Started*, 110 lines (per the formula-inspector section ingest). The designer must explicitly resolve overlap with this design (supersede / cite-as-precedent / author-as-independent — see *Open questions* below).
- `designs/chat-command-bar.md` § Value modal — the existing four-state Value modal the design extends.
- `designs/chat-components.md` § Inventory panel / Message display — the four entry points to the modal.
- `designs/chat-invariants.md` — the six MUST-hold invariants.
- `designs/inventory-grouping-by-type.md` — *Not Started*; the related type-aware Chat surface and the daemon-API extension (`type` field on `followNameChanges` events) the Formula view likely reuses.
- `designs/daemon-256-bit-identifiers.md` — the 26-formula-type catalog reference.
- `designs/daemon-mount.md` — defines two of the formula types the layout taxonomy must cover (`mount` and `scratch-mount`), neither of which the proposed prompt enumerates explicitly.

### Why each reference is relevant (half-line per citation)

- `formula-inspector` section: the direct precedent — same substrate (per-type metadata), same navigation idiom (clickable formula references), open question of supersede vs. cite.
- `chat-command-bar` Value modal section: the front face the design extends; the Enter-Profile keyboard-parity-gap precedent.
- `d256` formula-types section: the canonical 26-type list and category groupings the layout taxonomy must address or defer.
- `inventory-grouping-by-type` section: the daemon-API extension and design-doc template (Five Considerations + Options-Considered-with-preferred) the new design likely reuses.
- `chat-invariants` overview: six MUST-hold rules that directly constrain the flip affordance, Escape behavior, and modeline coverage.
- `chat-components` inventory-and-messages section: the four existing entry points to the modal — the back-to-value navigation must land users in a state indistinguishable from these.
- Project README rules/authorizations/authority: DRAFT-against-`llm` discipline; no per-action authorization needed; every commenter is maintainer-equivalent.

### Open questions for the designer (or for the librarian to grow)

1. **Supersede vs. specialize `designs/formula-inspector.md`?** The existing design covers the substrate (per-type metadata + clickable formula references + retention-path reveal) but predates the Chat Value modal as the surface. The designer must pick: (a) merge into `formula-inspector.md` (rename / extend), (b) author `chat-value-modal-formula-view.md` and cite `formula-inspector.md` as the underlying-substrate design, or (c) supersede `formula-inspector.md` outright (its CLI-mirror and edit-toggle disciplines would need to migrate or be deferred). The prompt favors (b) by the file-name choice, but the overlap is large enough that the design must state the choice explicitly under *Cross-design coordination*.
2. **Navigation-stack vs. replace.** The prompt names this as an open question. The library has no prior chat-side back-stack precedent — `chat-components` § profile breadcrumb and `chat-focus-message` § navigation cover related but not modal-navigation patterns. The librarian may want to grow a concept page on this.
3. **Card-flip animation precedent.** The library has no existing card-flip affordance in the chat UI (no section matches "card flip" or "modal flip"). The pending-commands design has *card states* but not flips. The design is introducing a novel UI affordance; cite no precedent and surface the choice (animation register, reduced-motion fallback) as a first-instance decision.
4. **Reference-to-promise rendering.** The 26-type catalog includes `promise` and `resolver`; a reference whose target is a `promise` formula has additional state (pending / fulfilled / rejected). The design should name a status-aware control for promise-typed references.
5. **Cycle handling.** A formula's reference chain can return to the originating value (e.g., a `directory` that retains a `pet-store` that retains the same `directory`). The design should name a cycle-detection convention for the back-stack and the reference-button render.

### Library writeback

- Added three keyword shortcuts to [`journal/library/keywords.md`](../../library/keywords.md):
  - `Formula view of a value` → `formula-inspector` section.
  - `flip the modal card` → `chat-command-bar` value-modal section.
  - `literal vs reference property` → `formula-inspector` section.
- No concept-page drafts or section prunings this engagement. The card-flip and navigation-stack gaps are surfaced as open questions for the librarian rather than back-filled from a single design's terminology.

Self-improvement: nothing this time.
```

## Library writeback

- Added three keyword shortcuts to `journal/library/keywords.md`:
  - `Formula view of a value` | (see section: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal)
  - `flip the modal card` | (see section: endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states)
  - `literal vs reference property` | (see section: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal)

No concept-page drafts or section prunings this engagement.

## Open questions

- **No card-flip precedent in the library.** Searching the library's keywords, sections, and chat-cluster designs surfaces no prior card-flip affordance (the only "flip" matches are status-flip and a marshal-format default-flip, neither of which is a UI card). The design is introducing a novel UI affordance; this is a candidate for a future concept page once the design's animation / accessibility shape settles.
- **No chat-side modal navigation-stack precedent.** The library has profile-breadcrumb and chat-focus-message navigation, neither of which is a modal back-stack. If the design picks the stack option, the librarian may want to grow a concept page from the resulting design.
- **`designs/formula-inspector.md` overlap unresolved at the library layer.** The relationship between `formula-inspector.md` (substrate) and the proposed `chat-value-modal-formula-view.md` (UI surface) is large enough that the librarian may want to cross-link the two once the new design lands, or, if the designer chooses to supersede, prune the formula-inspector section into the new one's source slug.

Self-improvement: nothing this time.
