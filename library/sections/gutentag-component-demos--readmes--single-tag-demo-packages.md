---
title: Single-tag demo packages — list, dice, colorim, accrete
source: README.md (×4)
source_repo: gutentags/{list.html,dice.html,colorim.html,accrete.html}
source_commit: b3d6ff7e9f64f450e839107e088c1b6fb912309e
source_date: 2015-06-29
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules]
status: current
notes: Consolidated worked-example catalog of four single-tag demo packages; per-repo README commits listed inline. tengwar.html has no README and is skipped.
---

Abstract: A worked-example catalog of Guten Tag's single-tag **demo component packages**, each a concrete instance of the `<tag>.html` packaging convention: an npm package *named* `<tag>.html` that publishes one Guten Tag component, with `package.json` `main` pointing at the tag-definition file. Their READMEs are one-liners ("a rough draft of X") plus a live demo link, carrying no design prose beyond the code — so they are catalogued together here rather than ingested one section apiece. They are useful as *examples* of the packaging convention (see the core gutentag README's [`custom-tags-and-packaging`](gutentag--readme--custom-tags-and-packaging.md) section) and as demos of what Guten Tag components look like in the small.

The `<tag>.html` packaging convention, as practiced by these packages: the npm package is named `<tag>.html` (e.g. `dice.html`), and `package.json` sets `main` to the tag-definition file — observed as `main: "dice.html"` and `main: "list.html"` (the tag file itself), the single-tag realization of the core README's "a single-tag package is named `<tag>.html`" rule.

The four packages (README text is quoted essentially in full — each is only a few lines):

- **`list.html`** (README `b3d6ff7`, 2015-04-26) — *"Gutentag, List! This is a very rough draft of a simple list component, suitable for menus and as a basis for more sophisticated lists supporting selection, ranged-selection, or multi-selection."* `package.json` description: `<list> tag for gutentag`.
- **`dice.html`** (README `716ab1e`, 2015-05-31) — *"Guten Tag, `<dice>`! This package contains die roller component, animated with CSS, illustrated with the Unicode die faces. The component can be composed into an application using Guten Tag."* [Demo](http://gutentags.github.io/dice.html/).
- **`colorim.html`** (README `9339653`, 2015-05-03) — *"Gutentag, `<colorim>`! This is a rough draft of a color picker with an emphasis on Vim-alike keyboard navigation."* [Demo](https://gutentags.github.io/colorim.html/).
- **`accrete.html`** (README `ec41bdb`, 2015-06-29) — *"Guten Tag, Accrete! This is a variation of the tile accretion game that's been going around."* [Demo](https://gutentags.github.io/accrete.html).

`tengwar.html` is a fifth single-tag package in the org but has no README (confirmed 404, 2026-07-06); it is skipped until it grows documentation.

Source: READMEs of [list.html](https://github.com/gutentags/list.html/blob/b3d6ff7e9f64f450e839107e088c1b6fb912309e/README.md) (`b3d6ff7`), [dice.html](https://github.com/gutentags/dice.html/blob/716ab1e08ceb465fea3ec20a785c125eac8a6872/README.md) (`716ab1e`), [colorim.html](https://github.com/gutentags/colorim.html/blob/93396534d3518f632fe3738ef29ace4e688f4232/README.md) (`9339653`), and [accrete.html](https://github.com/gutentags/accrete.html/blob/ec41bdbb5b523b251adc501b5fbd72f67892b525/README.md) (`ec41bdb`).
