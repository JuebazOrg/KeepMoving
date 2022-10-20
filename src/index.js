import "./main.css";
import { Elm } from "./Main.elm";
import * as serviceWorker from "./serviceWorker";
import "../src/styles.css"

const url = process.env.NODE_ENV === 'development' ? 'localhost:8000/': 'https://morning-shelf-98431.herokuapp.com/';

console.log(url)

Elm.Main.init({
  node: document.getElementById("root"),
  flags: { url }
}, );



// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.register();
