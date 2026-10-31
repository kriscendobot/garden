PR #1587 is open and freshly built; I checked the related PRs, the designs on `llm`, and the maintainer's recent design answers to decide whether it's still live.

**Viability verdict for endojs/endo-but-for-bots#1587 — `proceed`**

**PR facts:** OPEN, draft, not merged. Title: "feat(hosted-agent): add OAuth-backed inference providers". Head `e83e4306d2` on `feature/provider-registry-oauth`. It is the third PR in a stack: its base is the frozen branch `feature-api-key-provider-adapters-39526e2` (from #1575, which sits on #1573). That base is 36 ahead of and 0 behind `llm`. The PR was opened 2026-10-31T06:38Z and has no reviews or comments yet.

**Deciding question:** Is the provider-neutral OAuth/subscription field set on the hosted-agent inference-provider registry still unbuilt on `llm` and still wanted under the current design, with every subscription mode kept closed?

**Evidence:**
- **Not superseded.** Nothing on `llm` has `inference-provider-auth.js` or an `authMode` field on the registry. The registry itself comes from #1573 and the API-key adapters from #1575, and both are still open drafts (#1575 was updated 2026-10-31). So nothing newer has replaced this work; #1587 is the newest piece of the stack.
- **The overlapping PRs don't displace it.** #670 (the standalone `lal` subscription-OAuth toolkit) is a separate surface, and the PR body says it does not duplicate or enable it. #672, which wired subscription OAuth into Genie, is closed.
- **The motivating design is still live.** `designs/README.md` on `llm` lists `endopi-provider-registry-and-oauth` as "In Progress". That design names OAuth (its Phases 3–4) as the scope still missing. The newer design that governs it, `hosted-agent-broker-oauth` (also "In Progress"), says subscription mode stays unavailable. The PR follows that: Claude, ChatGPT and Copilot are all registered as explicitly unavailable and fail closed, and the API-key issuer refuses OAuth records too.
- **No conflict with the API-key direction.** The maintainer's 2026-10-27 answers on #1543 (API-key providers instead of bare subscriptions) don't contradict this PR. It changes no API-key behaviour, enables no subscription, and needs no migration (omitting `authMode` keeps the API-key default).

**Note for the panel (a scope question, not grounds to stop):** in the 2026-10-27 answers on #1543, the maintainer limited the first release to Anthropic providers. This PR still registers ChatGPT and Copilot entries, even though they are unavailable. The review should check that against that answer. The PR also has to wait for #1573 and #1575 to land before it can merge.

I spent no clean, panel, fix, CI-wait or un-draft budget, and changed nothing in the garden or the project repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1587-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (308194 cached reads)
- Output: 3456 tokens
- Cost: $0.5602628000000001
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
