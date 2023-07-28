terraform {
  cloud {
    organization = "Mayorfaj-io"

    workspaces {
      name = "mayor-dev"
    }
  }
}