import { Socket } from 'phoenix';
import LiveSocket from 'phoenix_live_view';
import css from "../css/app.css"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }});
liveSocket.connect()

