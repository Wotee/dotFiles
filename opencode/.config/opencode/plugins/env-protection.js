import { Plugin } from "@opencode/plugin"

const isProtectedEnvPath = (value) => {
  if (typeof value !== "string" || value.length === 0) return false

  const normalized = value.replaceAll("\\", "/")
  return normalized.split("/").some((segment) => segment.startsWith(".env"))
}

export default Plugin.define({
  id: "wote.env-protection",
  async setup(ctx) {
    await ctx.tool.hook("execute.before", (event) => {
      if (event.tool !== "read") return
      if (!event.input || typeof event.input !== "object") return

      const input = event.input
      const filePath =
        typeof input.path === "string"
          ? input.path
          : typeof input.filePath === "string"
            ? input.filePath
            : undefined

      if (filePath && isProtectedEnvPath(filePath)) {
        throw new Error("Do not read .env files")
      }
    })
  },
})
