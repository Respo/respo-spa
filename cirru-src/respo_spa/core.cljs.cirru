
ns respo-spa.core $ :require
  [] respo.alias :refer $ [] create-comp div span
  [] respo.renderer.expander :refer $ [] render-app
  [] respo.controller.deliver :refer $ [] build-deliver-event mutate-factory
  [] respo.renderer.differ :refer $ [] find-element-diffs
  [] respo.util.format :refer $ [] purify-element
  [] respo-client.controller.client :refer $ [] initialize-instance activate-instance patch-instance

defonce global-states $ atom ({})

defonce global-element $ atom nil

defn render-element (markup)
  let
    (build-mutate $ mutate-factory global-element global-states)
    render-app markup @global-states build-mutate

defn mount-app (markup target dispatch)
  let
    (element $ render-element markup)
      deliver-event $ build-deliver-event global-element dispatch
    initialize-instance target deliver-event
    activate-instance (purify-element element)
      , target deliver-event
    reset! global-element element

defn rerender-app (markup target dispatch)
  let
    (element $ render-element markup)
      deliver-event $ build-deliver-event global-element dispatch
      changes $ find-element-diffs ([])
        []
        purify-element @global-element
        purify-element element

    patch-instance changes target deliver-event
    reset! global-element element

defn render (markup target dispatch)
  if (some? @global-element)
    rerender-app markup target dispatch
    mount-app markup target dispatch
