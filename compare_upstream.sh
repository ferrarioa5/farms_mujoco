#!/usr/bin/env bash
# Compare this fork with the original upstream repository farmsim/farms_mujoco
# Usage: ./compare_upstream.sh [--branches]

set -euo pipefail

UPSTREAM_URL="https://github.com/farmsim/farms_mujoco.git"
UPSTREAM_REMOTE="upstream"

# Add upstream remote if not already present
if ! git remote get-url "$UPSTREAM_REMOTE" &>/dev/null; then
    echo "Adding upstream remote: $UPSTREAM_URL"
    git remote add "$UPSTREAM_REMOTE" "$UPSTREAM_URL"
fi

echo "Fetching from upstream ($UPSTREAM_URL)..."
git fetch "$UPSTREAM_REMOTE" --quiet

FORK_MAIN=$(git rev-parse HEAD)
UPSTREAM_MAIN=$(git rev-parse "$UPSTREAM_REMOTE/main")

echo ""
echo "=== Fork vs Upstream Comparison ==="
echo "Fork HEAD:     $FORK_MAIN"
echo "Upstream main: $UPSTREAM_MAIN"
echo ""

# Commits in fork not in upstream
AHEAD=$(git log "$UPSTREAM_REMOTE/main"..HEAD --oneline)
if [ -z "$AHEAD" ]; then
    echo "Fork has no commits ahead of upstream/main."
else
    echo "Commits in fork NOT in upstream/main:"
    echo "$AHEAD"
fi

echo ""

# Commits in upstream not in fork
BEHIND=$(git log HEAD.."$UPSTREAM_REMOTE/main" --oneline)
if [ -z "$BEHIND" ]; then
    echo "Fork is up-to-date with upstream/main (no missing commits)."
else
    echo "Commits in upstream/main NOT in fork:"
    echo "$BEHIND"
fi

echo ""

# File-level diff between fork and upstream/main
DIFF_STAT=$(git diff "$UPSTREAM_REMOTE/main"..HEAD --stat)
if [ -z "$DIFF_STAT" ]; then
    echo "No file differences between fork and upstream/main."
else
    echo "File differences between fork and upstream/main:"
    echo "$DIFF_STAT"
fi

# Optionally show upstream branches ahead of main
if [[ "${1:-}" == "--branches" ]]; then
    echo ""
    echo "=== Upstream branches ahead of upstream/main ==="
    git for-each-ref --format='%(refname:short)' "refs/remotes/$UPSTREAM_REMOTE/" \
        | grep -v "^${UPSTREAM_REMOTE}/HEAD$" \
        | grep -v "^${UPSTREAM_REMOTE}/main$" \
        | while IFS= read -r branch; do
        count=$(git log "$UPSTREAM_REMOTE/main".."${branch}" --oneline 2>/dev/null | wc -l)
        if [ "$count" -gt 0 ]; then
            echo "  ${branch#$UPSTREAM_REMOTE/}: $count commit(s) ahead"
        fi
    done
fi
