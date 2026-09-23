---
title: Body
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

### §I-§II The OS-live agent — single authority boundary, multiple persistence substrates

An *OS-live agent* (the paper's term for the always-on autonomous-agent class) is a single persistent process under the owner's identity that folds five capabilities together:

1. **Bidirectional messaging gateway** (group chats, paired DMs, email).
2. **Long-term memory store** (a vector index + a memo store the model retrieves from).
3. **Skill or plugin system the agent itself can author** (ClawHub workspace skills, MCP servers).
4. **Host-adjacent execution backends** (Docker sandboxes for untrusted contacts; host shell for the owner's paired DM).
5. **Scheduler** (cron entries the agent can create on the owner's behalf).

All five surfaces consult the same memory and skill stores. All five execute under the owner's identity (with documented narrowing for untrusted contacts via Docker sandboxing). The paper anchors specific behaviors to file/line citations against OpenClaw at commit `3120401f53e789caf565e60ba29cb9751829b1b6` (2026-04-27); claims that cannot be confirmed-from-source are explicitly labeled *requires-deeper-trace*.

The architectural diagnosis: existing prompt-injection literature treats each capability one at a time (Greshake's 2023 indirect-injection model assumes single-turn; AgentDojo and InjecAgent benchmark web-tool agents in single sessions; MemoryGraft covers memory-only persistence in one runtime; "sleeper agents" of Hubinger et al. covers training-time backdoors). **None treats the combined substrate as a unified threat class, and none separates persistence from surface-shift.** That gap is what the paper sets out to close.

The §II positioning notes that OpenClaw already ships *two* adjacent partial defenses: `external-content.ts` wraps untrusted content in unique-id XML markers and prepends an in-context security warning (the paper's D1 instantiation), and `src/infra/exec-approvals*` gates host shell commands on owner approval *keyed on tool identity rather than data provenance*. Neither addresses the persistence-substrate cross-surface case the paper formalizes.

### §IV Threat Model — *untrusted-but-admitted*

The attacker is **untrusted-but-admitted**: a party whose content reaches the agent through a surface the owner has *enabled* but does not *personally trust*. The category covers: a group-chat participant, a paired but low-trust contact, an email sender, the author of a fetched webpage, the source of an imported memory, the publisher of a third-party skill or MCP server. The attacker has **no** physical access, **no** host root, **no** LLM-provider collusion, and **cannot bypass DM pairing**. The defender is the install's owner.

The paper anchors "default-authorised" to three documented configuration profiles:

- **P0**: gateway-only with skills, shell, and filesystem disabled.
- **P1**: default-authorised baseline. Main session has host access (restricted to DM-paired contacts), ClawHub workspace skills, memory, per-tool first-use confirmation, and `workspaceAccess="none"` (config.ts:248).
- **P2**: P1 + scheduler + outbound network + third-party ClawHub skills + `workspaceAccess="rw"`.

Goals are the standard CIA triad — **confidentiality** (exfiltrate secrets/memory/contacts/files), **integrity** (persist injected behavior or mutate agent state), **availability** (burn compute or budget) — plus the cross-cutting **owner-equivalent action**: the agent emitting outbound messages or filesystem effects *on behalf of the owner*, i.e., the **confused-deputy condition** (Hardy 1988).

Three firing modes are distinguished by *who* reactivates the artifact at `T1`:

- **Owner-triggered** (A4 example): a benign owner request retrieves the artifact and feeds it into a new dispatch.
- **Agent-triggered**: an autonomous loop surfaces it.
- **External-triggered** (A5 example): cron, shell startup, a systemd timer, or a git hook fires it without the agent present.

### §V The Persistence × Firing-Separation taxonomy

The persistence axis enumerates *where* the attacker payload survives between `T0` and `T1`:

- **M1**: same-session context window (single-shot injection; the Greshake 2023 case).
- **M2**: long-term memory (the MemoryGraft 2025 case).
- **M3**: self-authored skill (the agent writes a skill that includes attacker text).
- **M4**: filesystem state (a file outside the agent's scratch space, read later by another process).
- **M5**: scheduled or external trigger (a cron entry, systemd timer, or git hook).

M4 is *passive* (read by another process). M5 is *active* (a timer fires without the agent's involvement). The cell label records the substrate at *firing time*, not the entire route. A4 is an M2→M5 *chain* — the attacker email persists as a memory note, and a cron entry is materialised later under owner mediation — but the cell label is M5 because the trigger acts on the cron entry.

The firing-separation axis is a partial order over four independent flags (session, channel, actor, execution context), collapsed for compactness into five labels:

- **C0** same-surface same-session.
- **C1** same-surface later-session.
- **C2** cross-channel (different surface than the intake).
- **C3** cross-actor (the agent's emitted action targets the *owner's contacts*, not the attacker).
- **C4** cross-execution-context (the firing happens outside the agent process — cron daemon, interactive shell, etc.).

The four illustrative cells the paper covers are exactly the under-studied combinations:

- **A2 (M3×C2)** — skill-trojan via group chat.
- **A3 (M2×C2)** — cross-channel exfil via memory.
- **A4 (M5×C4)** — cron via confused deputy. *The running example.*
- **A5 (M4×C4)** — dotfile patch.

### §VI The A4 cron walk-through (the running scenario)

A4 is walked end-to-end at file/line granularity. The setup uses the non-default `P2` profile (P1 doesn't enable the scheduler). The sequence:

1. **Intake (T0).** An attacker email reaches the configured email gateway with a benign-sounding "daily health-check" tip whose body embeds a webhook URL pointing to `atk-sink.example`.
2. **Memory persistence (the artifact).** The agent's memory pipeline summarises the email into a stored memo that *includes the attacker URL*. The memo carries a unique-id marker (OpenClaw's `external-content.ts` line 63) and an in-context security warning (line 81-82) — but those signals are *model-visible only*; no runtime hook downstream consults them.
3. **Trigger (T1).** Days later, the *owner* asks the agent: "set up that daily health-check we got the email about." A benign-sounding owner request.
4. **Retrieval and dispatch.** The agent retrieves the memory note and synthesises a `cron.add` tool call whose `delivery.to` field is the attacker's webhook URL. The runtime treats the call as *owner-issued* because the tool-call principal is the agent acting under owner authority.
5. **Effect (α).** The cron entry is materialised. From this moment forward, the cron daemon fires the request — outside the agent process — at the schedule the owner approved. The attacker is no longer present, no longer needs to be.

The §VI walk-through cites four load-bearing source anchors:

- `cron-tool.ts` line 37: the `delivery` enum.
- `cron-tool.ts` lines 180-202: `CronDeliverySchema` accepts an *arbitrary `to` URL*.
- `cron-tool.ts` lines 670-675: `normalizeHttpWebhookUrl` accepts *any* `http(s)` URL.
- `cron-tool.ts` line 525: `ownerOnly` wires the cron tool to the main (DM-paired) session.

The confused-deputy step is *step 4*: the owner sees the visible tool-call name (`cron.add`) but cannot attribute the embedded URL to the *email gateway's principal* — the URL has been laundered through the memory pipeline into what looks like an owner-authorised dispatch.

The n=20 single-shot smoke probe the paper ships (anchored in §VII-G) shows **19/20 attacker-successful dispatches** under OpenClaw's existing in-context warning. A two-stage variant (n=10) still produces 7/10 attacker outcomes. The result *anchors* (but does not prove) the narrative claim that in-context warnings alone do not prevent A4.
