---
title: §The prompt-on-failure capture pattern — `git hash-object -w --stdin`
source-slug: garden--designs-driver-md
section-slug: the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
source-url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
source-repo: kriskowal/garden
source-path: designs/driver.md
source-author: gardener + fixer + designer
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
---

Lines 358-398 carry §the-prompt-on-failure-capture-pattern:

> *On a failure the script cannot interpret, captures the log via `git hash-object -w --stdin` and passes the SHA into the prompt; claude reads the log on demand via `git cat-file blob`.*

§First-explicit-observation in library: **§the-prompt-on-failure-capture-pattern — §the-failure-log-IS-written-to-the-git-object-store + §the-SHA-IS-passed-to-the-LLM-prompt + §the-LLM-reads-the-log-on-demand-via-`git cat-file blob` + §the-pattern-AVOIDS-stuffing-the-full-log-into-the-prompt + §the-LLM-pulls-only-the-portions-it-needs**.

§Sibling-pattern to many systems' log-by-reference patterns; §the-discipline-IS-cheap-prompt-context-not-eager-load-of-log-content.

§The-`git hash-object`-and-`git cat-file blob`-pair-IS-content-addressed-log-storage — §sibling-pattern to cycle 276's sha512-sharded-cache + cycle 275's SHA-256 blob-storage; §three-cycles-with-content-addressed-storage-disciplines (275 + 276 + 281).

§First-explicit-observation in library: **§three-cycles-with-content-addressed-storage-disciplines (275 SHA-256 blob-storage + 276 SHA-512 source-map-cache + 281 git-object-store-for-failure-logs)**.
