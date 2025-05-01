import consumer from "./consumer"

consumer.subscriptions.create("TokensChannel", {
  received(data) {
    const tbody = document.querySelector("#live-token-body")
    if (tbody) {
      tbody.insertAdjacentHTML("afterbegin", data)
    }
  }
})
