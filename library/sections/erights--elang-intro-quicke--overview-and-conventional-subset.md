---
title: "A 15 Minute Introduction to E: the conventional object-oriented subset"
source_kind: web
source_url: https://erights.org/elang/intro/quickE.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/quickE.html
source_fetched_via: mirror
source_content_sha256: 0a9cec3ff648ad327f7320b47ede7b8be1820c950e0b338f6a19f6ce874a6a55
source_authors: [Marc Stiegler]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [getting-started, eventual-send]
status: current
notes: |
  Section 1 of 4 from Marc Stiegler's "15 Minute Introduction to E". Covers only the
  conventional Java-like subset the document treats as background before leaping to E's
  unique features. Companion sections: eventual-send-and-location-transparency,
  promises-when-catch-and-far-references, bootstrapping-remote-references.
---

## Abstract

The opening of Marc Stiegler's "15 Minute Introduction to E", which deliberately skips most of the language and most of its conventional constructs in order to "leap almost directly to a discussion of the features that make E unique." This section captures the conventional, Java-familiar subset it does show first as background: variable declaration and assignment (`def a := 1 + 2`, `#` comments), the C-like `if`-statement, a Java-like print (`println(...)`), object creation through a maker object that behaves like a class (`def car := carMaker("Mercedes")`), and method calls with the period syntax (`car.moveTo(2,3)`). The document points the reader at the *E Quick Reference Card* for the full syntax and traditional constructs, and explicitly marks this as the end of its coverage of ordinary object-oriented E before it turns to the eventually operator. Use this to ground claims about E's surface syntax and its "looks like a conventional OO language" baseline, or to find where the 15-minute intro draws the line between the familiar and the novel.

## The conventional subset

The document states its scope up front: it is a 15-minute introduction; "Many — even most — of the constructs of the language are not even mentioned," and the constructs left out "should be straightforward to learn for anyone who has programmed in Java." It leaps "almost directly to a discussion of the features that make E unique, starting with the eventually operator and its attendant features," and refers the reader to the *E Quick Reference Card* for the succinct syntax view.

"Most of E looks and acts like a conventional object-oriented programming language." The quick examples it gives:

Variable declaration and assignment, Pascal-flavored:

```e
def a := 1 + 2
# Comments can start with a #
```

The `if`-statement, C-familiar:

```e
if (a == b) { a := 3 * a }
```

The print statement, Java-like:

```e
println("Here's the answer")
```

Object creation, "a little different, but easily understood by anyone who has written Java" — here a `carMaker` object that "behaves like a class" creates a car:

```e
def car := carMaker("Mercedes")
```

A method call, "somewhat like C++, Python, or Java, with a period separating the object from the method name":

```e
car.moveTo(2,3)
```

"For the purposes of this introduction, this ends our coverage of the ordinary object-oriented E features." The next section turns to the eventually operator `<-`, which is where E departs from the conventional languages.

Source: [elang/intro/quickE.html](https://erights.github.io/erights-org-website/elang/intro/quickE.html) via the erights.github.io mirror; content SHA-256 `0a9cec3f`.
