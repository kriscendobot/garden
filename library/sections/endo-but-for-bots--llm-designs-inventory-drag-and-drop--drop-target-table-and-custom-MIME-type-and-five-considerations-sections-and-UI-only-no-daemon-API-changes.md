---
title: "designs/inventory-drag-and-drop.md — Drop-target table + custom MIME type + five Considerations sections + UI-only no daemon API changes"
source-slug: endo-but-for-bots--llm-designs-inventory-drag-and-drop
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/inventory-drag-and-drop.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/inventory-drag-and-drop.md
total-lines: 99
ingest-cycle: 248
ingest-date: 2026-06-08
lane: designs
---

# Drop-target table + custom MIME type + five Considerations sections + UI-only no daemon API changes

A 99-line **Not Started** design (Created 2026-02-14; Updated 2026-02-24). Implements HTML5 drag-and-drop on inventory items in the chat UI. The design is §UI-only — §all-necessary-daemon-API-methods-already-exist.

## §UI-only — no daemon API changes

§Implementation-Notes: *All necessary daemon API methods already exist*. The design enumerates four-existing-daemon-API-methods (copy + move + send + remove) and §names-the-file-each-lives-in. §No-daemon-API-changes-needed — §all-operations-use-existing-methods.

§Eleven-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248). §When-a-UI-feature-could-be-implemented-by-adding-new-daemon-methods-or-by-reusing-existing-ones, §reuse-the-existing-ones + §the-UI-IS-the-presentation-layer-not-the-new-substrate.

§Sibling-pattern-to-cycle-246's-inbox-delivery (webhook payloads through existing mail system) — §two-cycles-with-explicit-no-new-daemon-API-changes-as-named-discipline. §The-UI-or-the-event-delivery-layer-IS-the-only-new-code-needed.

## §Drop-target table — three columns

```
| Target | Action | Daemon API Call |
|--------|--------|-----------------|
| Directory item (expandable) | Copy capability into directory | `E(agent).copy(sourcePath, [targetDir, itemName])` |
| Agent/guest handle | Send capability to agent | `E(agent).send(targetAgent, strings, edgeNames, petNames)` |
| PINS section (work item 003) | Pin the capability | `E(agent).pin(petName)` |
| Trash/dismiss zone | Remove from inventory | `E(agent).remove(petName)` |
```

§Four-named-drop-targets + §each-row-has-the-action-and-the-existing-daemon-API-call. §The-table-IS-the-mapping-from-UI-target-to-daemon-API-call. §When-a-UI-feature-dispatches-to-existing-API-methods, §the-table-IS-the-dispatch-table + §the-design-IS-the-mapping-not-the-implementation.

§Sibling-pattern-to-cycle-238's-method-placement-table (which methods sit on which facet) — §two-different-shapes-of-dispatch-table: §cycle-238 maps methods to facets + §cycle-248 maps UI-targets to daemon-API-calls. §Two-cycles-with-explicit-dispatch-table-as-the-design.

§Three-cycles-with-explicit-dispatch-or-method-placement-table (238 + 240 method-placement + 248 drop-target). §The-table-IS-the-mechanism-of-decoupling-between-the-presentation-and-the-substrate.

## §Custom MIME type for drag payload

§The-drag-data-payload-includes-the-pet-name-path-as-both-`text/plain`-AND-`application/x-endo-petname`. §Two-MIME-types-on-drag-data: §`text/plain` for legacy compatibility + §`application/x-endo-petname` for type-safe Endo-aware drop targets.

§The-custom-MIME-type-IS-the-discriminator — §a-drop-target-that-only-accepts-Endo-pet-names-can-check-the-custom-MIME-type + §plain-text-drops-from-other-applications-don't-trigger-Endo-handlers. §First-explicit-observation in library of §custom-MIME-type-as-discriminator-on-HTML5-drag-payload.

§The-`x-endo-`-prefix follows the §custom-MIME-type-convention for non-IANA-registered types. §When-a-design-extends-an-HTML5-API-with-application-specific-type-information, §define-a-custom-MIME-type-with-the-`x-`-prefix-or-the-`application/vnd.`-prefix.

§Sibling-pattern-to-cycle-246's-`X-Hub-Signature-256`-and-`Stripe-Signature` (named external headers) — §two-cycles-with-explicit-protocol-string-conventions: §cycle-246 cites external service headers + §cycle-248 defines an application-specific MIME type.

## §Five Considerations sections — named scope discipline

§The-design-has-five-named-Considerations-sections:

1. **Security Considerations** — three named threats (privilege escalation + accidental drops + non-atomic moves).
2. **Scaling Considerations** — two named concerns (no daemon impact + large inventory virtualized rendering deferred).
3. **Test Plan** — five named tests (three manual UI + one automated + one no-drop-cursor verification).
4. **Compatibility Considerations** — two named facts (pure UI change + HTML5 broadly supported).
5. **Upgrade Considerations** — `None`.

