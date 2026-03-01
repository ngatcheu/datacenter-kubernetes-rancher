data "github_repository" "this" {
  full_name = "${var.github_owner}/${var.github_repository}"
}

resource "flux_bootstrap_git" "this" {
  path = var.flux_bootstrap_git_path
}
