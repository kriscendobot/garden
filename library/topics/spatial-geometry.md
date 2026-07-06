# Topic: spatial-geometry

> Abstract: **ndim** (`gutentags/ndim`, "Dimensions"), the small multi-dimensional geometry library supplying the point, region, and box types the Guten Tag ecosystem's spatial components (and Blick's animation math) build on. Its defining convention is a **pure/mutable operator split**: every mutating operator (`addThis`, `subThis`, `mulThis`, `scaleThis`, …, `This`-suffixed, returns `this`) has a pure counterpart (`add`, `sub`, …) that clones first — so allocation-sensitive hot paths mutate in place while ordinary code stays allocation-friendly. Types: Point/Point2/Point3 (elementwise vectors), Region/Region2 (position+size rectangles with containment), Box/Box2 (start+end corner pairs, interconvertible with regions), and quadkey tile-naming for square regions. Seeded 2026-07-06 from the ndim README (design curated from source). A supporting numeric-geometry utility beneath the framework, distinct from `html-modules` (the component framework) and `animation-coordination` (Blick, which consumes these vectors).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [ndim--readme--overview](../sections/ndim--readme--overview.md) | ndim README | Point/region/box types across dimensions with a pure/mutable operator split (`op` clones, `opThis` mutates and returns `this`); elementwise vector ops, region containment, box↔region conversion, and quadkey tile naming. |

## See also

- [`animation-coordination`](animation-coordination.md): Blick, whose design-rationale reaches for ndim's mutable vector operators to avoid GC churn in per-frame animation math.
- [`html-modules`](html-modules.md): Guten Tag, the component framework whose spatial components (grids, tile games) build on ndim points and regions.
