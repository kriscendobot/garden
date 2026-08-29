CI is green (rc 0). The fix round is complete.

## Completion report

Applied panel round-5 must-fix items to `designs/claude-agents-capability.md` on PR #64 (kriscendobot/minion.town, head `design/claude-agents-capability`), pushed as one review-feedback follow-up commit (`c2d15ad..ff80a00`), and watched CI to terminal — **GREEN**.

Fixes applied, by requesting seat:

- **critic** (request-changes): Named the in-flight inference marker's liveness mechanism — each held marker records the `claude -p` spawn's OS pid plus start time (to defeat pid reuse), and is live only while that pid names a host-launched running process — and bounded the reconciliation sweep to run at least once per minute (previously "the set of live confined spawns" with no named mechanism or cadence, the linchpin the section exists to protect). Also rewrote the "up-to-eight-deep tree" clause so it reads as a total retained-descendant quota (which only incidentally bounds a single unbranched chain to eight levels), not a per-level fan-out limit.
- **skeptic** (request-changes): (1) Restated the companion `@endo/claude` active-kill bound (wall-clock / output-byte / `--max-turns` → `limit-exceeded`) that frees the slot for an *alive-but-wedged* child, distinct from the passive crash path, and added an acceptance-evidence item that provokes a runaway prompt and confirms the slot is freed via that path. (2) Scoped the model allow-list to the caller's own subscription plan (Pro vs. Max), not a single deployment-global set, so `unknown-model` binds at admission to the resource it protects instead of surfacing opaquely as `unavailable` at infer time; updated both the `models()` and `create()` doc comments.
- **copyeditor** (request-changes): Disambiguated the pronoun `it` ("For one user, the deployment mints…"); glossed `facet` at its first use in the capability-shape prose; fixed the parallel article use in the confinement-canary list ("an unreachable tool, a built-in, a settings file, a sibling guest…") and aligned the "settings file" term with the acceptance-evidence bullet.

Also converted the one em-dash I introduced to the doc's parenthetical convention (the doc is em-dash-free per the pedant's positive check) and confirmed no stray non-ASCII was added.

Not applied (out of must-fix scope): the comment-only seats' items (skeptic's title-overclaim tweak; decomplector, ergonomist, pedant, novice suggestions). Per the stage brief I applied the must-fix set once, pushed, watched CI, and stopped — the driver re-posts panel-6.

Follow-ups: none blocking. The design still carries its self-declared Open Questions (user-reach of setup-token; browser OAuth relay) as deferred, which the panel treated as comment-only.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr64-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1809492 cached reads)
- Output: 15118 tokens
- Cost: $1.9683840000000001
- Wall-clock: 294s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
