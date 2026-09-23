---
title: Authorization, delegation import, and identification
source: notes/repository.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: Invoking any capability requires authorization, which the operator resolves through the `access::Prove` capability. Given the capability the caller wishes to invoke (identified by its subject `did:key` and ability), the flow searches the operator's `CertificateStore` for delegation chains from the subject to the operator; if a valid chain is found the operator signs an invocation carrying the proof chain; if no chain exists but the subject credential is a `Signer`, a delegation can be issued on the spot — the output on success is a signed invocation ready to dispatch. Delegations are imported into the certificate store via `profile.access().save(chain).perform(&operator)`, making the chain available for future authorization lookups. Invoking `authority::Identify` returns the current delegation chain as `Capability<Operator>`, encoding the subject DID (chain root), the profile DID and optional account DID (from `Profile` in the chain), and the operator DID (from `Operator`).

## Authorization

Invoking any capability requires authorization. The operator resolves delegation chains using the `access::Prove` capability.

**Input:** the capability the caller wishes to invoke, identified by its subject `did:key` and ability.
**Output on success:** a signed invocation ready to be dispatched.

The authorization flow:
1. The operator's `CertificateStore` is searched for delegation chains from the subject to the operator
2. If a valid chain is found, the operator signs an invocation carrying the proof chain
3. If no chain exists but the subject credential is a `Signer`, a delegation can be issued on the spot

## Delegation Import

Delegations are imported via `profile.access().save(chain).perform(&operator)`. This stores the UCAN delegation chain in the profile's certificate store, making it available for future authorization lookups.

## Identification

Invoking `authority::Identify` returns the current delegation chain as `Capability<Operator>`, which encodes:

- The **subject** DID (from the chain root)
- The **profile** DID and optional **account** DID (from `Profile` in the chain)
- The **operator** DID (from `Operator` in the chain)

Source: [notes/repository.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/repository.md) at commit `18c640a0`.
