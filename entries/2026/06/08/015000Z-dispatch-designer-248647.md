---
ts: 2026-06-08T01:50:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--248647
prs:
  - repo: endojs/endo-but-for-bots
    pr: 89
    role: target
refs:
  - entries/2026/06/08/013700Z-dispatch-researcher-41281f.md
  - entries/2026/06/08/014800Z-result-researcher-41281f.md
  - https://github.com/endojs/endo-but-for-bots/pull/89
  - https://github.com/endojs/endo-but-for-bots/pull/89#pullrequestreview-4342320898
  - https://github.com/endojs/endo-but-for-bots/pull/89#issuecomment-4644790211
---

# dispatch: designer — apply kriskowal CHANGES_REQUESTED on PR #89 + author scheduler design

Maintainer-feedback dispatch on `endojs/endo-but-for-bots#89`
(`docs(designs): propose genie-integration`). Review
`4342320898` is kriskowal CHANGES_REQUESTED, 5 inline + a top-
level "rebase for zizmor CI fix". One inline requires authoring
a NEW design as a prerequisite refactor (the scheduler).

## State at dispatch time

- **PR** `#89`, design-only, base `llm`, head
  `docs/design-genie-integration` at
  `97b16962db4abef03b1368c1ede4804d3b4aa001`.
- Current `llm` tip: `11a76ae6` (the master-into-llm sync merged
  this cycle; carries the upstream zizmor fix from endo#3297).

## Maintainer asks (verbatim, all 5 inline + 1 top-level)

**Inline 1** (`designs/genie-integration.md:8`, id `3285712716`):
*"Prettier."*

**Inline 2** (`designs/genie-integration.md:452`, id
`3369680410`): *"Every agent in the daemon has a 'pet store'
which can read and write files and make and remove directories.
This should be a sufficient space for the agent's memory and
references to shared context. It should not be necessary for
this virtual filesystem to be backed by an actual file system.
If we s..."* (body truncated — **read full via**
`gh api repos/endojs/endo-but-for-bots/pulls/comments/3369680410`)

**Inline 3** (`designs/genie-integration.md:481`, id
`3369682114`): *"Please dispatch a designer to propose a
scheduler design that closes the gap between what the daemon
currently provides and what the integrated agent would need.
This should amount to a prerequisite refactor. Please include
that new design in this PR."*

**Inline 4** (`designs/genie-integration.md:485`, id
`3369682742`): *"Let's simply call it 'scheduler'."*

**Inline 5** (`designs/genie-integration.md:560`, id
`3370450380`): *"Please remove. This is indeed irrelevant."*

**Top-level** (id `4644790211`): *"Also rebase for the zizmor
CI fix."*

## Library and project references

