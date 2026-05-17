#!/usr/bin/env bash
#
# Quick report from the XMapTools analytics TSV log
# Usage: bash stats.sh [path/to/xmaptools_stats.tsv]
# ---------------------------------------------------------------

LOG="${1:-$(dirname "$0")/data/xmaptools_stats.tsv}"

if [ ! -f "$LOG" ]; then
    echo "Log file not found: $LOG"
    exit 1
fi

TOTAL=$(wc -l < "$LOG" | tr -d ' ')

echo ""
echo "  XMapTools Download Statistics"
echo "  =============================="
echo "  Log file : $LOG"
echo "  Total events: $TOTAL"
echo ""

echo "  By action:"
awk -F'\t' '{print $2}' "$LOG" | sort | uniq -c | sort -rn | while read count action; do
    printf "    %-12s %s\n" "$action" "$count"
done
echo ""

echo "  By architecture:"
awk -F'\t' '{print $3}' "$LOG" | sort | uniq -c | sort -rn | while read count arch; do
    printf "    %-16s %s\n" "$arch" "$count"
done
echo ""

echo "  By OS:"
awk -F'\t' '{print $4}' "$LOG" | sort | uniq -c | sort -rn | while read count os; do
    printf "    %-12s %s\n" "$os" "$count"
done
echo ""

echo "  By day (last 14 days):"
awk -F'\t' '{print substr($1,1,10)}' "$LOG" | sort | uniq -c | tail -14 | while read count day; do
    printf "    %s  %s\n" "$day" "$count"
done
echo ""
