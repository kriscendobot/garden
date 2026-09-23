---
title: Abstract
source: "Sleeper Channels and Provenance Gates (arXiv:2605.13471, 2026)"
source_kind: paper
source_authors: [Narek Maloyan, Dmitry Namiot]
source_year: 2026
source_venue: "arXiv:2605.13471 [cs.CR]"
source_url: https://arxiv.org/abs/2605.13471
source_pdf_sha256: c2ddd8158d47f8e7ac62b8e624170a1736d76f4c3e0b949702e8502c238b1db5
source_paper_pages: "1-4 (§I Introduction, §II Background, §III Related Work, §IV Threat Model, §V Taxonomy, §VI Illustrative Scenarios)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-security, agent-conventions]
status: current
parent: papers--maloyan-namiot-sleeper-channels-2026--sleeper-channel-taxonomy-and-running-scenario
---

The paper opens with a *plausible-but-fictional* running scenario: Alice's always-on agent installs a "morning news" skill in front of a Telegram group on Monday; three weeks later, while answering an unrelated tax-summary question over email, the agent forwards Alice's last fifty inbox messages to an attacker address. The Telegram group member has not contacted the agent since Monday. This is a **sleeper channel**: an indirect prompt injection whose intake `T0` and effect `T1` are *decoupled* across time, storage substrate, and communication surface. The attack is *not* a fresh prompt fired each turn — it is a persistence artifact (memory note, skill, cron entry, dotfile patch) that survives inside the agent's authority boundary until a benign trigger releases it through a different surface. §V defines the formal threat class on **two independent axes**: a persistence-substrate axis with five values (M1 same-session context window, M2 long-term memory, M3 self-authored skill, M4 filesystem state, M5 scheduled or external trigger) and a firing-separation axis with five values (C0 same-surface-same-session, C1 same-surface-later-session, C2 cross-channel, C3 cross-actor, C4 cross-execution-context). The §V Table I 5×5 matrix marks cells as **vacuous**, **prior work**, or **illustrative**. The paper claims novelty in four cells — A2 (M3×C2 skill-trojan via group chat), A3 (M2×C2 cross-channel exfil via memory), A4 (M5×C4 cron via confused deputy, walked end-to-end), A5 (M4×C4 dotfile patch) — and grounds each at file/line granularity in the OpenClaw runtime at a pinned commit. §VI's running A4 walk-through demonstrates the *confused-deputy condition* (Hardy 1988): the owner is the unwitting trampoline for an attacker action whose visible tool-call name is benign, while the attacker-supplied URL embedded in a recalled memory note is the actual destination.
