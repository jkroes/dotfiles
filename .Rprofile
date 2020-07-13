# Create a directory for the major.minor version of R contained in R_LIBS_USER
# that is independent of the R installation itself. In other words,
# removing or reinstalling R of any version will not delete the associated
# user library.
version_library <- function() {
  rlu <- Sys.getenv("R_LIBS_USER")
  if (!dir.exists(rlu)) {
    dir.create(rlu, recursive = T)
    print("R must restart to recognize library at R_LIBS_USER")
    q("no")
  }
}
version_library()
