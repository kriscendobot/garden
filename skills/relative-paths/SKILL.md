---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---

# Skill: relative paths and links

## The rule

Within a single document tree, every link, cross-reference, and path in a documentation file is **relative**, never absolute. This covers:

- Markdown links: `[text](../skills/foo/SKILL.md)`, not `[text](/Users/kris/garden/skills/foo/SKILL.md)`.
- Inline code references in prose: `` `roles/liaison/AGENT.md` ``, not `` `/Users/kris/garden/roles/liaison/AGENT.md` ``.
- Sample commands shown in skill files: `git -C journal log`, not `git -C /Users/kris/garden/journal log`. When the command needs to communicate "the garden root", use `<garden-root>` as a placeholder.

External URLs (`https://github.com/...`, RFC links, package registry URLs) are always absolute by nature and unaffected.

## The cross-tree exception

The garden is read by two kinds of consumer that sit in different filesystem locations:

1. The liaison, standing in the garden root.
2. Subagents, dispatched into worktrees that may live anywhere on the host.

When a document instructs a consumer in tree A to read a file in tree B, the path **must be absolute** because the consumer's cwd is unknown. In practice this means:

- `roles/COMMON.md` cites garden artifacts by absolute path (`/Users/kris/garden/skills/<name>/SKILL.md`) because subagents read it from inside their worktrees.
- The dispatch prompt template in `CLAUDE.md` uses absolute paths for the same reason.
- A role file's `## Skills` list links to skills inside the garden using a relative path (`../../skills/<name>/SKILL.md`) because role and skill files live in the same tree.
- A reference shelf README links to files inside the same shelf using relative paths.
- A reference shelf README linking to a top-level garden doc (e.g., `../../WORKTREES.md`) uses a relative path because both live in the garden tree.

The test: if both the citing document and the cited file live under the same tree (the garden as a whole, or one worktree), use a relative path. If they live in different trees (a worktree citing a garden file the subagent must read), use an absolute path.

## Why

Absolute paths bake in the developer's working-directory layout. A document that says `/Users/kris/garden/foo` is wrong on every machine but this one. The same path written as `foo` (or `../foo` from a sibling directory) works wherever the document is read, including from a fork, a clone, a tarball, or a GitHub web view.

For markdown links specifically, the relative form lets GitHub's web renderer resolve cross-document links into navigable links rather than 404s.

The cross-tree exception exists because subagents have no anchor: they cannot know where the garden lives relative to their worktree without being told.

## How to write paths

Inside a `.md` file at `<root>/<dir>/<file>.md`, write:

- `./sibling.md` (or just `sibling.md`) for a same-directory file.
- `../other-dir/foo.md` for a sibling directory.
- `../../some-package/README.md` to reach up two levels.
- `packages/foo/src/bar.js` (no leading `./`) when the path is inline-code prose, not a markdown link target. Either form is fine for prose; pick one and stay consistent within a file.

## Pitfalls

- **Sample commands.** Tutorials sometimes paste `cd /Users/kris/garden` because the agent ran the command from there. Rewrite as `cd <garden-root>` or omit the `cd` entirely.
- **Tool output.** Pasted output from `find`, `grep -rn`, or `git status` often includes absolute paths. Strip the prefix before pasting into prose.
- **Cross-repo references.** When a file legitimately needs to point at a sibling repo, use a relative path with `..` rather than an absolute machine path.
- **Worktrees of bare clones.** A worktree's `.git` is a pointer file, not a directory. References to per-worktree git admin paths should use the bare clone path (e.g., `<bare>/info/exclude`), not a per-worktree `.git/info/exclude` that does not exist.
- **Confusing the cross-tree exception with laziness.** The exception is for documents that genuinely instruct an agent in another tree. Within `roles/`, `skills/`, or any one tree, relative wins.

## How to sweep

```sh
grep -RnP "/Users/[^ )\\\"\`'<]+" --include='*.md' . \
  | grep -v ^./references/ \
  | grep -v 'references/.*/README.md'
```

For each hit, decide whether the absolute path is one of the legitimate cross-tree cases (keep) or a within-tree reference (rewrite as relative). When in doubt, ask: would a reader running on a different machine be able to follow this path? If yes, the path is fine. If no, rewrite.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-12_: adopted from `../../references/endo-but-for-bots/skills/relative-paths-rule.md`. The source assumes a single repo where all interior references are within one tree. Our adaptation adds the explicit cross-tree exception so that `roles/COMMON.md` and dispatch prompts can keep their absolute paths to garden artifacts: subagents reading them from worktrees have no shared anchor without an absolute path. Adoption included a one-time sweep at commit `422a15a`.
