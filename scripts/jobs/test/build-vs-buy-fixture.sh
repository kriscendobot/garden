#!/bin/bash
# build-vs-buy-fixture.sh — sourced by the export-index / build-vs-buy tests.
# make_fixture <dir>: a git workspace with @endo/promise-kit (barrel `export *`),
# @endo/barrel (subpath export, renamed re-export, depends on @endo/foo: a cycle
# for foo), a private @endo/priv, and @endo/foo, committed as one base commit.
make_fixture() {
  local R="$1"
  mkdir -p "$R"/packages/{promise-kit/src,foo/test,barrel/src,priv}
  git -C "$R" init -q
  git -C "$R" config user.name fixture; git -C "$R" config user.email fixture@example.invalid
  printf '%s\n' '{"name":"root","private":true,"workspaces":["packages/*"]}' > "$R/package.json"
  printf '%s\n' '{"name":"@endo/promise-kit","exports":{".":{"types":"./index.d.ts","default":"./index.js"},"./package.json":"./package.json"}}' \
    > "$R/packages/promise-kit/package.json"
  printf '%s\n' "export * from './src/kit.js';" > "$R/packages/promise-kit/index.js"
  cat > "$R/packages/promise-kit/src/kit.js" <<'JS'
/** Make a promise kit. */
export const makePromiseKit = () => {
  let resolve;
  let reject;
  const promise = new Promise((res, rej) => {
    resolve = res;
    reject = rej;
  });
  return harden({ promise, resolve, reject });
};
export function parse(text) { return text; }
export default makePromiseKit;
JS
  printf '%s\n' '{"name":"@endo/barrel","exports":{".":"./index.js","./sub.js":"./src/sub.js"},"dependencies":{"@endo/foo":"*"}}' \
    > "$R/packages/barrel/package.json"
  printf '%s\n' "export { helperThing as renamedHelper } from './src/sub.js';" > "$R/packages/barrel/index.js"
  printf '%s\n' 'export function helperThing(left, right) { return left + right; }' > "$R/packages/barrel/src/sub.js"
  printf '%s\n' '{"name":"@endo/priv","private":true,"main":"index.js"}' > "$R/packages/priv/package.json"
  printf '%s\n' 'export const privateHelperFn = () => 1;' > "$R/packages/priv/index.js"
  printf '%s\n' '{"name":"@endo/foo","main":"index.js"}' > "$R/packages/foo/package.json"
  printf '%s\n' 'export const value = 1;' > "$R/packages/foo/index.js"
  git -C "$R" add -A && git -C "$R" commit -qm base
}
