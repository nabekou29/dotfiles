#!/usr/bin/env bash
battery_info=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%' | head -1)

if [ -z "$battery_info" ]; then
  echo ""
  exit 0
fi

charge=${battery_info%%%}

if pmset -g batt | grep -q 'charging'; then
  icon=""
elif [ "$charge" -gt 90 ]; then
  icon=""
elif [ "$charge" -gt 75 ]; then
  icon=""
elif [ "$charge" -gt 50 ]; then
  icon=""
elif [ "$charge" -gt 25 ]; then
  icon=""
else
  icon=""
fi

echo "${icon}  ${charge}%"
