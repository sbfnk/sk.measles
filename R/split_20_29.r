##' Sensitivity analysis splitting the 20-29 year age group
##'
##' @return contact matrix with 20-29 year olds split
##' @author Sebastian Funk \email{sebastian.funk@lshtm.ac.uk}
##' @export
##' @inheritParams sk_projected_seroprevalence
split_20_29 <- function(contacts)
{
  ## identify column
  twtw9 <- which(colnames(contacts)=="20-29")

  ## duplicate row/column
  contacts_sa <-
    contacts[c(1:twtw9, twtw9:ncol(contacts)), c(1:twtw9, twtw9:ncol(contacts))]
  colnames(contacts_sa)[twtw9 + (0:1)] <- c("20-24", "25-29")

  ## halve within-group contacts
  contacts_sa[, twtw9 + (0:1)] <- contacts_sa[, twtw9 + (0:1)] / 2

  off_diag <- unname(contacts[twtw9, twtw9+1] / 2)
  diag <- contacts[twtw9, twtw9] - contacts[twtw9, twtw9+1] / 2

  contacts_sa[twtw9, twtw9] <- diag
  contacts_sa[twtw9+1, twtw9+1] <- diag
  contacts_sa[twtw9, twtw9+1] <- off_diag
  contacts_sa[twtw9+1, twtw9] <- off_diag

  return(contacts_sa)
}
