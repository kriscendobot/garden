---
id: confused-deputy
aliases: ["confused deputy", "Confused Deputy", "confused deputy problem", "Confused Deputy attack", "Hardy confused deputy", "Norm Hardy confused deputy", "FORTRAN compiler billing", "deputy confusion", "ambient authority confusion", "accountability laundering"]
topics: [capability-theory, capability-security]
---

# confused-deputy

The **Confused Deputy** is Norm Hardy's name (1988) for the failure mode at the heart of
the object-capability argument: a program (a *deputy*) that acts on behalf of two or more
masters is *confused about which master it is serving for which purpose* because it holds
its permissions as **ambient authority** it cannot wield selectively. It cannot say "use
*this* permission for *this* resource" because the permissions "were not distinct things
it could wield selectively — the compiler never actually saw or handled them directly."
The canonical true story (retold by Chip Morningstar from Hardy): a timeshared FORTRAN
compiler was granted permission to write a protected **system accounting/billing file**
(to record resource usage) *and* to write customer output files; a user named the billing
file as the compiler's *output* file, the access-control system asked only "does this
*program* have permission to write this file?" — it did — and the billing records were
overwritten. The root cause is **separating designation from authority**: the designator
(a pathname the user supplies) and the authority (an ACL the system holds) travel by
separate routes with no assurance they belong together, so the deputy can be *fooled into
doing things never intended to be allowed*. Capabilities fix it by making the authority
travel *with* the designation — the compiler would hold one capability from the operators
for the billing file and a different one from the customer for the output file, with no
ambient authority to confuse. Morningstar notes the pattern is not historical trivia:
between **5 and 8 of the OWASP top 10** are arguably confused-deputy problems (injection
attacks, CSRF, XSS, click-jacking), "manifestations of this one conceptual flaw first
noticed in the 1970s." The related systemic effect — losing track of who was trying to do
what, so blame cannot be assigned — Morningstar calls **accountability laundering**.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [habitat-chronicles--what-are-capabilities--designation-and-authority-the-idea](../sections/habitat-chronicles--what-are-capabilities--designation-and-authority-the-idea.md) | **Canonical plain-language telling.** Hardy's FORTRAN-compiler billing-file story, ambient authority as the root flaw, and the 5–8-of-OWASP-top-10 claim. |
| [habitat-chronicles--what-are-capabilities--distributed-services-and-engineering-practices](../sections/habitat-chronicles--what-are-capabilities--distributed-services-and-engineering-practices.md) | The service-chaining form: an upstream service using its own credentials becomes a Confused Deputy; the ACL patch-ups (RBAC/ABAC/PBAC) are "the same one broken thing: ambient authority"; "built in accountability laundering." |
| [papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy](../sections/papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy.md) | The formal treatment: confused-deputy avoidance as one of two practical advantages of object-capability systems (requires Property A + Property D); coins *unconfusable deputy*. |
| [cap-talk-2002-2003--unix-file-descriptor-confused-deputy](../sections/cap-talk-2002-2003--unix-file-descriptor-confused-deputy.md) | A descriptor is capability-like, but implicit numeric-name assignment lets a privileged program mistake a newly opened protected file for inherited stderr. |
| [cap-talk-2002-2003--confused-deputy-redux-namespace-assignment](../sections/cap-talk-2002-2003--confused-deputy-redux-namespace-assignment.md) | May 2002 continuation: the namespace owner, not the kernel, must assign the descriptor index; caller-environment trust is the recurring hazard. |
| [cap-talk-2002-2003--access-matrix-column-vs-row-distinction](../sections/cap-talk-2002-2003--access-matrix-column-vs-row-distinction.md) | Wagner shows setegid explicit-intention signalling avoids the confused deputy in Unix; Shapiro warns the control is discretionary and fails against untrusted code. |
| [cap-talk-2004-2008--mungi-pola-and-confused-deputy](../sections/cap-talk-2004-2008--mungi-pola-and-confused-deputy.md) | Capability primitives are insufficient when application APIs accept forgeable names and resolve them with ambient authority. |
| [cap-talk-2004-2008--confused-deputy-as-ambient-authority](../sections/cap-talk-2004-2008--confused-deputy-as-ambient-authority.md) | The concise 2007 teaching thread: pass an authorized object instead of a name resolved using the deputy’s authority. |
| [cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies](../sections/cap-talk-2004-2008--hybrid-systems-reintroduce-confused-deputies.md) | Hybrid applications reintroduce confused deputies through ACL checks and implicit rights amplification. |
| [cap-talk-2009-2012--confused-deputies-in-capability-systems](../sections/cap-talk-2009-2012--confused-deputies-in-capability-systems.md) | Toby Murray's argument that confused deputies can arise inside ocap systems too, when a service skips input-validation on a passed capability that is more powerful in its hands (rights amplification); the fix is to authenticate accepted capabilities (trademarks in E/Cajita/KeyKOS, final-type checks in Joe-E). |
| [cap-talk-2009-2012--what-is-designation](../sections/cap-talk-2009-2012--what-is-designation.md) | Designation defined on-list; the designation/authority fusion is exactly what prevents the confused deputy (Properties A + D). |

## See also

- [[object-capability]] — the model that eliminates the Confused Deputy by making authority travel with designation (Properties A "No Designation Without Authority" and D "No Ambient Authority").
- [[principle-of-least-authority]] — the discipline whose violation (broad ambient grants) is what leaves a deputy confusable; POLA + capability designation is the fix.
- [[caretaker-pattern]] — the auditable-delegation extension of the revoker that restores the accountability the confused deputy launders away.
- [[habitat-unum]] — the sibling habitat-chronicles.com concept (Chip Morningstar's other essay ingested here).

## Common confusions

- **"The Confused Deputy is a bug in the deputy's code."** No — the deputy behaves exactly as written; the flaw is *architectural*, in the access-control model that hands it ambient authority it cannot associate with intended uses. Rewriting the compiler does not fix it; changing how authority is designated does.
- **"It only affects old timesharing systems."** No — CSRF, many injection attacks, XSS, and click-jacking are all confused-deputy problems; Morningstar counts 5–8 of the OWASP top 10.
- **"`setuid` solves it."** The Unix `setuid` mechanism (which makes `passwd` possible) is itself "a potent source of confused deputy problems," behind an astonishing number of Unix security exploits.
