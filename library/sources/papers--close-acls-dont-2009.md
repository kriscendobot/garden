---
source_kind: paper
source_authors: [Tyler Close]
source_title: "ACLs don't"
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto). References span Hardy 1988 through Close 2008 and Hansen-Grossman 2008 — paper is ~2009 vintage."
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_url: https://papers.agoric.com/assets/pdf/papers/acls-dont.pdf
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_pdf_pages: 12
ingested: 2026-05-29
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The Tyler Close ~2009 paper that **provides the access-matrix-terminology formalization of the Confused Deputy attack**. The paper's organizing thesis: in messaging scenarios involving *more than two principals*, the **ACL model fails to retain enough information to enable correct access decisions** — the *particulars of the operation may have been determined by a principal other than the request sender or the request receiver*, and that information is not available to the receipt-time reference monitor. The capability model performs access checks at *construction time* on the sender side, where the principal who chose each parameter is still known; access decisions are correspondingly correct.

The paper is the **first non-Miller paper in the library's capability-theory cluster**. It is also the **first paper in the library by Tyler Close** — author of the web-key paper [4] (cited but not separately ingested), the Horton capability protocol [13], and the Waterken-clickjacking [3] follow-on. The library can cite this paper whenever:

- **A design needs the canonical compilation-scenario Confused Deputy worked example.** Three principals (Vendor, User, Compiler); Vendor-provided Compiler that compiles User-supplied source while maintaining a usage log for the Vendor; User-as-attacker tricks Compiler into overwriting log.txt by passing it as the output filename. The simplest possible scenario that exhibits the Confused Deputy attack class.
- **A design needs the *three structural failures of ACLs* enumeration.** §2.4 *ACLs don't authorize correctly* (RBAC/ABAC/IBAC/setuid/stack-introspection all fail); §2.5 *ACLs don't authenticate reliably* (client authentication misleads access decisions); §2.6 *ACLs don't assign accountability correctly* (the deputy is held accountable instead of the principal-of-intent).
- **A design needs the §2.7 caveat — capability applications can recreate ACL vulnerabilities.** *The crucial step in a Confused Deputy attack occurs when an object identifier passes through an intermediate principal without being checked against the access matrix.* The fix: *capabilities-by-reference everywhere* — file descriptors not filenames, web-keys not URLs.
- **A design needs the CSRF / clickjacking / click-fraud-as-Confused-Deputy mapping.** Table 3 makes the element-for-element correspondence explicit. The unguessable-token CSRF defense *is structurally a capability-model retrofit*; the Same Origin Policy is the integrity boundary that makes the token unforgeable.
- **A design needs the §3.2.1 web-key + §5 migration-path argument.** *No changes to Web protocols, formats, user agents or server-side infrastructure are required to make this transition. The required changes are limited to the URL namespace defined by a Web application.* Capability adoption is application-local, not infrastructure-wide.
- **A design needs to invoke Norm Hardy 1988 *Confused Deputy* as primary citation.** Hardy's paper is reference [8]; this paper is the access-matrix-terminology elaboration. The two together form the canonical citation pair for *the* foundational ACL critique.

## The argument arc

