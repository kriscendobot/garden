# Weave the sturdy-refs content onto live `llm` (it merged onto a frozen snapshot, stranding it)

Wear the **weaver** role. PR **#510** (sturdy-refs endor-syscall design) **merged onto its frozen
base `llm-65b0abe`** (186 commits behind live `llm`, 5 ahead = the sturdy-refs stack), so its
content is **NOT on live `llm`**. The maintainer wants it **forwarded to live `llm` now**. Bot
repo `endojs/endo-but-for-bots`, bot identity.

## Task

1. **Forward #510's merged sturdy-refs content (the 5 commits on `llm-65b0abe`) onto live `llm`**
   — rebase/cherry-pick the stack onto current live `llm` and update `llm` so the design content
   lands there. The content is largely a new design doc (`designs/sturdy-refs-endor-syscall.md`)
   + the build job, so the weave should be mostly additive; resolve any conflicts.
2. **Rebase the still-open #521** (`feat(pass-style): first-class 'sturdyref'`, on the same frozen
   `llm-65b0abe` base) onto **live `llm`**, so the shared stack base moves forward together and
   #521 no longer sits on the stale snapshot. Keep #521 coherent and open.
3. Verify nothing is lost: #510's design content is present on live `llm`; #521 still carries its
   own diff atop live `llm`.

If you hit a weave impasse (non-trivial conflicts / porting), **escalate to a fixer and resume**
per the standing weaver→fixer rule; do not stop at the impasse.

## Definition of done

#510's sturdy-refs content present on **live `llm`**, #521 rebased onto live `llm` (stack
coherent), nothing lost — pushed. Report the live `llm` SHA and #521's new base/head. Post a brief
note on #521 that its base moved to live `llm`.

Posted by the liaison on behalf of the maintainer.
