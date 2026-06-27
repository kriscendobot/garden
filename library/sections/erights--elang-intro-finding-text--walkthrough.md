---
title: "Example: Finding Text"
source_kind: web
source_url: https://erights.org/elang/intro/finding-text.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/finding-text.html
source_fetched_via: mirror
source_content_sha256: b8eaab98cea555b1951c69f05115b3430905c6fd8689ecd3eecca330346bee01
source_authors: [Mark S. Miller, Amy Mar]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory]
status: current
notes: Primary erights.org tutorial body chapter (the chapter the tutorial index only listed), reachable via the GitHub Pages mirror. The first hands-on E walkthrough; introduces the message-call-is-the-primitive framing that grounds the object-capability model. Companion to the index [erights--elang-intro--tutorial-overview](erights--elang-intro--tutorial-overview.md).
---

## Abstract

The first hands-on chapter of the E language tutorial: a guided build of a text-finding program (search lines of a file, then all `.txt` files in a directory tree) that introduces E's core conventional-language constructs — the `for`-loop over a collection, `def`-defined functions, parameters and function calls, the `if`-expression and compound `else if`, recursion, string concatenation, and quasi-literal interpolation. Its load-bearing capability-theory nugget is E's framing of **the message call as the primitive and the function call as a special case**: `line.includes(substring)` is a *message call* (object `line`, message name `includes`, argument list), whereas `print(x)` is a *function call*, "a message call in which no message name is provided." That objects-respond-to-messages framing — not classes, not field access — is the substrate on which E's object-capability model is built (the next chapter generalizes it to defining new message-responding objects). Use this when grounding any claim about E's basic syntax, its collection-as-mapping model (a file is a mapping from line number to line text, iterated with `for num => line in file`), or where E draws the function-call / message-call distinction.

## Walkthrough

The example finds occurrences of a text string in a file, using the stanzas of "Jabberwocky" as test data saved to `jabberwocky.txt`.

**The for-loop.** A file is iterated directly; E treats a text file as a collection mapping line numbers (from 1) to line strings:

```e
? for line in <file:c:/jabbertest/jabberwocky.txt> {
>     print(line)
> }
```

The `?` is elmer's top-level prompt; `>` is its continuation prompt while an expression is still incomplete.

**Functions.** Wrapping the loop in a `def` generalizes it over any file. The define-expression "begins at the word `def` and ends at the last curly brace"; executing it performs no action except creating the function and binding a variable to it:

```e
? def show(file) :void {
>     for line in file {
>         print(line)
>     }
> }
# value: <show>

? show(<file:c:/jabbertest/jabberwocky.txt>)
```

`file` is the function's **parameter** (a placeholder for data supplied at the call); the last line is a **function call** that supplies an argument.

**Conditions.** The `if`-expression runs code only when a condition tests true. Adding a `substring` parameter turns `show` into `find`:

```e
? def find(file, substring) :void {
>     for line in file {
>         if (line.includes(substring)) {
>             print(line)
>         }
>     }
> }

? find(<file:c:/jabbertest/jabberwocky.txt>, "and")
```

The comparison is case-sensitive, so the line containing `And` is not matched while `Bandersnatch` (containing `and`) is.

**Function calls and message calls.** This is the chapter's conceptual center. `line.includes(substring)` is a **message call**: the object held by `line` (a string) is asked to do something, named by the **message name** `includes`, with an argument list. `print(...)` is a **function call** — "actually just a message call in which no message name is provided." A function "is simply an object that can be called with function-call notation." The next chapter extends this to defining new objects that respond to message calls, not just function calls.

**Mappings: the `=>` operator.** Collections in E are mappings from keys to values; a file maps line numbers to lines. `for num => line in file` binds both the key (line number) and value (line). Read `k => v` as "k maps to v":

```e
? def find(file, substring) :void {
>     for num => line in file {
>         if (line.includes(substring)) {
>             print(`$num:$line`)
>         }
>     }
> }
```

The backtick form ``` `$num:$line` ``` is a quasi-literal (string interpolation). Earlier the chapter builds the same output by string concatenation (`"" + num + ":" + line`), explaining the leading empty string: `num` is numeric, so the empty *string* on the left drives string concatenation rather than numeric addition.

**Calling Java methods.** E runs on the JVM and "makes all Java objects available in E as if they had been written in E"; E's strings *are* `java.lang.String` instances, so `line.indexOf(substring) != -1` works as an alternative to `includes`. Directory entries are `java.io.File` instances exposing `getName()`, `endsWith()`, `isDirectory()`.

**Recursion.** Generalizing from one file to a directory tree, `findall` calls itself, terminating at non-directories:

```e
? def findall(dirfile, substring) :void {
>     if (dirfile.isDirectory()) {
>         for file in dirfile {
>             findall(file, substring)
>         }
>     } else if (dirfile.getName().endsWith(".txt")) {
>         find(dirfile, substring)
>     }
> }
```

The chapter notes a portability caveat: a Windows directory tree is necessarily finite, but Unix symbolic links can create cycles ("effectively infinite directory trees"), deferring cycle-safe traversal to a later chapter.

## See also

- [erights--elang-intro--tutorial-overview](erights--elang-intro--tutorial-overview.md): the tutorial index this chapter hangs from.
- [erights--elang-intro-standalone--walkthrough](erights--elang-intro-standalone--walkthrough.md): the next chapter, packaging this `findall` as a runnable standalone program.
- [object-capability](../concepts/object-capability.md): the security model E builds on the message-call-as-primitive framing introduced here.
- [ocap-history--e-capdesk-polaris-market-history](ocap-history--e-capdesk-polaris-market-history.md): the library's E / CapDesk / Polaris survey this primary source grounds.

Source: [elang/intro/finding-text.html](https://erights.org/elang/intro/finding-text.html), fetched 2026-06-27 via the erights.org GitHub Pages mirror ([erights.github.io/erights-org-website/elang/intro/finding-text.html](https://erights.github.io/erights-org-website/elang/intro/finding-text.html)), content SHA-256 `b8eaab98cea5`.
