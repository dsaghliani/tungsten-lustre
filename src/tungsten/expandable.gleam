import lustre/element.{type Element}
import lustre/element/html.{button, div, text}
import lustre/event.{on_click}

pub type Model {
  Model(name: String, is_expanded: Bool, content: Element(Message))
}

pub type Message {
  Toggle
}

pub fn initialize(name, content) -> Model {
  Model(name, content, is_expanded: False)
}

pub fn update(model: Model, message: Message) -> Model {
  case message {
    Toggle -> {
      Model(..model, is_expanded: !model.is_expanded)
    }
  }
}

pub fn view(model: Model) -> Element(Message) {
  case model.is_expanded {
    True -> {
      div([], [
        div([], [button([on_click(Toggle)], [text("-")]), text(model.name)]),
        model.content,
      ])
    }
    False -> {
      div([], [button([on_click(Toggle)], [text("+")]), text(model.name)])
    }
  }
}
