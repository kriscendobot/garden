---
title: "Starting E and Elmer"
source_kind: web
source_url: https://erights.org/elang/intro/starting-e.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/starting-e.html
source_fetched_via: mirror
source_content_sha256: 27990f44ed96ebf617e2b79d1432c0de57433a05e75dc7038a3b01e99c03ca65
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
topics: [getting-started]
status: current
notes: |
  Primary erights.org tutorial body chapter on launching an E interpreter; reachable
  via the GitHub Pages mirror. The source self-flags as obsolete at the top ("*** This
  chapter is obsolete and needs to be rewritten. There is no more 'elmer', and the 'e'
  command has been replaced by the bash script 'rune'..."), so treat the tooling names
  as historical. The teachable substance (the read-eval-print loop, the `elmer`
  literate-prototyping editor, and the documentation-as-regression-test ambition)
  survives the obsolescence note. Companion to the index
  [erights--elang-intro--tutorial-overview](erights--elang-intro--tutorial-overview.md).
---

## Abstract

The (self-described obsolete) first tutorial chapter on launching an E interpreter and the `elmer` prototyping editor. It introduces E's interactive read-eval-print loop: at the `?` prompt you type an E expression and the interpreter prints `# value: <result>` (`? 2 + 3` yields `# value: 5`). Its lasting interest is two-fold. First, it documents the *historical* tooling names (the original `e` command, now replaced by the bash script `rune`; the `elmer` GUI editor; the `eBrowser` and `capDesk` Windows shortcuts), which a reader needs in order to make sense of older erights.org pages that assume them. Second, it describes **`elmer`**, a Notepad-like editor that interleaves plain text with live interpreter sessions (an embedded example starts at any line whose first non-whitespace character is `?`), and records the project's ambition to "run all our documentation as a readable automated regression test" — an early statement of literate, executable documentation. Use this to ground claims about how E was launched and prototyped, the `?`/`# value:` REPL convention that pervades the other tutorial chapters, or the documentation-as-regression-test idea.

## Launching the interpreter and the REPL

The chapter opens with a maintainer's obsolescence note: there is no more `elmer`, the `e` command has been replaced by the bash script `rune` (which has no icon), and on the (then Windows-only) install you get a different pair of icons, one for `eBrowser` and one for `capDesk`, neither yet documented. Read the rest as historical.

After installing E (per the Download page), the start menu held an `erights.org` entry with sub-entries for `e` and `elmer`. Launching `e` opened an MS-DOS-like shell window running an E interpreter that prompts with a question mark. You type an E expression at the prompt; the interpreter runs it and shows the resulting value:

```e
? 2 + 3
# value: 5

? _
```

The window is terminated by typing `Ctrl-Z` at the next prompt. This `?`-prompt / `# value:` echo is the same convention every other tutorial chapter uses for its interactive examples.

## elmer: the literate-prototyping editor

Direct interaction with `rune` (the `e` command's successor) is "great for one line programs, but multi-line programs need to be edited before they are executed." `elmer` is described as "a minimal gui environment for prototyping small E programs": a Notepad-like text editor in which you can edit plain text with embedded code examples — for instance, a plain-text version of the tutorial chapter itself.

In `elmer` you engage the interpreter by *starting an embedded example*: type a line whose first non-whitespace character is a question mark.

```
For example, E does arithmetic

    ? 2 + 3
    # value: 5

    ? |
```

The difference from the bare `e` REPL is editorial. In the bare REPL `e` prints the `?`, you type `2 + 3`, and `e` prints `# value: 5`. In `elmer` you type `? 2 + 3`, `elmer` prints `# value: 5` while repeating your indentation, and then `elmer` types the next (indented) `?`, making it as easy to enter a sequence of examples as it is with `e`. To go back to editing plain text, you just backspace over the question mark.

`elmer` lets you save, open, and edit these interpreter sessions exactly as Notepad lets you save, open, and edit plain-text files. The chapter notes that, before conversion to HTML, many of the pages at the erights.org site were first written in `elmer` and assume the reader will use `elmer` to try out their examples, and states the project's ambition: "Eventually, we expect to run all our documentation as a readable automated regression test." You exit `elmer` as you would any window-based program.

Source: [elang/intro/starting-e.html](https://erights.github.io/erights-org-website/elang/intro/starting-e.html) via the erights.github.io mirror; content SHA-256 `27990f44`.
