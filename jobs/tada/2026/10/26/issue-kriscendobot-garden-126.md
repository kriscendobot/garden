I've posted a reply to issue #126: https://github.com/kriscendobot/garden/issues/126#issuecomment-6426048994

**Answer: partly yes.** I surveyed `endojs/endo-but-for-bots@llm` (844ce3df7b), mostly through a read-only research agent, and checked its key claims against the source myself. Endo Chat already has the pieces for T3-style "agents talk to each other":
- **Shared rooms:** the daemon `EndoChannel` is a multi-party room that members join by invitation, and the `space-channel` package provides views for it.
- **@-mentions:** the chat composer autocompletes names and offers to invite and notify the person you mention.
- **Several providers at once:** agents backed by different providers (Anthropic, OpenAI, OpenRouter including Kimi, Ollama) can run side by side as separate confined guests.
- **jaine:** an agent built to sit in a channel; it watches the whole room and decides when to speak.

But only jaine takes part in a room on its own, so it isn't "natural" yet.

**What the comment contains:**
- **Demo design, "The Roundtable":** three jaine agents on three providers debate in one channel while the user watches and steps in. It ends on the Endo-only security story: you can see who invited each agent, give one agent a tool the others can't use, and throttle or ban an agent. Running it across machines is marked as a stretch goal. I haven't run the demo end to end.
- **Draft marketing blurb:** it leads on confinement and capability handoff, which T3 can't offer.
- **Seven gaps:**
  1. lal, fae and the hosted Claude/Codex sessions can't take part in a channel, and fae's prompt is out of date.
  2. A mention posted by an agent notifies nobody.
  3. Nothing stops agents from replying to each other in an endless loop (no turn or hop budget).
  4. There's no one-step setup and no CLI command to create a channel.
  5. Messages don't show which model wrote them.
  6. jaine checks for new messages every 5 seconds instead of streaming them.
  7. Cross-machine use and shared subscriptions aren't deployed or tested over a real peer connection.

**Follow-ups:** I posted no follow-on jobs. The comment offers dckc two: a designer job for "agent-to-agent channel participation" (gaps 1–3 and 5) and a builder job to script the Roundtable demo, including the missing channel-creation command. The issue stays open for the submitter to close.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/issue-kriscendobot-garden-126.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (626748 cached reads)
- Output: 7003 tokens
- Cost: $2.500188800000001
- Wall-clock: 331s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
