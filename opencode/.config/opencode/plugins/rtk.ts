import { execFile } from "node:child_process"
import { promisify } from "node:util"

import { Plugin } from "@opencode/plugin"

// RTK OpenCode plugin — rewrites commands to use rtk for token savings.
// Requires: rtk >= 0.23.0 in PATH.
//
// This is a thin delegating plugin: all rewrite logic lives in `rtk rewrite`,
// which is the single source of truth (src/discover/registry.rs).
// To add or change rewrite rules, edit the Rust registry — not this file.

const execFileAsync = promisify(execFile)

type CommandInput = {
  command?: unknown
}

const hasRtk = async () => {
  try {
    await execFileAsync("rtk", ["--version"], { encoding: "utf8" })
    return true
  } catch {
    return false
  }
}

export default Plugin.define({
  id: "wote.rtk",
  async setup(ctx) {
    if (!(await hasRtk())) {
      console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
      return
    }

    await ctx.tool.hook("execute.before", async (event) => {
      const tool = String(event.tool ?? "").toLowerCase()
      if (tool !== "bash" && tool !== "shell") return
      if (!event.input || typeof event.input !== "object") return

      const input = event.input as CommandInput
      const command = typeof input.command === "string" ? input.command : undefined
      if (!command) return

      try {
        const { stdout } = await execFileAsync("rtk", ["rewrite", command], {
          encoding: "utf8",
        })
        const rewritten = String(stdout).trim()
        if (rewritten && rewritten !== command) {
          input.command = rewritten
        }
      } catch {
        // rtk rewrite failed — pass through unchanged
      }
    })
  },
})
