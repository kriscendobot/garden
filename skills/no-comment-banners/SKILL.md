---
created: 2026-06-25
updated: 2026-08-10
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
code-style rule, not a garden-document prose rule, so it is enforced at three
sites:

- **Generation.** `scripts/jobs/gardening/detect-banners.sh` detects an added
  banner-rule comment and gates the state machine's banner-sweep handler. The
  pre-push driver does not currently ship a `no-ascii-banners` probe, so the
  panel remains the backstop when the detector or handler does not settle it.
- **Gardening loop.** The sense-gated `scripts/jobs/gardening/detect-banners.sh`
  detector runs inside `garden-pr.sh`: on any ADDED banner-rule line in a code
  file it fires the conditional
  `scripts/jobs/handlers/banner-sweep-claude.sh` fixer, which deletes the rule
  lines (keeping a bracketed title as a plain comment) and re-stages — mirroring
  the workstation-coupling detector+handler pair. Deterministic and
  quiet-by-design; best-effort, with the `archivist` juror as the backstop.
- **Review.** The `archivist` code-panel seat (it already reads comment and
  JSDoc prose) flags any surviving banner rule as should-fix. The `pedant`
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
