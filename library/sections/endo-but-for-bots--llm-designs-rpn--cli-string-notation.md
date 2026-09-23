---
title: CLI string notation (path-segment + escaping + group-membership + multi-path)
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, tooling]
status: current
notes: The five prefixes (`@`, `*`, `/`, `:`, `~`) are the canonical visual taxonomy: persistent root, transient root, pet-name edge, field edge, retention edge. The `#<type>+<mergeKind>` suffix is for groups. Pet-name escaping uses quoted form `/"name with spaces"` with backslash-escapes — chosen over percent-encoding because it reads better, though percent-encoding flagged as open question. The `*` prefix on transient roots means a pet name beginning with `*` must render as `/"*..."`.
---

> Abstract: **Goals**: unambiguous, type-able with no modifier keys, monospace-renderable, compact for pet-name-only paths, distinguishable per edge kind without color. **Path-segment notation** (left-to-right, root to target): persistent root `@<root-name>` (e.g., `@endo`, `@known-peers-store`); transient root `*<root-id-prefix>` (e.g., `*7a3f`; defaults to 4-char prefix, `--full-ids` reveals); pet-name edge `/<name>`; field edge `:<field>` (`:worker`, `:hub`); retention edge `~peer:<peer-id-prefix>`. Concatenated with no whitespace. First segment is always a root. Last segment names the target. Target's group type appended after `#` to disambiguate (`#eval`, `#worker`, `#promise+resolver`). Examples: `@endo/pins/shared-file#eval`, `@endo:hub/alice/inbox/2026-05#eval`, `@known-peers-store:hub~peer:7a3f/shared-file#eval`, `*7a3f/scratch#eval`. Parsing: left-to-right, single-character lookahead on `/`, `:`, `~`, `#`, `@`, `*`. Root names + field names are closed sets. **Pet-name escaping**: a pet-name segment containing any of `/`, `:`, `~`, `#`, or whitespace renders in quoted form `/"name with spaces"` (with `\` and `"` backslash-escaped). Bare form `/inbox` for names without special chars. **Group-membership rendering**: merged-group segments render with the merge kind appended (`#promise+resolver`, `#host+handle`) rather than a count; full member list via `--verbose` or expanded inspector panel. **Multi-path listing**: `endo paths <name-or-locator>` prints one path per line with index prefix. **Best-path display in row-oriented surfaces** (`endo workers`): one path per target plus a `+N` suffix when more exist.

### Goals

A retention-path notation must be unambiguous (one string → one path), type-able (no modifier keys), monospace-renderable, compact for the common pet-name-only case, and distinguishable per edge kind without color.

### Path-segment notation

A retention path renders left-to-right from a GC root toward the target. Each segment produces one textual form:

| Segment | Notation | Example |
|---|---|---|
| Persistent root | `@<root-name>` | `@endo`, `@known-peers-store` |
| Transient root | `*<root-id-prefix>` | `*7a3f` |
| Pet-name edge | `/<name>` | `/inbox`, `/alice` |
| Field edge | `:<field>` | `:worker`, `:hub`, `:slot0` |
| Retention edge | `~peer:<peer-id-prefix>` | `~peer:7a3f` |

A complete path concatenates segments with no intervening whitespace. The first segment is always a root. Persistent roots use the `@` prefix; transient roots use the `*` prefix to distinguish a short-lived pin from a named root. The transient root identifier defaults to a 4-char prefix of the root formula's id; `--full-ids` reveals the full id. The last segment names the target. The target's group type is appended after a `#` to disambiguate when the same name resolves to different formula types in different paths.

Examples:

```
@endo/pins/shared-file#eval
@endo:hub/alice/inbox/2026-05#eval
@known-peers-store:hub~peer:7a3f/shared-file#eval
@endo/host:worker#worker
*7a3f/scratch#eval
```

Parsing is left-to-right, single-character lookahead on `/`, `:`, `~`, `#`, `@`, `*`. The set of root names is closed (`endo`, `known-peers-store`, plus a small fixed list maintained alongside `formula-type.js`'s root formulas). Field names are drawn from `extractLabeledDeps` and are also a closed set.

### Pet-name escaping

Pet names can contain any character except `/`, `\0`, and `@`; in particular `:`, `~`, `#`, `*`, and whitespace are all permitted. The notation cannot assume those characters are absent.

A pet-name segment whose body contains any of `/`, `:`, `~`, `#`, or whitespace renders in a quoted form:

```
/"name with spaces"
/"name:with:colons"
/"name#hash"
```

Quoted form: a leading `/`, a `"`, the literal pet name with `\` and `"` backslash-escaped, a closing `"`. A pet name with no special characters renders bare (`/inbox`); the parser accepts both forms.

The `@` character cannot appear in a pet name (rejected by the pet-name validator), so the leading `@` of a root segment is unambiguous. `*` cannot occur immediately after a segment delimiter without ambiguity (reserved for transient-root prefix); a pet name beginning with `*` renders as `/"*..."`.

### Group-membership rendering

A retention-path segment can correspond to a group of formulas merged by union-find (host+handle, channel+handle, promise+resolver). The default rendering picks the segment's primary pet-name (if any) or the group representative's id, and appends `+<mergeKind>` to name the merge:

```
@endo/promise#promise+resolver
@endo/host#host+handle
```

The full member list is available via `--verbose` (CLI) or the expanded inspector panel. The `+<mergeKind>` form is more informative than a count and reads naturally for the small fixed set of merges produced by `graph.js`'s union-find.

### Multi-path listing

For surfaces that want every path (the per-target inspector deck or `endo paths <name-or-locator>`), call the single-target `listRetentionPaths(locator)` from `daemon-retention-paths.md`. The CLI lists them one per line, prefixed with the path index and rendered with the notation above:

```
$ endo paths shared-file
1  @endo/pins/shared-file#eval
2  @known-peers-store:hub~peer:7a3f/shared-file#eval
```

### Best-path display in row-oriented surfaces

For row-oriented surfaces where one path per target is the constraint (`endo workers`, the workers-panel tenant list), the host returns a single best path; the CLI renders that path and (when there are more) appends a `+N` suffix indicating additional paths exist:

```
worker-7a3f
  @endo/pins/shared-file#eval +1
  @endo/inbox:mailHub#mail-hub
```

The CLI obtains `+N` either from a separate count field (added in a follow-up) or by calling the per-target `listRetentionPaths(locator)` on demand when the operator drills in. This iteration ships the best-path return without the count; surfaces that want the count call the per-target API.

If no path is reachable, the best-path string is empty and the row falls back to the locator.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
