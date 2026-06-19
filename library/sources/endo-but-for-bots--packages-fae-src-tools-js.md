---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/fae/src/tools.js
source_line_range: 1-96
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 416 chat-lane ingest. 95-line tools.js from @endo/
  fae/src — the tool-discovery module the cycle 415
  COMPARISON document referenced. Sixty-fourth AUTHORED
  conformant single-body section doc in post-refactor era.
  One-hundred-and-six consecutive non-garden sources after
  the pivot (310-416). §one-hundred-and-six-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  asymmetric-error-handling-local-trusted-remote-
  defensive — the file treats LOCAL tools and REMOTE
  tools differently for error handling. Lines 32-34
  (local): `for (const tool of localTools.values()) {
  schemas.push(tool.schema()); }` — NO try/catch. If a
  local tool's schema() throws, the discovery FAILS.
  Lines 57-67 (remote): try/catch around the schema()
  call, console.warn on failure, SKIP the tool but
  continue discovery. The trust boundary mirrors the
  cap-security model: local code is THIS AGENT's code
  (trusted to follow the FaeTool contract); remote code
  is SOMEONE ELSE's code (validated defensively because
  the contract may not hold). §the-named-trust-boundary-
  as-error-handling-asymmetry as tier-3 meta-pattern;
  the source code's structure reflects the security
  model.

  §the-named-graceful-tool-discovery-failure-via-warning
  — lines 63-67: a remote tool that doesn't conform to
  the FaeTool interface produces a console.warn but
  doesn't fail discovery. The agent gets a PARTIAL
  tool set rather than crashing. §the-named-partial-
  discovery-over-total-failure as tier-3 meta-pattern.

  §the-named-CONFIRMS-cycle-415-runtime-discovery — lines
  22-23: "Called at the start of each agent turn so that
  tools adopted between turns (e.g., received via mail)
  are immediately available." Verifies cycle 415's
  COMPARISON-FAE-LAL.md claim of runtime-tool-discovery-
  per-turn. §the-named-comparison-claim-confirmed-by-
  source as tier-3 meta-pattern; another counterexample
  to drift framings (cycle 412 named this for
  Anthropic-ID synthesis; cycle 416 adds another
  instance).

  §the-named-local-tools-take-precedence-over-daemon-
  tools — line 55: `.filter(name => !toolMap.has(name))`.
  The daemon's tools/ directory is added only for names
  not ALREADY in the local toolMap. Local tools shadow
  daemon tools by name. §the-named-shadowing-by-local-
  precedence as tier-3 meta-pattern.

  §the-named-parallel-tool-discovery-via-allSettled —
  line 53: `await Promise.allSettled(names...)`. Tool
  schemas are fetched in PARALLEL using allSettled — one
  tool's failure doesn't fail the others. §the-named-
  parallel-with-isolation-via-allSettled as tier-3 meta-
  pattern.

  §the-named-unknown-tool-error-lists-available-tools —
  lines 89-90: `throw new Error(\`Unknown tool: "${name}".
  Available tools: ${available}\`)`. The error message
  for an unknown tool LISTS all available tool names.
  Diagnostic helpfulness baked into the error path.
  §the-named-helpful-error-with-available-options as
  tier-3 meta-pattern; sibling to general "error
  messages should help debug" discipline.

  §the-named-missing-directory-equals-empty-directory —
  lines 41-46: `try { maybeToolNames = await E(host).
  list('tools'); } catch { maybeToolNames = []; }`. A
  missing tools/ directory is treated the same as an
  empty one. §the-named-defensive-fallback-to-empty as
  tier-3 meta-pattern.

  §the-named-type-narrowing-via-JSDoc-predicate — lines
  47-52: the .filter callback has a JSDoc annotation
  declaring its predicate as `x is string`. TypeScript-
  via-JSDoc type narrowing for runtime filtering.
  §the-named-JSDoc-type-predicate-for-runtime-filter as
  tier-3 meta-pattern; the Endo/SES discipline reaches
  into runtime-type-narrowing via JSDoc rather than
  pure TypeScript syntax.

  §the-named-stale-eslint-disable-no-active-violations
  — line 3: `/* eslint-disable no-await-in-loop */` at
  file level. But discoverTools uses Promise.allSettled
  (not await-in-loop); executeTool doesn't loop. The
  disable is unnecessary in the current code.
  §the-named-defensive-or-stale-eslint-disable as
  tier-3 meta-pattern; cluster's growing inventory of
  documentation-vs-code drift now extends to LINT-
  CONFIG-vs-CODE drift.

  §the-named-harden-on-both-exports — lines 73, 95:
  both discoverTools and executeTool are explicitly
  hardened. Counterexample to providers/ directory's
  absence (cycles 406, 408, 412). §the-named-fae-src-
  follows-harden-convention as tier-3 meta-pattern.
  Cluster's harden-discipline-inconsistent-across-
  package framing extends: the inconsistency is PER-
  SUBDIRECTORY (lal/providers don't harden; lal/setup
  does; conversation-tree does; fae/src does).

  §the-named-eventual-send-uniform-across-local-and-
  remote — line 92: `await E(tool).execute(args)`. The
  E() invocation works for both local FaeTool exo
  objects AND remote far-references. §the-named-E-
  send-as-locality-transparent as tier-3 meta-pattern;
  one of the deepest Endo idioms — the same call
  syntax for in-process and cross-process invocation.

  §the-named-toolMap-as-typed-union-by-locality —
  line 36: `Map<string, FaeTool | object>`. Local
  tools are typed FaeTool; remote tools are typed
  `object` because the CapTP boundary erases
  interface information. §the-named-type-union-
  reflects-trust-boundary as tier-3 meta-pattern;
  another shape where the SECURITY model influences
  the CODE structure.

  §the-named-DiscoveredTools-two-field-shape — lines
  13-16: DiscoveredTools is `{ schemas: ToolSchema[],
  toolMap: Map<string, FaeTool | object> }`. Two
  fields: the LLM-facing schemas array AND the
  dispatch-facing toolMap. Same data, two organizations.
  §the-named-LLM-facing-vs-dispatch-facing-shapes as
  tier-3 meta-pattern; sibling to cycle 414's storage-
  vs-presentation framing.

  §the-named-no-tool-version-tracking — the discoverTools
  doesn't track tool versions. Each turn re-fetches
  the schema fresh. If a tool's interface changes
  between turns, the LLM sees the new shape. §the-
  named-stateless-discovery as tier-3 meta-pattern.

  §the-named-sixty-four-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 415 (1, adjacent
  forward; COMPARISON-FAE-LAL claimed runtime tool
  discovery; cycle 416 verifies in source) + cycle
  414 (3, two-field DiscoveredTools shape echoes
  storage-vs-presentation) + cycle 412 (3, comparison-
  claim-confirmed-by-source recurs — design-doc-
  prediction-matches-code third instance) + cycle 406
  (3, harden-discipline subdirectory-pattern extends)
  + cycle 387 (5, FaeTool branded-interface via
  M.interface — confirms cycle 415's faetool-as-exo
  framing) + cycle 401 (3, eventual-send framing
  applied uniformly) + cycle 326 (75) + cycle 322
  (75) + cycle 364 (4, shapes count) + cycle 318 (3,
  Endo idiom). Pushes citation-arc-closures-in-pivot
  to SIX-HUNDRED-AND-TWENTY-SIX (617 + 9 net new).
