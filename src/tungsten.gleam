import lustre
import lustre/element.{type Element}
import tungsten/domain
import tungsten/objective_picker

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

pub type Model {
  Model(objective_picker: objective_picker.Model)
}

pub type Message {
  ObjectivePicker(objective_picker.Message)
}

pub fn init(_flags) {
  [
    domain.Project("Project A", [
      domain.Component("Component AA", [
        domain.Objective("Objective AAA"),
        domain.Objective("Objective AAB"),
      ]),
    ]),
    domain.Project("Project B", [
      domain.Component("Component BA", [domain.Objective("Objective BAA")]),
      domain.Component("Component BB", [
        domain.Objective("Objective BBA"),
        domain.Objective("Objective BBB"),
        domain.Objective("Objective BBC"),
      ]),
    ]),
  ]
  |> objective_picker.initialize()
  |> Model()
}

pub fn update(model: Model, message: Message) -> Model {
  case message {
    ObjectivePicker(message) ->
      model.objective_picker
      |> objective_picker.update(message)
      |> Model()
  }
}

pub fn view(model: Model) -> Element(Message) {
  model.objective_picker
  |> objective_picker.view()
  |> element.map(ObjectivePicker)
}
