---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: the garden itself (this repo), branch main2, pushed directly (no PR, per
CLAUDE.md Conventions).

Land the `muster` vocabulary. A liaison session on 2026-08-16 authored this
encoding but wrote it into the DEPLOYED root checkout, where it cannot be
committed: the root is detached at a main2 ancestor and `deploy-garden.sh`
blocks on a dirty tracked tree. The edits were reverted there to unblock
deploys, so this job carries the full content and is the only surviving copy.

`muster` is the maintainer-chosen verb for interactive maintainer-inbox review:
compact the duplicates, classify what survives, dispose of each item. It is
LIAISON-SESSION vocabulary only, like `help` and `start the garden`, and must
NEVER become watcher-recognized: triage is a conversation, not a board entry.
Do not add it to any watcher's verb table.

Task: apply the patch below to a proper worktree of main2, verify it applies
cleanly against the current tip (it was authored against 55d2c6411b, and main2
has since advanced), resolve any drift by intent rather than by force, and push
to main2. Three files change: README.md (the Key vocabulary table), CLAUDE.md
(the Orchestrator vocabulary table), and roles/liaison/AGENT.md (a new section
`## Muster` inserted before `## Plan queue`).

Style check before pushing: the garden bans em-dashes in prose
(skills/em-dash-style). The patch was written to that rule; keep it that way.

--- BEGIN PATCH ---
diff --git a/CLAUDE.md b/CLAUDE.md
index fdd80e01e1..337664a897 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -46,6 +46,7 @@ The maintainer steers the liaison in plain language; these verbs are just precis
 | --- | --- |
 | **help** / **help &lt;topic&gt;** | run the interactive first-run tutorial ([`roles/liaison/AGENT.md`](roles/liaison/AGENT.md) § Help; track in [context/first-run/README.md](context/first-run/README.md)) / answer a topic from `context/` and offer to do what the answer prescribes. **Liaison-session vocabulary only — never watcher-recognized** (a tutorial is a conversation, not a board entry). Distinct from the CLI built-in `/help`. |
 | **start the garden** | perform the starting stage directly ([context/operations/starting.md](context/operations/starting.md)) — for the user who wants motion, not a tour; the liaison runs the bring-up itself, asking before each consequential step. Also liaison-session only. |
+| **muster** | work the maintainer inbox interactively: compact, classify, dispose ([`roles/liaison/AGENT.md`](roles/liaison/AGENT.md) § Muster). **Liaison-session vocabulary only, never watcher-recognized**, like *help*: triage is a conversation, not a board entry. |
 | **run the gauntlet #N** | post the full PR-creation chain end to end: clean → panel review → fix-loop → un-draft ([pr-creation-flow](skills/pr-creation-flow/SKILL.md)). For a PR that did **not** come through a `build` (a maintainer-authored PR, or a probe now promoted), or to re-run on demand. It is **not** a required follow-up to a build (a build already auto-runs it). v1 called this "the gamut"; that name is retired ([designs/judicial-workflow.md](designs/judicial-workflow.md) § the rename). |
 | **design X** / **propose X** / **spec X** | post a [designer](roles/designer/AGENT.md) job. |
 | **build #N** / **build X** | post a [builder](roles/builder/AGENT.md) job. The build's draft PR **auto-runs the gauntlet** (clean → panel → fix-loop → un-draft) under its supervising gardener via the gardening state machine; no separate *run the gauntlet #N* is needed. The lone exception is a **probe** (next row), which stays draft. |
diff --git a/README.md b/README.md
index bf4a42f338..146e8aa474 100644
--- a/README.md
+++ b/README.md
@@ -91,6 +91,7 @@ deterministically. `#N` is a pull-request number.
 | **ferry #N** | carry approved work upstream under your own identity — authorization required |
 | **defer X** / park X | park a job on the plan queue; the foreman promotes it when the board idles |
 | **promote X** / go ahead on X | move a parked job onto the board now |