§Five-Considerations-sections as named design-doc shape. §First-explicit-observation in library of §five-named-Considerations-sections-as-implementation-spec-shape (Security + Scaling + Test Plan + Compatibility + Upgrade).

§Empty-considerations-section-acknowledged-explicitly — §Upgrade-Considerations is "None"; §the-design-explicitly-says-`None`-not-omits-the-section + §the-acknowledgment-IS-the-completeness-signal. §When-a-named-section-has-no-content, §explicitly-say-`None`-not-omit + §the-reader-knows-the-author-considered-and-found-nothing.

§Sibling-pattern-to-cycle-244's-Deviations-from-design as named Status subsection — §two-cycles-with-explicit-acknowledgment-of-something-not-needing-content. §Cycle-244-names-deviations + §cycle-248-names-the-absence-of-upgrade-concerns.

## §Default copy + Alt-to-move (modifier-key disambiguation)

§The-Interaction-Details-section names §two-default-modifier-key-behaviors:

- **Default**: drop = copy.
- **Alt/Option held during drop**: drop = move (copies then removes the source name).

§Two-default-modifier-behaviors-with-named-default-and-named-override. §The-default-IS-the-safer-non-destructive-action + §the-modifier-IS-the-destructive-explicit-action. §When-a-UI-action-could-be-destructive-or-non-destructive, §default-to-non-destructive + §require-a-modifier-for-the-destructive-form.

§Sibling-pattern-to-cycle-244's-default-resolve-on-timeout-not-default-reschedule — §two-cycles-with-the-default-IS-the-safer-or-forward-progress-choice. §Cycle-244's-default-is-forward-progress; §cycle-248's-default-is-non-destructive-copy.

§First-explicit-observation in library of §modifier-key-disambiguation-on-drop-action as named UI pattern.

## §Move operations not atomic — acknowledged

§The-Security-Considerations-section explicitly names: *Move operations (copy + remove) are not atomic; a failure after copy but before remove could leave a duplicate. This matches the existing CLI `endo mv` behavior.*

§Acknowledged-non-atomic-move-with-named-existing-behavior. §When-a-new-UI-feature-inherits-a-known-non-atomic-behavior-from-the-existing-substrate, §name-the-non-atomic-behavior-explicitly-in-Security-Considerations + §match-the-existing-behavior-not-fix-it-as-part-of-this-feature.

§Sibling-pattern-to-cycle-245's-TODO-names-a-known-confusing-case — §two-cycles-with-explicit-acknowledgment-of-a-known-imperfection-not-fixed-in-this-design (cycle 245 TODO + cycle 248 non-atomic-move).

## §Multi-select as stretch goal — named scope deferral

§Multi-select: Consider supporting shift-click or ctrl-click to select multiple items for batch drag operations (stretch goal). §The-`stretch goal`-annotation IS the §named-scope-deferral.

§When-a-design-has-a-tempting-feature-that's-not-in-scope, §name-it-as-`stretch goal`-not-omit-it + §the-reader-sees-the-feature-was-considered-and-deferred. §Sibling-pattern-to-cycle-238's-`Alt-C-deferred` + cycle-240's-Reserved-future-siblings + cycle-242's-subDir-deferred — §four-cycles-with-explicit-deferral-of-a-named-future-feature.

§Different-deferral-vocabularies-in-library: §`deferred` (238 + 242) + §`reserved-as-future-sibling` (240) + §`stretch goal` (248). §Three-different-shapes-of-deferral-vocabulary.

## §Send-confirmation dialog — prevent accidental capability sharing

§The-design-names-`Send confirmation`: *Dropping onto an agent handle shows a confirmation dialog before sending, to prevent accidental capability sharing.* §The-confirmation-IS-the-defense-against-accidental-share.

§When-a-UI-action-shares-a-capability-irreversibly, §require-a-confirmation-dialog + §the-confirmation-IS-the-defense-against-misclick. §Sibling-pattern-to-cycle-238's-revoke()-and-cycle-246's-permanent-revoke — §three-cycles-with-explicit-defense-against-irreversible-action (238 + 246 + 248). §Cycle-238-and-cycle-246-name-revocation-as-permanent; §cycle-248-names-a-confirmation-before-a-share-action.

## §Visual feedback — three named affordances

§Three-named-affordances on drag interaction:

1. §Drag-ghost-shows-the-pet-name (the drag preview).
2. §Drop-targets-highlight-on-dragover (visual confirmation of valid targets).
3. §Invalid-targets-show-a-no-drop-cursor (negative-affordance).

§Three-named-visual-affordances cover §confirmation-of-source + §confirmation-of-valid-target + §indication-of-invalid-target. §When-a-UI-action-has-source-target-and-validity-states, §each-state-gets-its-own-affordance.

§First-explicit-observation in library of §three-named-visual-affordances-on-drag-interaction.

## §Affected Packages — single package

