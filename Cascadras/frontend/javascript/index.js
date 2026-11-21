import "$styles/index.css"

// Fathom events (WEB-32). Each "Reserve a founding seat" button that jumps
// to the form carries data-fathom-click with its event name.
const track = (name) => {
  if (name && window.fathom?.trackEvent) window.fathom.trackEvent(name)
}

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-fathom-click]").forEach((link) => {
    link.addEventListener("click", () => track(link.dataset.fathomClick))
  })

  // The reserve form posts to Kit in the background. On success it fires the
  // Fathom signup event and swaps in the thank-you text in place, with no
  // page change. If Kit can't be reached from here, the browser posts the
  // form instead and Kit shows its own confirmation.
  document.querySelectorAll("[data-reserve-form]").forEach((form) => {
    const fields = form.querySelector(".reserve-fields")
    const thanks = form.querySelector("[data-reserve-thanks]")
    const status = form.querySelector(".reserve-status")
    const button = form.querySelector("button[type=submit]")
    let sending = false

    const say = (text, kind) => {
      if (!status) return
      status.textContent = text
      status.dataset.kind = kind || ""
    }

    form.addEventListener("submit", async (e) => {
      e.preventDefault()
      if (sending) return
      sending = true
      if (button) button.disabled = true
      say("Sending…")

      let result
      try {
        const response = await fetch(form.action, {
          method: "POST",
          body: new FormData(form),
          headers: { Accept: "application/json" },
        })
        result = await response.json().catch(() => ({}))
        if (!response.ok && !result.status) result.status = "failed"
      } catch (_networkError) {
        form.submit()
        return
      }

      if (result.status === "success") {
        track(form.dataset.fathomEvent)
        if (fields) fields.hidden = true
        if (thanks) {
          thanks.hidden = false
          thanks.focus()
        }
        return
      }

      sending = false
      if (button) button.disabled = false
      const errors = Array.isArray(result.errors) ? result.errors.join(" ") : ""
      say(errors || "That didn't go through. Check the email address and try again.", "error")
    })
  })
})
