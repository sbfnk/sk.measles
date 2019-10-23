##' Groups seroprevalence levels and projects to 2018
##'
##' @return table of seroprevalence by age group, original (2014) and shifted (2018)
##' @importFrom dplyr %>% mutate filter select group_by summarise left_join ungroup
##' @importFrom tidyr spread separate
##' @importFrom tibble tibble
##' @importFrom readr parse_number
##' @importFrom epimixr project_immunity
##' @importFrom socialmixr reduce_agegroups limits_to_agegroups
##' @author Sebastian Funk \email{sebastian.funk@lshtm.ac.uk}
##' @export
##' @param contacts a contact matrix
##' @param equivocal whether equivocal samples are to be interpreted as
##'   "positive" (default) or "negative" 
sk_projected_seroprevalence <- function(contacts, equivocal=c("positive", "negative"))
{
  equivocal=match.arg(equivocal)

  seroprevalence <- sk_seroprevalence %>%
    mutate(perspective="2014")

  if (equivocal == "positive") {
    seroprevalence <- seroprevalence %>%
      mutate(seropositive=seropositive+equivocal)
  }

  ## determine lower bounds of age groups
  lower_age_groups <- tibble(group=colnames(contacts)) %>%
    separate(group, c("low", "high"), sep="-", fill="right") %>%
    mutate(low=parse_number(low)) %>%
    .$low

  cvm <- sk_mcv_coverage %>%
    spread(year, uptake) %>%
    select(-vaccine) %>%
    as.matrix

  ## assume 2018 like 2017
  cvm <- cbind(cvm, cvm[, ncol(cvm)])
  colnames(cvm)[ncol(cvm)] <- "2018"

  maternal_immunity <- seroprevalence %>%
    filter(lower.age.limit==0) %>%
    .$seropositive

  baseline_immunity <- seroprevalence$seropositive
  names(baseline_immunity) <- seroprevalence$lower.age.limit

  ## project immunity
  shifted_immunity <-
    project_immunity(baseline.immunity = baseline_immunity,
                     baseline.year = 2014,
                     year = 2018,
                     coverage = cvm,
                     schedule = c(1, 6),
                     maternal.immunity = maternal_immunity,
                     efficacy = 0.95)

  seroprevalence_shifted <- seroprevalence %>%
    mutate(seropositive=shifted_immunity,
           perspective="2018")

  ## group seroprevalence data in age groups of contact survey
  seroprevalence_grouped <- seroprevalence %>%
    rbind(seroprevalence_shifted) %>%
    mutate(age_group=reduce_agegroups(lower.age.limit, lower_age_groups)) %>%
    left_join(sk_population %>% mutate(perspective=as.character(year)) %>% select(-year),
              by=c("lower.age.limit", "perspective")) %>%
    group_by(perspective) %>%
    mutate(age_group=limits_to_agegroups(age_group)) %>%
    group_by(age_group, perspective) %>%
    summarise(prop.immune=sum(seropositive * population) / sum(population),
              population=sum(population)) %>%
    ungroup()

  return(seroprevalence_grouped)
}
