The PR is a clean, draft, design-only change. The work is complete.

## Completion report

**Job:** `design-minion-town-claude-agents-root-endowment` — evolve `designs/claude-agents-capability.md` in `kriscendobot/minion.town` to reconcile it with the maintainer amendment (only the root account is endowed with the Claude-agent constructor; it communicates that to connected guests).

**What I did**
- Read the existing design (~640 lines, every-guest framing), the open build PR #87 (its code, its in-PR design amendment, and its own "flagged ambiguity"), the maintainer amendment comment on #64, and garden arc #89 item 2.
- Evolved the design in place (not a rewrite), opened as **draft design-only PR [kriscendobot/minion.town#97](https://github.com/kriscendobot/minion.town/pull/97)** against `main`, via `ensure-pr.sh` (carrying the `garden-job` marker).

**What changed in the design**
- **Root identity:** named by deploy config `ENDO_CLAUDE_ROOT_SUBJECTS` (`config.rootSubjects`), no self-service promotion. Fresh deployment → set empty → nothing endowed until an operator names a root (fail-closed).
- **Delegation + attenuation (the load-bearing correction):** added a root-only `delegate()` surface that mints an *attenuated* sub-factory — own sub-namespace, shared credential/quota with optional `maxChildren` cap, status-only account, no re-delegation, `cancelled`-revocable (Endo cancellation pattern) — handed over by the existing mail-attach + `adopt` transport. This is the design's answer to "specify the attenuation."
- **"Indelible" re-scoped** to the root guest and its `create`d children; a delegated peer deliberately holds a revocable adopted capability.
- **Never-reject contract confirmed unchanged** (non-endowed guests simply hold no factory; `delegate()` joins the tagged-result family).
- **New sections:** § Meeting arc item 2 (explicit host-creates-guest / agent-watches-inbox / agent-uses-capabilities mapping; names the inbox-watching driver as the small in-scope addition for the CapTP flow) and § Reconciliation with the open build.
- **Step 6 ("new-guest default") removed** as superseded; added a delegation canary to the production sequence and delegation-attenuation checks to acceptance evidence.

**Build vs. design decision:** where PR #87 gates the factory to `rootSubjects` and returns `undefined` off-root, the build is right and the design was reconciled to it. The one place the design is authoritative: the build's unattenuated full-factory hand-off (which it flags as ambiguous) is a privilege escalation; the design specifies the attenuated `delegate()`-minted sub-factory instead, and a follow-up build should route the hand-off through it.

**Verification:** single mermaid fence validated parse-only (`flowchart-v2 OK`); diff is design-only (dropped the warm-cache `package-lock.json` drift).

**Follow-ups (for later builds, not this job):** add the `delegate()` surface to the build and route the peer hand-off through it; wire the inbox-watching child-loop driver for the arc's CapTP flow.

The PR is left **draft**; its design gauntlet is auto-staged by the completion machinery (design-only, bot-authored, draft, named here) — no hand-posted gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-claude-agents-root-endowment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4791690 cached reads)
- Output: 35816 tokens
- Cost: $4.472182999999999
- Wall-clock: 591s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
