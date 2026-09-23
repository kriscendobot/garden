---
title: Body
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "1-7 (§1 Introduction, §2 Terminology and Distinctions, §3 How Much Authority Does cp Need?)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat
---

### §1 The access-control paradigm — why "bugs" miss the point

The paper's opening diagnosis: viruses regularly roam our networks; a single exploited bug compromises a whole system; bugs grow with code size so vulnerability *increases* over the life of a given software system. Virus checkers and firewalls are *perpetual stopgaps* providing the defender no fundamental advantage over the attacker. The architectural cause: programs execute with excessive authority.

Solitaire's least authority is render-into-window + receive-UI + save-score-file. The least authority Solitaire *receives* is the *full user authority*. Under POLA (Principle of Least Authority — "closely related to" Saltzer-Schroeder's Least Privilege [Saltzer75]), Solitaire would be limited to its least authority. Today it isn't, so Solitaire can scan email and sell it on eBay while playing within the rules of your system. The flaw is not in Solitaire and not in the OS: *each OS is functioning as specified, and each specification is a valid embodiment of its access-control paradigm*. The flaws lie in the **access-control paradigm**.

The paper defines paradigm: "an access control model *plus a way of thinking* — a sense of what the model means, or could mean, to its practitioners, and of how its elements should be used." The model alone isn't the problem; the *way of thinking* it invites is.

The §1 thesis: over the last 30 years, the formal security literature has reasoned about bounds on authority "exclusively from the evolution of state in protection graphs — the arrangement of permissions. This implicitly assumes all programs are hostile." Conservatively safe, but it *omits consideration of security-enforcing programs* — security policy emerges from the interaction between the behavior of programs and the underlying protection primitives. Omission has produced *false negatives* — mistaken infeasibility results "diverting attention from the possibility that an effective access control model has existed for 37 years": Dennis and van Horn's 1966 capability model.

### §2 Terminology — permission vs authority

The §2 distinction is the structural anchor.

**Direct access right.** Alice has a *direct access right* to `/etc/passwd` if the protection state gives her *permission to invoke the behavior* of that object. The thin black arrows in the paper's access diagrams depict *permissions*.

**Indirect access right.** Bob has *no permission* to read `/etc/passwd`. But if Alice can read it and Alice can talk to Bob, and Alice is willing to proxy by sending him copies — then Bob can *indirectly* read `/etc/passwd`. Bob's *authority* includes the read. His *permission* does not.

The paper makes the resulting analysis classes explicit:

- **Permission analysis** asks: given the current arrangement of access rights, what can each subject *directly* do? Bishop-Snyder's *de jure* analysis. Reasoning is over the protection-graph state and the *update rules* governing how that state can evolve.
- **Authority analysis** asks: given the arrangement *and* the state and behavior of subjects on the permitted causal pathways, what effects can a subject ultimately cause? Bishop-Snyder's *de facto* analysis, refined.

Each analysis class admits two flavors:

- **Arrangement-only bound on permission** — reason only from the current arrangement and its update rules. Corresponds to Bishop-Snyder's *de jure* analysis. Decidable in at least three known protection systems [Jones76, Shapiro00, Motwani00]. The paper footnote notes that Harrison-Ruzzo-Ullman 1976 is *often misunderstood* to say this calculation is "never decidable" — HRU actually says it is possible to *design* a set of update rules that are undecidable, which is a much weaker claim.
- **Partially behavioral bound on permission** — take the state and behavior of *some* subjects and objects into account. Tighter bounds; harder reasoning.
- **Arrangement-only bound on authority** — reason about potential causal pathways from the arrangement alone. Bishop-Snyder's *de facto*. Conservative.
- **Partially behavioral bound on authority** — take *some* subjects' behavior into account when reasoning about causal paths. The strongest bound but requires reasoning about specific code.

The §2 closing observation that anchors the paper's program: "Permission is relative to a frame of reference. Authority is invariant." Frame of reference = the boundary between a *base* system (the rules creator) and the *subjects* hosted on that base, who play only by those rules. A subject one frame is itself a base in the next frame in. Subjects *extend the expressiveness* of a base by building abstractions whose behavior further limits the authority they provide to others.

### §3 The cp-versus-cat lesson — first articulation

The cp-vs-cat comparison was reprised in *Structure of Authority* (Miller-Tulloh-Shapiro 2004) and is now widely cited. This paper is the **first published form**. Both renditions make the same point — that designation method determines least authority — but Paradigm Regained's framing emphasizes the *paradigm* (the OS supports both styles but explains only one *as* access control); *Structure of Authority* later emphasizes the *practice* (POLA as the discipline of taking the strict reading).

**cp:** `cp foo.txt bar.txt` — the shell passes the two strings `"foo.txt"` and `"bar.txt"` to cp. By these strings, the user means particular files in *the user's namespace*. For cp to open the files, cp must already have authority *to use the user's namespace* and *to read and write any file the user might name*. Given this way of using names, cp's least authority *still includes all of the user's authority to the file system*. As long as we normally install and run applications in this manner, *both security and reliability are hopeless*.

**cat:** `cat < foo.txt > bar.txt` — the *shell* uses `"foo.txt"` and `"bar.txt"` to determine which files the user means to designate. The names are evaluated in the *caller's namespace prior to the call*. The callee (cat) gets direct access to the first-class anonymous objects passed in, and designates them with parameter "names" bound in *its own private namespace* (file descriptor numbers). The file descriptors are granted *only to this individual process*, so only this process can use them to access these files. The two file descriptors are all the authority cat needs.

The §3 closing observation is the architectural punchline: "Today's widely deployed systems use both styles of access control. They grant permission to open a file on a per-account basis, creating the pools of authority on which viruses grow. These same systems flexibly grant access to a file descriptor on a per-process basis. **Ironically, only their support of the first style is explained *as* their access control system.**"

Object-capability systems differ from current systems *more by the elimination of the first style than by the elaboration of the second*. If support for the first style were eliminated and cat ran with access *only* to the file descriptors passed in, cat could still do its job — and "we could more easily reason about our vulnerabilities to its malice or bugs. In our experience of object-capability programming, these radical reductions of authority and vulnerability mostly happen *naturally*."
