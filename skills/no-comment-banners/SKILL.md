---
created: 2026-06-25
updated: 2026-10-04
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
characters from the set `- = * ~ _` and nothing else, **or** whose content
is a title bracketed by runs of two or more of those rule characters on both
sides:

```js
// --- Fallible work, before the consume ---
# === Setup ===
```

The same goes for rules and boxes drawn with **Unicode box-drawing or
block-element characters** (U+2500..U+259F): a title bracketed by U+2500
light-horizontal rules (the `// <rule> title <rule>` shape), a heavy (U+2501)
or double (U+2550) rule line, a block-element (U+2588 and kin) rule, or a
shell-comment box whose corners (U+250C, U+2510, U+2514, U+2518) and sides
(U+2502) frame a title. A comment line carrying even one such glyph is a
banner, because those characters only ever draw line art. ASCII rule lines of
`#`, `/`, or `+` (`##########`, `//////////`, `# +--------+`) count as well.

The section title is fine; the rules bracketing it are not, whether they sit
on their own lines or on the title's line. Write the title as a plain comment
and delete the rules:

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
  dash, including a mid-sentence `// foo -- bar`. The bracketed-title shape
  needs a rule run at *both* ends of the comment body.
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
  panel pre-pass. On any ADDED banner-rule line in a code file (JS/TS and
  shell, `.sh`/`.bash`), `panel.sh`
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
# Bracketed titles: `// --- Title ---`, `# === Title ===`, `/* -- Title -- */`.
grep -nE '^[[:space:]]*(//|#|\*)[[:space:]]*[-=*~_]{2,}[[:space:]]+[^-=*~_[:space:]].*[[:space:]][-=*~_]{2,}[[:space:]]*$' path/to/file
grep -nE '/\*\*?[[:space:]]*[-=*~_]{2,}[[:space:]]+[^-=*~_[:space:]].*[[:space:]][-=*~_]{2,}[[:space:]]*\*/' path/to/file
# Rule lines of `#`, `/`, or `+` (`##########`, `//////////`, `# +------+`).
grep -nE '^[[:space:]]*(//|#|\*)[[:space:]]*[-=*~_#/+]{4,}[[:space:]]*$' path/to/file
# Any comment carrying a box-drawing or block-element glyph (U+2500..U+259F).
LC_ALL=C grep -nE $'(^[[:space:]]*[#*]|//|/\\*).*\xe2(\x94[\x80-\xbf]|\x95[\x80-\xbf]|\x96[\x80-\x9f])' path/to/file
```

Delete each matched rule-only line. When the banner bracketed a section title, keep the
title line and adjust its punctuation so it reads as a sentence. For a
bracketed title, strip the rule runs from both ends and keep the title.

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
- _2026-09-29_: widened the rule and `detect-banners.sh` to titles bracketed by
  2+ rule runs on both sides after kriskowal flagged
  `// --- Fallible work, before the consume ---` on
  `endojs/endo-but-for-bots#1125` (review `5215956390`); the 4+-run-only
  predicate had let it through.
- _2026-10-04_: widened the rule and `detect-banners.sh` to Unicode
  box-drawing and block-element glyphs (any one in a comment), to `#`/`/`/`+`
  rule lines, and to shell files, after kriskowal noted on
  `kriscendobot/minion.town#148` (comment `5981444423`) that the detector had
  missed shell box banners and `// <U+2500 rule> title <U+2500 rule>` comments.
