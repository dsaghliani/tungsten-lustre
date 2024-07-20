import gleam/int
import gleam/list
import lustre/element.{type Element}
import lustre/element/html.{div}
import tungsten/domain.{type Project}
import tungsten/expandable

pub type Key =
  String

pub type Model {
  Model(List(#(Key, expandable.Model)))
}

pub type Message {
  Expandable(Key, expandable.Message)
}

pub fn initialize(projects: List(Project)) -> Model {
  let expandables =
    list.index_map(projects, fn(project, idx) {
      let components =
        list.map(project.components, fn(component) {
          let objectives =
            list.map(component.objectives, fn(objective) {
              html.text(objective.name)
            })
          expandable.initialize(component.name, html.div([], objectives))
          |> expandable.view()
        })
      #(
        int.to_string(idx),
        expandable.initialize(project.name, html.div([], components)),
      )
    })

  Model(expandables)
}

pub fn update(model: Model, message: Message) -> Model {
  let Model(expandables) = model

  case message {
    Expandable(idx, message) -> {
      let assert Ok(expandable) = list.key_find(expandables, idx)
      let updated_expandable = expandable.update(expandable, message)

      expandables
      |> list.key_set(idx, updated_expandable)
      |> Model()
    }
  }
}

pub fn view(model: Model) -> Element(Message) {
  let Model(expandables) = model
  let views =
    list.map(expandables, fn(key_value) {
      let #(key, expandable) = key_value
      expandable |> expandable.view |> element.map(Expandable(key, _))
    })

  div([], views)
}
