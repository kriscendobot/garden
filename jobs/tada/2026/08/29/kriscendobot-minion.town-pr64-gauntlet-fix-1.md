CI is GREEN (rc 0). Fix pushed as a review-feedback follow-up commit, CI verified green. Per the stage contract, I applied the panel's must-fix items once and stopped — no panel re-run.

## Completion report

Applied the design panel's round-1 must-fix findings to `designs/claude-agents-capability.md` on the PR #64 head (`kriscendobot/minion.town`, branch `design/claude-agents-capability`), one review-feedback follow-up commit (`73f42c6`), then verified CI green.

**What changed, by seat:**
- **critic** — Stated that each `@claude-agents` introduction mints a *fresh per-child facet* (not one shared object reference), which is the property the "recursive without parent access" security claim depends on; added the missing `@claude-account → child guest` edge to the mermaid diagram so it matches the "every child receives both special names" prose.
- **skeptic** — Cited the Endo source for the `specialNames`/`platformNames` claim (verified: `packages/daemon/src/guest.js` `makeGuest` builds exactly `@agent/@self/@host/@mail/@nets/@planes` ~lines 94–104; `platformNames` is a `host.js` host-provisioning map ~lines 446/467/491 on `llm`); stated the retained-child counter is a single count keyed on `iss+sub`, global across the whole descendant tree (not per nesting level); flagged that the setup-token path serves only local-CLI users and named the browser-relay fallback + canary-has-CLI assumption.
- **decomplector** — Stated the child `infer` exo re-validates the credential live on every `run` so disconnect reaches already-issued exos (no snapshot); named the quota as per-user data the factory reads rather than inline mechanism prose.
- **ergonomist** — Encoded `create()`'s failure modes as a discriminated-union return in the TS interface (`ClaudeAgent | {type:"needs-auth"} | {type:"quota-exceeded"}`, `run` rejects only for `pool-exhausted`); renamed the non-conversational concierge `@claude` → `@claude-account` throughout (diagram, prose, `provideGuest` snippet, auth steps, acceptance, decisions).
- **copyeditor/pedant** — Fixed the problem-scope bullet-4 parallel structure/terminal punctuation; recast "No secret is a form value" → "No form value is a secret"; glossed "Reincarnation"; split the quota list so it no longer mixes amounts with a policy.
- **novice** — Added a diagram walk-through paragraph; defined the "generic child loop" operationally; named the two-names→recursion mechanism; glossed `introducedNames`, `platformNames`, `makePetSitter`; replaced the bare causal "so" in the auth section with the actual mechanism.

Also updated the acceptance-evidence list to add the nested-creation depth test (ninth child through a child's own factory still rejected) and the disconnect-reaches-a-pre-existing-child test, and added a Decisions bullet on credential-expiry behavior.

**Care note:** the pedant's clean bill certified the doc as em-dash-free; my first draft introduced em-dashes/en-dashes/`§`/`≈`. I recast all of them back to plain ASCII (commas, parentheses, hyphens) and re-verified zero non-ASCII code points before committing, so I didn't regress that standing check.

**Follow-ups:** none blocking. The driver re-posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr64-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3705130 cached reads)
- Output: 35955 tokens
- Cost: $3.667268
- Wall-clock: 538s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
