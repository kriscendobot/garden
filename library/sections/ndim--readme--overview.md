---
title: Overview — point, region, and box types with pure and mutable operators
source: README.md
source_repo: gutentags/ndim
source_commit: 0ab38db1669504872b9745e3e0280bfcd68176ab
source_date: 2014-12-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [spatial-geometry]
status: current
notes: README is two lines; the type-set and operator-convention description is curated from the package source (point.js, point2.js, box.js, region2.js, quadkey.js) at current master, cited inline.
---

Abstract: **ndim** ("Dimensions") provides point and region types and methods for various dimensions, supporting **both pure and mutable operators**. The defining convention is that every mutating operator has a pure counterpart: the pure method clones and delegates (`Point.prototype.add = function (that) { return this.clone().addThis(that); }`), while the in-place variant carries a `This` suffix (`addThis`, `subThis`, `mulThis`, `divThis`, `scaleThis`) and returns `this` for chaining. This lets hot animation/layout code mutate in place to avoid allocation (why Blick, sensitive to GC churn, reaches for these vectors) while ordinary code uses the allocation-friendly pure forms. This is the whole of the ndim README; the type-set detail below is curated from the package source.

The README in full:

> **Dimensions** — Provides point and region types and methods for various dimensions. Supports both pure and mutable operators.

Type set (from the package source and `package.json`'s `files` list):

- **Point / Point2 / Point3** — an n-dimensional point/vector base with 2- and 3-dimensional subclasses carrying explicit `x`/`y`(/`z`) fields. Operators are elementwise: `mul`/`mulThis` is elementwise multiplication (the source is explicit — *"not dot or cross, just elementwise multiplication"*), alongside `add`/`sub`/`div`/`scale` and bitwise variants. `Point2.zero` and `Point2.one` are shared constants.
- **Region / Region2** — a position+size rectangle type; `Region2.prototype.contains(that)` tests containment by comparing `position`/`position+size` on each axis.
- **Box / Box2** — a start+end corner-pair type, with `copyFromRegion`/`copyIntoRegion` converting between the start/end (box) and position/size (region) representations, and `become(that)` for in-place assignment.
- **quadkey** — `encode(region, worldSize)` / `decode(path, worldSize)` compute the quadkey used to name square tiles from a region's position and scale (Bing-Maps-style quadrant path strings), applicable only to square regions.

The pure/mutable split (`op` returns a fresh clone; `opThis` mutates in place and returns `this`) is the through-line of the whole library.

Source: [README.md](https://github.com/gutentags/ndim/blob/0ab38db1669504872b9745e3e0280bfcd68176ab/README.md) at commit `0ab38db`; type set curated from the package source at `gutentags/ndim` master (`point.js`, `point2.js`, `box.js`, `region2.js`, `quadkey.js`).
