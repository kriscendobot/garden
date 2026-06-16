---
section: comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: The eight spinout-gap tables
parent: endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts
---

The §Feature-by-Feature Mapping section runs eight tables, each
covering one feature category. Each table inventories the cross-
product (Pi feature × Endo equivalent × Status), and each spins out
a sibling design naming the gap. The eight categories + their
sibling-design spinouts:

| Category | Sibling design | Status as of 2026-06-02 |
|----------|----------------|--------------------------|
| **Built-in tool core** (read/write/edit/bash) | [endopi-edit-tool](endopi-edit-tool.md) | Pi's *edit* (unique-match oldText/newText replacement on normalized line endings, structured diff preview) is the interesting one — Endo has no edit-by-replacement primitive; `cli-edit-verb` covers hashline patches for human-on-CLI editing, not the primitive a tool-calling LLM uses. |
| **Session model** (JSONL tree, id/parentId, /tree, /fork, /clone, /export) | [endopi-jsonl-transcript-format](endopi-jsonl-transcript-format.md) (cycle 117) | Pi's session-on-disk format is *the part worth porting verbatim* — *the session-export feature also doubles as the agent's own form of long-term memory inside its workspace*. |
| **Multi-provider LLM API** (30+ providers, subscription auth, cross-provider handoff, token tracking, tool-call streaming, image input) | [endopi-provider-registry-and-oauth](endopi-provider-registry-and-oauth.md) | Pi's `pi-ai` package is a focused dependency Endo could vendor or take inspiration from; the *subscription auth* piece (Claude Pro / ChatGPT Plus / Copilot instead of API key) is *its highest-leverage feature for end users*. |
| **Extension model** (TS modules + full system access; tools / commands / shortcuts / hot-reload / pi install) | [endopi-extension-package-manifest](endopi-extension-package-manifest.md) | *Endo's existing guest-plugin model is *more* secure than Pi's. The gap is not the architecture but the ergonomics: Pi extensions can ship both code and resources (skills, prompts, themes) under one keyword in `package.json`, and a single `pi install` command resolves them all.* |
| **Skills system** (SKILL.md frontmatter, progressive disclosure, /skill:name slash command, cross-harness skill paths) | [endopi-skills-markdown-format](endopi-skills-markdown-format.md) (cycle 112) | The daemon side is `endoclaw-skill-registry`; the on-disk side is this sibling — a markdown-frontmatter skill format compatible with the agentskills.io specification used by Pi, Claude Code, and Codex. |
| **Prompt templates** (markdown `{{var}}` interpolation, `/templatename` expansion, global+project+package locations) | [endopi-prompt-templates](endopi-prompt-templates.md) | Self-contained, low-risk feature. |
| **Context files** (AGENTS.md / CLAUDE.md, parent-walking from cwd, append vs replace via SYSTEM.md) | Tracked under [endopi-skills-markdown-format](endopi-skills-markdown-format.md); same discovery rule. | The discovery rule composes with the skills format. |
| **Operating modes** (interactive TUI, print, RPC stdio JSONL, SDK) | [endopi-stdio-rpc-bridge](endopi-stdio-rpc-bridge.md) | Pi's RPC mode is *the part Endo does not have* — a strict line-delimited JSON protocol for embedding the agent in another process (an IDE, a CI harness, a Familiar pane) without WebSocket overhead. The maintainer's `endor-bus-tui` direction may eventually subsume this; the short-term gap is real. |

A ninth table covers **compaction** (auto + manual `/compact`,
structured summary format, iterative compaction, `keepRecentTokens`
/ `reserveTokens` knobs, branch summarization on `/tree`) — spinning
out [endopi-iterative-compaction](endopi-iterative-compaction.md);
the sister §Genie section reports this design's *substrate now
exists* in genie's observer/reflector pair, so the design's role
shifts from *specify the algorithm* to *harmonise with the
observer/reflector pair and route Lal/Fae transcripts through them*.

A tenth table covers **session sharing** (Hugging Face publish /
HTML export / GitHub gist) — HTML export is *the only piece worth
carrying forward*; the rest is philosophical (sharing transcripts
is a workflow choice).
