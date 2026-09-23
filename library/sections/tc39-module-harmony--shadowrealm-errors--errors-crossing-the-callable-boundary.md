---
title: Errors Crossing Callable Boundary
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/errors.md
source_content_sha256: f96224a3dce4f6712929942f42d72d5e2cf78edbf2d69f95ec6c61d1a0fe80f4
source_commit: e191b135591e
source_authors: [Caridy Patiño]
source_date: 2023-01-26
ingested: 2026-07-29
ingested_by: scholar
topics: [module-harmony, errors]
status: current
notes: "Single-section ingest of the whole two-page errors.md (conventions.md § Sectioning shapes, single-screen reference doc). The main explainer's one-line summary of this material is the `security-integrity-yes-availability-no-confidentiality-partial` section of tc39-module-harmony--shadowrealm-explainer."
---

Abstract: The ShadowRealm proposal's implementer guidance for what a host may reveal when an error crosses the callable boundary. The spec's own rule is total replacement — an error thrown across the boundary in **either direction** is replaced by a fresh `TypeError` — and this document says what the host may put in that `TypeError`'s `message` without breaking the boundary. Three rules carry the substance. **(1) Compose, do not nest.** The new message may be built from the original error's `name` and `message` (`"wrapped function threw, error was TypeError: null has no properties"`), but on each further crossing the message is formed **from scratch** rather than wrapping the previous wrapping, so nested ShadowRealms and re-entrancy do not accumulate a message chain, and an error re-entering the realm it originated in arrives as a brand-new `TypeError` with **no visible reference to the original**. **(2) Read the slot, not the property.** Reading `name`/`message` off the original error must not be observable by user-land code: the host reads the data values only when the original has an `[[ErrorData]]` internal slot, and for accessor properties uses values it cached at error-creation time — so a getter on `Error.prototype.message` cannot be used as a cross-boundary trigger. **(3) Non-errors get a generic message.** A thrown value with no `[[ErrorData]]` slot (`throw someObject`) produces `"wrapped function threw, error was uncaught exception: Object"`. Firefox's implementation is cited as following this logic.

## Errors Crossing Callable Boundary

> This document describes the various mechanism that different browsers must implement when exposing information via Error objects. The objective is to provide guidance for implementers.

Errors thrown across the ShadowRealm's callable boundary **in either direction** are replaced by a fresh `TypeError` as described by the spec. Additionally, the new `TypeError` instance can be augmented with a `message` property to help developers.

### New `Error.message`

The new `TypeError` object created to propagate an error across the callable boundary can be augmented with a `message` property, whose value can be a combination of `name` and `message` from the original error. For an original `error.message` of:

```
TypeError: null has no properties
```

the new `error.message` after crossing a boundary is:

```
TypeError: wrapped function threw, error was TypeError: null has no properties
```

This "allows developers to clearly understand that the error was thrown from another Realm."

**No nesting across repeated crossings.** If the error crosses multiple nested ShadowRealms, the second time the error is copied when crossing another boundary the message "should still be formed from scratch rather than providing nesting of the message." The same applies to re-entrancy: an error re-entering the ShadowRealm where it originated "will come as a brand new TypeError object, with no visible reference to the original Error object."

**Reading the original must be unobservable.** Accessing the `name` and `message` of the original error object "must not be observed by user-land code." The logic the document offers:

- If the original error has an `[[ErrorData]]` internal slot, use the **data values** of the `name` and `message` data properties. Where those are **accessor** properties, use "the cached values stored during the creation of the original error by the host."
- If the original error does **not** have an `[[ErrorData]]` internal slot, produce a generic message. So:

  ```js
  function x() {
      throw someObject;
  }
  ```

  produces a `TypeError` with the message:

  ```
  wrapped function threw, error was uncaught exception: Object
  ```

The document notes that the Firefox implementation follows the logic described above.

Source: [errors.md](https://github.com/tc39/proposal-shadowrealm/blob/main/errors.md) at content sha256 `f96224a3`, file commit `e191b135`. Stage 2.7; retrieved 2026-07-29.