§The-Affected-Packages-section names a single package: `packages/chat`. §The-narrow-blast-radius-IS-the-design's-evidence-of-decoupling. §When-a-feature-touches-only-one-package, §name-the-package-explicitly + §the-narrow-blast-radius-validates-the-no-new-daemon-API-changes-claim.

§Sibling-pattern-to-cycle-242's-Roadmap-calibration-per-git-blame — §two-cycles-with-explicit-impact-record (242 retrospective impact + 248 prospective impact). §Cycle-242-names-which-files-changed; §cycle-248-names-which-packages-will-change.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §UI-only — no daemon API changes (eleven-cycles-on-no-new-abstractions discipline).
- §Drop-target-table mapping UI targets to existing daemon API calls.
- §The-table-IS-the-mapping-from-UI-target-to-daemon-API-call.
- §Custom-MIME-type as discriminator on HTML5 drag payload.
- §Two-MIME-types-on-drag-data (legacy text/plain + custom application/x-endo-petname).
- §Five-Considerations-sections as named implementation-spec shape (Security + Scaling + Test Plan + Compatibility + Upgrade).
- §Empty-considerations-section-acknowledged-explicitly — say `None` not omit.
- §Default-copy-Alt-to-move — modifier-key disambiguation; default IS the safer non-destructive action.
- §Move-operations-not-atomic-acknowledged — match existing CLI behavior, name the non-atomicity in Security Considerations.
- §Send-confirmation-dialog — confirmation IS the defense against accidental capability sharing.
- §Three-named-visual-affordances on drag interaction (source ghost + target highlight + no-drop cursor).

**Tier-2 (named-scope-deferral patterns):**

- §Multi-select-as-stretch-goal — named scope deferral vocabulary.
- §Three-different-shapes-of-deferral-vocabulary (`deferred` + `reserved-as-future-sibling` + `stretch goal`).
- §Affected-Packages section as narrow-blast-radius evidence.

**Tier-3 (named comparisons):**

- §Two-cycles-with-explicit-no-new-daemon-API-changes-as-named-discipline (246 + 248).
- §Three-cycles-with-explicit-dispatch-or-method-placement-table (238 + 240 + 248).
- §Two-cycles-with-the-default-IS-the-safer-or-forward-progress-choice (244 + 248).
- §Three-cycles-with-explicit-defense-against-irreversible-action (238 + 246 + 248).
- §Four-cycles-with-explicit-deferral-of-a-named-future-feature (238 + 240 + 242 + 248).

## §Synthesis target — slot machine library

For a slot machine library:

- §UI-only-no-game-engine-changes — when a UI feature could be implemented in the game engine or in the UI, prefer the UI when the engine already supports the operation.
- §Action-target-table mapping UI gestures to existing game-engine API calls.
- §Custom-MIME-type for §game-token-MIME-type as discriminator on drag-and-drop transfers between games.
- §Five-Considerations-sections for §game-feature-spec-shape.
- §Empty-considerations-section-acknowledged-explicitly for §game-feature-completeness-signal.
- §Default-non-destructive-action-modifier-key-for-destructive for §game-action-safety-default.
- §Acknowledged-non-atomic-action with named matching-existing-behavior for §game-action-inherits-known-non-atomic-substrate-behavior.
- §Confirmation-dialog for §irreversible-game-action-defense-against-misclick.
- §Three-named-visual-affordances for §game-action-source-target-validity-states.
- §Stretch-goal as named scope deferral for §game-feature-considered-and-deferred.

## §Library meta-counters

- §Library-reaches-754-sections at cycle 248 (designs-lane inventory-drag-and-drop).
- §Eighty-second-consecutive designs-chat alternation cycle (cycles 166-248).
- §Eleven-cycles-on-no-new-abstractions discipline now (211 + 214 + 222 + 232 + 236 + 238 + 240 + 242 + 244 + 246 + 248).
- §Two-cycles-with-explicit-no-new-daemon-API-changes-as-named-discipline (246 + 248).
- §Three-cycles-with-explicit-dispatch-or-method-placement-table (238 + 240 + 248).
- §Two-cycles-with-the-default-IS-the-safer-or-forward-progress-choice (244 + 248).
- §Three-cycles-with-explicit-defense-against-irreversible-action (238 + 246 + 248).
- §Four-cycles-with-explicit-deferral-of-a-named-future-feature (238 + 240 + 242 + 248).
- §Three-different-shapes-of-deferral-vocabulary (`deferred` + `reserved-as-future-sibling` + `stretch goal`).
- §First-explicit-observation in library of §custom-MIME-type-as-discriminator-on-HTML5-drag-payload.
- §First-explicit-observation of §five-named-Considerations-sections-as-implementation-spec-shape.
- §First-explicit-observation of §empty-considerations-section-acknowledged-explicitly.
- §First-explicit-observation of §modifier-key-disambiguation-on-drop-action.
- §First-explicit-observation of §three-named-visual-affordances-on-drag-interaction.
- §First-explicit-observation of §Affected-Packages-section-as-narrow-blast-radius-evidence.

(Kris Kowal (prompted) authored)
