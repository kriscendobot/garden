---
title: Adding a new package
source: packages/README.md
source_repo: agoric/agoric-sdk
source_commit: 917211fe1cb3fedbec9001739257cc7e7226289f
source_date: 2023-08-04
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, repository-governance]
status: current
---

> Abstract: Step-by-step procedure for adding a new NPM package to `agoric-sdk/packages/`: directory setup, `package.json` creation, sdk-package-names update, yarn install + commit lock file, workspace-dependency check, CI test-matrix update. The note also names the published/private split (some packages have `private: true` and are not published).

This path has all the packages in the repo. Not all are published (some are `private: true`).

To create a new package:

* mkdir `packages/foo`
* add your sources/tests/etc to `packages/foo/src/` etc
* populate a new `packages/foo/package.json`, using other packages as a template
* update `agoric-cli/src/sdk-package-names.js`
* run `yarn install`, and commit the resulting changes to `yarn.lock`
* check the output of `yarn workspaces info` to make sure there are no `mismatchedWorkspaceDependencies`, adjust the new package's dependencies until they are correctly satisfied by the other local packages
* edit `.github/workflows/test-all-packages.yml` to add a clause that tests the new package
* commit everything to a new branch, push, check the GitHub `Actions` tab to make sure CI tested everything properly
* merge with a PR

Source: [packages/README.md](https://github.com/Agoric/agoric-sdk/blob/917211fe1cb3fedbec9001739257cc7e7226289f/packages/README.md) at commit `917211fe`.
