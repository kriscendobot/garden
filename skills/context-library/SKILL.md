---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: context-library

How agents and roles author agent-optimized hierarchical documentation in the
journal. The journal is read by future agents, not by humans skimming a wiki.
The conventions below optimize for the agent's path: arrive at the right
document quickly, descend only when an abstract justifies it, and abandon the
trail when an abstract makes clear the branch is wrong.

This skill is canonical for two context trees on two branches, same discipline:
the journal trees (the `journal2` branch, directory `journal/`) that aspire to be
browsable as context — `journal/projects/`, `journal/agents/`, and any future
tree a doc-growth job grows — **and the `context/` tree on `main2`** (the
garden's operator manual for agents: `context/first-run/`, `context/operations/`;
see `context/README.md`). Both obey this same discipline; they differ only in
branch and audience (per-instance research vs. shipped-with-code operator
procedure). Role and skill files in the garden library (`main2`) are written for
the same reader (an agent reading them at claim time), but their layout is fixed
by the library README; this skill does not retroactively reshape them.

## When to use

- Authoring a new directory under `journal/` that will hold context (projects,
  agents, designs, glossaries).
- Adding a child file or subdirectory to an existing context tree.
- Refactoring an existing document that has grown long enough to split.
- Reviewing whether a context tree's abstracts still describe what is below them.

## The discipline

### Directory-as-hierarchy

Every directory that is part of a context tree carries a `README.md` index. The
index is the entry point for an agent arriving at the directory; it is **not** a
"what is in this folder" listing of filenames. It is the prose contract that
says, for each child, "this is what you will find if you descend here."

A directory's children should **partition the topic cleanly**. Over-general
parents are fine if children disambiguate; that is the entire point of the
hierarchy. The parent's job is to route the reader to the right child. If two
children's abstracts overlap, refactor: either merge them, or sharpen the
boundaries until they no longer overlap.

### Abstract-at-the-top

Every document in a context tree opens with a short prose abstract, before any
other sections. The abstract is specific enough that a reader can decide whether
to descend without reading the body. "Specific" means:

- It names the topic in terms the reader's query would use.
- It states what is in this document and (when useful) what is *not* in it.
- It does not paraphrase the body's prose; it predicts the body's value.

A reader who matches their query against the abstract should be able to
confidently commit to reading the body (or abandon and try a sibling). A vague
abstract ("notes on the project") forces the reader to scan the body anyway,
defeating the indirection.

### The exit-criteria contract

The abstract is a **contract**: the body must live up to it. An agent following
a trail uses the abstract as a stop condition. If the abstract does not match the
query, the agent abandons the search at that level. If the body fails to deliver
on the abstract, that is a defect the next author should fix (sharpen the
abstract, or rewrite the body to match).

Concretely, an agent walking the tree:

1. Reads the parent's index README.
2. Picks the child whose one-line abstract best matches the query.
3. Reads that child's full abstract (the first prose paragraph).
4. If the abstract matches, descends. If not, returns to step 2 with the
   next-best child.
5. If no child matches at any level, returns "nothing found at `<breadcrumbs>`;
   tried `<list>`."

A posted `librarian` job (any agent can post one; see [librarian]) is the
job-time embodiment of this walk: a gardener claims it and walks the tree on the
poster's behalf, returning the breadcrumbs and the answer.

### Partitioning rule

Children of a directory should partition their parent's topic cleanly. The test:
pick a hypothetical query that fits the parent's topic; can you predict which
child it lands in from the children's abstracts alone? If the answer is "either
of two" or "neither," repartition.

When a topic does not partition cleanly, the right answer is usually **deeper
hierarchy**, not a longer document. Two siblings that keep colliding probably
want a shared grandparent that splits the topic at a coarser cut.

### Prefer many small files to one long file

A single long file with numbered sections is the failure mode this skill exists
to prevent. Symptoms: a `README.md` with `## Section 1`, `## Section 2`,
`## Section 3` headings where each section is half-a-screen; readers grep for
keywords rather than navigating the hierarchy; new content gets appended as a new
section rather than placed in the partition tree.

The corrective: each section becomes a sibling file (or a subdirectory with its
own README), and the parent's index lists each by abstract. The parent gets
shorter, the children get individually navigable, and the abstracts give the
reader an explicit decision point at every step.

### Cross-references

Within one tree, use **relative paths** (`./peer.md`,
`../sibling-topic/README.md`). Across trees (a project README citing a garden
skill), use **absolute paths**. Apply consistently.

The cross-tree case is common in `journal/projects/`: a project README cites a
garden skill by absolute path because the journal (`journal2`) and the garden
library (`main2`) are separate trees. Within the project's own subtree (e.g.,
`journal/projects/<slug>/<topic>.md` citing `./README.md`), keep paths relative.

### One-liner

Prefer many small files in a deep tree to a single long file with numbered
sections. The agent reads the abstracts of small files faster than it scans a
long file's sections, and the directory shape advertises the partition
explicitly.

## Procedure

When adding a new context document:

1. **Locate the right directory** by walking the existing hierarchy. If no
   directory matches, the new document is either at the root of a new tree (rare)
   or you are missing a parent partition.
2. **Write the abstract first.** Force yourself to articulate what is in this
   document before writing the body. If the abstract is hard to write, the
   document's scope is probably wrong.
3. **Check siblings.** If your new abstract overlaps with a sibling's, you need
   to repartition before adding more material.
4. **Update the parent README** to list the new child with a one-line abstract
   that matches (a summary of) the new document's abstract.
5. **Mind the cross-references.** New cross-tree references use absolute paths to
   the garden library; within-tree references are relative.

When refactoring an existing context document:

1. **Identify the sections that have grown into independent topics.** Symptoms:
   a section with its own subsections, a section repeatedly cited from outside, a
   section that answers a recurring query in isolation.
2. **Spin the section into a sibling file** with its own abstract.
3. **Rewrite the parent's abstract** to predict the new child set, not the old
   section list.
4. **Sweep references** that named the old section anchor. External cites should
   now point to the new sibling file.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-13_: authored alongside the seed `journal/projects/` tree. The
  framing comes from the maintainer's brief on agent-optimized documentation; the
  librarian-walk shape is what motivates the exit-criteria contract being
  explicit.
- _2026-06-24_: migrated into v2. Pointed the journal references at the
  `journal2` layout and the library references at `main2`; replaced the v1
  librarian-role embodiment with the posted-`librarian`-job form.
