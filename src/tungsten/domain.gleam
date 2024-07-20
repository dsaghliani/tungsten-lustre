pub type Project {
  Project(name: String, components: List(Component))
}

pub type Component {
  Component(name: String, objectives: List(Objective))
}

pub type Objective {
  Objective(name: String)
}
