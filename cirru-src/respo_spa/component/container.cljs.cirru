
ns respo-spa.component.container $ :require
  [] respo.alias :refer $ [] create-comp div span

defn handle-click (simple-event dispatch)
  dispatch :inc nil

defn render (store)
  fn (state mutate)
    div ({})
      span $ {} :style
        {} $ :cursor |pointer
        , :attrs
        {} :inner-text $ str "|Counter(clicks):" store
        , :event
        {} :click handle-click

def comp-container $ create-comp :container render
