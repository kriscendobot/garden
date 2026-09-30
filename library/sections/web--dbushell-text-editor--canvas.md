---
title: Canvas: rendering the editor on a <canvas> element
source_kind: web
source_url: https://dbushell.com/2026/09/01/text-editor/
source_content_sha256: 3ab555a041ecba3f68f8a791498911288079554457b7b26ddc478e0dd7630e20
source_authors: [David Bushell]
source_date: 2026-09-01
ingested: 2026-09-30
ingested_by: scholar
topics: [web-text-editors, web-frontend]
status: current
---

**Abstract.** The first approach Bushell tries: render all text (and the cursor) on a `<canvas>`, implementing a "minimum viable" feature set by hand (pointer-down cursor placement, arrow-key movement, current-line highlight, typing, animated cursor), and borrowing native scrolling by sizing a hidden overflow `<div>` to the text and using its scroll position as the canvas render offset. The verdict: canvas "gives me nothing for free" — selection, undo/redo, multi-line paste, and scrolling must all be rebuilt — and, decisively, a canvas editor is entirely inaccessible, so he abandons it ("Rendering on `<canvas>` would be a nightmare").

My first experiment renders everything on a `<canvas>` element. You can't tell, but your CPU is doing a lot of work to render that picture at 60–120 frames per second. Lack of interactivity is an obvious problem for a text editor.

I made a list of the "minimum viable" features and implemented them:

- Pointer down to position text cursor
- Arrow keys to move text cursor
- Highlight current line
- Type to enter text
- Fancy cursor animation

Canvas gives me nothing for free. Amongst many desirable features, I'm missing:

- Text selection
- Undo/redo history
- Multi-line paste
- Overflow scrolling

That last one is critical. Life is too short to implement custom elastic scrollbars. I decided to cheat and use native browser overflow on a hidden element. A `<div>` is sized to match the canvas text and the scroll position is used to calculate render offsets on the canvas.

I'm pleased with how that's coming along but I'm also disheartened because `<canvas>` is entirely inaccessible. I could continue to add text selection and other features but I'm not solving the fundamental accessibility issue.

**Later note from the post (Edit 2).** The [EditContext API](https://developer.mozilla.org/en-US/docs/Web/API/EditContext_API) improves `<canvas>` input. (Scholar gloss: EditContext decouples text input (IME, composition) from a DOM editing host, which is the input half of the canvas problem; it does not by itself restore selection, undo, or accessibility.)

**Tradeoff summary (scholar).** Full rendering control and no DOM cost per line, paid for with re-implementing every editing primitive and an accessibility deficit the author judged fundamental. Technique worth reusing regardless of substrate: the hidden native-overflow `<div>` as a scroll proxy.

Source: [Fine, I’ll build my own text editor!](https://dbushell.com/2026/09/01/text-editor/) by David Bushell, 2026-09-01 (content SHA-256 `3ab555a0`, retrieved 2026-09-30).
