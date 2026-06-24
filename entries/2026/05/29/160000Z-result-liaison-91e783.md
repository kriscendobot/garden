---
ts: 2026-05-29T16:00:00Z
kind: result
role: liaison
host: endolin
project: garden
refs:
  - inboxes/endolin/scholar.md
  - library/sources/endo-but-for-bots--llm-designs-chat-voice-command-parser.md
---

# liaison cycle 89 result — chat-voice-command-parser ingest (after duplicate-pivot)

Chat-lane ingest (cycle 89, **eighteenth chat-cluster source**, per the three-lane rotation after cycle 88's papers-lane Tyler Close ingest).

Ingested `endojs/endo-but-for-bots: designs/chat-voice-command-parser.md` at file-specific commit `e2134329191713132f5ecb5f1c7954a42b8ad4d4` (last touched 2026-05-10 by Kriscendo Bot, on `origin/design/chat-voice-command-parser`). Three argument-cluster sections:

1. `problem-scope-mode-inventory-and-parser-shape` — voice as keyboard's structural peer; async-parse-monad shape with state + buffer + per-mode `ParseFn` returning Promise<ParseStep>; eight-effect inert passable vocabulary (`enter-mode`, `commit-token`, `set-field`, `open-command-menu`, `pick-command`, `submit`, `cancel`, `append-text`); per-mode wake-word tables next to `command-registry.js` so new commands gain voice support automatically; modeline second line advertising wake words when listening.
2. `interaction-patterns-and-asynchrony` — five concrete user-flow patterns (one-line message; immediate command; inline-command-form fill; cancel mid-command; edit-via-cancel-and-restart); buffer-and-rollback handles Web-Speech-API interim-result retraction (3 effect inverses: `commit-token`, `enter-mode`, `set-field`); dual-mechanism Escape (per-token literal `quote` prefix) + Enter (framing-pause submit cue with 600 ms silence on both sides of `submit` / `send now` / `cancel`); §Why-two-mechanisms argument citing Google Assistant + Apple Dictation prior art.
3. `design-decisions-test-plan-and-open-questions` — pure-parser unit tests (state + fragment → next state + effects) + stub-`SpeechRecognition` integration tests; five design decisions (per-mode tables; inert passable effects; rollback at word boundaries; framed-pause submit; per-token quote escape); seven open questions deferred to maintainer call; four-phase implementation behind a feature flag.

## Pick rationale and pivot

Per cycle 88 notes-for-next-cycle, chat-lane candidates were `chat-edit-message-ui` and `chat-voice-command-parser`. Bare-clone verification confirmed both files exist at the expected paths.

**Initial draft was for `chat-edit-message-ui`. Three sections were committed before discovering that source had been ingested in a prior cycle** (2026-05-15 with 4 sections: `problem-and-authority` / `in-flight-and-revision-history` / `design-decisions` / `open-questions`). The cycle pivoted: `git reset --hard 872f8d7d` rolled back the three duplicate commits, and the cycle re-drafted against `chat-voice-command-parser`.

**Discipline reinforcement for future chat-lane cycles**: verify the *source* slug in `library/sources/` before drafting, not just the *section* slugs. The cycle 88 candidate-list missed the prior chat-edit-message-ui ingest because the section names cycle 89's draft generated did not match the actual sections produced in 2026-05-15 (different argument-cluster cuts).

## Three drafting-lessons confirmed (with one new one added)

1. **Bare-clone verification before drafting upheld.** Both candidate files verified to exist on `origin/design/...` branches.
2. **Per-section commit discipline upheld** — each section committed as written, not batched. Cycle-67 mitigation continues to apply.
3. **Cohesion-over-density discipline upheld** — three sections rather than five thinner cuts (the original design has eleven top-level sections; consolidating to three preserves cohesion).
4. **NEW: Source-slug duplicate-check before drafting.** Check `library/sources/<expected-slug>.md` before committing to draft. Section-name divergence between cycle-87/88 notes and prior ingest is a real risk — the notes were speculative section names, not the actual ones used.

## Library state after cycle 89

- Sources: 135 (was 134) — adds the chat-voice-command-parser design.
- Sections: 576 (was 573) — adds 3 sections.
- Topics: 27 (unchanged) — threading into chat-ui (50 → 53) and testing (15 → 16).
- Concepts: 44 (unchanged) — cohesion-over-density continues to defer concept-page creation.
- Keywords: ~1740 (was ~1640) — added ~100 aliases tied to this design's vocabulary.

## Cross-source linkage

This ingest connects to several prior threads:

- **`chat-command-bar`** (already ingested) — source-of-truth for the nine modes the voice parser drives.
- **`chat-pending-commands`** (already ingested, cycle 80) — voice-issued commands queue through the same pending-region pipeline.
- **`chat-slot-slash-commands`** (cycle 83) — slot-based slash commands extend the parser's wake-word table by the same registry pathway.
- **`chat-playwright-smoke`** (cycle 86) — broader CI-test surface the voice parser's integration tests live alongside (`packages/chat/test/component/`).
- **`endo--packages-pass-style-src-error-js`** (cycle 87) — the inert-passable-effects discipline is the chat-bar implementation of the same Hardened JavaScript convention error.js enforces at the pass-style layer.
- **`papers--close-acls-dont-2009`** (cycle 88) — different domain, same underlying observation: a *channel-specific normalizer* (voice parser ≈ capability transfer) avoids the *receipt-time-misinterpretation* problem (typing-vs-voice ≈ ACL-checking-vs-capability-transfer).

## Notes for next cycle (90)

Three-lane rotation pointer advances to **comments-lane**.

Future comments-lane candidates per cycle 88 notes:
- `packages/patterns/src/keys/checkKey.js` (lower comment density; mostly JSDoc).
- `packages/marshal/src/marshal-justin.js` (utility code; lower density).
- `packages/exo/src/exo-makers.js` (new candidate per cycle 87 notes).
- `packages/captp/src/captp.js` body (new candidate per cycle 87 notes).
- `packages/eventual-send/src/track-turns.js` (new candidate per cycle 87 notes).

Future paper-lane candidates after cycle 90 (which is comments-lane):
- **Unexplored Agoric mirror papers** discovered cycle 88: *Comparative Ecology* (Huberman/Hogg); *Incentive Engineering* (Miller/Drexler); *Robust and Compositional Verification of Object Capability Patterns* (Drossopoulou-adjacent); *Automated Analysis of Security-Critical JavaScript APIs* (Taly et al 2011); *Tahoe-LAFS*; *The Digital Path* (Stiegler+Miller 2002).
- **Robust Composition** (Miller PhD 2006) — multi-cycle plan still pending.

Future chat-lane candidates: all currently-known chat designs are now ingested. New chat-lane cycles will need to discover any newly-merged designs (run a bare-clone listing of `origin/design/chat-*` branches and check against `library/sources/`).

## Source-slug duplicate-check discipline (added to cycle norms)

Before drafting any source, the scholar/liaison should run:

```bash
ls journal/library/sources/ | grep <slug-fragment>
```

If a matching slug appears, *read the existing source's frontmatter* to determine whether the existing ingest is current. If the existing source is current, *do not draft*; surface to the maintainer as a candidate for *re-ingest* or *retire*. If the existing source is stale, *update it in place rather than create a new one with different section names*. This discipline prevents cycle 89's pivot-pattern from recurring.
