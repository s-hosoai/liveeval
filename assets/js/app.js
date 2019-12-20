import { Socket } from 'phoenix';
import LiveSocket from 'phoenix_live_view';
import css from "../css/app.css"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let Hooks = {}
Hooks.MyHook = {
    mounted() {
        this.el.addEventListener("input", e => {
            this.pushEvent("change", { "code": this.el.value })
        })
    }
}

let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks });
liveSocket.connect()

