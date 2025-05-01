import consumer from "./consumer"

consumer.subscriptions.create("TokensChannel", {
  connected() {
    console.log("🟢 Connected to TokensChannel")
  },

  received(data) {
    const tbody = document.querySelector("#live-token-body")
    if (tbody) {
      tbody.innerHTML = data
    }
  }
});
