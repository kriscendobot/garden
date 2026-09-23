---
title: Move serialization to claim projections
source: notes/claim-based-serialization.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: The change moves serialization from the capability types themselves to their claim representations, in five steps. (1) **Change `Caveat` to use claims** — drop the `Serialize + DeserializeOwned` supertrait and the blanket impl, so each type implements `constrain()` by pushing its claim representation. (2) **Make `Claim` provide `constrain()`** — merge `Caveat` into `Claim` (`trait Claim { type Claim: Serialize + DeserializeOwned; fn claim(self) -> Self::Claim; fn constrain(&self, builder: &mut impl PolicyBuilder); }`); where `Claim = Self`, `constrain` just pushes `self`, and where fields are non-serializable it pushes the claim type. (3) **Drop `Serialize + DeserializeOwned` from trait bounds** on `Effect`/`Attenuation`/`Policy` (now `Sized + Claim`) and `Ability` (now `Sized`). (4) **Make `Constrained` and `Capability` conditionally serializable** — only implement `Serialize`/`Deserialize` when all parts are serializable, rather than deriving unconditionally. (5) **Update `parameters()` to use claim projection** — use `Claim::constrain()` instead of `Caveat::constrain()` for UCAN parameter collection. Impact: most types unaffected (where `Claim::Claim = Self`, behavior is identical); types with projections (`Put`, `Set`, `Publish`) already have working derive macros; `access::Prove<P>` can carry `by: P::Issuer` projected to `Did`; and it eliminates the two-step Proof/claim(signer) flow. Files: `dialog-capability/src/{settings,claim,effect,attenuation,policy,ability,constrained,capability}.rs`, `dialog-macros/src/lib.rs` (the `Claim` derive gains `constrain()`), and `dialog-ucan/src/scope.rs` (use `Claim::constrain`).

Move serialization from the types themselves to their claim representations.

## Step 1: Change `Caveat` to use claims

```rust
// Before (current)
pub trait Caveat: Serialize + DeserializeOwned {
    fn constrain(&self, builder: &mut impl PolicyBuilder);
}
impl<T: Serialize + DeserializeOwned> Caveat for T {
    fn constrain(&self, builder: &mut impl PolicyBuilder) { builder.push(self); }
}

// After
pub trait Caveat {
    fn constrain(&self, builder: &mut impl PolicyBuilder);
}
```

No blanket impl. Each type implements `constrain()` by pushing its claim representation.

## Step 2: Make `Claim` provide `constrain()`

Merge `Caveat` into `Claim`:

```rust
pub trait Claim {
    type Claim: Serialize + DeserializeOwned;
    fn claim(self) -> Self::Claim;
    fn constrain(&self, builder: &mut impl PolicyBuilder);
}
```

For types where `Claim = Self`, `constrain` just pushes `self`. For types with non-serializable fields, `constrain` pushes the claim type.

## Step 3: Drop `Serialize + DeserializeOwned` from trait bounds

```rust
pub trait Effect: Sized + Claim { ... }
pub trait Attenuation: Sized + Claim { ... }
pub trait Policy: Sized + Claim { ... }
pub trait Ability: Sized { ... }
```

## Step 4: Make `Constrained` and `Capability` conditionally serializable

Only implement `Serialize`/`Deserialize` when all parts are serializable, rather than deriving unconditionally.

## Step 5: Update `parameters()` to use claim projection

Use `Claim::constrain()` instead of `Caveat::constrain()` for UCAN parameter collection.

## Impact

- Most types unaffected: where `Claim::Claim = Self`, behavior is identical.
- Types with projections (`Put`, `Set`, `Publish`) already have derive macros that work.
- `access::Prove<P>` can carry `by: P::Issuer`, projected to `Did`.
- Eliminates the two-step Proof/claim(signer) flow.

## Files to modify

| File | Change |
|------|--------|
| `dialog-capability/src/settings.rs` | Remove `Serialize + DeserializeOwned` from `Caveat`, or merge into `Claim` |
| `dialog-capability/src/claim.rs` | Add `constrain()` method |
| `dialog-capability/src/effect.rs` | Drop `Caveat` from `Effect` bounds |
| `dialog-capability/src/attenuation.rs` | `Caveat` to `Claim` |
| `dialog-capability/src/policy.rs` | `Caveat` to `Claim` |
| `dialog-capability/src/ability.rs` | Drop `Serialize + DeserializeOwned` |
| `dialog-capability/src/constrained.rs` | Conditional `Serialize`/`Deserialize` impl |
| `dialog-capability/src/capability.rs` | Conditional `Serialize`/`Deserialize` impl |
| `dialog-macros/src/lib.rs` | Update `Claim` derive to generate `constrain()` |
| `dialog-ucan/src/scope.rs` | Use `Claim::constrain` instead of `Caveat::constrain` |

Source: [notes/claim-based-serialization.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/claim-based-serialization.md) at commit `18c640a0`.
