---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Skill: em-dash style

## The rule

Avoid em-dashes (`—`, U+2014) in prose. Prefer separate sentences, parentheses, or colons. In technical documentation, em-dashes obscure the rhythm of the prose and almost always read better as their own sentence.

The rule covers prose only. Em-dashes inside code formatting (quoting the character itself, regex literals, ASCII art) are fine. En-dashes (`–`, U+2013) for numeric ranges (`80–100`) are also fine.

## Scope

The garden adopted this rule in 2026-05-12. It applies to every garden-authored document: `CLAUDE.md`, `WORKTREES.md`, every `roles/*/AGENT.md`, every `skills/*/SKILL.md`, and our own `references/*/README.md` files.

Vendored content under `references/<source>/` (everything other than our own README files) is left as-is. References are read-only snapshots of upstream material; sweeping them would defeat the snapshot.

Journal entries already committed are append-only and are not rewritten. Going forward, journal entry bodies follow the rule like everything else.

## How to write the change

Replace each em-dash with one of:

- A period: `Foo bar — baz qux.` becomes `Foo bar. Baz qux.`
- Parentheses: `Foo bar — baz qux — quux.` becomes `Foo bar (baz qux) quux.`
- A colon: `Foo bar — baz qux.` becomes `Foo bar: baz qux.`

Pick by reading; mechanical substitution often reads worse than the original. When the em-dash was joining a brief aside to a longer clause, parentheses usually win. When it was acting as a colon (introducing an elaboration), use the colon. When it was joining two thoughts that could stand alone, use a period.

## How to sweep

```sh
grep -RnP "\xe2\x80\x94" --include='*.md' . \
  | grep -v ^./references/ \
  | grep -v 'references/.*/README.md'
```

The chained `grep -v` excludes vendored references but keeps our own README files inside `references/`. Adjust the pattern when sweeping a single file.

For a single file, use `grep -nP "\xe2\x80\x94" path/to/file.md`.

## Pitfalls

- **Editor smart punctuation.** Some editors substitute three-hyphen sequences with em-dashes. Disable smart quotes if phantom em-dashes appear in diffs.
- **Bullet leaders.** A bullet that begins `- Foo — bar` reads worse as `- Foo - bar` (the dash blurs with the bullet). Recast as `- Foo. Bar` or `- Foo (bar)`.
- **Tool output and pasted text.** `gh pr view`, GitHub web copy-paste, and many CLI tools emit em-dashes. Rewrite when quoting verbatim into prose; preserve when quoting inside fenced code blocks.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-12_: adopted from `../../references/endo-but-for-bots/skills/em-dash-style-rule.md`. The source's table-cell sentinel exception (`| — | — |` placeholders in a project-specific README) was dropped (we have no such tables). Adoption included a one-time sweep of every garden-authored document at commit `422a15a`.
