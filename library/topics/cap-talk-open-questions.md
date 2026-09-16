# Topic: cap-talk-open-questions

> Abstract: Unsettled, contentious, or never-converged notions surfaced in the cap-talk mailing-list archive — the disagreements themselves, called out explicitly rather than buried in a neutral summary, because in an object-capability discussion the open disagreement is often the useful signal. Each entry names the question, where in the archive it appears, and (when known) whether and how it was later resolved. This is a growing note: each `scholar-ingest-source` cap-talk cycle appends the contentious notions it finds. Distinct from `capability-theory` (settled foundations) — an idea earns a row here only while it is genuinely open or was long contested on the list.

## Open / contested notions

### 1. Are ACLs and capabilities equivalent? (the Equivalence question)

The archive's founding dispute. A newcomer's natural intuition (Frascadore, 1998) is that ACLs and capabilities are "inseparable" — the owner must consult an ACL to decide whether to grant a capability, so one reduces to the other. Shapiro argued the relationship is *asymmetric* (ACLs build on capabilities cheaply; the reverse is intractable) and posed concrete challenge problems the 1998 thread did not resolve. **Later resolution (external to the list):** Miller-Yee-Shapiro's *Capability Myths Demolished* (2003) formalizes four models and shows Model 4 (object-capabilities) is not equivalent to ACLs, refuting the Equivalence Myth. Contested on-list for years before that paper settled it.

- [cap-talk-1998--acl-vs-capability-challenge-problems](../sections/cap-talk-1998--acl-vs-capability-challenge-problems.md) — the challenge problems and Frascadore's attempted ACL solution.
- [cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys](../sections/cap-talk-1998--what-is-a-capability-swipe-cards-vs-keys.md) — the seeding equivalence intuition.

### 2. What counts as "a capability"? (the definitional dispute)

A recurring, never-fully-converged terminology fight: does syscall-gating, POSIX "capabilities," a parent-monitors-child sandbox, or a "capability URL" deserve the name? Jim Dennis (1998) argued that active syscall-monitoring "isn't a capabilities model" and that misusing the word confuses newcomers and irritates practitioners. The dispute persists in the field (POSIX capabilities, seccomp, "capability URLs") and is only sharpened by insisting on the *object-capability* qualifier.

- [cap-talk-1998--caos-capability-os-terminology](../sections/cap-talk-1998--caos-capability-os-terminology.md) — the CAOS thread.

## See also

- [capability-theory](capability-theory.md) — where a question moves once it is settled.
- [[principle-of-least-authority]], [[confused-deputy]] — concepts the equivalence question turns on.
