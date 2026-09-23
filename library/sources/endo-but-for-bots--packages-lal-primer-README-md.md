---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/README.md
source_line_range: 1-37
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 405 designs-lane ingest. 37-line primer/README.md,
  the index of @endo/lal's agent-facing primer directory.
  Seventh lal-package artifact in the cluster after the
  README (cycle 399), providers/config.js (cycle 400),
  LAL-ARCHITECTURE.md (cycle 401), agent.types.d.ts
  (cycle 402), test/simulator/README.md (cycle 403), and
  test/simulator/mock-powers.js (cycle 404). The primer
  directory itself contains 13 files totaling 1168 lines;
  this README.md is the entry index. Fifty-third AUTHORED
  conformant single-body section doc in post-refactor era.
  Ninety-five consecutive non-garden sources after the
  pivot (310-405). §ninety-five-cycles-with-named-pivot-
  domain-stay.

  Single most structurally interesting move: §the-named-
  third-surface-for-third-audience — the primer reveals
  a THIRD surface the cluster has not yet named, beyond
  the two named in cycles 401-404. Cycle 401 named the
  LLM-exposed tool catalog (16-18 tools). Cycle 404 named
  the guest-power method surface (22 methods in the
  mock; the LLM-tool surface is a subset). Cycle 405's
  primer/README.md reveals the USER-FACING Chat slash-
  command surface: `/ls`, `/view`, `/edit`, plus the
  `@recipient message` addressing form. The agent
  system has THREE distinct surfaces for THREE distinct
  audiences:
  1. LLM-exposed tool catalog (16-18 tools; for the LLM)
  2. Guest-power method surface (22 methods; for the
     agent's internal use)
  3. User-facing Chat slash commands and @-addressing
     (for the human user; the WEB UI inside Familiar)
  §the-named-three-surfaces-three-audiences as tier-3
  meta-pattern.

  §the-named-tool-name-drift-across-agent-facing-docs —
  line 10 of primer/README.md gives example tools as
  "list, readText, inspect, etc." But cycle 401's LAL-
  ARCHITECTURE.md tool catalog has `lookup` (not
  readText) and `inspectCapability` (not just inspect).
  The primer README mentions `readText` which is NOT in
  the LAL-ARCHITECTURE catalog at all. So either: (a)
  the primer was written for an earlier or later
  version of the tool catalog, or (b) the primer's
  example listing is loose. §the-named-primer-tool-
  examples-drift-from-architecture-catalog as tier-3
  meta-pattern. The cluster's drift vocabulary now
  identifies drift even within the agent-facing
  documentation set.

  §the-named-primer-as-package-local-internal-docs —
  the primer lives at packages/lal/primer/*.md, inside
  the code package directory. Not on a public docs
  site; not in a separate documentation repo. §the-
  named-internal-package-docs-as-runtime-resource as
  tier-3 meta-pattern; the docs are PART of the
  package's distribution surface, suggesting they may
  be consumed at runtime.

  §the-named-primer-existence-vs-no-dynamic-context-
  claim — cycle 401's LAL-ARCHITECTURE.md said: "There
  is no dynamic context building — no workspace files,
  no memory consolidation, no skills system. The
  system prompt is a single hardcoded string." But the
  primer directory contains 13 files totaling 1168
  lines — substantial agent-facing content. Three
  possibilities: (a) the primer is INLINED into the
  hardcoded system prompt (making the system prompt
  enormous); (b) the primer is available via some
  lookup mechanism (contradicting the no-dynamic-
  context claim); (c) the primer is for human readers
  / maintainers / future versions and not consumed by
  the current agent at runtime. The design doc and the
  primer's framing both phrase the agent as having no
  workspace, yet here is a workspace of documents
  shipped in the package. §the-named-primer-claim-vs-
  design-claim-tension as tier-3 meta-pattern.

  §the-named-primer-organized-by-audience — the primer
  README structures its 13 files into three sections:
  Agent Reference (6 files; for the LLM), User
  Interface Reference (2 files; for the human user),
  and How-To Guides (4 files; step-by-step
  walkthroughs for the agent). The organization is by
  AUDIENCE rather than by topic. §the-named-docs-
  organized-by-audience-rather-than-topic as tier-3
  meta-pattern.

  §the-named-chat-as-primary-CLI-as-secondary — lines
  19-24: "Most users work in Endo Chat (the web UI
  inside Familiar). When giving instructions, default
  to Chat commands. Only mention the CLI when it
  provides something Chat cannot — primarily `endo
  run` for running program files and `endo checkin`/
  `endo checkout` for snapshotting filesystem
  subtrees." The Chat surface is positioned as primary;
  the CLI surface is reserved for operations Chat
  doesn't expose. §the-named-Chat-primary-CLI-fallback
  as tier-3 meta-pattern; agent-facing instruction
  about which user surface to recommend.

  §the-named-CLI-reserved-for-program-files-and-
  snapshot — the CLI's specific reserved territory is:
  (a) `endo run` for running program files; (b) `endo
  checkin` / `endo checkout` for snapshotting
  filesystem subtrees. §the-named-CLI-territory-as-
  program-files-and-filesystem-snapshots as tier-3
  meta-pattern.

  §the-named-chat-supports-slash-and-at-addressing —
  line 22: `/ls`, `/view`, `/edit` (slash commands)
  plus `@recipient message` (at-addressing). Two
  distinct input shapes in the same Chat UI. §the-
  named-two-input-shapes-in-chat as tier-3 meta-
  pattern; sibling to cycle 386's petname-edgename
  framing (also a two-shape addressing system).

  §the-named-how-to-guides-as-distinct-shape-from-
  reference — the primer separates "Agent Reference"
  documents (factual, indexed) from "How-To Guides"
  (step-by-step procedural). Sibling to standard
  tech-writing distinction (reference vs tutorial).
  §the-named-reference-vs-how-to-as-doc-shapes as
  tier-3 meta-pattern.

  §the-named-four-how-to-guides-for-four-domains —
  lines 33-36: howto-inventory (names, directories,
  values), howto-messaging (sending, receiving,
  replying), howto-capabilities (inspecting,
  requesting, sharing), howto-code (evaluating and
  defining programs). Four domains corresponding
  roughly to the four tool categories in cycle 401's
  LAL-ARCHITECTURE.md catalog: Directory, Mail,
  Inspection+Identity, Evaluation. §the-named-how-to-
  guides-aligned-with-tool-categories as tier-3 meta-
  pattern.

  §the-named-ocap-environment-named-in-first-line —
  line 3: "You are an Endo agent operating in an
  object-capability (ocap) security environment."
  The primer addresses the agent in second person and
  names the ocap security model directly. §the-named-
  second-person-agent-address as tier-3 meta-pattern;
  the document is written for the agent to read, not
  for a human reader.

  §the-named-Familiar-as-Endo-Chat-host — line 19
  identifies Endo Chat as "the web UI inside Familiar".
  Familiar is the Electron shell from CLAUDE.md (the
  outer CLAUDE.md that lists Familiar architecture
  constraints). §the-named-Familiar-as-Chat-shell-
  inside-Endo as tier-3 meta-pattern.

  §the-named-fifty-three-conformant-cycles-and-
  counting — fifty-third AUTHORED conformant single-
  body section doc in post-refactor era.

  Closes nine citation arcs: cycle 404 (1, adjacent
  forward; guest-power-surface framing now extended
  by a third user-facing surface) + cycle 403 (2,
  simulator README discusses lal but the primer is
  the agent's intended runtime context) + cycle 401
  (3, the LAL-ARCHITECTURE tool catalog the primer
  README example drifts from) + cycle 386 (3,
  petname-edgename inversion sibling for the two-
  input-shapes-in-chat observation) + cycle 384 (3,
  design-doc-trails-code sibling; cycle 405 finds
  primer-tool-examples-drift-from-architecture-catalog)
  + cycle 326 (75) + cycle 322 (75) + cycle 364 (4,
  shapes count now SEVEN-plus-and-counting) + cycle
  346 (3, name-aliasing-for-domain-vocabulary). Pushes
  citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-
  TWENTY-TWO (513 + 9 net new).
---

37-line primer/README.md, the index of @endo/lal's agent-facing primer directory. Seventh lal-package artifact in the cluster. The primer itself contains 13 files totaling 1168 lines; this README.md is the entry index. Designs-lane after cycle 404 chat-lane mock-powers.js. **Single most structurally interesting move**: §the-named-third-surface-for-third-audience — *the primer reveals a THIRD surface beyond cycle 401's LLM-exposed tool catalog (16-18 tools) and cycle 404's guest-power method surface (22 methods): the user-facing Chat slash command surface (`/ls`, `/view`, `/edit`) plus `@recipient` at-addressing. Three surfaces for three audiences (LLM / agent-internal / human user).* §the-named-three-surfaces-three-audiences as tier-3 meta-pattern. §the-named-tool-name-drift-across-agent-facing-docs (primer README's example tools `readText, inspect` don't match LAL-ARCHITECTURE's `lookup, inspectCapability`); §the-named-primer-tool-examples-drift-from-architecture-catalog. §the-named-primer-as-package-local-internal-docs; §the-named-internal-package-docs-as-runtime-resource. §the-named-primer-existence-vs-no-dynamic-context-claim (1168 lines of primer vs cycle 401's "no dynamic context, no workspace files" claim); §the-named-primer-claim-vs-design-claim-tension. §the-named-primer-organized-by-audience; §the-named-docs-organized-by-audience-rather-than-topic. §the-named-chat-as-primary-CLI-as-secondary; §the-named-Chat-primary-CLI-fallback. §the-named-CLI-reserved-for-program-files-and-snapshot; §the-named-CLI-territory-as-program-files-and-filesystem-snapshots. §the-named-chat-supports-slash-and-at-addressing; §the-named-two-input-shapes-in-chat. §the-named-how-to-guides-as-distinct-shape-from-reference; §the-named-reference-vs-how-to-as-doc-shapes. §the-named-four-how-to-guides-for-four-domains; §the-named-how-to-guides-aligned-with-tool-categories. §the-named-ocap-environment-named-in-first-line; §the-named-second-person-agent-address. §the-named-Familiar-as-Endo-Chat-host; §the-named-Familiar-as-Chat-shell-inside-Endo. §the-named-fifty-three-conformant-cycles-and-counting. Nine citation arcs closed; pushes citation-arc-closures-in-pivot to FIVE-HUNDRED-AND-TWENTY-TWO.
