---
title: Staged, dry-run-by-default structural rewrite
source: crates/pi-natives/src/ast.rs
source_repo: can1357/oh-my-pi
source_commit: e4517e1586ac56d2806a9a466e0f3f58aa4b587d
source_date: 2026-10-05
source_authors: [can1357, roboomp, HvC]
ingested: 2026-10-07
ingested_by: scholar
topics: [programming-language-design, tooling, llm-agent-frameworks]
status: current
---

> Abstract: `astEdit` applies a map of ast-grep pattern-to-template rewrites across files in their own detected languages. It is a dry run unless the caller opts out, caps total replacements and touched files, deduplicates identical edits from overlapping rules, and stages every output in memory so files are written only after the whole pass computes successfully, through the same injectable filesystem as search.

## Inputs and defaults

`AstReplaceOptions` takes `rewrites` (a map from pattern string to replacement template; keys must be non-empty and at least one mapping is required), an optional `lang` override, a `path` (a host path or absolute `scheme://` URL), a `glob`, a rule `selector`, a `strictness`, `maxReplacements`, `maxFiles`, `failOnParseError`, a cancel signal, `timeoutMs`, and a `filesystem` through which candidates are "resolved, walked, read, and written".

Defaults are conservative: `dryRun` is **true** when omitted, so a caller must ask for writes explicitly. `maxReplacements` and `maxFiles` default to unbounded but are floored at 1, and `failOnParseError` defaults to false.

## Mixed-language trees

Without a `lang` override each file is rewritten in its own language. A rule is compiled for every language present among the candidates; a rule that fails to parse in some of those languages skips those languages' files and records parse errors, because a pattern usually targets one language. A rule that parses in no discovered language is a real pattern error and fails the call. With `failOnParseError`, any per-file parse failure aborts the operation.

## Edit staging

When several rules match the same node with the same output, the edit is listed and counted once instead of staging a duplicate that would trip the apply-time overlap check. Replacement counting stops at `maxReplacements`, and file processing stops at `maxFiles`, setting `limitReached`.

The source states the write discipline directly: "Stage writes in memory so a later compute error cannot leave earlier files partially modified on disk; flush only after the whole pass succeeds." Writes then go through the injected filesystem one file at a time. This protects against a compute error midway through the pass. It is not a cross-file transaction: a write failure partway through the flush is reported as an error after earlier files have been written.

## Result

`AstReplaceResult` reports each change (file, before and after text, byte span, deleted length, line and column range), per-file counts, `totalReplacements`, `filesTouched`, `filesSearched`, `applied` (false for a dry run), `limitReached`, and `parseErrors`. Previewing a refactor and applying it share one code path, differing only in whether the final flush runs.

## Relation to hashline

This is a structural, pattern-addressed edit surface. The garden's existing hashline material (`designs/cli-edit-verb.md` in endo-but-for-bots) concerns line-addressed edits with content-hash anchors. Both sit on oh-my-pi's native layer but address text differently, and neither replaces the other.

Source: [crates/pi-natives/src/ast.rs](https://github.com/can1357/oh-my-pi/blob/e4517e1586ac56d2806a9a466e0f3f58aa4b587d/crates/pi-natives/src/ast.rs) at commit `e4517e15`.
