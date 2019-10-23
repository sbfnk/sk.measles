##' Explore vaccination scenarios
##'
##' @return wide table of seroprevalence by age group, original (2014) and shifted (2018)
##' @importFrom dplyr %>% mutate group_by summarise if_else bind_rows
##' @importFrom epimixr adjust_immunity
##' @importFrom socialmixr limits_to_agegroups
##' @importFrom tidyr spread
##' @author Sebastian Funk \email{sebastian.funk@lshtm.ac.uk}
##' @export
##' @inheritParams sk_projected_seroprevalence
##' @param ... any further parameters to pass to \code{\link{sk_projected_seroprevalence}}
scenarios <- function(contacts, ...)
{
    seroprevalence <- sk_projected_seroprevalence(contacts, ...)

    ## determine number of seroprevalence age groups after adjusting
    nsero <- length(unique(seroprevalence$age_group))

    ## adjust contact columns that don't exist in seroprevalence
    contacts[, nsero] <- rowSums(contacts[, nsero:ncol(contacts)])
    contacts <- contacts[1:nsero, 1:nsero]

    effImm <- list()
    ## check efficacy of 50% decrease in susceptibility in each age group

    for (group in unique(seroprevalence$age_group)) {
      effImm[[as.character(group)]] <- seroprevalence %>%
        group_by(perspective) %>%
        mutate(prop.immune=if_else(age_group==group, 0.5 * (1 + prop.immune), prop.immune)) %>%
        summarise(adjusted.immunity=adjust_immunity(contacts, immunity=prop.immune)) %>%
	mutate(age_group=group,
	       adjusted.immunity=round(adjusted.immunity, 2)) %>%
	spread(perspective, adjusted.immunity) %>%
	rename(`Age group (years)`=age_group)
    }

    return(bind_rows(effImm))

}
