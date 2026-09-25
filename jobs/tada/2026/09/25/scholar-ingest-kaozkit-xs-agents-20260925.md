Both KaozKit articles are now in the library on journal2. They're cross-linked, and each source page notes where the two articles agree and where they differ. The link-integrity check passed.

**Source IDs and sections filed** (both fetched live; each is pinned by a SHA-256 hash of the fetched page):
- `web--haruni-kaozkit-xs-agents`, by Sébastien Burel (August 2026), 6 sections: `overview`, `an-agent-is-a-module`, `why-xs-not-javascriptcore`, `what-the-snapshot-changes-in-practice`, `the-layers`, `licensing-and-whats-next`.
- `web--moddable-kaozkit`, by Peter Hoddie (2026-09-15), 4 sections: `introducing-kaozkit`, `xs-for-agents`, `agents-on-ice`, `dig-deeper-and-lesson-14`.
- **New pages:**
  - Topic `xs-agent-runtimes` covers both sources and holds the ranked cross-references below.
  - Concept `xs-heap-snapshot-agent-persistence`.
- **Rows added to existing pages:**
  - Topics: `llm-agent-frameworks`, `persistence`, `capability-security`, `hardened-javascript`, `scheduled-agent-tasks`, `capability-mediated-integrations`.
  - Concepts: `principle-of-least-authority`, `ambient-authority`, `formula-persistence-thesis`.
  - Indexes: sources, topics, concepts and `keywords.md`. The generated sections index and topic counts were rebuilt.
- **Records:** the result entry is `entries/2026/09/25/052614Z-result-scholar-3ed693.md`, and a short summary went to the maintainer inbox.

**Where the two articles differ:**
- Hoddie claims XS has no known security vulnerabilities; Burel doesn't.
- Hoddie says agents get notified on suspend and resume, and that moving to another device needs a compatible KaozKit version. Burel says no serialization code is needed and that you can simply copy the file to another machine.
- Only Burel covers running one XS machine per agent, the actor framework, the tool allow-lists and the licensing.

**Cross-reference findings, most relevant first:**
1. **Endo's XS-worker snapshot design** in endojs/endo-but-for-bots does the same thing KaozKit does, and is more careful about the hard cases:
   - It only suspends a worker when it is idle, so nothing is frozen mid-call.
   - It streams snapshots into content-addressed storage.
   - It keeps a stable table of host functions so a snapshot can be restored later.
   - It names what makes a snapshot incompatible: XS version, CPU architecture, and that host-function table.

   Neither article says what happens to a snapshot taken during an in-flight LLM call or after an app update. Endo's metering design also covers budgets for runaway agents, which KaozKit doesn't mention.
2. **Agent confinement on minion.town.**
   - KaozKit resolves API keys in the native host and never lets them into JavaScript. That answers Gap 1 of kriscendobot/minion.town#106, where the API key sits in an environment file.
   - KaozKit's host starts with no services and only adds what a project needs. That answers Gap 1 of kriscendobot/minion.town#116, where Codex confinement is a deny-list that a CLI upgrade can widen.
   - Where KaozKit is weaker than Endo: each agent gets one `host` global and tools are named by string. An agent therefore can't hand a narrower capability to a sub-agent, unlike Endo guests passing references (see the guest invite/accept work, endojs/endo-but-for-bots#1125).
3. **XS in the garden's own work.**
   - The divergences Iron Horse found against XS (such as non-shortest number formatting) are correctness bugs, not sandbox escapes, so they don't contradict Hoddie's security claim.
   - `test:xs` in exo-stream is still just `exit 0`. The parked follow-up on endojs/endo-but-for-bots#1100 still needs Moddable's `xst`.
   - KaozKit builds by linking against a local Moddable checkout, which suggests a pinned checkout is the practical way to get XS.
4. **Actors.** Burel's rule that message handlers must never `await` is the same turn discipline E-style vats follow.
5. **Persistence styles.** KaozKit keeps whole agents in a heap snapshot, while the garden fleet keeps its state in the journal and rebuilds it on restart. They suit different scopes (one local agent versus a multi-host fleet), so this is not a contradiction with a current design.

**Suggested follow-ups (for the maintainer; nothing posted):**
- Set up a pinned Moddable `xst` in the sandbox. That would allow a real `test:xs` run for endojs/endo-but-for-bots#1100.
- For minion.town's inference backends, use KaozKit's shape as the design answer to Gap 1 in kriscendobot/minion.town#106 and kriscendobot/minion.town#116: the agent holds a model capability but never the key, and the host adds only allowed services.
- Optionally, find out how KaozKit handles snapshots taken during an in-flight host call and across app updates. This would be a read-only question; the garden should not start any contact.

Both sources were ingested completely, so no follow-on scholar job was needed.

Self-improvement: the `message-user.sh` reference check rejects bare `#N` (it wants `owner/repo#N`), but `journal-entry.sh` accepts it. So a result entry can use references the digest can't, and I had to rewrite the digest. A scholar authoring both from one draft would benefit from the same check in both places.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/scholar-ingest-kaozkit-xs-agents-20260925.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2915803 cached reads)
- Output: 30693 tokens
- Cost: $2.4849720999999994
- Wall-clock: 575s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
