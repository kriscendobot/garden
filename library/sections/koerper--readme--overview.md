---
title: Overview — a virtual DOM with body nodes
source: README.md
source_repo: gutentags/koerper
source_commit: 16e26cc0c08382a22d0d6e99d562d140b5bcf18a
source_date: 2016-10-26
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [virtual-dom, html-modules]
status: current
---

Abstract: Koerper (German *Körper*, "body," from Latin *corpus*) is a virtual DOM interface built on Wizdom that adds a "body" node type and proxies attributes and event listeners through the actual document. A body node encapsulates a region of a document *without* a container element, which is what lets Guten Tag farm portions of the actual document out to components — giving those components freedom to shape their own content and to be composed in any structure. This is what makes container-free components like `repeat` and `reveal`, and components that must be peers in a flex-box layout, possible.

> Körper, from Middle High German, from Latin *corpus*, meaning *body*.

Koerper provides a virtual DOM interface, based on [Wizdom](https://github.com/gutentags/wizdom), that implements an additional "body" node type and proxies attributes and event listeners through the actual document. Body nodes enable encapsulation of a region within a document without necessitating a container element. This enables [Gutentag](https://github.com/gutentags/gutentag) to farm out portions of its actual document to components, giving those components great flexibility to determine the shape of their content, simultaneously allowing components to be composed with any structure. This is particularly useful for components that do not need a container element, like repeat and reveal tags, as well as components that need to be peers in the flex-box model.

Installation:

```
npm install --save koerper
```

Source: [README.md](https://github.com/gutentags/koerper/blob/16e26cc0c08382a22d0d6e99d562d140b5bcf18a/README.md) at commit `16e26cc`.
