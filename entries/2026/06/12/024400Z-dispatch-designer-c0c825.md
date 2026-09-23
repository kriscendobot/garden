---
ts: 2026-06-12T02:44:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--c0c825
prs:
  - repo: endojs/endo-but-for-bots
    pr: 416
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/416
  - https://github.com/endojs/endo-but-for-bots/pull/416#pullrequestreview-4478931681
  - https://github.com/endojs/endo-but-for-bots/pull/416#discussion_r3397770016
  - https://github.com/endojs/endo-but-for-bots/pull/416#discussion_r3397774675
---

# dispatch: designer — address kriskowal's CHANGES_REQUESTED on PR #416 (agentry design)

User directive (2026-06-12T02:38Z, "rsvp …pull/416#pullrequestreview-4478931681"):
apply kriskowal's review on the agentry design PR. The PR is
authored by 0xpatrickbot but the bot has direct push authority
to `endo-but-for-bots`, and the maintainer has the garden
working on it via this rsvp.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#416`
  ("docs(designs): @endo/agent-tools + @endo/agentry defineAgent
  builder"), OPEN (not DRAFT), base `llm`, head
  `pc-agent-tools-and-agentry-designs` at
  `e1d9f3b195bfd99ed8de94f126e1e045441cfb04` (`e1d9f3b19`).
  `reviewDecision: CHANGES_REQUESTED`. Author: 0xpatrickbot.
- **Review** `4478931681`, CHANGES_REQUESTED, body empty.
  Submitted 2026-06-12T02:28:28Z by kriskowal. Substance in
  inline comments below.
- **Inline asks** (per `Fetch ALL inline comments tied to a
  review` discipline):

### Ask 1 (id `3397770016`) at `designs/agentry-agent-builder.md:108`

> This needs to be more robust. SmallCaps encoding is a Hilbert
> Hotel of all string values regardless of the type they
> represent, so not just encoding bigints, but deflecting
> strings that have a type-introducer prefix, and vice versa on
> the return path.

Translation: the SmallCaps encoding scheme (per
`@endo/marshal`'s smallcaps representation) treats certain
type-introducer-prefixed strings specially. When encoding
non-bigint values that happen to start with a SmallCaps
type-introducer character (e.g., `'+'`, `'-'` for bigints; the
SmallCaps spec lists the full set), the encoder must escape
them so the decoder doesn't mis-route. Similarly the decoder
must un-escape strings that were escaped. The design currently
only handles bigint encoding; it needs to handle the
type-introducer escaping for arbitrary strings.

### Ask 2 (id `3397774675`) at `designs/agentry-agent-builder.md:40`

> Is this agent definition or agent creation? I would expect
> define to create a powerless template and for make to empower
> an instance.

Translation: the design conflates two phases. The maintainer's
mental model is:
- `defineAgent(...)` — produces a powerless template (a
  builder, schema, or class) with no capabilities yet bound.
- `makeAgent(...)` — instantiates the template with concrete
  powers, producing an empowered live agent instance.
The design should adopt this distinction explicitly at line
40 (and propagate consistently).

## Task

In your `project/` worktree on
`pc-agent-tools-and-agentry-designs` at `e1d9f3b19`:

1. **Read** `designs/agentry-agent-builder.md` in full to
   understand the design.
2. **Read the canonical SmallCaps reference**: the SmallCaps
   spec lives in `@endo/marshal`'s source (likely
   `packages/marshal/src/encodeToSmallcaps.js` and
   `decodeFromSmallcaps.js`). Identify the type-introducer
   character set + the escaping rule. The design should
   reference SmallCaps's existing escape discipline rather
   than re-deriving it.
3. **Address Ask 1 (SmallCaps robustness)**:
   - Edit `designs/agentry-agent-builder.md` at and around
     line 108 to describe the encoding/decoding contract:
     - On encode: any string whose first character is a
       SmallCaps type-introducer gets escaped (per SmallCaps's
       own rule, likely a leading `!`).
     - On decode: any string starting with an escape gets
       unescaped.
     - bigint encoding (which probably uses `+`/`-`
       type-introducer) becomes one case of the general
       type-introducer scheme.
   - Reference the SmallCaps spec by source path for
     reviewers to consult.
4. **Address Ask 2 (define-vs-make split)**:
   - Edit `designs/agentry-agent-builder.md` at line 40 (and
     propagate throughout) to distinguish:
     - `defineAgent` — powerless template (no capabilities
       bound; pure shape).
     - `makeAgent` — instantiation with concrete powers.
   - Look for other places in the doc where the conflation
     might persist (the term "agent" by itself becoming
     ambiguous) and update for clarity.
5. **Commit each addressed comment separately**:
   - `docs(designs): clarify SmallCaps type-introducer
     escaping in agentry agent-builder design`.
   - `docs(designs): split defineAgent (template) from
     makeAgent (instance) in agentry design`.
   One commit per ask is cleaner than bundling.
6. **Push** to `pc-agent-tools-and-agentry-designs` via
   `git push origin HEAD:pc-agent-tools-and-agentry-designs`
   (append push; this is the bot's branch on
   endo-but-for-bots; bot has direct push).
7. **Reply on each inline thread**:
   - On `3397770016` cite the addressing commit SHA and
     summarize the SmallCaps escape contract.
   - On `3397774675` cite the addressing commit SHA and
     confirm the define/make split.
8. **Post a top-level summary** on PR #416 noting both
   addressed asks (with at-mentions to `@kriskowal` and
   `@0xpatrickbot` since this is cross-bot collaboration).
9. **Re-request review** from kriskowal.

## Authorizations (per-action, forwarded by liaison)

- **Push commits** to `pc-agent-tools-and-agentry-designs`
  (append push only). The bot has direct push to
  endo-but-for-bots; the cross-bot pattern is the
  maintainer's explicit ask via rsvp.
- **Reply on both inline threads**. Standing
  `endo-but-for-bots` broad-comment authorization.
- **Top-level summary comment** on PR #416.
- **Re-request review** from kriskowal.

## Out of scope

- Do NOT change other parts of the design beyond the two
  asks.
- Do NOT rebase or force-push.
- Do NOT touch the other design doc in this PR
  (`designs/agent-tools.md`) unless the changes propagate
  naturally (the SmallCaps fix and define/make split may
  warrant a cross-reference but no surface edits).
- Do NOT un-draft / mark ready (PR is already not-draft).
- Do NOT amend 0xpatrickbot's prior commits.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` naming:

- Pre/post branch tip SHAs.
- The two commit SHAs (one per ask).
- Diagnosis of the SmallCaps spec (which file references; what
  the type-introducer set is; what the escape rule is).
- The define/make split content (before/after summary at line
  40 and any other propagated edits).
- The two inline-thread reply URLs.
- The top-level summary comment URL.
- Re-request-review URL/status.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
