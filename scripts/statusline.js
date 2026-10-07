// Claude Code status line: model (effort) | ctx % | 5h % until HH:MM | week %. Input: session JSON on stdin.
// Fields: https://code.claude.com/docs/en/statusline
let input = "";
process.stdin.on("data", (c) => (input += c)).on("end", () => {
  let j = {};
  try { j = JSON.parse(input); } catch {}
  const pct = (v) => Math.round(v) + "%";
  const out = [];
  const model = j.model?.display_name;
  if (model) out.push(j.effort?.level ? `${model} (${j.effort.level})` : model);
  const ctx = j.context_window?.used_percentage;
  if (ctx != null) out.push("ctx " + pct(ctx));
  const five = j.rate_limits?.five_hour;
  if (five?.used_percentage != null) {
    const until = five.resets_at
      ? " until " + new Date(five.resets_at * 1000).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit", hour12: false })
      : "";
    out.push("5h " + pct(five.used_percentage) + until);
  }
  const week = j.rate_limits?.seven_day;
  if (week?.used_percentage != null) out.push("week " + pct(week.used_percentage));
  process.stdout.write(out.join(" | ") + "\n");
});
