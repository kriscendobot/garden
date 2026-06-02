---
created: 2026-06-02
updated: 2026-06-02
author: gardener
---

# Skill: avoid Latin shorthand

## The rule

Avoid Latin shorthand in bot-authored prose. Use the English equivalent. The rule covers prose in code comments, design documents, PR bodies, PR review replies, commit messages, and the body of journal entries and inbox messages.

Latin shorthand is dense, register-shifting, and assumes a reader who shares the writer's training. English equivalents read more directly and stay legible to a wider audience.

## Replacements

| Shorthand | Prefer |
| --------- | ------ |
| `cf.`     | "See" / "Per" / "Compare with" (pick by intent: pointer, citation, or contrast) |
| `i.e.`    | "that is" |
| `e.g.`    | "for example" |
| `etc.`    | "and so on" / "and similar" / restructure to enumerate the cases |
| `et al.`  | "and others" |
| `vs.`     | "versus" / "compared to" |
| `viz.`    | "namely" |
| `ad hoc`  | "improvised" / "case-by-case" / restructure to name the actual decision shape |

When the substitution reads worse than the original, restructure the sentence rather than mechanically swapping. `etc.` is often a signal that the writer did not want to enumerate; if the enumeration is short, enumerate it. If the enumeration is long, name the category instead of trailing off.

## The borderline case: `via`

`via` is fully assimilated into English and acceptable. The norm flags it for awareness, not avoidance. If a sentence reads naturally with "through" or "by way of", prefer those; if `via` is the cleanest fit (the prepositional `via <channel>` shape), leave it. The point is the writer notices the choice rather than reflexively reaching for the Latin.

## Scope

This applies to **bot-authored** prose. The maintainer's own writing (review comments from kriskowal, design documents the maintainer authored) is not in scope; quoting the maintainer verbatim preserves their wording.

Existing prose with Latin shorthand is fixed **on encounter**, not via a sweep. When a role is editing a file for another reason and notices a Latin shorthand, rewrite it as part of the change. Do not open a separate sweep PR or dispatch.

Vendored content under `references/<source>/` is exempt for the same reason em-dash-style exempts it: references are read-only snapshots of upstream material.

## How to write the change

When rewriting on encounter, read the surrounding sentence first. Many Latin shorthands sit at sentence joints where the English replacement wants different surrounding punctuation:

- `Foo, e.g. bar.` → `Foo, for example bar.` or `Foo (for example, bar).`
- `Foo, i.e. bar.` → `Foo. That is, bar.` or `Foo (that is, bar).`
- `Foo, etc.` → `Foo and similar cases.` or enumerate: `Foo, baz, and qux.`
- `cf. § Bar` → `See § Bar.` or `Per § Bar.`

Pick by reading. The goal is prose a reader can absorb at a glance, not a token-for-token translation.

## Motivating incident

kriskowal review on `endojs/endo-but-for-bots#351` at 2026-06-02T20:45:07Z, inline on `packages/compartment-mapper/src/link.js` line 73: "Please avoid Latin. Dispatch to gardener to improve style guide." The fixer half landed the immediate code fix (the `cf.` on the cited line plus a whole-file scan); this skill is the gardener half, encoding the norm so future bot-authored prose avoids the same shorthand.

## Pitfalls

- **Don't over-rewrite quoted maintainer prose.** When a journal entry, design document, or PR description quotes the maintainer verbatim, preserve the original. The norm covers prose the bot authored, not prose the bot is faithfully reproducing.
- **Don't sweep in passing.** "Fix on encounter" means inside the file you are already editing for a reason. Spinning out a Latin-shorthand-sweep dispatch on its own is not authorized by this skill.
- **`vs.` in compact contexts.** A column header or short label where `versus` would be awkward (`A vs. B` in a benchmark table) is a judgment call; rewriting to "versus" is fine but not required when the compact form is genuinely clearer.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-06-02_: encoded after kriskowal review on `endojs/endo-but-for-bots#351` (inline 20:45:07Z). The triggering shorthand was `cf.` on a single line; the skill scope is wider because the underlying signal is "avoid Latin shorthand", not "avoid `cf.` specifically".
