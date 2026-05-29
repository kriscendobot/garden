---
title: The 1971 access-matrix model recast for multi-party messaging; ACL-checking vs capability-transfer in the compilation scenario; the Confused Deputy attack that exploits ACL's loss-of-context across message sends
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto; references span Hardy 1988 to Close 2008 + Hansen-Grossman 2008 — published ~2009)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "1-3 (§1 Introduction + §2 Access Matrix through §2.3 Confused Deputy attack)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
---

## Abstract

The §1 paper opens by naming a new attack class — CSRF and clickjacking — that does not fit the familiar buffer-overflow / SQL-injection / XSS mold: *neither attack requires injecting code chosen by the attacker into the victim program*. Both attacks use the victim's existing program logic *to unexpected ends* by sending messages that follow the syntactic conventions expected for legitimate requests; the attacker thereby makes use of resources that *should* be inaccessible according to the application's access policy. Despite victims correctly implementing traditional access control lists (ACLs), the attacker still gains access — *without modifying any of the application's program logic*. Stranger still, the popular counter-measures *do not involve fixing incorrect ACL configurations, nor adding ACLs to unprotected parts of the application*. So *ACLs seem to play no part in fixing the problems*. The §1 question: *why do ACLs seem to be so ineffective at fulfilling their basic purpose of controlling access?* The §2 paper answers by recasting the 1971 Lampson **access matrix** ([9] in references) — a table whose rows label *principals* and whose columns label *protected objects*, with each cell carrying the operations that principal may perform on that object — as the underlying *abstract* model that both ACLs and capabilities are *implementations* of. The §2 paper then runs a single concrete scenario — three principals (Vendor, User, Compiler), a Vendor-provided Compiler that compiles User-provided source code while maintaining a usage log for the Vendor — through *both* implementations side-by-side. **§2.1 ACL checking**: the Compiler executes `Filesystem.write("a.out", "compiled code")`; the reference monitor checks column `A_a` of the access matrix for the *sender's* (Compiler's) `write` permission. The check passes because the Compiler indeed has write access to a.out. **§2.2 Capability transfer**: capabilities flow with the message. The User constructs the compile message by *copying* the appropriate permissions from row `A_U`; the Compiler then *wields* the User-provided write permission directly when calling Filesystem. Same scenario, same end-state. **§2.3 The Confused Deputy attack** is what cleaves the two implementations apart. The User sends `Compiler.compile("main.c", "log.txt")` — selecting the *Vendor's* log file as the output. The Compiler dutifully writes the compiled output to `log.txt`, *overwriting the Vendor's usage log with attacker-controlled compiled code*. Under ACL checking, the reference monitor checks `A_C,l,write` (the Compiler's write permission on log.txt) — *which the Compiler legitimately holds for its logging duties* — and the check passes. Under capability transfer, the User would have had to *forge or steal* a write capability on log.txt to construct the malicious message; the User does not hold that capability, so the message cannot be constructed. The Compiler is the *Confused Deputy*: it has been *deputized* by the Vendor (and operates on the Vendor's behalf) but also operates on behalf of the User; the implicit expectation is that the User-contributed message uses *User-contributed* permissions, but the ACL reference monitor cannot distinguish *whose* contribution authorizes the action — it only knows *who is sending*.

## Body

### §1 The new attack class — *no injected code, yet authorization fails*

The §1 paper opens by contrasting CSRF and clickjacking with familiar attack classes:

> In the last few years, increasing attention has been devoted to attacks which are distinctly different in nature from the major vulnerabilities discussed in the past. Previously, buffer overflow, SQL injection and Cross-Site Scripting (XSS) garnered the most attention. These attacks all share a common modus operandi in that they inject code into a victim program and thus make it behave according to the attacker's wishes.

The buffer-overflow / SQL-injection / XSS family shares a property: *the attacker chooses code that runs inside the victim's protection domain*. The defense is *don't let the attacker inject code* (bounds checks, parameterized queries, output encoding).

CSRF and clickjacking are *categorically different*:

> Neither attack requires injecting code chosen by the attacker into the victim program. Instead, both attacks use the victim's existing program logic to unexpected ends. Using messages that follow the syntactic conventions expected for legitimate requests, the attacker makes use of resources that should be inaccessible according to the application's access policy.

In a CSRF attack, the attacker *cannot run code* in the victim's stock-trading application — but the attacker can *send a buy-message* that the application's reference monitor approves because the message arrives over an authenticated session.

In a clickjacking attack, the attacker *cannot run code* on the user's webcam — but the attacker can position invisible UI elements so the user *accidentally clicks the start-recording button*; the application's reference monitor approves because the click arrives from the legitimate user's mouse.

The strangeness: *the popular counter-measures do not involve fixing incorrect ACL configurations, nor adding ACLs to unprotected parts of the application*. The CSRF mitigation is *unguessable tokens in HTML FORM*; the clickjacking mitigation is *frame-busting / x-frame-options*. Neither is an ACL fix. The §1 question — *why do ACLs seem to be so ineffective at fulfilling their basic purpose of controlling access?* — is the paper's organizing thesis.

### §2 Access matrix as the common abstraction

The §2 paper grounds the argument in Lampson's 1971 *Protection* paper [9], which introduced the **access matrix** model:

> The 1971 paper "Protection", introduced the access matrix as a way to model the permissions in a software system and how they may be shared and exercised. An access matrix is a table where each row is labeled with the identifier for a principal, who may send messages, and each column is labeled with the identifier for a protected object, which may be a subject of messages. A principal is considered to be a kind of protected object and so may appear as both a row and column. Each cell in an access matrix contains entries identifying the operations the corresponding principal is permitted to perform on the corresponding object. ... Entry `A_{R,c,p}` refers to the permission `p` in row `R`, column `c` of access matrix `A`.

The §2 framing's load-bearing observation: ACL and capability are *two implementation techniques for storing and querying the access matrix*. The Protection paper presented them as *equivalent given equal performance trade-offs*. The §2 paper aims to overturn this presumption — *ACLs and capabilities make different access decisions in multi-party scenarios*.

The worked scenario: three principals, the **compilation example**:

- **Vendor** (V) — provides the Compiler.
- **User** (U) — submits source code for compilation.
- **Compiler** (C) — a software agent that compiles User-supplied source code while maintaining a usage log for the Vendor.

Files involved: `main.c` (m, User's input source code), `a.out` (a, User's output object code), `log.txt` (l, Vendor's usage log).

Table 1 — initial access matrix (two principals):
| | main.c (m) | a.out (a) | log.txt (l) |
|---|---|---|---|
| Vendor (V) | | | read, write |
| User (U) | read, write | read, write | |

Once the User executes the Compiler, a new row and column are added for the running Compiler instance (Table 2):
| | Compiler (c) | main.c (m) | a.out (a) | log.txt (l) |
|---|---|---|---|---|
| Vendor (V) | | | | read, write |
| User (U) | call | read, write | read, write | |
| Compiler (C) | | read | write | write |

The Vendor pre-configured the Compiler with `read` on main.c, `write` on a.out, and `write` on log.txt (so the Compiler can read the User's input, write the output, and append to the Vendor's log).

### §2.1 ACL checking — column-keyed access checks

The §2.1 paper walks the User-issued compile message:

```
User: Compiler.compile("main.c", "a.out")
```

The ACL reference monitor checks `column A_c` of the access matrix to verify the *sender* (User) has `call` permission on the Compiler. Entry `A_{U,c,call}` exists, so the check passes.

The Compiler then sends `Filesystem.read("main.c")`. The reference monitor checks `column A_m` for `A_{C,m,read}` — which exists — and passes the read.

The Compiler then sends `Filesystem.append("log.txt", "log entry")`. The reference monitor checks `column A_l` for `A_{C,l,write}` — which exists — and passes the append.

Finally `Filesystem.write("a.out", "compiled code")`. The reference monitor checks `column A_a` for `A_{C,a,write}` — which exists — and passes the write.

The structural pattern: **the ACL reference monitor checks the *sender's* permission against the *column* of the target object**.

### §2.2 Capability transfer — row-keyed permission packaging

The §2.2 paper walks the same scenario under capabilities:

> In the capability model, a message consists of a list of permissions and an arbitrary amount of data. Each permission in the list is selected by the message sender, choosing from its held permissions. The selected permissions are added to the message by the system and therefore cannot be forged. A message recipient can in turn send messages using any of the permissions provided by the message, or already held by the recipient.

The User constructs the compile message by *copying* permissions from row `A_U`:

```
User: A_{U,c,call}.compile(A_{U,m,read}, A_{U,a,write})
```

The User explicitly passes the *read main.c* permission and the *write a.out* permission to the Compiler.

The Compiler then wields the User-supplied permissions:

```
Compiler: A_{U,m,read}.read()
Compiler: A_{V,l,write}.append("log entry")    // for the log: Compiler's own
Compiler: A_{U,a,write}.write("compiled code")  // for the output: User-supplied
```

The Compiler distinguishes between the *Vendor-contributed* log permission (for the log append, which is Vendor work) and the *User-contributed* output permission (for the compiled-code write, which is User work).

The structural pattern: **capabilities flow along the message chain; each message carries a list of permissions the sender chose from the row of permissions it holds; the receiver wields those permissions directly**.

### §2.3 The Confused Deputy attack — ACL fails, capability prevents

The §2.3 paper turns the worked example into an attack scenario. The attacker is the User; the goal is to overwrite the Vendor's `log.txt` with attacker-controlled compiled code.

The User sends the malicious compile message:

```
User: Compiler.compile("main.c", "log.txt")
```

The User has substituted `log.txt` for `a.out` in the output-filename argument. The Compiler dutifully proceeds:

```
Compiler: Filesystem.write("log.txt", "compiled code")
```

**Under ACL checking**: the reference monitor performs a look-up against column `A_l` of the access matrix; entry `A_{C,l,write}` exists (because the Compiler legitimately needs to *append* to its log); the check passes. The Vendor's usage log is overwritten with attacker-controlled compiled code.

**Under capability transfer**: the User's attempt to construct a compile message specifying *write permission to log.txt* fails at the reference monitor's construction step. The look-up against row `A_U` of the access matrix shows that the User does not possess this permission — the User cannot *transfer* a permission it does not hold.

The §2.3 paper names the attack pattern: *the Compiler is termed a **Confused Deputy***:

> The Compiler has been deputized by the Vendor to operate on his behalf, but also operates on behalf of the User. Though it has the responsibility of mediating between distinct parties, the Compiler does not have a mechanism for keeping separate the authority received from these different sources. The implicit expectation is that the write message will use the permission received from the User will be exercised, but the Compiler has no way to express this expectation and so permission received from the Vendor is exercised instead. The Vendor contributed write permission is confused for one contributed by the User; hence, the Confused Deputy.

The Confused Deputy attack class was originally described by Norm Hardy in his 1988 *SIGOPS Operating Systems Review* note [8] (footnote 3 in this paper records that the term *Confused Deputy* is *a little unfortunate since it implies some lack of competence on the part of the deputy software agent* — the actual problem is *a condition created by the ACL model which the deputy may be unable to rectify*).

### The crucial difference: *when is the access check performed?*

The §2.3 contrast is structural, not just operational:

- **ACL checking** performs the access check *at the message-receipt boundary* on the reference monitor side. The check sees only *who sent the message* (the Compiler) and *what object is being acted on* (log.txt); it does not see *who supplied the object identifier* (the User).
- **Capability transfer** performs the access check *at message-construction time*, on the sender's side. The check sees that the User does not hold the relevant permission and so cannot construct a message exercising it.

The §2.3 paper draws the conclusion explicitly:

> Although both models can be construed as algorithms operating on an access matrix object, they use different parts of the matrix at different times and grow the matrix in different ways, resulting in different access decisions for identical scenarios. Therefore, the view presented in the Protection paper that ACLs and capabilities are merely different implementation choices for a single access model embodied by the access matrix is incorrect. Moreover, for a given access policy, access decisions are not results that can benignly differ: one is right, the other wrong.

The 1971 Protection paper's *equivalence presumption* is overturned. ACL and capability are not equivalent implementations of the same model; they implement *different* access decisions in multi-party scenarios, and only one of them is correct.

## Connection to the wider library

This section is the **canonical worked example of the Confused Deputy attack and the ACL-vs-capability access-decision divergence** at the introductory-paper level. Three threads:

1. **The compilation scenario is reusable** as a teaching example for any capability-security audience. Three principals, one mediating software agent, one usage-log file — the minimal setup that makes the difference visible. The library can cite this section whenever a design needs the canonical Confused Deputy walk-through.

2. **The access-matrix-as-shared-abstraction framing** is the bridge between the 1971 Protection paper's vocabulary and contemporary capability-system literature. Anyone reading Lampson 1971 + Miller-Yee-Shapiro 2003 should pair them with this paper, which makes the access-matrix-as-shared-abstraction-but-not-shared-decision-procedure observation explicit.

3. **The construction-time-vs-receipt-time check distinction** is the structural insight. Capability systems perform access checks *when the message is constructed*; ACL systems perform access checks *when the message is received*. The receipt-time check loses the *which principal supplied the identifier* context — which is precisely what the Confused Deputy attack exploits.

## Translation block (paper idiom → contemporary surface)

| 2009 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| Access matrix (1971 Protection) | The conceptual model both ACL and capability systems implement; ACL = column-stored, capability = row-stored. |
| Capability transfer | The contemporary `@endo/marshal` + `captp` discipline: capabilities flow on the wire with their permission attached; the receiver wields them directly. |
| ACL checking (column look-up) | Web cookies; HTTP basic auth; Unix file permissions; the standard *check-the-sender's-permission-on-the-object* discipline. |
| Confused Deputy | The defining attack class for ACL systems; called out in Miller-Tulloh-Shapiro 2004 *Structure of Authority* and Miller-Shapiro 2003 *Paradigm Regained* as the motivating example for *only connectivity begets connectivity*. |
| Vendor + User + Compiler scenario | Reusable teaching example; structurally identical to any web-application + browser + browser-extension trio, or any IDE + user + plugin trio. |

## See also

- [[object-capability]] — the §2.2 capability transfer is the implementation; this paper is the canonical introduction.
- [[four-ways-to-acquire-references]] — the User-Compiler-Filesystem capability flow is a worked example of *introduction* and *parenthood* and *endowment*.
- [[principle-of-least-authority]] — the Compiler exercising User-contributed authority for output and Vendor-contributed authority for logging is the canonical worked POLA example.
- [[smart-contract]] — the Compiler-as-mediator is a smart-contract avant-la-lettre; the worked scenario is the structural ancestor of the Vendor-User-Mediator pattern in Agoric Zoe contracts.
- `papers--miller-capability-myths-demolished-2003--{access-models-introduction, confined-subjects-and-the-confinement-myth, irrevocability-myth-and-the-caretaker-pattern}` — Miller-Yee-Shapiro 2003 makes the same point at greater length and with the Equivalence Myth as its central target; this section is the Tyler-Close-style condensed proof.
- `papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat` — Miller-Shapiro 2003's *permission vs authority* distinction is the formal language for what this section informally calls *ACL gets the wrong access decision*.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation` — Miller-Tulloh-Shapiro 2004 names the cp-vs-cat designation argument; the Compiler is a *deputy* that under cp would never have been confused.

## Common confusions

- **"The Compiler is the attacker."** No — the Compiler is the *victim's* deputy, mediating between Vendor (its principal) and User (its caller). The User is the attacker. The Compiler is *exploited* by the User's malicious choice of output filename.
- **"`log.txt` is the attacker's file."** No — `log.txt` is the *Vendor's* usage log, written-to by the Compiler in the normal course of operation. The User does not have direct write access to it. The attack is *trick the Compiler into writing to it on the User's behalf*.
- **"This is the same as a buffer overflow."** Categorically not. Buffer overflow injects attacker code; the Confused Deputy attack uses the *victim's* legitimate code with attacker-supplied *data* (the output filename). No code injection occurs.
- **"ACL configurations could fix this if you added log.txt-write-protection to the Compiler."** No — the Compiler needs `log.txt` write access to *do its job* (append usage log entries). Removing that permission would break the legitimate Vendor-side functionality. The ACL model cannot express *Compiler may write log.txt for Vendor reasons but not for User reasons*.
- **"The 1971 Protection paper proved ACLs and capabilities are equivalent."** It presented them as two implementation choices for the access matrix model, but did *not* prove access-decision equivalence in multi-party scenarios — the §2.3 paper points out this gap. The presumption of equivalence stuck despite its narrow basis; this section is the explicit refutation.
- **"This applies only to OS-level access control."** No — the worked example is OS-flavored (Compiler, Filesystem, log.txt), but the §3 paper extends it to web applications (CSRF, clickjacking). The structural lesson is *model-agnostic*: any system where a mediating agent acts on multiple principals' behalf is susceptible to the same attack class under ACL.
