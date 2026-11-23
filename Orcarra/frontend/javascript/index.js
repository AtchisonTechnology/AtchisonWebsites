import "$styles/index.css"

// Fathom events (WEB-33). Each "Reserve a spot for your club" button that jumps
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
  // page change. If Kit can't be reached from here, or answers with anything
  // but a clear success, the browser posts the form itself, so Kit handles
  // it and shows its own page. A reply we can't read never loses a signup
  // (AGENT-1059 follow-up to WEB-34).
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
      // Measure the card before "Sending…" adds a line to it, so the
      // thank-you swap holds the form's own height (WEB-34).
      const formHeight = form.offsetHeight
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
        // Hold the card at the form's height so nothing below it moves
        // when the thank-you text replaces the fields (WEB-34).
        form.style.minHeight = `${formHeight}px`
        form.classList.add("is-done")
        if (fields) fields.hidden = true
        if (thanks) {
          thanks.hidden = false
          thanks.focus()
        }
        return
      }

      // Not a clear success: Kit may answer 200 with a failure body or a
      // page we can't read. Post the form the plain way and let Kit handle
      // it, rather than drop the signup behind an error line.
      console.warn("Kit did not confirm the signup; posting the form directly.", result)
      form.submit()
    })
  })
})
