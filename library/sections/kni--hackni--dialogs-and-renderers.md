---
title: Dialogs and renderers — the pluggable input and output boundary
source: HACKNI.md
source_repo: kriskowal/kni
source_commit: 0d6e2949daf0701df3ed7c173899e2a04b0dcca2
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

Abstract: kni cleanly separates the graph-walking engine from *how* it prompts and *how* it presents narrative, via two swappable roles. A **dialog** prompts the interlocutor for input and calls back with `answer`; the engine drives it with `ask(cue)`, where the optional cue lets custom dialogs offer different input modes. A **renderer** accepts text and option snippets and produces the narrative, driven by a `write`/`break`/`paragraph`/`option`/`flush`/`display`/`clear` (and join/delimit) vocabulary, handling whitespace via `lift`/`drop` markers. The shipped implementations are the web `document.js` (DOM-building renderer + dialog, with hyperlink embedding and page-turn behaviors) and the command-line `readline.js`/`console.js`/`excerpt.js` (readline input plus fixed-width excerpting). The lens reading: the dialog is the pluggable elicitation channel and the renderer the pluggable presentation channel, so the same graph can drive a terminal, a web page, or a phone bot — or a programmatic caller.

**Dialogs.** A dialog is responsible for prompting the interlocutor for input. The web dialog hooks up click and keyboard handlers to choose options and resumes the engine with an answer when the user chooses; the command-line dialog uses readline. The engine drives the dialog with `ask`, which may receive a `cue` argument indicating the engine has requested an arbitrary string. The minimum dialog facilitates a text input; custom dialogs may provide different input modes depending on the cue. The dialog calls back to the engine with `answer`.

**Renderers.** A renderer accepts snippets of text and options and produces the narrative. The engine drives it via `write(lift, text, drop)`, `break()`, `paragraph()`, `startJoin(lift, delimiter, conjunction)`, `stopJoin()`, `delimit(delimiter)`, `option(number, label)`, `flush()`, `pardon()`, `display()`, and `clear()`. The renderer collapses redundant break/paragraph calls. `lift` and `drop` are an empty string or a single space depending on whether whitespace is required around text; generally lifting space is ignored at the start of a paragraph or after a break, dropped space at the end of a line, and interpolated space is collapsed. Two chunks of text join without space only if the prior drops nothing and the next lifts none.

**The web dialog and renderer (document.js).** The kni Document serves as both renderer and dialog controller, building a DOM on the fly with CSS that lets the containing document govern position and animation. Its options object accepts `createPage`, `meterFaultButton`, and `pageTurnBehavior` (`log` default — remove options, keep narrative; `remove`; `fade`). A text block ending in a URL (e.g. `{Example https://example.com}`) is embedded as a hyperlink.

**The command-line dialog renderer (readline.js, console.js, excerpt.js).** The readline module hooks Node.js readline to the engine; the console module drives creation of an *excerpt* for the narrative; the excerpt handles line wrapping and indentation within a fixed width so the reader can scan paragraphs without awkward terminal line wrapping.

Source: [HACKNI.md](https://github.com/kriskowal/kni/blob/0d6e2949daf0701df3ed7c173899e2a04b0dcca2/HACKNI.md) at commit `0d6e2949`.
