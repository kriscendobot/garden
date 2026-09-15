---
created: 2026-06-25
updated: 2026-09-15
author: gardener
---

# Skill: no comment banners

## The rule

Do not draw **banner horizontal rules** in code comments. A banner is a
comment line whose body is a run of repeated punctuation used as a decorative
separator rather than as prose:

```js
// ---------------------------------------------------------------------------
// Section title
// ---------------------------------------------------------------------------
```

The forbidden shapes are a comment line (`//`, `#`, `/* … */`, or a JSDoc
` * ` continuation) whose remaining content is four or more repeated rule
characters from the set `- = * ~ _` and nothing else. The section title is
fine; the rules bracketing it are not. Write the title as a plain comment and
delete the rules:

```js
// Section title.
```

The maintainer's reason (PR #503, review `4573212313`): banner rules are
"inevitably inconsistent with a human maintainer in the loop." A person editing
the file does not redraw the ruler to the same width, does not add one to the
next section, and does not agree on the character. The decoration drifts the
moment a human touches the file, so it reads as machine-generated noise. The
same objection retired ASCII box diagrams; horizontal rules are the same class of decoration in a
thinner shape.

## What is *not* a banner

- A `// foo -> bar` directional arrow or any comment that is prose containing a
  dash.
- A markdown thematic break (`---` on its own line in a `.md` file) used as a
  real section divider in prose. This rule is about *code comments*, not
  markdown structure.
- A dashed line inside a fenced code block that is sample output or data.
- A pre-existing banner in a file the change does not otherwise touch: do not
  open a diff just to delete one. Sweep banners only in files you are already
  editing.

## Scope

The rule governs code comments in the projects the garden builds for (today
`endojs/endo-but-for-bots` and, post-ferry, `endojs/endo`). It is a project
code-style rule, not a garden-document prose rule, so it is enforced at two
sites:

- **Generation.** Avoid banner-rule comments when producing code. The pre-push
  driver does not currently ship a `no-ascii-banners` probe.
- **Review.** `scripts/jobs/gardening/detect-banners.sh` runs as a deterministic
  panel pre-pass. On any ADDED banner-rule line in a code file, `panel.sh`
  force-adds the `archivist` seat even to a trimmed panel and hands it the
  matching lines as evidence. The juror judges the finding, and any edit follows
  the ordinary panel disposition and fixer loop; the detector never deletes the
  line itself. The `pedant`
  design-panel seat carries the same rule for code blocks inside design
  documents, alongside the ASCII-diagram rule it already holds.

## How to sweep a file you are editing

```sh
grep -nE '^[[:space:]]*(//|#|\*)[[:space:]]*[-=*~_]{4,}[[:space:]]*$' path/to/file
grep -nE '/\*[[:space:]]*[-=*~_]{4,}[[:space:]]*\*/' path/to/file
```

Delete each matched line. When the banner bracketed a section title, keep the
title line and adjust its punctuation so it reads as a sentence.

## Notes from the field

(Append; terse and dated.)

- _2026-06-25_: adopted after PR `endojs/endo-but-for-bots#503` review
  `4573212313`. The maintainer asked to apply the banner feedback generally and
  to reinforce the garden to anticipate it at the generation and review sites.
  The reconstructed passable-byte-arrays PR carried roughly forty `// ----`
  rule comments across six files. The planned `no-ascii-banners` probe was
  widened in documentation, but its executable did not survive the v2
  migration; `detect-banners.sh` plus the panel seats are the active enforcement.
- _2026-09-15_: moved banner detection from a pre-review LLM deletion handler
  into the panel pre-pass. A hit now forces the archivist juror, preserving the
  normal review, disposition, and fixer-loop accountability.
