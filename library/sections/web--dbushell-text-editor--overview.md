---
title: Overview: why build a web text editor, and Monaco as the div-soup baseline
source_kind: web
source_url: https://dbushell.com/2026/09/01/text-editor/
source_content_sha256: 3ab555a041ecba3f68f8a791498911288079554457b7b26ddc478e0dd7630e20
source_authors: [David Bushell]
source_date: 2026-09-01
ingested: 2026-09-30
ingested_by: scholar
topics: [web-text-editors]
status: current
---

**Abstract.** David Bushell's framing for a from-scratch, in-browser text editor experiment: dissatisfaction with modern editors (following his "They don't make 'em like Sublime Text anymore" post), and Microsoft's Monaco Editor (the editor VS Code is built on) characterized as a "`<div>` soup hellscape" whose performance on older hardware sets a low bar. The rest of the post tries three rendering substrates in turn — `<canvas>`, `contenteditable`, and `<textarea>` — so read this section only for the motivation and the Monaco baseline; the substance is in the three approach sections.

["They don't make 'em like Sublime Text anymore"](https://dbushell.com/2026/08/07/sublime-text/) resonated with a lot of folk. Software these days is garbage. That got me thinking; I'm good at building garbage! Why can't I build my own text editor?

VS Code is built upon [Monaco Editor](https://microsoft.github.io/monaco-editor/) which is a `<div>` soup hellscape. I was late to the VS Code train because for years my Intel Mac was too slow. That issue was resolved when I bought Apple silicon. If that's the standard I have a lot of room to make mistakes.

**Scholar note.** The post names Monaco only as the incumbent (a DOM-of-`<div>`s editor library, the approach VS Code ships); it does not evaluate Monaco's API, embedding cost, or features, and it does not mention CodeMirror or other editor libraries. The three sibling sections cover the build-your-own substrates: [canvas](web--dbushell-text-editor--canvas.md), [contenteditable](web--dbushell-text-editor--content-editable.md), [textarea](web--dbushell-text-editor--textarea.md).

Source: [Fine, I’ll build my own text editor!](https://dbushell.com/2026/09/01/text-editor/) by David Bushell, 2026-09-01 (content SHA-256 `3ab555a0`, retrieved 2026-09-30).
