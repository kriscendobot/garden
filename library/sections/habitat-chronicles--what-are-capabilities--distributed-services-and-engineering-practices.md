---
title: What can we do — distributed services and software engineering practices
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
ingested: 2026-07-11
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

## Abstract

The last two of Morningstar's four incremental adoption paths. **Distributed services**
centers on the **service-chaining problem**, "for which the ACL approach has no
satisfactory solution at all": the web is services using services using services, and
when one service invokes another, *whose credentials* should be used? The upstream
service's own credentials invite a Confused Deputy; the user's credentials empower the
upstream to *impersonate the user however it likes*. The running example is **Mint**,
to which users hand the login/passwords for every financial account — "unlimited access
[with a promise] not to abuse it." The capability alternative: obtain a separate,
narrowly-scoped, **revocable** credential (a capability!) from each institution to pass
along; Alan Karp's **"Zebra Copy"** paper worked out the mechanics, realizable today
with SAML, **OAuth2 bearer tokens**, or even special URLs. The blocker is coordination
and standardization (the installed-base problem), but it "looks ... like a competitive
opportunity for ambitious upstarts." Morningstar notes the real-world fallback is
*contractual obligations*, i.e. "built in accountability laundering," and dismisses
RBAC/ABAC/PBAC as "just variations of the same one broken thing: ambient authority."
**Software engineering practices** reports Electric Communities' discovery that code
written with ocap tools "had greater odds of being correct on the first try" — because
"measures that prevent deliberate misbehavior tend to be good at preventing accidental
misbehavior also," and a bug *is* accidental misbehavior. The distilled, language-
agnostic discipline is **three rules for taming Java**: (1) all instance variables
private, (2) no mutable static state or statically-accessible authority, (3) no mutable
state across thread boundaries — which yield reference unforgeability and encapsulation,
quarantining unavoidable Rule-#2 violations into startup factory classes. It points to
**Joe-E**, Monte, and Pony, and observes recent JavaScript features were "put there
expressly to enable this kind of thing."

## Content

**Distributed services.** Of the many distributed-systems problems capabilities help,
Morningstar picks "one of the most important: the **service chaining problem**, for which
the ACL approach has no satisfactory solution at all." The web is "a vast ecosystem of
services using services using services" — booking a business trip goes through the
corporate intranet to a travel agency's site, which invokes airline/hotel/car services,
which invoke still others to email an itinerary or text a delay. The question: **if you
invoke one service that uses another, whose credentials access the second?** If the
upstream service uses *its own* credentials, it "might be fooled ... into doing something
on your behalf that it is allowed to do but which the downstream service wouldn't let you
do" — a classic Confused Deputy. If it needs *your* credentials, "you've empowered it to
impersonate you however it likes." The same recurs at each hop.

The running example is **Mint** (personal-finance aggregation): to organize your
finances it needs your bank/brokerage/credit-card data, so "you give them the login names
and passwords for all your accounts" — nominally read-only, actually **unlimited access**
under a promise not to abuse it. "To someone steeped in capability concepts, the idea
that you would willingly give strangers on the web unlimited access to all your financial
accounts seems like madness." Morningstar stresses he is not beating up on Mint — given
"the legacy security architecture of the web, they have no practical alternative." **The
capability alternative** (not currently available to users): obtain "a separate credential
— a capability! — from each of your financial institutions that you could pass along," each
granting only the relevant read access, each **revocable** (withdraw one after a breach at
the aggregator without disrupting your own access), each **distinct per data-manager** (so
a Mint competitor gets its own). "There are no particular technical obstacles to doing any
of this." **Alan Karp's "Zebra Copy: A reference implementation of federated access
management"** worked out much of the mechanics (with SAML certificates); "you can do this
just as well with **OAuth2 bearer tokens**, or even just special URLs." The obstacle is
that providers and consumers "would all have to agree ... and then standardize ... and
then actually change their systems, whereas the status quo doesn't require any such
coordination" — the installed-base problem — but constant enterprise service deployment
"looks to me like a competitive opportunity for ambitious upstarts."

