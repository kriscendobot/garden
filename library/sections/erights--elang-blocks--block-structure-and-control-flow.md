---
title: "Block Structure: E has no statements, only expressions"
source_kind: web
source_url: http://erights.org/elang/blocks/index.html
source_effective_url: https://erights.github.io/erights-org-website/elang/blocks/index.html
source_fetched_via: mirror
source_content_sha256: b4c8701886d21120907698ead0b5fdced2559539c5616d7219c96d0f51f5c34d
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language]
status: current
notes: >
  Primary-source HTML via the erights.org GitHub Pages mirror. The Block & Scope
  chapter's landing page. Its substantive content is the "everything is an
  expression" framing plus the one-screen cheat sheet of E's sequential control
  structures and `def` forms; the per-construct chapters (Control Flow
  Expressions, the for Loops, the define Expressions, Inheritance by Delegation)
  are queued in scholar-ingest-erights-3.
---

## Abstract

The **Block Structure** chapter states one of E's defining design choices: like
the C-tradition languages (C, C++, Java, Perl, Python, Tcl, csh) E's statements
and expressions appear only inside function and object definitions — but unlike
them, **E has no statements at all, only expressions**. The control-flow
constructs that other languages make statements (`if`, `while`, `for`, `try`,
`switch`) are *expressions* in E, each yielding a value. This is the same
"expression-oriented" property Hardened JavaScript leans on conceptually (an
object's behavior is a value, definitions evaluate). This section captures the
framing and the page's one-screen cheat sheet of E's sequential control
structures and `def` forms; the per-construct chapters are queued.

## Everything is an expression

As in many C-tradition languages, E statements and expressions appear only
inside function and object definitions. **Actually, E has no statements — only
expressions.** The control-flow constructs (like the `if` expression) that one
might expect to be statements are instead expressions in E.

The chapter's reading path from here:

- **Control Flow Expressions** — the constructs most like traditional
  control-flow.
- **The for Loops** — E's main iteration construct.
- **The define Expressions** — how to define new variables, functions, normal
  objects, and message-plumbing objects.
- **Inheritance by Delegation** — the `class`/`extends` expression supporting a
  delegation pattern that mirrors conventional inheritance.

## Quick links to sequential E control structures

The chapter's cheat sheet of E's sequential control structures:

```e
if (cond) { then-expr } else { else-expr }
left && right
left || right
{ nested-expr }
escape hatch { body }
while (cond) { body }
try { attempt } catch ex { handler } finally { exit }
switch (specimen) { match pattern { body } ... }
```

The `for` loops:

```e
for value-patt in collection { body }
for key-patt => value-patt in collection { body }
```

## Defining (variables, functions, objects, delegation, plumbing)

```e
# variables
def pattern := expr

# functions
def name(patterns) guard { body }

# objects
def name { methods matchers }

# ... by delegation
def name extends expr { methods }

# message-plumbing objects
def name match pattern { body }
```

**Inheritance by delegation** is the single `def … extends …` form, e.g.:

```e
def self extends abstractFoo(self, ...) { ... }
```

A delegating object forwards messages it does not handle to the object named
after `extends`, giving a conventional-inheritance feel without a class
hierarchy — the lineage ancestor of the explicit-delegation discipline Endo's
exo/Far objects favor over prototype inheritance.

## Source

Source: [elang/blocks/index.html](https://erights.github.io/erights-org-website/elang/blocks/index.html) (mirror of `http://erights.org/elang/blocks/index.html`), last modified 1998-10-03, content SHA-256 `b4c8701886d21120907698ead0b5fdced2559539c5616d7219c96d0f51f5c34d`, fetched via the erights.org GitHub Pages mirror.
