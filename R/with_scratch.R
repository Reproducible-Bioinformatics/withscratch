#' Execute code inside a scratch directory context.
#'
#' @param source_directory The source directory.
#' @param target_directory The target directory.
#' @param modifier A target path modifier.
#' @param callback_function The function to run inside the scratch directory
#' context.
#' @param cleanup_after Clean up after execution.
#' @param copy_pattern Pattern used to copy files from the target_directory back
#' to the source directory.
#' @return Timed directory with the format %Y%m%d_%H%M%S appended to
#' target_directory path.
#' @export
with_scratch <- function(
    source_directory,
    target_directory,
    modifier = modifier_timed_directory,
    callback_function,
    cleanup_after = FALSE,
    copy_pattern = NULL) {
  if (!dir.exists(source_directory)) {
    stop(paste("source_directory", source_directory, "doesn't exist."))
  }
  if (typeof(callback_function) != "closure") {
    stop("callback_function is not a closure.")
  }
  if (modifier != NULL) {
    if (typeof(modifier) != "closure") {
      stop("modifier is not a closure.")
    }
    target_directory <- modifier(target_directory)
  }
  # Create directory if doesn't exist.
  dir.create(target_directory, recursive = TRUE)

  # Calls the callback function.
  callback_function(target_directory)

  if (!cleanup_after) {
    return
  }
  # Copy back from target_directory to source_directory.
  file.copy(
    list.files(
      pattern = copy_pattern,
      path = target_directory,
      full.names = TRUE,
      all.files = TRUE,
      recursive = TRUE,
    ),
    source_directory
  )
  unlink(target_directory, recursive = TRUE)
}

#' Append a timed directory with the format %Y%m%d_%H%M%S to the
#' target_directory path.
#'
#' @param target_directory The target directory.
#' @return Timed directory with the format %Y%m%d_%H%M%S appended to
#' target_directory path.
#' @export
modifier_timed_directory <- function(target_directory) {
  return(
    file.path(target_directory, strftime(Sys.time(), "%Y%m%d_%H%M%S"))
  )
}