1. **CSRF and clickjacking are categorically different from buffer overflow / SQL injection / XSS.** They use the victim's *existing program logic* with *attacker-supplied parameters*; no code injection occurs. Popular mitigations *do not involve fixing ACL configurations* — so why do ACLs play no part in fixing the problems?
2. **The 1971 Lampson access-matrix model.** ACL = column-stored; capability = row-stored. The Protection paper presented them as equivalent implementations. The presumption is wrong in multi-party scenarios.
3. **The compilation scenario: Vendor-User-Compiler.** Three principals, one mediating software agent (the Compiler), one usage-log file (log.txt).
4. **ACL checking** performs receipt-time access checks against the matrix column. The User-as-attacker tricks the Compiler into writing to log.txt; the Compiler's legitimate write permission on log.txt passes the check; the Vendor's log is overwritten.
5. **Capability transfer** performs construction-time access checks on the sender side. The User cannot construct a compile message specifying write-access to log.txt because the User does not possess that permission. The Confused Deputy attack is structurally prevented.
6. **ACLs don't authorize correctly.** RBAC, ABAC, IBAC, setuid, stack introspection all share the *delaying-the-access-check-until-a-late-stage* property and exhibit the Confused Deputy vulnerability. Stack introspection comes closest but cannot express *per-argument-per-principal* authorization (multi-argument case) and depends on the application programmer's manual principal-tracking.
7. **ACLs don't authenticate reliably.** Client authentication tells you *who relayed* a message, not *who intended* the operation. Using client authentication as the input to an access decision is misleading.
8. **ACLs don't assign accountability correctly.** The deputy is held accountable for actions instigated by another principal. Redress requires identifying the principal-of-intent. The Horton capability protocol [13] provides the systematic capability-chain accountability mechanism.
9. **The §2.7 caveat.** A capability application can re-introduce ACL vulnerabilities by re-implementing ACL design on top of capabilities (e.g. string-name-to-capability mappings at the API surface). The *crucial step* test: does an object identifier pass through a deputy without being checked? The fix: capabilities-by-reference everywhere.
10. **CSRF and clickjacking on the Web are Confused Deputy attacks.** Table 3 makes the mapping explicit. The unguessable-token CSRF defense is structurally a capability retrofit. The §3.2.1 web-key generalizes the pattern.
11. **Click fraud extends the diagnosis** to online advertising's client-authentication-misled access decisions.
12. **§5 conclusion: capability migration is deployable.** *No infrastructure change required* for the Web; URL-namespace migration is the only required change. Capability model can effectively control access in multi-party scenarios; ACL cannot.

## For the Endo / Agoric library

This paper is the **canonical citation for *why an Endo / Agoric / OCapN ecosystem must be capability-based, not ACL-based***. The library now has, for the Confused Deputy / ACL-critique thread:

- **Original publication**: Hardy 1988 *Confused Deputy* (in references, not separately ingested — it's a short SIGOPS note).
- **Theoretical elaboration**: Miller-Yee-Shapiro 2003 *Capability Myths Demolished* (cycle 64 ingest) refutes the Equivalence Myth at length.
- **Permission-vs-authority formalization**: Miller-Shapiro 2003 *Paradigm Regained* (cycle 70 ingest) introduces the *de jure permission* vs *de facto authority* distinction.
- **Access-matrix-terminology formalization**: this paper. The contribution is *precision in the access-matrix language*, which clarifies how ACL and capability produce *contradictory* access decisions (not benignly-differing ones).
- **POLA-as-discipline**: Miller-Tulloh-Shapiro 2004 *Structure of Authority* (cycle 71 ingest) makes the cp-vs-cat argument and the multiplicative-attack-surface case.

The Tyler Close paper is the *short, intro-paper-style* condensed proof. The Miller cluster provides the long-form, theoretical-system-style elaboration. The library now has the *complete arc from condensed-position-paper to formal-Hoare-logic* on the ACL-critique question:
- Short position paper: this paper (Close ~2009).
- Theoretical foundation: Miller-Yee-Shapiro 2003, Miller-Shapiro 2003, Miller-Tulloh-Shapiro 2004 (cycles 65-71).
- Formal Hoare-logic specification: Drossopoulou-Noble-Miller-Murray 2015 (cycle 85).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [compilation-scenario-and-the-confused-deputy-attack](../sections/papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack.md) | capability-security, capability-theory | current |
| [three-failures-of-acls-and-capability-application-caveat](../sections/papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat.md) | capability-security, capability-theory | current |
| [web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix](../sections/papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix.md) | capability-security, capability-theory | current |

The paper's five sections (§1 + §2 + §3 + §4 + §5) collapse to three argument-cluster sections. §1 introduction + §2.1-§2.3 (the compilation scenario through the Confused Deputy attack) → section 1; §2.4-§2.7 (the three failures + the capability-application caveat) → section 2; §3 contemporary Web examples + §4 related work + §5 conclusion → section 3.

## Provenance

- Fetched 2026-05-29 from `papers.agoric.com/assets/pdf/papers/acls-dont.pdf`.
- PDF SHA-256 `d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75`, 12 pages.
- The Agoric mirror's paper index lists this as one of the canonical capability-theory papers; the URL slug is `acls-dont`.
- Year is inferred from reference dates: [3] Close 2008, [4] Close 2008, [7] Hansen-Grossman 2008 are the latest references; paper is ~2009 vintage. The paper does not carry an explicit conference / journal venue, suggesting it is a position paper or unpublished workshop submission.
- Drafted by the liaison via orchestrator-direct-draft. **First non-Miller paper in the library's capability-theory cluster**; **first Tyler Close paper**.
