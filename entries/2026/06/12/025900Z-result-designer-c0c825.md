---
ts: 2026-06-12T02:59:00Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/designer--c0c825/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/416
---

Applied kriskowal's CHANGES_REQUESTED (review id 4478931681, 2026-06-11T17:10Z) on PR #416's agentry-agent-builder.md design doc, in two focused commits, pushed to `pc-agent-tools-and-agentry-designs`. Replied on both inline review threads, posted a top-level summary comment, and re-requested kriskowal as reviewer.

## Commits

- `4022259d1 docs(designs): address PR #416 review on SmallCaps robustness`
  Addresses comment id 3397770016 at line 108. Replaced the bigint-only `#290` callout with a normative *The SmallCaps wire contract* subsection referencing [`packages/marshal/src/encodeToSmallcaps.js`](https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToSmallcaps.js); named the reserved range BANG (`!` 33) through DASH (`-` 45) and the seven assigned sigils; stated the symmetric encode/decode contract as a table (deriver names the outbound shape: string-encoded bigint + Hilbert-Hotel `!`-escape on type-introducer collisions; `prepareArguments` runs the matching reverse: `coerceBigintArgs` + `unescapeHilbertHotel` + LLM-JSON fixups). Threaded into the agentry↔agent-tools boundary's seam paragraph, the deriver call site sketch, and Design Decision 4 (renumbered from 3 after the define/make split).

- `5f1955b7c docs(designs): address PR #416 review on define-vs-make split`
  Addresses comment id 3397774675 at line 40. Applied the exo `define*` / `make*` factorization (see [exo-taxonomy.md](https://github.com/endojs/endo/blob/master/packages/exo/docs/exo-taxonomy.md#make-instance-vs-define-class-vs-define-class-kit)): `defineAgent(template)` returns an `AgentTemplate` (powerless) — method guards, derived wire schemas, attenuation policies as functions-of-cap, prompts, compaction selector, `prepareArguments` pipeline, pi entry point; `makeAgent(template, powers)` binds the template to one operator's powers (workspace `Filesystem`, `Spawner`, provider `authToken`, the `makeReadPowers({ fs, crypto, url })` for the #297 `importLocation` confinement). New §`defineAgent` (powerless template) vs `makeAgent` (instance with powers) subsection, two-phase pipeline diagram (define-time subgraph + make-time subgraph), dual config sketch, per-harness wrappers come in pairs (`define<Name>Agent` + `make<Name>Agent`), Design Decision 2 records the split, all subsequent decisions renumbered (3-9 → 4-10) and cross-references updated, #404 wizard table split into two columns (template vs powers; Submit drives `makeAgent`), #370 connection rewritten as one template / many `makeAgent` calls.

`designs/README.md` row expanded to reflect both rulings (template + instance pair, function-of-cap policy model, symmetric SmallCaps decode).

## PR-side actions

- Reply on inline comment 3397770016 (line 108, SmallCaps): comment id 3400366368 ([html](https://github.com/endojs/endo-but-for-bots/pull/416#discussion_r3400366368)).
- Reply on inline comment 3397774675 (line 40, define-vs-make): comment id 3400367697 ([html](https://github.com/endojs/endo-but-for-bots/pull/416#discussion_r3400367697)).
- Top-level summary comment: [4686913630](https://github.com/endojs/endo-but-for-bots/pull/416#issuecomment-4686913630).
- Re-requested kriskowal as reviewer (`requested_reviewers` updated).

## Authorization

The dispatch prompt authorized append-push to the PR branch and explicitly: replying on both inline review threads, posting the top-level summary, and re-requesting review. PR is authored by 0xpatrickbot; did not amend any 0xpatrickbot commits (both new commits land on top of `e1d9f3b19` as bot-authored append-only).

Self-improvement: nothing this time.
