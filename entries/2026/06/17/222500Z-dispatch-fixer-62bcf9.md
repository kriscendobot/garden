---
ts: 2026-06-17T22:25:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--62bcf9
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/449
  - https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431819321
---

# dispatch: fixer — #449 worked-example correction (erights mid-round-3)

Erights posted an inline comment at 22:23:32Z on
`packages/immutable-arraybuffer/designs/freezable-typedarray.md`
(pre-rename path `DESIGN-freezable-typedarray.md`) pointing out
a factual error in the *Indexed assignment never modifies the
underlying buffer* worked example:

> > view[0] reads as 0 (delegates to the hidden genuine
> > TypedArray's read of the immutable buffer's byte 0).
>
> How? It seems to me this would just be an OrdinaryGet, so after
> `view[0] = 42;`, I would expect `view[0]` to evaluate to `42`.
> The assignment creates a property on the wrapper named `0`. The
> indexed lookup reads is.
>
> What does work is that after `view[0] = 42;`, `view.at(0)`
> evaluates to the zero value of the hidden genuine view.
>
> Your analysis of the frozen (or even non-extensible) case is
> correct. Your invariant is correct.

Comment id `3431819321`, in_reply_to `3431601526`.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#449`, DRAFT, base
  `master-4a04d07`, head
  `design/immutable-arraybuffer-freezable-typedarray-emulation`
  at `cc55ec895` (fixer a37e0f's push at 22:23Z, post-r3-r2
  must-fix-loop addressing).

## Task

In your `project/` worktree at `cc55ec895`:

1. Locate the worked example in
   `packages/immutable-arraybuffer/designs/freezable-typedarray.md`
   under *Semantics* > *Indexed assignment never modifies the
   underlying buffer* > *Worked example (non-frozen wrapper)*.
2. Correct the assertion. Per erights:
   - After `view[0] = 42;`, `view[0]` evaluates to `42` (it's an
     OrdinaryGet finding the new own data property installed by
     the assignment).
   - It is `view.at(0)` (and `Uint8Array.prototype.at.call(view, 0)`)
     that delegates and returns the underlying buffer's byte 0.
   - The invariant about the underlying buffer (frozen +
     non-extensible analysis) is still correct.
3. Update the worked example accordingly. The fix is to show
   *both* reads: `view[0]` returning `42` (the shadowing own
   property) AND `view.at(0)` returning the underlying buffer's
   byte 0 (or `Uint8Array.prototype.at.call(view, 0)`). The point
   the example is making — that the underlying buffer is
   untouched — survives unchanged; only the read-mechanism
   explanation is wrong.
4. If the surrounding prose elsewhere in the document repeats the
   same incorrect claim about indexed read delegating, fix those
   too (grep for `view[0]` reads and similar phrasings).
5. Reply inline on comment `3431819321` confirming the
   correction and citing the new commit SHA. Acknowledge erights
   was right about OrdinaryGet.
6. Run pre-push-gates.
7. Commit and push to
   `design/immutable-arraybuffer-freezable-typedarray-emulation`
   (append only).

## Authorizations

- Push to `design/immutable-arraybuffer-freezable-typedarray-emulation` (append only).
- Inline reply on comment 3431819321.

## Out of scope

- Do NOT re-request review.
- Do NOT mark PR ready.
- The 12 round-2 summary-fix items still wait for the
  terminating-round bundle; do NOT address them here.

## Deliverable

A `result` entry naming pre/post head SHAs, the corrected file,
the pre-push-gates result, the inline reply URL, and
**Recommended next stage**: `next: solicitor` for #449 r3 (the
solicitor will now read against the corrected worked example).

End your turn with a concise summary back to the orchestrator.
