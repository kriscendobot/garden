---
created: 2026-07-11
updated: 2026-08-10
author: gardener
---

# Skill: typist-friendly code points

## The rule

Avoid code points that are difficult for a typist to produce and maintain. When a bot-authored document carries a glyph that has no key on a standard keyboard, every future human edit of that text becomes harder: the maintainer cannot retype the character, cannot grep for it from memory, and either copy-pastes it forward or lets the document drift into a mix of the glyph and its ASCII spelling. Prefer the ASCII spelling from the start.

The rule covers bot-authored text everywhere it lives: design documents, README and other markdown prose, code comments, commit messages, PR bodies and review replies, journal entry and inbox message bodies.

The rule targets **symbol and punctuation** code points that have an ASCII spelling. Accented letters inside proper names and loanwords (`Café`, `naïve`, a contributor's name) are not in scope; they are spelling, not typography.

## Replacements

Mechanically substitutable (the auto-fix pass below performs these):

| Glyph | Code point | Type instead |
| ----- | ---------- | ------------ |
| `→` | U+2192 RIGHTWARDS ARROW | `->` |
| `←` | U+2190 LEFTWARDS ARROW | `<-` |
| `↔` | U+2194 LEFT RIGHT ARROW | `<->` |
| `⇒` | U+21D2 RIGHTWARDS DOUBLE ARROW | `=>` |
| `⇐` | U+21D0 LEFTWARDS DOUBLE ARROW | `<=` |
| `…` | U+2026 HORIZONTAL ELLIPSIS | `...` |
| `“` `”` | U+201C / U+201D curly double quotes | `"` |
| `‘` `’` | U+2018 / U+2019 curly single quotes | `'` |
| `≤` | U+2264 LESS-THAN OR EQUAL TO | `<=` |
| `≥` | U+2265 GREATER-THAN OR EQUAL TO | `>=` |
| `≠` | U+2260 NOT EQUAL TO | `!=` |
| `×` | U+00D7 MULTIPLICATION SIGN | `x` or `*` |
| `−` | U+2212 MINUS SIGN | `-` |
| (invisible) | U+00A0 NO-BREAK SPACE | plain space |

Substitutable only by reading (the auto-fix pass detects these but does not rewrite them):

| Glyph | Code point | Rewrite as |
| ----- | ---------- | ---------- |
| `•` | U+2022 BULLET | a markdown `-` bullet when it leads a line; a comma or slash when it separates inline items |
| `✓` `✔` | U+2713 / U+2714 check marks | `yes`, `[x]`, or `PASS`, by what the mark asserts |
| `✗` `✘` | U+2717 / U+2718 ballot marks | `no`, `[ ]`, or `FAIL`, by what the mark denies |

Two neighboring code points are owned elsewhere and deliberately excluded here:

- **Em dash `—` (U+2014)**: owned by [em-dash-style](../em-dash-style/SKILL.md). Its rewrite (period, parentheses, or colon) is a judgment call, never a mechanical substitution, so the auto-fix pass leaves it alone.
- **En dash `–` (U+2013)**: em-dash-style tolerates it in numeric ranges (`80–100`). In new bot-authored prose prefer the plain hyphen (`80-100`) or the word (`80 to 100`); existing en-dash ranges are not worth a sweep.

## Scope and exemptions

The rule governs **bot-authored** text, matching [no-latin-shorthand](../no-latin-shorthand/SKILL.md) scoping:

- Quoting the maintainer or upstream material verbatim preserves the original glyphs.
- Vendored content under `references/<source>/` is exempt: references are read-only snapshots.
- A string literal or test fixture whose **value** is the glyph (a Unicode-handling test, a locale string, rendered UI text where the typographic character is the product) keeps the glyph. The rule is about text a human maintains, not data a program asserts.
- Fenced code blocks are exempt (they often capture output or upstream code verbatim). An inline code span is exempt only when it quotes a glyph by itself in order to talk about it (as this skill's own tables do); a span that carries a glyph among other text (a signature like `stmt.get(...args) -> object`) is content, and the deterministic pass scans and fixes it like prose.
- A markdown file that must legitimately carry these code points opts out with a `typist-code-points-exempt` marker in its first five lines, mirroring the `ascii-exempt` and `spell-out-exempt` markers.

Existing prose is fixed **on encounter**, plus automatically at the gate (below): when a role edits a file for another reason, it rewrites the typist-hostile glyphs in that file as part of the change. No standalone sweep dispatch is authorized by this skill.

## Enforcement tiers

The standing instruction runs at all three tiers the garden uses for style rules:

1. **Guidance.** This skill, indexed in `roles/COMMON.md` § House style, so every role reads it as part of the standing style set.
2. **Jury.** The [typist](../../roles/jurors/typist/AGENT.md) seat (always-on in every code panel) and the [copyeditor](../../roles/jurors/copyeditor/AGENT.md) seat (every design panel, cross-fired onto markdown-heavy code PRs) flag typist-hostile code points in the diff; the [pedant](../../roles/jurors/pedant/AGENT.md) carries the rule among its layered project style rules. The seats are the always-on backstop for a PR whose gauntlet never ran.
3. **Gate (auto-fix).** The [pre-push-gates](../pre-push-gates/SKILL.md) probe `typist-friendly-code-points.sh` scans added lines of changed markdown files and, run with `--fix` in the gate's auto-fix stage, mechanically rewrites the substitutable glyphs in the changed files (skipping code fences and inline code spans) and re-stages. The judgment-only glyphs (`•`, check and ballot marks) fail the probe with a one-line suggestion instead. The current executable probe is markdown-scoped; source ASCII and box-drawing rules remain guidance and panel concerns until their own probe scripts land.

## How to sweep a file

```sh
grep -nP "\x{2192}|\x{2190}|\x{2194}|\x{21D2}|\x{21D0}|\x{2026}|\x{201C}|\x{201D}|\x{2018}|\x{2019}|\x{2264}|\x{2265}|\x{2260}|\x{00D7}|\x{2212}|\x{00A0}|\x{2022}|\x{2713}|\x{2714}|\x{2717}|\x{2718}" path/to/file.md
```

Or run the probe directly against a worktree: `scripts/jobs/gardening/pre-push-gates/probes/typist-friendly-code-points.sh [--fix] <project-root>`.

## Motivating incident

kriskowal review on `endojs/endo-but-for-bots#124` (discussion `r3548802060`, 2026-07-11): "Avoid code points that are difficult for a typist to maintain. This is a standing instruction that should be in style guidance and observed by automation in the jury selection process and automatically fixed." The precipitating example was `designs/daemon-endor-pet-store-sqlite.md`, which used `→` (U+2192) arrows throughout its prose and tables where `->` types and reads just as well.

## Pitfalls

- **Editor and renderer smart punctuation.** Many editors substitute `...` with `…` and straight quotes with curly quotes as you type; GitHub web copy-paste and `gh pr view` output carry the typographic forms. Rewrite when quoting into prose; preserve inside fenced blocks that capture output verbatim.
- **Mermaid is already ASCII.** Mermaid edge syntax (`-->`, `->>`) never needs an arrow glyph; a `→` inside a mermaid label is as avoidable as one in prose.
- **Do not corrupt quoted glyphs.** A document that quotes a glyph in backticks to discuss it (this file, the em-dash-style skill) keeps the glyph inside the code span. The probe and fixer skip code spans and fences for exactly this reason.
- **The multiplication sign needs reading.** `×` becomes `x` in prose (`3x faster`) but `*` in anything expression-shaped; the auto-fix picks `x`, so check expression contexts after a fix.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-07-11_: encoded from kriskowal's standing instruction on `endojs/endo-but-for-bots#124` (`r3548802060`). Landed all three tiers in one pass: this skill, the typist/copyeditor/pedant seat wiring, and the `typist-friendly-code-points.sh` gate probe with `--fix`.
