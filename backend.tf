terraform {
  cloud {
    organization = "one-man-team"

    workspaces {
      name = "peon-media-hosting"
    }
  }
}