---

95-line tools.js from @endo/fae/src — the tool-discovery module the cycle 415 COMPARISON document referenced. Chat-lane after cycle 415 designs-lane COMPARISON-FAE-LAL.md. **Single most structurally interesting move**: §the-named-asymmetric-error-handling-local-trusted-remote-defensive — *the file treats LOCAL tools and REMOTE tools differently for error handling. Local tools' schema() calls have NO try/catch (lines 32-34) — failure halts discovery. Remote tools' schema() calls have try/catch + console.warn + skip (lines 57-67) — the agent gets a partial tool set. The trust boundary mirrors the cap-security model.* §the-named-trust-boundary-as-error-handling-asymmetry as tier-3 meta-pattern. §the-named-graceful-tool-discovery-failure-via-warning; §the-named-partial-discovery-over-total-failure. §the-named-CONFIRMS-cycle-415-runtime-discovery (lines 22-23 verify the COMPARISON document's claim); §the-named-comparison-claim-confirmed-by-source. §the-named-local-tools-take-precedence-over-daemon-tools; §the-named-shadowing-by-local-precedence. §the-named-parallel-tool-discovery-via-allSettled; §the-named-parallel-with-isolation-via-allSettled. §the-named-unknown-tool-error-lists-available-tools; §the-named-helpful-error-with-available-options. §the-named-missing-directory-equals-empty-directory; §the-named-defensive-fallback-to-empty. §the-named-type-narrowing-via-JSDoc-predicate; §the-named-JSDoc-type-predicate-for-runtime-filter. §the-named-stale-eslint-disable-no-active-violations (file-level disable with no await-in-loop in the code); §the-named-defensive-or-stale-eslint-disable (lint-config-vs-code drift). §the-named-harden-on-both-exports (counterexample to providers/ absence); §the-named-fae-src-follows-harden-convention (harden inconsistency is PER-SUBDIRECTORY). §the-named-eventual-send-uniform-across-local-and-remote; §the-named-E-send-as-locality-transparent. §the-named-toolMap-as-typed-union-by-locality (FaeTool | object — interface info erased at CapTP boundary); §the-named-type-union-reflects-trust-boundary. §the-named-DiscoveredTools-two-field-shape (schemas[] + toolMap); §the-named-LLM-facing-vs-dispatch-facing-shapes (sibling to cycle 414's storage-vs-presentation). §the-named-no-tool-version-tracking; §the-named-stateless-discovery. §the-named-sixty-four-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-TWENTY-SIX.
