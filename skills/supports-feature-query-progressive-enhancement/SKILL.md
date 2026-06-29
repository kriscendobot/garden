---
created: 2026-06-29
updated: 2026-06-29
author: gardener
---

# Skill: supports-feature-query-progressive-enhancement

Gate a modern CSS feature behind an `@supports` feature query and ship a
hand-rolled fallback so the design **degrades gracefully** on engines that lack
the feature. The page works everywhere; engines that have the feature get the
better treatment. This includes the negated form `@supports not (...)` paired
with structural selectors (`:has()`, `:nth-of-type()`) to approximate the modern
behavior on the fallback path.

This generalizes the [web-designer](../../roles/web-designer/AGENT.md) role's
"prefer asset-free and build-step-free techniques / progressive enhancement"
operating norm into a reusable procedure. A web-designer specifies the gate in a
design; a [web-builder](../../roles/web-builder/AGENT.md) implements it.

Grounded in two pieces of real work: Jake Archibald's customizable-`<select>`
essay, which gates `calc-size()`, `max-block-size: stretch`, and anchored
container queries this way (library:
`web--goldilocks-select-height--{viewport-margin-and-flip-fallbacks,intrinsic-min-max-with-calc-size,final-css-and-browser-support}`),
and the garden's own chat color-schemes design, whose "scheme-aware tokens with
intentional exceptions" pattern is the same gate-and-document discipline applied
to theming (library:
`endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state--pattern-scheme-aware-tokens-with-intentional-exceptions`).

## When to use

- A design depends on a CSS feature not yet shipped in every in-scope browser:
  `calc-size()`, `max-block-size: stretch`, anchor positioning, `:has()`,
  container queries, `field-sizing`, anything on the modern edge.
- You need the design to be **usable**, not just non-broken, on the engines that
  lack the feature: a fallback that approximates the intent rather than collapsing
  to nothing.
- You are tempted to detect the browser by user-agent string or to ship the
  modern feature unguarded and "let old browsers cope." Feature-query gating is
  the correct, capability-based alternative.

## The two forms of the gate

`@supports` tests whether the engine understands a property/value pair. Two forms
matter, and the robust pattern uses **both** so the two paths are mutually
exclusive:

```css
.box {
  /* 1. The baseline that every engine applies. */
  min-block-size: 12em;

  /* 2. The modern path, applied only where the feature is understood. */
  @supports (min-block-size: calc-size(fit-content, min(size, 1px))) {
    min-block-size: calc-size(fit-content, min(size, var(--min-size)));
  }

  /* 3. The fallback path, applied only where it is NOT understood. */
  @supports not (min-block-size: calc-size(fit-content, min(size, 1px))) {
    /* approximate the modern behavior with what the engine does have */
  }
}
```

Key points:

- **Test the real feature with a throwaway value.** The probe
  `calc-size(fit-content, min(size, 1px))` uses a `1px` cap purely to make a
  syntactically valid value the engine can accept-or-reject; the actual styling
  inside the block uses the real custom property. Probe for the exact construct
  you depend on (the function, the keyword, the property), not a proxy.
- **Always ship the baseline first.** Declaration 1 is the floor every engine
  applies; the `@supports` blocks layer over it. If you omit the baseline and only
  style inside `@supports (...)`, engines without the feature get nothing.
- **The `not (...)` block earns its place when the fallback must actively differ**
  from the baseline, not merely be absent. Use it for a real alternate treatment;
  if "do nothing extra" is an acceptable fallback, the baseline alone suffices and
  you can drop the negated block.

## Structural fallbacks: approximate the feature with selectors

When the modern feature computes something from content that older engines cannot,
approximate it structurally. The essay's case: where `calc-size()` is missing it
cannot drop the minimum height for genuinely short pickers, so it detects "short"
structurally with `:has()` + `:nth-of-type()` and removes the minimum there:

```css
@supports not (min-block-size: calc-size(fit-content, min(size, 1px))) {
  .picker:not(
    :has(:where(option:nth-of-type(4))),
    :has(:where(optgroup:nth-of-type(2)))
  ) {
    min-block-size: 0;
    max-block-size: fit-content;
  }
}
```

That reads: on engines without `calc-size()`, when the picker has fewer than 4
options and fewer than 2 optgroups (a structural proxy for "short list"), drop the
minimum and shrink-wrap. It is an approximation, not an equivalent, and the design
should say so. Note this fallback itself depends on `:has()`; if `:has()` is also
out of scope, the baseline minimum is the final floor.

## The theming parallel: gate-and-document

The same discipline applies beyond feature queries to any **conditional styling
with intentional exceptions**. The chat color-schemes design's rule is: by default
every hardcoded color outside `:root` becomes a scheme-varying `var(--*)`; the
handful that stay hardcoded (white text on a saturated accent background) are
**documented inline as intentional exceptions**, so a later audit can grep for hex
literals and treat every survivor as either a regression or a recorded exception.
The transferable idea is the same as the `@supports not (...)` block: when you
take a path that diverges from the default, **record why at the divergence point**
so the divergence is reviewable rather than mysterious.

## Procedure

1. **Name the feature and the in-scope engines.** State which browsers/engines
   must work (the web-designer's rendering-surface section). The gate exists
   because at least one in-scope engine lacks the feature; if all of them have it,
   you do not need the gate.
2. **Write the baseline** that every engine applies unconditionally.
3. **Add the `@supports (<feature>)` block** with the enhanced treatment, probing
   the exact construct you depend on.
4. **Add the `@supports not (<feature>)` block** only if the fallback must
   actively differ from the baseline; approximate the lost behavior with the
   primitives the engine does have (structural selectors, fixed values), and
   record that it is an approximation.
5. **Document every divergence inline** (a comment at the exception, or a
   rationale row in the design) so a later audit can tell a deliberate exception
   from a regression.
6. **Verify** on a feature-present engine and a feature-absent engine per the
   checklist below.

## Verification

- On a feature-present engine: the enhanced path is active and the fallback is
  not (confirm in DevTools that the `@supports` block matches).
- On a feature-absent engine: the page is **usable**, not merely unbroken: the
  fallback delivers the design intent as closely as the primitives allow.
- The two `@supports` blocks are mutually exclusive (a positive and its `not`),
  so no engine applies both or neither beyond the baseline.
- The probe tests the real construct: temporarily break the feature name and
  confirm the engine falls to the fallback path (guards against a probe that
  always passes).

## Limitations (call these out in the design)

- **`@supports` tests syntax support, not correctness.** An engine can parse a
  property and still render it subtly differently; the essay's residual Safari
  imperfection is exactly this. Feature-query gating reduces breakage; it does not
  guarantee pixel-identical results.
- **A structural fallback is an approximation.** The `:has()`/`:nth-of-type()`
  short-list detector is a proxy for the real computed size; it can misjudge edge
  cases. Say so, and bound the approximation (the conditions under which it is
  wrong).
- **Fallbacks can themselves depend on modern features.** A `:has()`-based
  fallback needs `:has()`; chain your assumptions explicitly so the final baseline
  floor is always reachable.

## Output

The deliverable is the gated CSS (baseline + `@supports` enhanced path +
optional `@supports not` fallback) with each divergence documented inline, plus a
design note stating the gated feature, the in-scope engines, and what the fallback
approximates versus what the modern path delivers.

## Notes from the field

(Append; terse and dated.)

- _2026-06-29_: initial write (job `author-web-designer-css-skills`, scholar
  proposal). Two grounding exemplars: the goldilocks-select essay's
  `@supports`/`@supports not` `calc-size()` gate with a `:has()`/`:nth-of-type()`
  short-list fallback, and the chat-color-schemes "scheme-aware tokens with
  intentional exceptions" gate-and-document discipline. Pairs with
  [css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md),
  which is the feature most often gated this way in web-frontend sizing work.
