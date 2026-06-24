---
source: designs/chat-voice-command-parser.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-voice-command-parser
source_commit: e2134329191713132f5ecb5f1c7954a42b8ad4d4
source_date: 2026-05-10
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
section_count: 3
status: current
notes: |
  **Status: Not Started** upstream. Introduces an asynchronous
  parse-monad state machine that consumes voice transcript fragments
  from the Web Speech API and produces inert passable effects the
  chat-bar interprets — so the voice channel drives the same nine
  modes (Send, Token Autocomplete, Token Only, Token + Text, Text
  Only, Command Selecting, Inline Command Form per-command, Eval,
  Value Modal) the keyboard already drives. Eight-effect vocabulary
  (`enter-mode`, `commit-token`, `set-field`, `open-command-menu`,
  `pick-command`, `submit`, `cancel`, `append-text`). Per-mode
  wake-word tables co-located with `command-registry.js` so new
  commands gain voice support automatically. Five concrete
  interaction patterns validate the parser's mode traversal.
  Buffer-and-rollback handles Web-Speech-API interim-result
  retraction (3 effect inverses: `commit-token`, `enter-mode`,
  `set-field`). Dual-mechanism wake-word-vs-prose disambiguation:
  per-token literal `quote` escape + framing-pause submit cue
  (`submit` / `send now` / `cancel` flanked by 600 ms silence on
  both sides). Five design decisions + seven open questions. Four-
  phase implementation behind a feature flag.
---

> Abstract: The chat bar accepts speech-to-text via the Web Speech
> API (`packages/chat/voice-input.js`, PR #101), but the transcription
> arrives as a flat string that lands in the contenteditable input
> exactly as if the user had typed those characters. *That works for
> the Send mode but degrades the rest of the command bar: a
> transcribed `slash list` does not open the command menu the way a
> typed `/` does, and a transcribed pet name does not become a chip
> the way the autocomplete pipeline produces.* This design introduces
> an asynchronous parse-monad state machine (state + buffer + per-mode
> `ParseFn` returning effects) that turns voice transcripts into the
> same effects a keystroke sequence would. Eight inert passable
> effects; per-mode wake-word tables next to `command-registry.js`;
> modeline second line advertising wake words when listening. Five
> interaction patterns validate the parser's mode traversals. Buffer-
> and-rollback handles Web-Speech-API interim-result retraction with
> three effect inverses. The wake-word-vs-prose vocabulary collision
> is resolved with two complementary mechanisms — *Escape* (per-token
> literal `quote` prefix; suppresses wake-word interpretation of the
> next whitespace-delimited token) and *Enter* (framing-pause submit
> cue; `submit` / `send now` / `cancel` commit only when flanked by
> a 600 ms silence interval on both sides). The §Why-two-mechanisms
> argument: a pure modal toggle imposes context switches the
> keyboard doesn't require; a pure confidence-threshold cannot
> distinguish a high-confidence transcription of literal `submit`
> from a high-confidence transcription of the submit cue. Splitting
> the two cases keeps each mechanism load-bearing for one job;
> matches Google Assistant + Apple Dictation prior art. Five design
> decisions + seven open questions deferred for maintainer call;
> four-phase implementation behind a feature flag.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-scope-mode-inventory-and-parser-shape](../sections/endo-but-for-bots--llm-designs-chat-voice-command-parser--problem-scope-mode-inventory-and-parser-shape.md) | chat-ui | current |
| [interaction-patterns-and-asynchrony](../sections/endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony.md) | chat-ui | current |
| [design-decisions-test-plan-and-open-questions](../sections/endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions.md) | chat-ui, testing | current |

The design's eleven top-level sections collapse to three argument-cluster sections. §What is the Problem Being Solved + §Scope + §Existing Mode Inventory + §Parser Shape (Why-async-monad + Effects + Wake-words-per-mode) + §Modeline Integration → section 1 (architecture-and-vocabulary). §Interaction Patterns + §Asynchrony and Race Conditions + §Escape and Enter (literal-quote prefix + framing-pause submit + cancel-and-others + why-two-mechanisms) → section 2 (interaction-and-disambiguation). §Test Plan + §Dependencies + §Phased Implementation + §Design Decisions + §Open Questions + §Prompt → section 3 (validation-and-decisions).

## Provenance

- Fetched 2026-05-29 from `endojs/endo-but-for-bots@e2134329191713132f5ecb5f1c7954a42b8ad4d4` (the file's last-modifying commit on `origin/design/chat-voice-command-parser`).
- File last modified 2026-05-10 by Kriscendo Bot (the bot identity for the maintainer's prompt-driven design dispatches).
- Verified via bare-clone listing before drafting (cycle 73 / 74 verify-bare-clone discipline).
- **Eighteenth chat-cluster source**.

## Cycle 89 pivot note

Cycle 88's notes-for-next-cycle named two candidates: `chat-edit-message-ui` (already ingested in a prior cycle as a 4-section source — bare-clone verification confirmed the source file exists at `journal/library/sources/endo-but-for-bots--llm-designs-chat-edit-message-ui.md` ingested 2026-05-15) and `chat-voice-command-parser`. Three duplicate sections were drafted and committed for chat-edit-message-ui before the duplication was discovered; the three commits were `git reset --hard`-removed and the cycle pivoted to chat-voice-command-parser. **Discipline reinforcement for future chat-lane cycles: check `library/sources/` for the candidate slug *before drafting*, not just `library/sections/`.** The notes-for-next-cycle 87 missed the prior chat-edit-message-ui ingest because the section names in cycle 87's notes did not match the actual sections produced (the prior ingest used `problem-and-authority` / `in-flight-and-revision-history` / `design-decisions` / `open-questions`, not the names cycle 89's draft generated).
