
ns respo-spa.demo $ :require
  [] respo-spa.core :refer $ [] render
  [] respo-spa.updater.core :refer $ [] updater
  [] respo-spa.component.container :refer $ [] comp-container

defonce global-store $ atom 0

defonce global-states $ atom ({})

defn dispatch (op op-data)
  let
    (new-store $ updater @global-store op op-data)

    reset! global-store new-store

defn render-app ()
  let
    (target $ .querySelector js/document |#app)
    render (comp-container @global-store)
      , target dispatch global-states

defn -main ()
  enable-console-print!
  render-app
  add-watch global-store :rerender render-app
  add-watch global-states :rerender render-app

set! (.-onload js/window)
  , -main

defn on-jsload ()
  render-app
  .log js/console "|code updated."
