---
title: Effects, providers, and capability composition
source: notes/capability-sysstem.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [capability-security]
status: current
---

> Abstract: An **effect** is a capability that can be invoked (you can hold archive/catalog access, but access is not itself invocable — an effect is). Performing an effect through the host environment produces an `Output`. To perform effects an environment implements the `Provider<E>` trait, whose async `execute(invocation)` receives a validated invocation and returns the effect's typed output. Capabilities compose into a DSL via `.claim(...)` (`Subject::from(did).claim(Archive).claim(Catalog{..})` builds a `Claim<CatalogAccess>` exposing `.subject()`, `.ability()`, `.policy()`). Effectful functions declare the providers they need via trait bounds (`Env: Provider<Acquire<CatalogAccess>> + Provider<DoGet>`), `acquire` a delegation for the active principal, then `invoke` and `perform` the effect — and provider bounds can be grouped into ability-set traits (`Archive`, `Memory`, `Storage`).

**Effects** are capabilities that can be invoked — you can have access to an archive or a catalog within it, but those are not things you invoke; the leaf operation is. When effects are performed by the host environment they produce `Output`s:

```rust
pub struct Get { pub key: Vec<u8> }
impl Ability for Get {}
type DoGet = Access<Get, CatalogAccess>;
impl Effect for DoGet { type Output = Result<Vec<u8>, GetError>; }
type GetInvocation = Invocation<DoGet>;
```

To perform effects, an environment provides implementations via the `Provider` trait; a validated invocation is passed to the provider to perform the effect:

```rust
struct DemoEnv;
impl Provider<DoGet> for DemoEnv {
    async fn execute(&mut self, invocation: GetInvocation) -> <DoGet as Invocation>::Output {
        // access subject/catalog/key off the validated invocation
        Ok(b"world")
    }
}
```

**Composition** into a DSL:

```rust
let capability = Subject::from("did:key:zSpace") // Claim<RepositoryAccess>
   .claim(Archive)                                // Claim<ArchiveAccess>
   .claim(Catalog { catalog: "index".into() });   // Claim<CatalogAccess>

assert_eq!(capability.subject(), "did:key:zSpace".into());
assert_eq!(capability.ability(), "/archive");
assert_eq!(Catalog::policy(&capability).catalog, "index");
```

Effectful functions acquire the capabilities they need from the host runtime, describing the environment in terms of the providers it must offer:

```rust
async fn demo<Env>(env: Env) -> Result<(), AuthorizationError>
where Env: Provider<Acquire<CatalogAccess>> + Provider<DoGet> {
    let catalog = capability.acquire(env).await?;   // may fail: no delegation arrangeable
    let get = catalog.invoke(Get { key: b"hello" }); // GetInvocation
    let content = get.perform(env).await?;           // ask env to perform the effect
    Ok(())
}
```

`Acquire` obtains a delegation of the requested capability to the currently active principal; `DoGet` performs the `get` effect. Provider requirements need not be enumerated one-by-one — ability groups defined as Rust traits compose them:

```rust
trait Archive: Provider<DoGet> + Provider<DoPut> {}
trait Memory: Provider<DoResolve> + Provider<DoPublish> {}
trait Storage: Archive + Memory {}
```

This is the same shape as Endo's endowment discipline: authority arrives as an injected, typed provider rather than an ambient import, and a function's type states exactly the authority it consumes.

Source: [notes/capability-sysstem.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/capability-sysstem.md) at commit `f777fe7c`.
