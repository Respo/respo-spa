
ns respo-spa.core $ :require
  [] respo.alias :refer $ [] create-comp div span
  [] respo.render.expander :refer $ [] render-app
  [] respo.controller.deliver :refer $ [] build-deliver-event mutate-factory
  [] respo.render.differ :refer $ [] find-element-diffs
  [] respo.util.format :refer $ [] purify-element
  [] respo-client.controller.client :refer $ [] initialize-instance activate-instance patch-instance

defonce global-element $ atom nil

defn render-element (markup states-ref)
  let
    (build-mutate $ mutate-factory global-element states-ref)
    render-app markup @states-ref build-mutate

defn mount-app
  markup target dispatch states-ref
  let
    (element $ render-element markup states-ref)
      deliver-event $ build-deliver-event global-element dispatch
    initialize-instance target deliver-event
    activate-instance (purify-element element)
      , target deliver-event
    reset! global-element element

defn rerender-app
  markup target dispatch states-ref
  let
    (element $ render-element markup states-ref)
      deliver-event $ build-deliver-event global-element dispatch
      changes $ find-element-diffs ([])
        []
        purify-element @global-element
        purify-element element

    patch-instance changes target deliver-event
    reset! global-element element

defn render
  markup target dispatch states-ref
  if (some? @global-element)
    rerender-app markup target dispatch states-ref
    mount-app markup target dispatch states-ref
