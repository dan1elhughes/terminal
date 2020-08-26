# ⚠️ When this PR is merged, replace ghd with gh.
# ghd is the locally built version from the PR.
# https://github.com/cli/cli/pull/1580

function copypr() {
    echo "⏳ Reading pull request $1..."
    content=$(ghd pr view $1)

    title=$(echo $content | grep "title:" | cut -d$'\t' -f2)
    url=$(echo $content | grep "url:" | cut -d$'\t' -f2)

    echo -e ":github-green: $title\n:pr-arrow-darkmode: $url" | pbcopy

    echo "✅ Pull request copied to clipboard in Slack format."
}
