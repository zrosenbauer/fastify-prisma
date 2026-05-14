#!/usr/bin/env bash
#
# Publish the package to npm from your local machine. Mirrors the CI workflow:
#   clean → install → bump → verify → build → commit + tag → publish → push → GH release.
#
# Local-only. The CI workflow (`.github/workflows/pkg-npm-publish.yaml`) is the
# normal release path — use this when you need to ship a release by hand.
#
# Usage:
#   scripts/local-publish.sh [patch|minor|major|<semver>]   # default: patch
#   scripts/local-publish.sh --dry-run [bump]               # build + pack + publish --dry-run, no push, no tag kept
#
# Auth:
#   Uses npm's standard auth from `~/.npmrc`. Log in first with:
#     npm login        # opens a browser, OAuth confirm, writes a token to ~/.npmrc
#   When done you can revoke with `npm logout` if you don't want the token lingering.

set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# --- args --------------------------------------------------------------------

DRY_RUN=0
BUMP="patch"
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    patch|minor|major) BUMP="$arg" ;;
    [0-9]*.[0-9]*.[0-9]*) BUMP="$arg" ;;
    *) echo "unknown arg: $arg" >&2; exit 2 ;;
  esac
done

log() { printf '\n\033[1;36m→ %s\033[0m\n' "$*"; }
die() { printf '\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

# --- preflight ---------------------------------------------------------------

log "preflight"

[[ "$(git rev-parse --abbrev-ref HEAD)" == "main" ]] || die "not on main"
git fetch origin main --quiet
[[ "$(git rev-parse HEAD)" == "$(git rev-parse origin/main)" ]] || die "main is not up to date with origin/main"
[[ -z "$(git status --porcelain)" ]] || die "working tree not clean"

command -v npm >/dev/null || die "npm not installed"
NPM_USER="$(npm whoami --registry=https://registry.npmjs.org 2>/dev/null || true)"
[[ -n "$NPM_USER" ]] || die "not logged in to npm — run: npm login"
echo "  npm user: $NPM_USER"

command -v gh >/dev/null || die "gh CLI not installed"
gh auth status >/dev/null 2>&1 || die "gh not authenticated (run: gh auth login)"

# --- clean + install ---------------------------------------------------------

log "clean"
yarn clean
rm -f ./*.tgz
find . -name '*.tsbuildinfo' -not -path './node_modules/*' -delete 2>/dev/null || true

log "install"
yarn install --immutable

# --- bump --------------------------------------------------------------------

log "bump ($BUMP)"
yarn version "$BUMP"
NEW_VER="$(node -p "require('./package.json').version")"
TAG="v$NEW_VER"
PKG="$(node -p "require('./package.json').name")"
echo "  $PKG → $NEW_VER ($TAG)"

# --- verify ------------------------------------------------------------------

log "verify"
yarn analyze:types
yarn analyze:ci
yarn test run

log "build"
yarn build

# --- commit + tag (local only; pushed after publish succeeds) ----------------

log "commit + tag"
git commit -am "[🤖 npm-publish]: $NEW_VER ($BUMP)"
git tag "$TAG"

# Roll back the local commit/tag if anything past this point fails.
rollback() {
  echo
  log "rolling back local commit + tag"
  git tag -d "$TAG" 2>/dev/null || true
  git reset --hard HEAD~1 2>/dev/null || true
}
trap rollback ERR

# --- publish -----------------------------------------------------------------

if (( DRY_RUN )); then
  log "dry-run publish"
  npm publish --access public --dry-run
  trap - ERR
  rollback
  echo "✓ dry-run complete"
  exit 0
fi

log "publish"
npm publish --access public

# --- push + release ----------------------------------------------------------

log "push main + tag"
git push origin main --follow-tags

log "GH release"
gh release create "$TAG" --generate-notes --title "$TAG"

trap - ERR

# --- done --------------------------------------------------------------------

cat <<EOF

✓ Published $PKG@$NEW_VER
  npm:    https://www.npmjs.com/package/${PKG}/v/${NEW_VER}
  github: https://github.com/zrosenbauer/fastify-prisma/releases/tag/${TAG}

If this is the final @joggr/* patch, deprecate now:
  npm deprecate "$PKG@*" "Renamed to @zrosenbauer/fastify-prisma. See https://github.com/zrosenbauer/fastify-prisma."

EOF