+| **muster** | work the maintainer inbox with the liaison: compact the duplicates, classify what is left, and dispose of it item by item. A conversation, not a board entry, so no watcher recognizes it |
 | **stand up / stand down / drain / lift** | fleet operations, handled by the liaison directly. **Drain** = a moratorium on undertaking further work, while work already in progress finishes; **lift** relaxes it ([scaling.md](context/operations/scaling.md)) |
 | **restore** | recover the fleet after an outage: reactivate hung agents, forward dead letters, ack + redispatch poison ([restore](skills/restore/SKILL.md)) |
 
diff --git a/roles/liaison/AGENT.md b/roles/liaison/AGENT.md
index ab03c3f06d..8354a13f40 100644
--- a/roles/liaison/AGENT.md
+++ b/roles/liaison/AGENT.md
@@ -267,6 +267,54 @@ autonomous background service.
   is suspected. Distinct from **stand up** (which brings units up from nothing);
   after a long stop you often stand up *then* restore.
 
+## Muster — interactive maintainer-inbox review (vocabulary)
+
+**muster** (also "let's muster", "muster the inbox") is liaison-session vocabulary
+like `help`: it opens an interactive working session over the maintainer inbox.
+No watcher recognizes it, because triage is a conversation and not a board entry.
+The inbox accumulates faster than any human reads it (81 unread on 2026-08-16,
+oldest from 07-25), so a muster is three passes, in this order. Never skip
+straight to the third.
+
+**1. Compact.** Most of a stale inbox is already dead. Before reading anything
+closely, retire what time has answered:
+
+- **Verify current state first.** A message says a PR waits on your approval;
+  check whether that PR merged weeks ago. Batch the checks (`gh pr view <N>
+  --json state,mergedAt,reviewDecision`) rather than opening messages one at a
+  time. A message whose blocker is gone gets a bare
+  `maintainer-archive.sh <msgid>` and never costs the maintainer a glance.
+- **Collapse repeat presses.** A daily press posts the same open question every
+  tick. Six messages restating one unanswered design decision are one decision.
+  Archive all but the newest and carry the newest into pass 3.
+- **Sweep the deploy-gap class.** A job that HALTED on "the deployed garden
+  lacks commit X" is dead the moment a deploy lands. Re-post the job rather than
+  answering the message.
+
+Report the compaction as a count, not a list: the maintainer wants to know the
+pile shrank, not which corpses were buried.
+
+**2. Classify.** Group what survives by what it *wants*, since that is what
+determines the maintainer's next keystroke. The recurring classes:
+
+- **Approval-gated.** A conductor stalled for want of a fresh APPROVED review on
+  a current head. Cheapest to clear and usually the largest class.
+- **Decision-gated.** A design fork, a supersession, a retire-or-rescope
+  recommendation. Genuinely needs judgment, so this is where the session's
+  attention should go.
+- **Doom and halt.** Reaper-parked jobs and non-converging gauntlets sitting in
+  `jobs/plan/` behind a go-ahead gate. Each wants promote, re-scope, or drop.
+- **Informational.** Completion reports, field notes, self-improvement findings.
+  Archive on sight unless something in one changes a decision above.
+
+**3. Dispose, one at a time.** Present each survivor with the decision named in a
+sentence, the evidence you verified, and the concrete options. Act on the answer
+immediately (`maintainer-reply.sh <msgid>` routes a reply to the originating
+doer and archives; an empty reply is a bare archive), then move to the next.
+Work the decision-gated class first while attention is freshest. Stop whenever
+the maintainer says so: a muster is resumable, and the seen-cursor plus the
+unread/read split is all the state it needs.
+
 ## Plan queue — parking work and promoting it (vocabulary)
 
 Some work should not auto-run: it needs the maintainer's **go-ahead**, or it is
--- END PATCH ---

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-16T16:11:10Z
