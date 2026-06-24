---
ts: 2026-05-22T00:18:30Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--2821af/project
---

# Result: fixer 2821af — Quinn Pig screed round 2 (PR #335)

Addressed kriskowal's CHANGES_REQUESTED round 2 review on PR #335 (`design: AI agent requirements reference (Quinn Pig screed)`).
Review id 4341533455, submitted 2026-05-22T00:10:47Z, 9 inline asks on `designs/ai-agent-requirements-quinnypig-screed.md` covering Endo-side analysis substance (distinguish Garden tooling from Daemon capabilities; cite existing Endo designs/docs not CLAUDE.md; correctly characterize XS metering, sqlite+CAS, snapshots, reflection).

Commit `fa4a54fd2` (single commit, +176 / -71 lines).
Pushed to `origin/designs/ai-agent-requirements-quinnypig-screed`.

Per-ask disposition:

| Ask | Disposition |
|---|---|
| Bullet 1: "look more to the Daemon for guardrails" | Bullet 1 reframed: capability-bank confinement is the primitive, gated-PR is one shape it enables. Boatman / `roles/COMMON.md` framing removed; references now point to `daemon-capability-bank`, `endo-posix-sandbox`, `daemon-agent-tools`. |
| Bullet 3: reflection + see docs not CLAUDE.md | Bullet 3 leads with `__getMethodNames__`, `getMethodGuards`, `@endo/patterns` reflective surfaces. CLAUDE.md citation replaced with `packages/exo/docs/*`, `packages/patterns/docs/*`, `docs/exo-method-banks.md`, `docs/message-passing.md`. |
| Bullet 4: "not relevant" garden GitHub-account example | `kriscendobot` / `kriskowal` worked example removed. OCapN identity story retained; time-limited capabilities flagged as the open axis (bullet 9). |
| Bullet 5: XS metering + worker rate limits + termination + snapshot paging + storage charging + GC tokens | Rewritten from "honest gap" to characterize the XS-metering substrate. Honest-gap framing moved to the budget-as-capability surface layered on the substrate. References added: `daemon-xs-worker-metering`, `daemon-xs-worker-snapshot`, `daemon-content-store-gc`, `daemon-cas-management`. |
| Bullet 6: worker-granularity circuit breaking + RPC-scale prior art | Worker-granularity circuit breaking added; credit given to maintainers' prior RPC-scale circuit-breaker experience. Human-escalation remains the design area. |
| Bullet 7: transactional dry-runs via ephemeral storage proxy | Reframed as transactional dry-runs (client pays compute + network); economics named as the interesting problem; `previewCost` and full dry-run placed on the same spectrum. |
| Bullet 8: cite our designs for pattern mismatch error explanations | Bullet 8 opens with "this is an area that will require attention" and cites `patterns-diagnostic-feedback` as the active design. Names the unbuilt step (extension to capability-grant hints). CLAUDE.md citation gone; `docs/errors.md` and `docs/error-tracing-design.md` cited. |
| Bullet 10: sqlite + CAS + XS snapshots; daemon roll-back feasible | All three substrates named (SQLite for durable name layer, CAS for immutable history, XS snapshots for in-memory state). A roll-back-capable daemon stated as feasible to design. References: `daemon-endo-rust-sqlite`, `daemon-content-store-gc`, `daemon-cas-management`, `daemon-xs-worker-snapshot`, `lal-reply-chain-transcripts`. |
| Closing tweet: self-hosting Endo development | Closing tweet section names self-hosting Endo's development inside its own harness as the regime where the daemon's surfaces stop being hypothetical for the project itself. |

Also synced the cross-cutting `## Honest gaps` section so the framing matches the per-bullet rewrites: cost accounting now described as "budget-as-capability surface layered on existing XS metering substrate"; rollback bullet credits the SQLite + CAS + XS-snapshot substrate; new bullet for LLM-actionable error explanation extension.

Inline replies (all on the `/replies` endpoint, cited the SHA):
- 3285017866 (bullet 1): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285068750
- 3285023507 (bullet 3): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285068935
- 3285024486 (bullet 4): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285069041
- 3285033643 (bullet 5): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285069624
- 3285036384 (bullet 6): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285069782
- 3285043791 (bullet 7): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285069963
- 3285046036 (bullet 8): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285070646
- 3285049649 (bullet 10): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285070865
- 3285052432 (closing tweet): https://github.com/endojs/endo-but-for-bots/pull/335#discussion_r3285070995

Top-level summary comment (with @kriskowal mention and per-ask disposition table): https://github.com/endojs/endo-but-for-bots/pull/335#issuecomment-4513838104

PR is design-only, no CI matrix to drive. The Reference doc does not enter `designs/README.md`'s milestone table, so no README sync was needed.

Self-improvement: I let one em-dash slip into the reply body for bullet 7 ("the daemon to compute the world for free"; "without asking the daemon to compute the world for free — making the dry-run cheap enough..."). `skills/em-dash-style/SKILL.md` is unambiguous about this in prose; replies posted to GitHub are prose and the skill applies. Already-posted comments cannot be silently edited from the bot identity, so the lesson lands as future discipline rather than a retroactive fix. The pattern to watch is that fast-typed comments slip past the discipline more often than commit bodies do, because the muscle memory for "make this read smoothly" pulls toward em-dashes; a quick grep for `—` or `--` on a reply draft before posting would catch it.