Today "the main defense against bad things ... is not the access control mechanisms at
all, it's the **contractual obligations** between the various parties" — adequate for big
companies dealing with big companies, but "not a sound basis for a robust service
ecosystem," and when something goes wrong "confused deputy problems are rooted in losing
track of who was trying to do what. In essence we have engineered everything with **built
in accountability laundering**." ACL proponents patch identity-based access controls with
"role-based ... or attribute-based ... or policy-based access control," but "none of these
schemes actually solves the problem, because they're all at heart just variations of the
same one broken thing: **ambient authority**."

**Software engineering practices.** At **Electric Communities**, the team set out to build
"a fully decentralized, fully user extensible virtual world" — different people running
different parts of the world, users adding not just new objects but new *kinds* of
objects. The touchstone problem: a fantasy RPG adjacent to an online stock exchange — "you
don't want someone taking their dwarf axe into the stock exchange and whacking peoples'
heads off, nor ... a stock trader ... have their portfolio stolen by brigands." If the
dwarf axe is a user-programmed object, "how does it acquire the ability to whack people's
heads off in one place but not have that ability in another?" Ocaps "became our power tool
of choice," and produced "lots of interesting and innovative technology" — "the **E
programming language** is one notable example that actually made it to the outside world."
The infrastructure was "ridiculously ambitious," development expensive, and the market did
not crave extensible virtual worlds, so the company pivoted.

The **unexpected discovery** on pivoting: carrying the ocap tools and "paranoid
techniques" to other businesses, "code produced with these tools and techniques had
greater odds of being correct on the first try compared to historical experience." More
time went to design and coding, less to debugging; products were more robust. "The key
insight is that measures that prevent deliberate misbehavior tend to be good at preventing
accidental misbehavior also. Since a bug is, almost by definition, a form of accidental
misbehavior, the result was fewer bugs."

Shorn of exotic technology, the principles are simple. For **Java** — chosen because it
"can be tamed — some languages cannot" — it reduces to **three rules**:

- **Rule #1: All instance variables must be private.**
- **Rule #2: No mutable static state or statically accessible authority.** (All static
  variables `final` and transitively immutable; constructors and static methods must not
  provide access to mutable state or side-effects on the outside world, unless obtained via
  objects passed in as parameters.)
- **Rule #3: No mutable state accessible across thread boundaries.**

These "simply ensure the qualities of reference unforgeability and encapsulation."
Avoiding static state and static authority matters because "Java class names constitute a
form of forgeable reference" — anyone can `new java.io.FileInputStream(...)` and open a
file given a string, limited only by the OS ACL "we are trying to avoid relying on" —
whereas a specific `java.io.InputStream` instance "is essentially a read capability."
Applying the rules changes code "in profound ways": the standard libraries violate them
(I/O authority via constructors and static methods), so "you **quarantine** all the
unavoidable violations of Rule #2 into carefully considered **factory classes** that you
use during your program's startup phase." It feels awkward at first, "rather like using a
strongly typed programming language for the first time," but "the discipline forces you to
think through things like your I/O architecture." For rigor and tool-enforcement,
Morningstar recommends **Adrian Mettler's Joe-E** (a pure ocap subset of Java with an
Eclipse plugin); dealing with the standard libraries is "a bit of an open issue" —
**taming** (pruning the dangerous stuff) yields safety but poor ergonomics, and good
capability-oriented wrappers "would probably be a valuable contribution." Similar rule sets
exist for Scala and OCaml, should be straightforward for C#, "probably hopeless for PHP or
Fortran," an open question for C++, and "definitely possible for **JavaScript**, as a
number of features in recent versions of the language standard were put there expressly to
enable this kind of thing." He also points to **Monte** (Python-derived) and **Pony**.
"There's a fairly soft boundary here between practices that simply improve the robustness
and reliability of your code if you follow them, and things that actively block various
species of bad outcomes."

*(Library note: the "taming" and three-rules discipline here is the direct ancestor of
Endo's SES **taming** of JavaScript intrinsics and the ocap-JS rules the
`hardened-javascript` and `capability-security` topics document; the service-chaining /
OAuth2-bearer-token discussion is germane to the garden's own gateway / delegated-access
lineage.)*

Source: [What Are Capabilities?](https://habitat-chronicles.com/2017/05/what-are-capabilities/) by Chip Morningstar, 2017-05-07 (content sha256 `e16d5cf3`).
