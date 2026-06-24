---
title: Body
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
parent: papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack
---

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
