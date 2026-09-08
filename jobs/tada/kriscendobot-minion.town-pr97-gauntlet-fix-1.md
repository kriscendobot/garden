FIX round 1 complete for kriscendobot/minion.town PR #97.

## What I did

Applied the design panel's round-1 must-fix items to `designs/claude-agents-capability.md` (the PR's sole file), pushed as a review-feedback follow-up commit, and watched CI to **green**.

## Panel items resolved

The full per-seat prose was torn down with the panel rundir, but I recovered the durable panel record (`689c4d57a259`, 16 items) locally and read the design at each cited location:

- **critic / skeptic (delegate exclusivity):** stated explicitly that `delegate()` is present *only* on the literal root factory — neither a delegated sub-factory nor a `create()`d child's re-introduced facet exposes it, so a `create()`d child cannot delegate at all (one level deep from root).
- **ergonomist (facet typing):** introduced `type DelegatedClaudeAgents = Omit<ClaudeAgents, "delegate">`; `delegate()` now returns it and children are re-introduced with it, instead of the literal `ClaudeAgents` that falsely advertised `delegate`.
- **ergonomist (return-shape coherence):** tagged `create()`'s success as `{ type: "provided"; agent }` so every method arm is `{ type }`-tagged; added a "return-shape convention" Decisions bullet and updated the prose that referenced a bare `ClaudeAgent`.
- **critic / skeptic (irrevocable delegation):** the host now mints its own internal cancellation for every delegation, so omitting the optional `cancelled` can never mint a permanently irrevocable grant.
- **critic (maxChildren):** gave the sub-cap the same atomic check-and-increment and directory-reconciled counter as the tree-wide pool.
- **ergonomist (undefined gate):** clarified `agentsFor`/`accountFor` returning `undefined` is a host-side composition gate, deliberately outside the never-reject facet contract.
- **novice:** glossed how "root" is identified at the diagram's first `rootSubjects` mention; broke the `delegate()` doc-comment into readable paragraphs; marked the forward reference to § Delegation as "below".
- **pedant:** fixed the broken `(§ quota)` cross-reference; removed the inconsistent section-title quoting; made the new Decisions bullets imperative-parallel; **removed all 46 em-dashes** per the em-dash-style rule (periods/colons/parentheses by judgment).
- **skeptic (test gap):** added the child-cannot-delegate check to the Confinement canary and acceptance evidence.

## Changes / notes

- One commit (`b335393`) on `design/claude-agents-root-endowment`, +164/−101 in the design doc only. I reverted an incidental `package-lock.json` edit left by the warm-cache install so it stayed out of the commit.
- Per the FIX stage contract I did **not** re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr97-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4721913 cached reads)
- Output: 52018 tokens
- Cost: $4.9370765
- Wall-clock: 873s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
