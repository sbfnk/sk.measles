##' Print table 1
##'
##' @return wide table of seroprevalence by age group, original (2014) and shifted (2018)
##' @importFrom dplyr %>% mutate rename group_by summarise
##' @importFrom tidyr spread
##' @importFrom epimixr adjust_immunity
##' @author Sebastian Funk \email{sebastian.funk@lshtm.ac.uk}
##' @export
##' @inheritParams sk_projected_seroprevalence
##' @param ... any further parameters to pass to \code{\link{sk_projected_seroprevalence}}
table1 <- function(contacts, ...)
{
    seroprevalence <- sk_projected_seroprevalence(contacts, ...)

    ## determine number of seroprevalence age groups after adjusting
    nsero <- length(unique(seroprevalence$age_group))

    ## adjust contact columns that don't exist in seroprevalence
    contacts[, nsero] <- rowSums(contacts[, nsero:ncol(contacts)])
    contacts <- contacts[1:nsero, 1:nsero]

    adjusted_immunity <- seroprevalence %>%
        group_by(perspective) %>%
        summarise(immunity=adjust_immunity(contacts, immunity=prop.immune)) %>%
        mutate(type="Contact-adjusted")

    plain_immunity <- seroprevalence %>%
        group_by(perspective) %>%
        summarise(immunity=sum(prop.immune*population)/sum(population)) %>%
        mutate(type="Plain")

    return(
        list(
	     by_age=
                 seroprevalence %>%
		   select(-population) %>%
		   mutate(prop.immune=round(prop.immune, 2)) %>%
                   spread(perspective, prop.immune) %>%
                   rename(`Age group (years)`=age_group),
             aggregate=
                 rbind(
		       plain_immunity %>%
		         mutate(immunity=round(immunity, 2)) %>%
                         spread(perspective, immunity),
		       adjusted_immunity %>%
		         mutate(immunity=round(immunity, 2)) %>%
                         spread(perspective, immunity)
		      )
            )
	)
}
