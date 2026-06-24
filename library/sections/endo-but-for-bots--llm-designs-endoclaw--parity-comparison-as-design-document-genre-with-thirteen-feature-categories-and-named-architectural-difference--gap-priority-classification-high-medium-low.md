---
source: designs/endoclaw.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endoclaw.md
section_kind: design
ingested: 2026-06-06
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Joshua T Corbin (edited)
topics:
  - daemon
  - capability-security
status_at_ingest: Reference
genre: §endo-but-for-bots-design §parity-comparison-as-design-document
cycle: 196
lane: designs
status: current
title: §Gap-priority-classification (High/Medium/Low)
parent: endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference
---

```
| Gap                                                 | Priority | Notes                                               |
| Web Fetch and Search capability                     | High     | Basic fetch and search provider API usage           |
| Core workspace / memory system                      | High     | This is the core engine that contitues a claw       |
| Heartbeat Timer                                     | High     | This is the core "there" that makes a claw tick     |
| Chat Channel Bridge                                 | Medium   | At least for easy ones like Telegram                |
| Cron/scheduler capability                           | Medium   | Timer capability in bank taxonomy                   |
| Proactive agent outreach                            | Medium   | Agent-initiated messages, morning briefings         |
| Browser automation capability                       | Low      | Puppeteer/Playwright-backed `Browser` exo           |
| System notifications                                | Low      | Electron `Notification` API in Familiar             |
| Productivity integrations (Gmail, Calendar, Notion) | Low      | Guest plugins with OAuth capabilities               |
| Smart home integrations                             | Low      | Guest plugins with network capabilities             |
| Skill registry / marketplace                        | Low      | Index of community plugins                          |
| Voice input                                         | Low      | Web Speech API in Chat UI                           |
| Mobile companion apps                               | Low      | iOS/Android; browser-based mobile access is interim |
```

§Thirteen-gaps-each-with-priority-and-note. §High-priority-
three: §Web-Fetch-and-Search + §Core-workspace/memory +
§Heartbeat-Timer. §These-are-the-§§"core engine that
constitutes a claw" and §§"core there that makes a claw tick"
items.

§The-§§"core engine that contitues a claw" (sic — "contitues"
is a typo in the design itself; the original is preserved
here without correction) names the §domain-specific-vocabulary.
§§"a claw" is the OpenClaw user's mental model of a personal
agent.

§Three-medium-priority-gaps: Chat-Channel-Bridge + Cron/
scheduler + Proactive-agent-outreach. §These-make-the-claw-
useful-not-merely-functional.

§Seven-low-priority-gaps: Browser + Notifications +
Productivity + Smart-home + Skill-registry + Voice + Mobile-
apps. §These-are-the-§nice-to-have-extensions.

§Compare-to-cycle-180-hex-package's §five-phases-mostly-S +
cycle 184-metering's §seven-phases-all-Complete. §Cycle-196-
priority-tier-not-phase-numbered. §The-gap-list-doesn't-have-
ordered-phases; it has §thematic-priorities.

§Tier-1-borrowing: §High/Medium/Low priority classification
with §one-line-note-per-gap for §lightweight-roadmap-shaping.
