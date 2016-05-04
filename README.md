
Respo SPA kit
----

Make Respo easier to pick up in simple page apps.
Based on [`respo`](https://github.com/mvc-works/respo) and [`respo-client`](https://github.com/mvc-works/respo).

> Respo APIs was in low level for the purpose of reusing on both server-side and client-side
> , as well as some debugging purpose. Respo APIs will not be prepared for normal users.
> Pick this library if you want to try Respo in the simple way.

### Usage

[![Clojars Project](https://img.shields.io/clojars/v/mvc-works/respo-spa.svg)](https://clojars.org/mvc-works/respo-spa)

Require it in Clojure:

```clojure
[mvc-works/respo-spa "0.1.1"]
```

I also suggest resuing the code with copy/paste: [Gist 0.1.1](https://gist.github.com/jiyinyiyong/fcf996468fa2ea1cd3ec3cab2e8bbf15)

Define an `updater` function:

```clojure
(ns respo-spa.updater.core)

(defn updater [store op op-data] (inc store))
```

Create a component in Respo:

```clojure
(ns respo-spa.component.container
  (:require [respo.alias :refer [create-comp div span]]))

(defn handle-click [simple-event dispatch] (dispatch :inc nil))

(defn render [store]
  (fn [state mutate]
    (div
      {}
      (span
        {:style {:cursor "pointer"},
         :event {:click handle-click},
         :attrs {:inner-text (str "Counter(clicks):" store)}}))))

(def comp-container (create-comp :container render))
```

And use glue code to connect them:

```clojure
(ns respo-spa.demo
  (:require [respo-spa.core :refer [render]] ; provided in this library
            [respo-spa.updater.core :refer [updater]]
            [respo-spa.component.container :refer [comp-container]]))

; global store in Atom
(defonce global-store (atom 0))

; global states in Atom
(defonce global-states (atom {}))

; a `dispatch` function to update store
(defn dispatch [op op-data]
  (let [new-store (updater @global-store op op-data)]
    (reset! global-store new-store)))

; some wrap-up on `render` which is provided in this library
(defn render-app []
  (let [target (.querySelector js/document "#app")]
    (render
      (comp-container @global-store)
      target
      dispatch
      global-states)))

; main function, call `render-app` and call again on changes
(defn -main []
  (enable-console-print!)
  (render-app)
  (add-watch global-store :rerender render-app)
  (add-watch global-states :rerender render-app))

(set! (.-onload js/window) -main)

; also rerenders when code updated
(defn on-jsload [] (render-app) (.log js/console "code updated."))
```

### License

MIT
