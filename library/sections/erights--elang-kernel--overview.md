---
title: "Kernel-E: the semantic core and its meta-circular interpreter"
source_kind: web
source_url: http://erights.org/elang/kernel/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/kernel/index.html
source_fetched_via: mirror
source_content_sha256: 2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, capability-security]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. Overview section of
  the Kernel-E reference: what Kernel-E is (the small subset E sugar expands to),
  why the chapter specifies its semantics as a meta-circular interpreter, and the
  eval/apply staging that lets enhanced interpreters add upgrade and debugging
  without losing the security of the base. The form catalogs and the interpreter
  skeleton are in the sibling sections.
---

## Abstract

**Kernel-E** is the small lambda-calculus-like subset of E that every surface-E
program is parsed into: surface E is sugar, and the canonical expansion of each
construct to Kernel-E *is* its only precise meaning, so the virtual machine only
ever executes Kernel-E parse nodes. This section captures the Kernel-E reference
chapter's framing: it specifies Kernel-E's semantics by exhibiting an
**executable meta-circular interpreter** (an interpreter for Kernel-E written in
full E), and it stages that interpreter deliberately. The base interpreter
**reifies `eval`** (what happens inside an object) while **absorbing `apply`**
(what happens between objects, the `callExpr` / `sendExpr` constructs) and
absorbing capability security; this lets interpreted subworlds inter-operate
transparently with non-interpreted contexts, and lets upgrade and debugging be
layered on as *enhanced* meta-interpreters whose security properties remain
analyzable against the unenhanced base. This is the same "small trusted core,
sugar by translation" discipline Hardened JavaScript reuses for the SES
intrinsics versus the surface language.

## Kernel-E is the bottom layer of a layered specification

> The E language is specified in layers. At the bottom is the Kernel-E language.
> The Kernel-E language is a subset of the regular E language — every program
> written in Kernel-E is also a valid E program with the same meaning. The
> remainder of E's grammar outside the kernel subset is E's sugar (see The E
> Language Grammar). The semantics of the sugar is defined by canonical expansion
> to Kernel-E.

The expansion happens during parsing: E parse trees only contain nodes defined
by Kernel-E, so only those are executed by the virtual machine. Defining the
semantics of Kernel-E therefore suffices to define the semantics of all of E.
(The chapter notes that an older PDF, *The Kernel-E Language Reference Manual*,
is deprecated but still carries material not yet migrated to these pages.)

## Semantics by meta-circular interpreter

To give a semantics of Kernel-E it suffices to write an executable specification
of the virtual machine as an interpreter of Kernel-E parse trees. Following "a
venerable tail-biting tradition," the chapter presents that interpreter written
in the full E language; an interpreter written in the same language it interprets
is a **meta-interpreter**. This introduces some circular-definition ambiguity (in
Brian Smith's terminology, the interpreter absorbs some issues by mapping them
onto the same issues in the language it is written in), which the chapter resolves
only informally in prose. The practical resolution is that the bootstrap E
interpreter is essentially a transliteration of this interpreter into Java, and
Java's definition does not depend on E, so the available bootstrap source
adequately resolves the circularity for engineering purposes.

Because the chapter is about semantics rather than surface syntax, its pseudo-BNF
for the kernel productions deliberately omits non-structural detail (precedence,
associativity); those live in the E Language Grammar chapter.

## Reifying eval, absorbing apply, staging the enhancements

Defining a model that handles security, upgrade, and debugging in one step is too
hard, so the chapter takes it in stages and presents only a meta-interpreter for a
**secure but non-upgradable, non-debuggable** E. In Brian Smith's terms this
meta-interpreter **reifies `eval` but absorbs `apply` and capability security**.
Borrowing Jonathan Rees's terminology: `eval` is the means by which an object
changes its state and decides what actions to take on the world outside itself
(what happens *inside* an object); `apply` is the means by which an object takes
such external actions (what happens *between* objects). In E the `apply`
functionality is provided by the `callExpr` and `sendExpr` constructs. By
absorbing `apply`, interpreted subworlds work transparently with non-interpreted
contexts. (This is also the basis for transparent Java/E inter-operation: ELib
implements E's inter-object semantics and is used both as the E runtime library
and directly as a library called from Java, so neither caller nor callee knows
whether the other is implemented in E or Java.)

Staging this way lets upgrade and debugging support be defined as **enhanced
meta-interpreters**. A real implementation can then offer the behavioral
equivalent of *allowing* (not requiring) code to run under such an enhanced
interpreter, which remains a faithful and secure implementation of the base
semantics (one could have run the enhanced interpreter on top of the base). The
enhanced interpreter gives clear answers to "who is allowed to do-or-see what?"
for secure debugging: the instantiator of an interpreted subworld holds the only
debugging capabilities to that world, and even the interpreter-starter can only
get a debugger's-eye view of an object if they also already hold that object.
This follows KeyKOS discipline, and the same debugging hooks also enhance
security by providing a discretion check enabling confinement.

## Source

Source: [elang/kernel/index.html](https://erights.github.io/erights-org-website/elang/kernel/index.html) (mirror of `http://erights.org/elang/kernel/index.html`), last modified 1998-10-03, content SHA-256 `2190baa1b4cb48aaee727a237b433fa4feaf23d43960be378c7a9ab537bf90a4`, fetched via the erights.org GitHub Pages mirror.
