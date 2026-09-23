---
ts: 2026-06-12T15:15:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--d73da3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 439
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/439
  - https://github.com/endojs/endo-but-for-bots/pull/439#pullrequestreview-4482857456
  - https://github.com/endojs/endo-but-for-bots/pull/439#discussion_r3400997331
  - https://github.com/endojs/endo-but-for-bots/pull/439#discussion_r3400999456
  - https://github.com/endojs/endo-but-for-bots/pull/439#discussion_r3401007599
  - https://github.com/endojs/endo-but-for-bots/pull/439#discussion_r3401012722
---

# dispatch: researcher — references for #439 designer (consolidate formula view + drop @info hub)

User directive (2026-06-12T15:13Z, "rsvp …pull/439#pullrequestreview-4482857456"):
apply kriskowal's review on the chat-value-modal-formula-view
design PR. Precedence dispatch ahead of the designer.

## Review substance

Kriskowal review `4482857456` (COMMENTED), top-level body:

> Please consolidate this design into the existing formula
> inspector design.

Plus 7 inline asks (5 substantive, 2 positive acks):

1. **`designs/chat-value-modal-formula-view.md:247`** (id
   `3400997331`):
   > This becomes more complicated for formulas in directories
   > of a guest's pet store. I have misgivings about the
   > `@info` hub design, generally. Let's actually prefer to
   > have a method of Host agents that is absent on Guest
   > agents, that can retrieve the formula for any identifier
   > (but not for any locator, as these span peers). Please
   > dispatch a designer to propose the corresponding removal
   > of the `@info` name hub feature, as it is revealed to be
   > misguided. We will also need to create a CLI/GUI verb
   > like `inspect` or `examine` or `formula` to replace the
   > former idiom.
   
   **Big architectural ask**: redesign away from `@info`,
   toward Host-agent-only `getFormula(identifier)` method, +
   new CLI/GUI verb.

2. **Line 297** (id `3400999456`):
   > Let's consolidate this plan into the existing plan.
   > Synthesize the best of both.
   
   Reinforces the consolidation framing.

3. **Line 300** (id `3401000880`, positive): "Stack model
   sounds good to me." → noted in result.

4. **Line 302** (id `3401001866`, statement): "This will be
   new." → noted in result.

5. **Line 306** (id `3401007599`):
   > The view for a promise formula will need to subscribe to
   > the promise and provide a button to view the next value
   > when it resolves, or the rejection reason. This should
   > be integrated with error tracing.
   
   **New feature**: promise-formula view with
   subscribe-and-button pattern, integrated with error
   tracing.

6. **Line 309** (id `3401012722`):
   > Principle of least surprise: do not unwind cycles. The
   > user has a mental model of how many layers they have
   > gone down that we should not meddle with.
   
   **Principle**: no cycle unwinding in the formula view.

7. **Line 312** (id `3401018617`, positive): "Let's
   implement this." → noted; affirms a specific design
   element.

👀 reactjis on the review + the 4 substantive inline asks are
already posted.

## Scope of the research

The downstream **designer** needs to know:
- The "existing formula inspector design" referenced in
  comments 1 and 2 — where it lives (probably
  `designs/formula-inspector.md` or similar), what shape it
  has.
- The `@info` hub design — where it's documented, what it
  does, which other designs reference it.
- The Host vs Guest agent type distinction — what methods
  Host has that Guest doesn't (precedent for the new
  `getFormula` shape).
- Existing CLI verbs (`endo` CLI) — what's there now, where
  a new `inspect`/`examine`/`formula` verb would slot in.
- Existing promise-formula view shape — what
  `chat-value-modal-formula-view.md` currently proposes vs
  the prior "existing plan" for promise formulas.
- Error-tracing integration surface — where the error
  tracing facility lives (probably the PR #58 work that
  shipped recently, or its base on `llm`).
- Any prior designs that touch cycle unwinding — the
  "principle of least surprise: do not unwind cycles" cue.

In your `project/` worktree on
`design/chat-value-modal-formula-view` (FETCH and CHECKOUT
the actual head if dispatch-prepare picked an older one):

1. **Read** `designs/chat-value-modal-formula-view.md` in
   full to understand the design being reviewed.
2. **Locate the existing formula inspector design** —
   `find designs/ -iname '*formula*' -o -iname '*inspector*'`
   and inspect each.
3. **Locate the `@info` hub design** — `git grep -lI -i
   '@info' designs/` and inspect.
4. **Map Host vs Guest agent type distinction** —
   `git grep -lI 'HostAgent\|GuestAgent\|HostFormula\|GuestFormula'
   packages/daemon/src/` and `git grep '@info'
   packages/daemon/src/`. Surface the methods Host has that
   Guest doesn't.
5. **Map existing CLI verbs** — inspect
   `packages/cli/src/commands/` for the verb landscape.
6. **Map error-tracing integration** — find the error
   tracing facility (per PR #58 work or its base) and
   identify how a promise formula view would subscribe.
7. **Identify cycle-unwinding references** — `git grep -lI
   'cycle' designs/` to find prior decisions or principles.

## Output shape

Produce a `result` entry under
`journal/entries/2026/06/12/` with the standard
`## Library and project references` section the orchestrator
inlines into the downstream designer brief. Surface:

- The existing formula inspector design's path + key
  sections.
- The `@info` hub design's path + how it's currently
  consumed (which other designs reference it; CLI verbs
  that depend on it).
- The Host vs Guest agent method delta (precedent for the
  new `getFormula` shape).
- CLI verb candidates (`inspect`, `examine`, `formula`) —
  any existing collisions.
- Promise-formula view's current shape (in the PR's
  design) vs the existing plan referenced in comment 2.
- Error-tracing integration points.
- Cycle-unwinding policy references (if any).
- Blockers / asymmetries / open questions.

## Out of scope

- Do NOT propose the redesign; that's the designer.
- Do NOT touch the tree or push.
- Do NOT speculate beyond what the code/designs show.

## Authorizations

Read-only.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` with
the `## Library and project references` section ready for
inlining into the designer dispatch.

End your turn with a concise summary back to the orchestrator. The
orchestrator inlines your section into the designer dispatch and
tears down your dispatch root on return.
