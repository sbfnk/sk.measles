#' Measles seroprevalence data for South Korea
#'
#' A dataset containing measles seroprevalence in South Korea
#' measured as part of the KNHANES study in 2014.
#' The data are described in Kang et al. (2017) An increasing, 
#' potentially measles-susceptible population over time after 
#' vaccination in Korea. Vaccine 35(33): 4126-4132.
#'
#' @format A tibble with three columns: lower.age.limit (the lower bound
#'   in years of the age group), seropositive (the proportion seropositive) 
#'   and equivocal (the proportion equivocal).
#' @source \url{https://doi.org/10.1016/j.vaccine.2017.06.058}
"sk_seroprevalence"

#' Measles vaccination coverage data for South Korea
#'
#' A dataset containing measles vaccination coverage in South Korea
#' as reported by the World Health Organization
#'
#' @format A tibble with three columns: vaccine (MCV1 or MCV2 for
#'   first/second dose, year and uptake.
#' @source \url{https://www.who.int/immunization/monitoring_surveillance/data/en/}
"sk_mcv_coverage"

#' Population by age for South Korea
#'
#' Census data from 2017 and estimates for 2014 and 2018, as provided
#' by the Korean Statistical Information Service
#' @format A tibble with three columns: lower.age.limit (the lower bound
#'   in years of the age group), year and population
"sk_population"

#' Age-specific mixing patterns for Japan
#'
#' Population-weighted number of contacts between age groups
#' The data are described in Ibuka Y, et al. (2016) Social contacts, 
#' vaccination decisions and influenza in Japan. 
#' J Epidemiol Community Health 70:162-167.
#' @format A tibble with twelve columns and twelve rows,
#'   representing the contact matrix
#' @source{https://doi.org/10.1136/jech-2015-205777}
"japan_contacts"