(Inlined verbatim from researcher `41281f`'s section.)

### Library concepts and sections

- [endopi.md source page](../../library/sources/endo-but-for-bots--llm-designs-endopi.md) — the family keystone for the endopi-* cluster, including the Genie section that documents `packages/genie` 0.0.1 as the *third Endo-side surface* that embeds Pi rather than re-implementing it.
- [endopi / Genie: Pi inside Endo, and the four architectural contrasts](../../library/sections/endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts.md) — the canonical exposition of the Genie surface that `designs/genie-integration.md` is the integration survey for. Names the observer / reflector subagent pair, the heartbeat autonomous executor, `makeIntervalScheduler` cron-style periodic prompts, the SOUL.md / HEARTBEAT.md Claw-compatible workspace, the §confinement-is-the-open-question framing. *Genie is closer to pi-agent than to pi-coding-agent* — depends on the embedding-shaped SDK, not the cli-shaped one.
- [endopi / comparative pi-mapping with eight spinout-gaps and architectural contrasts](../../library/sections/endo-but-for-bots--llm-designs-endopi--comparative-pi-mapping-with-eight-spinout-gaps-and-architectural-contrasts.md) — sister Lal/Fae section.
- [daemon-capability-bank / family-of-designs-and-six-design-principles](../../library/sections/endo-but-for-bots--llm-designs-daemon-capability-bank--family-of-designs-and-six-design-principles.md) — names **Timer / scheduling** (`daemon-capability-timer.md`, *Planned*) as one of nine sibling capabilities. The new scheduler design at inline 481 sits in this slot. The six §Design Principles are the rubric: capabilities-not-configurations, recursive attenuation, caretaker separation, optional deny patterns, LLM discoverability, existing Endo patterns.
- [daemon-agent-tools / dir-shell-git-capabilities-and-dynamic-tool-registration](../../library/sections/endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-git-capabilities-and-dynamic-tool-registration.md) — worked example of how a per-capability design lays out tool shapes, the §pet-name capability granting pattern, the §dynamic tool-discovery pattern.
- [daemon-mount / two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement](../../library/sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement.md) — `ScratchMount` is the daemon-managed live-mutable-filesystem-as-capability. The §two-formula-type-split with §lifecycle-asymmetry-vs-implementation-symmetry is a candidate shape for the scheduler (host-managed vs guest-revocable intervals).
- [chat-spaces-gutter / space-model-and-persistence](../../library/sections/endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence.md) — the canonical precedent for the maintainer's "stand the agent on the pet store" framing at inline 452. Encodes a typed namespace on top of the daemon's untyped pet-store primitives, with **no new daemon API**. The same shape applies to memory: observations / reflections / profile become a typed sub-namespace, not a vfs-backed markdown tree.
- [space concept page](../../library/concepts/space.md) — the *pet store holds formula keys not locators* idiom + the *typed namespace over untyped pet-store* idiom.
- [dehydrate-hydrate concept page](../../library/concepts/dehydrate-hydrate.md) — the pet-store-holds-formula-keys discipline.
- [readme / milestones-overview + timeline-and-strategic-items](../../library/sections/endo-but-for-bots--llm-designs-readme--milestones-overview.md) — **endoclaw-timer is a strategic-early M1 item** because *SES lockdown removes setTimeout / setInterval, so Timer is the only mechanism for scheduled agent execution*. The new scheduler design lands in this M1 slot.

### Project context

- [endo-but-for-bots project README](../../projects/endo-but-for-bots/README.md) — § Rules of engagement (design PRs land on `llm`); § Standing authorizations (the garden's roles may post comments freely on this repo); § Authority structure (every commenter is maintainer-equivalent).
- The dispatch's referenced design file `designs/genie-integration.md` on the PR head (`97b16962`) carries the §3 *Scheduling* section the maintainer's "Let's simply call it 'scheduler'" comment at line 485 lands inside. The section already proposes graduating the genie interval scheduler into a daemon `interval-scheduler` formula. The new prerequisite scheduler design at line 481 extracts §3 into its own sibling design under `designs/scheduler.md`, leaving the genie-integration PR to *reference* it.
- The existing `designs/endoclaw-timer.md` on `origin/llm@11a76ae6` (M1 strategic-early; status *In Progress* with Phase 1 prototype shipped in `packages/genie/src/interval/`) is the most direct precedent. The new design is the daemon-side graduation that endoclaw-timer's Phase 1 anticipated.
- Related designs worth citing rather than reinventing: `designs/daemon-capability-bank.md`, `designs/daemon-commands-as-messages.md`, `designs/daemon-value-message.md`, `designs/daemon-mount.md`, `designs/lal-fae-form-provisioning.md`, `designs/familiar-bundled-agents.md`.
- **Zizmor CI fix context**: maintainer's "rebase for the zizmor CI fix" refers to upstream `endojs/endo#3297` (*chore(ci): fix zizmor warning*), already in current bot-fork `origin/llm@11a76ae6`. A clean rebase of #89's head onto a fresh `llm-<sha>` frozen base picks up the fix without per-PR zizmor work.

### Open questions for the designer

- The maintainer's "Let's simply call it 'scheduler'" at line 485 disambiguates a name within the existing §3. Library has no concept page distinguishing *scheduler* (agent-side capability) from *interval-scheduler* (daemon formula type) from *timer* (existing simple formula type). If the new design lands these as distinct first-class names, surface as Open Question.
- The inline-452 rewrite raises whether existing §2 *Memory* becomes "use the pet store directly" vs "use `ScratchMount` over the pet store's state directory". Maintainer's framing favors the former; surface trade-off as Open Question.
- The §3 *Scheduling* section becoming a sibling design raises whether the new design supplants or extends `designs/endoclaw-timer.md`. Convention is *Superseded by* rather than deletion; name endoclaw-timer as Phase-1-shipped predecessor and add a *Superseded by* pointer on endoclaw-timer if the maintainer agrees.

## Task

In your `project/` worktree (currently at PR #89 head
`97b16962`):

1. **Rebase on current `llm`**. Per the maintainer's top-level
   ask + frozen-base-branch convention:
   - Compute the new frozen-base name: `llm-<short-sha-of-11a76ae6>`.
   - Push `origin/llm` to that ref:
     `git push origin 11a76ae6042ef0994f9cb3f2ec722a0ec05e127b:refs/heads/llm-<short-sha>`.
   - Rebase the head branch onto the new frozen base:
     `git fetch origin && git rebase llm-<short-sha>`.
   - Force-with-lease push the rebased head (lease anchor
     `97b16962db4abef03b1368c1ede4804d3b4aa001`).
   - The rebase picks up the zizmor CI fix automatically.
2. **Fetch the full body** of inline `3369680410` (the truncated
   pet-store comment) via the gh-api command above.
3. **Address inline 1** (`line 8` Prettier format fix): run
   `prettier --write designs/genie-integration.md` (or the
   project's invocation), commit as `style(designs): prettier
   format on genie-integration`.
4. **Address inline 2** (line 452 pet-store-as-memory framing):
   rewrite §2 *Memory* per the maintainer's full body. The
   research notes the rewrite should favor "use the pet store
   directly" (typed namespace) over "use ScratchMount over a
   state directory". Surface the trade-off as an Open Question
   if you're uncertain. Commit as `docs(designs): rewrite §Memory
   to stand on the pet store (#89 inline)`.
5. **Address inlines 3 + 4** (lines 481, 485): author a new
   `designs/scheduler.md` design as the prerequisite refactor.
   Use the daemon-capability-bank's §six Design Principles as
   the rubric. Name it as the daemon-side graduation of
   endoclaw-timer's Phase 1 prototype. Add a *Superseded by*
   pointer on `designs/endoclaw-timer.md` if you judge the
   supplant relationship correct, or surface as Open Question
   if uncertain. Update `designs/genie-integration.md:481-485`
   to reference the new `designs/scheduler.md` rather than
   propose §3 inline. Update `designs/README.md` to add the
   new design entry. Commit as
   `docs(designs): scheduler design + reference from
   genie-integration (#89 inline)`.
6. **Address inline 5** (line 560): remove the irrelevant
   section. Commit as `docs(designs): remove irrelevant section
   from genie-integration (#89 inline)`.
7. **Push** all commits to `docs/design-genie-integration`
   (force-with-lease for the rebase + appends for the new
   commits; if the appends land cleanly, you may end with a
   regular push).
8. **Retarget the PR** to the new frozen base if needed:
   `gh pr edit 89 -R endojs/endo-but-for-bots --base llm-<short-sha>`.
9. **Reply on each inline thread** citing the addressing
   commit(s). Reply with a top-level summary comment on PR #89
   acknowledging the directive and naming the new scheduler
   design + the rebase.

## Authorizations (per-action, forwarded by steward)

- **Push** new frozen-base branch + rebased head.
- **Retarget the PR base** if needed.
- **Reply on each inline thread** + top-level summary comment
  (`endo-but-for-bots` standing broad-comment authorization).
- **NOT re-request review** (the maintainer set the pace; they
  will return on their own cadence).

## Out of scope

- Do NOT touch source/test files outside `designs/`.
- Do NOT trigger the cleaner/judge/fixer chain (design PR shape).
- Do NOT pre-implement the scheduler's daemon-side code; this
  PR carries the design only.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming:

- Pre/post head SHAs.
- The new frozen-base ref name and SHA.
- Per-commit SHA + one-line description (5–6 commits expected).
- The new `designs/scheduler.md` file path and key sections.
- The §Memory rewrite path.
- Open Questions raised in the PR body or per-thread replies.
- Reply-on-thread URLs (5) + top-level summary comment URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
