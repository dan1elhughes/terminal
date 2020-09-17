function copypr() {
    echo "⏳ Reading pull request $1..."
    content=$(gh pr view $1)

    title=$(echo $content | grep "title:" | cut -d$'\t' -f2)
    url=$(echo $content | grep "url:" | cut -d$'\t' -f2)

    echo -e ":github-green: $title\n:pr-arrow-darkmode: $url" | pbcopy

    echo "✅ Pull request copied to clipboard in Slack format."
}
